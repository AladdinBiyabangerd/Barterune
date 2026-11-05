"""Independent geometry, source-copy, state and contrast checks for payment control pilot cases."""
import json, hashlib, struct
from pathlib import Path
root=Path('design/states/D2-payment-control-matrix-v15')
m=json.loads((root/'measurements.json').read_text())
fixtures={v['id']:v for v in json.load(open('design/states/D2-payment-modes-v15-fixtures.json'))['variants']}
loc=json.load(open('design/states/D2-payment-localization-v15.json'))['languages']
tokens=json.load(open('design/states/D1-pixel-composition-tokens.json'))['geometry']
profiles=json.load(open('design/states/D1-canonical-render-matrix.json'))['profiles']
assert m['caseCount']==len(m['cases'])==19488
assert len({c['id'] for c in m['cases']})==19488
assert m['missingGlyphs']==0
assert set(m['resolvedFonts']) <= {'NotoSans-Regular','NotoSans-SemiBold','NotoSans-Bold','NotoSansSymbols-Regular'}
def contains(a,b):
 x,y,w,h=a;X,Y,W,H=b
 return X>=x-.01 and Y>=y-.01 and X+W<=x+w+.01 and Y+H<=y+h+.01
def overlap(a,b):
 x,y,w,h=a;X,Y,W,H=b
 return min(x+w,X+W)-max(x,X)>.01 and min(y+h,Y+H)-max(y,Y)>.01
interactions={'normal','primary-pressed','primary-focused','primary-focused-pressed','back-pressed','back-focused','back-focused-pressed'}
assert {c['interaction'] for c in m['cases']}==interactions
expected=set()
for pid,iids in [('P1',[0,1,2]),('P2',[0,1,2]),('P3',[0])]:
 for iid in iids:
  for lang in loc:
   for scale in [1.0,1.3,2.0]:
    for fixture,v in fixtures.items():
     for interaction in interactions:
      if not v['enabled'] and interaction.startswith('primary-'):continue
      expected.add(f'{pid}-I{iid}-{lang}-{scale}x-{fixture}-{interaction}')
assert {c['id'] for c in m['cases']}==expected
normal={c['id'].removesuffix('-normal'):c for c in m['cases'] if c['interaction']=='normal'}
for c in m['cases']:
 base=normal[c['id'].removesuffix('-'+c['interaction'])]
 assert c['layout']==base['layout'] and len(c['pages'])==len(base['pages'])
 for page,bpage in zip(c['pages'],base['pages']):
  assert [{k:a[k] for k in ['text','rect','textRect','enabled']} for a in page['items']]==[{k:a[k] for k in ['text','rect','textRect','enabled']} for a in bpage['items']]
assert {c['layout'] for c in m['cases']}=={'two-pane','reflow'}
captures=0
for c in m['cases']:
 v=fixtures[c['fixture']];lang=c['id'].split('-')[2];l=loc[lang]
 assert c['operationId']==v['operationId']
 expected=[l[v['title']],l[v['status']]]+[l[s] for key in ['left','right'] for s in v[key]]+[l[v['primary']],l['← Geri']]
 actual=[]
 for page in c['pages']:
  assert Path(page['path']).is_file();captures+=1
  png=Path(page['path']).read_bytes();assert png[:8]==b'\x89PNG\r\n\x1a\n'
  profile=next(p for p in profiles if p['id']==c['id'].split('-')[0])
  assert list(struct.unpack('>II',png[16:24]))==profile['outputPx']
  items=page['items']
  for i,it in enumerate(items):
   actual.append(it['text'])
   assert contains(c['safeRect'],it['rect']), (c['id'],it)
   assert contains(it['rect'],it['textRect']), (c['id'],'text clipping',it)
   if it['action']:
    assert min(it['rect'][2:])/c['density']>=48
    pad=tokens['inset']*c['density']/2
    assert abs(it['textRect'][1]-it['rect'][1]-pad)<.01
    assert it['rect'][3]-it['textRect'][3]>=2*pad-.01
    assert it['enabled']==(v['enabled'] if it['group']=='primary' else True)
    selected=it['enabled'] and c['interaction'].startswith(it['group']+'-')
    assert it['pressed']==(selected and c['interaction'].endswith('pressed'))
    assert it['focused']==(selected and 'focused' in c['interaction'])
    if it['pressed']:
     edge=tokens['frameEdge']*c['density']/2
     edge*=2 if it['focused'] else 1
     x,y,w,h=it['rect'];assert contains([x+edge,y+edge,w-2*edge,h-2*edge],it['textRect'])
   for other in items[i+1:]: assert not overlap(it['rect'],other['rect']),(c['id'],'overlap')
 assert actual==expected
 assert (c['layout']=='two-pane')==all(h<=c['paneAvailablePx'] for h in c['paneRequiredPx'])
# Regress every accepted extension case against this complete cross-product.
extension=json.load(open('design/states/D2-payment-control-extension-v15/measurements.json'))
full={c['id']:c for c in m['cases']}
for old in extension['cases']:
 prefix='-'.join(old['id'].split('-')[:4])
 key=prefix+'-'+old['fixture']+'-'+old['interaction']
 new=full[key]
 assert new['layout']==old['layout'] and len(new['pages'])==len(old['pages'])
 for a,b in zip(new['pages'],old['pages']):assert a['items']==b['items']
# Actual opaque fills used behind all text: nav/paper, including inverse active CTA.
colors=json.load(open('design/states/D6-canonical-token-proposal.json'))['referenceColors']
def lum(key):
 h=colors[key]['value'].lstrip('#');s=[int(h[i:i+2],16)/255 for i in (0,2,4)]
 return sum(v*k for v,k in zip([v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in s],[.2126,.7152,.0722]))
a,b=sorted([lum('nav'),lum('paper')]);ratio=(b+.05)/(a+.05)
assert ratio>=4.5
r={'caseCount':19488,'captures':captures,'boundsPass':True,'pairwiseOverlapPass':True,'sourceCopyOrderAndStatePass':True,'minimumActionTargetDp':48,'missingGlyphs':m['missingGlyphs'],'resolvedFonts':m['resolvedFonts'],'opaqueTextContrast':ratio,'limits':['No interactive scrolling/device/accessibility proof','Decorative textured frame edges excluded from text backgrounds; disabled distinction not a complete state palette audit']}
r['sourceHashes']={p:hashlib.sha256(Path(p).read_bytes()).hexdigest() for p in ['design/states/D2-payment-modes-v15-fixtures.json','design/states/D2-payment-localization-v15.json','design/states/D1-pixel-composition-tokens.json','design/states/D1-canonical-render-matrix.json','design/states/D6-canonical-token-proposal.json','design/states/D2-payment-symbol-font.json']}
previous=json.load(open('design/states/D2-payment-control-pilot-v15/verification.json'))
assert r['sourceHashes']==previous['sourceHashes']
r['sourceHashesUnchangedFromPriorPilot']=True
r['acceptedExtensionGeometryRegressionCases']=len(extension['cases'])
pixels=json.load(open(root/'extension-pixel-regression.json'))
assert pixels['comparedCaptures']==545 and not pixels['mismatches']
r['acceptedExtensionPixelRegressionCaptures']=545
r['fullCrossProductPass']=True
r['interactionGeometryRegressionPass']=True
(root/'verification.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
