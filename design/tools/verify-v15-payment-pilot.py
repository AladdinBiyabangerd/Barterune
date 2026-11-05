"""Independent geometry, source-copy, state and contrast checks for seven pilot cases."""
import json, hashlib
from pathlib import Path
root=Path('design/states/D2-payment-pilot-v15')
m=json.loads((root/'measurements.json').read_text())
fixtures={v['id']:v for v in json.load(open('design/states/D2-payment-modes-v15-fixtures.json'))['variants']}
loc=json.load(open('design/states/D2-payment-localization-v15.json'))['languages']
assert m['caseCount']==len(m['cases'])==7
assert len({c['id'] for c in m['cases']})==7
assert m['missingGlyphs']==0
assert set(m['resolvedFonts']) <= {'NotoSans-Regular','NotoSans-SemiBold','NotoSans-Bold','NotoSansSymbols-Regular'}
def contains(a,b):
 x,y,w,h=a;X,Y,W,H=b
 return X>=x-.01 and Y>=y-.01 and X+W<=x+w+.01 and Y+H<=y+h+.01
def overlap(a,b):
 x,y,w,h=a;X,Y,W,H=b
 return min(x+w,X+W)-max(x,X)>.01 and min(y+h,Y+H)-max(y,Y)>.01
captures=0
for c in m['cases']:
 v=fixtures[c['fixture']];lang=c['id'].split('-')[2];l=loc[lang]
 assert c['operationId']==v['operationId']
 expected=[l[v['title']],l[v['status']]]+[l[s] for key in ['left','right'] for s in v[key]]+[l[v['primary']],l['← Geri']]
 actual=[]
 for page in c['pages']:
  assert Path(page['path']).is_file();captures+=1
  items=page['items']
  for i,it in enumerate(items):
   actual.append(it['text'])
   assert contains(c['safeRect'],it['rect']), (c['id'],it)
   assert contains(it['rect'],it['textRect']), (c['id'],'text clipping',it)
   if it['action']:
    assert min(it['rect'][2:])/c['density']>=48
    assert it['enabled']==(v['enabled'] if it['group']=='primary' else True)
   for other in items[i+1:]: assert not overlap(it['rect'],other['rect']),(c['id'],'overlap')
 assert actual==expected
 assert (c['layout']=='two-pane')==all(h<=c['paneAvailablePx'] for h in c['paneRequiredPx'])
# Actual opaque fills used behind all text: nav/paper, including inverse active CTA.
colors=json.load(open('design/states/D6-canonical-token-proposal.json'))['referenceColors']
def lum(key):
 h=colors[key]['value'].lstrip('#');s=[int(h[i:i+2],16)/255 for i in (0,2,4)]
 return sum(v*k for v,k in zip([v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in s],[.2126,.7152,.0722]))
a,b=sorted([lum('nav'),lum('paper')]);ratio=(b+.05)/(a+.05)
assert ratio>=4.5
r={'caseCount':7,'captures':captures,'boundsPass':True,'pairwiseOverlapPass':True,'sourceCopyOrderAndStatePass':True,'minimumActionTargetDp':48,'missingGlyphs':m['missingGlyphs'],'resolvedFonts':m['resolvedFonts'],'opaqueTextContrast':ratio,'limits':['No interactive scrolling/device/accessibility proof','Decorative textured frame edges excluded from text backgrounds; disabled distinction not a complete state palette audit']}
r['sourceHashes']={p:hashlib.sha256(Path(p).read_bytes()).hexdigest() for p in ['design/states/D2-payment-modes-v15-fixtures.json','design/states/D2-payment-localization-v15.json','design/states/D1-pixel-composition-tokens.json','design/states/D1-canonical-render-matrix.json','design/states/D6-canonical-token-proposal.json','design/states/D2-payment-symbol-font.json']}
(root/'verification.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
