"""Validate static service payment fixtures and their navigation contract."""
from pathlib import Path
import itertools,json
source=Path('design/states/D2-payment-modes-v15-fixtures.json')
f=json.loads(source.read_text());modes=f['modes'];variants=f['variants']
assert {(m['guide'],m['guard']) for m in modes}==set(itertools.product(['none','road','term'],repeat=2))-{('none','none')}
assert len(modes)==8 and len(variants)==40
assert len({v['id'] for v in variants})==40
assert len({m['operationId'] for m in modes})==8
by={v['id']:v for v in variants}
nav=json.loads(Path('design/states/D1-D6-design-v15/navigation.json').read_text())
edges={(t['source'],t['action'],t['target']) for t in nav['transitions']}
cap=lambda x:'D2-services-'+x+'.png'
for m in modes:
    guide={'none':0,'road':4*m['distance'],'term':12}[m['guide']]
    guard={'none':0,'road':10*m['distance'],'term':28}[m['guard']]
    assert m['guideCost']==guide and m['guardCost']==guard
    assert m['total']==guide+guard
    assert m['cashAfterSuccess']==m['cashBefore']-m['total']>=0
    for name in ['guide','guard']:
        c=m['contracts'][name];assert c['mode']==m[name]
        assert c['expiryDay']==(m['day']+4 if m[name]=='term' else None)
        assert c['start']==('payment-confirmed-day4' if m[name]=='term' else ('departure' if m[name]=='road' else None))
        assert c['end']==('destination-or-return-arrival' if m[name]=='road' else ('day8-start' if m[name]=='term' else None))
    for state,id in m['captures'].items():
        v=by[id];assert v['modeId']==m['id'] and v['paymentState']==state and v['operationId']==m['operationId']
        assert v['left'][-1]==f"Cəm: {m['total']} qızıl"
        assert v['enabled']==(state not in ['pending','unknown'])
        assert v['resolvedCash']==(None if state in ['pending','unknown'] else (m['cashAfterSuccess'] if state=='paid-success' else m['cashBefore']))
        assert v['paymentApplications']==(None if state in ['pending','unknown'] else int(state=='paid-success'))
        assert v['confirmedCash']==(m['cashAfterSuccess'] if state=='paid-success' else m['cashBefore'])
        if state in ['confirm','paid-success']:assert v['right'][1]==f"Qızıl: 100 → {m['cashAfterSuccess']}"
    c,p,s,fail,u=[m['captures'][k] for k in ['confirm','pending','paid-success','failed','unknown']]
    for a,act,b in [(c,'pay',p),(p,'resolve: paid-success',s),(p,'resolve: failed',fail),(p,'resolve: unknown',u),(u,'resolve saved',s),(u,'resolve failed',fail),(fail,'retry same operation',p)]:assert (cap(a),act,cap(b)) in edges
out={'fixture':str(source),'modeCount':8,'variantCount':40,'checksPassed':True,'checks':['All nonempty mode combinations','B05 prices and totals','term starts at payment day4, expires day8; road starts at departure','single saved operation across retry and resolution','unknown/pending cash is unresolved; success applies once','per-mode static navigation edges'],'scope':'Static integer/contract validation, not persistence or runtime tests'}
Path('design/states/D1-D6-design-v15/payment-mode-verification.json').write_text(json.dumps(out,indent=2)+'\n')
print('8 modes × 5 states verified')
