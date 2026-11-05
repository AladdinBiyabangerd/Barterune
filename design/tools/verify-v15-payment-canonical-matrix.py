"""Full cross-product, source/state, geometry, pagination and opaque contrast audit.
This checks static renderer measurements, not Android runtime behavior.
"""
import json, hashlib, struct
from collections import Counter
from itertools import product
from pathlib import Path
root=Path('design/states/D2-payment-canonical-matrix-v15')
read=lambda p:json.loads(Path(p).read_text())
parts=[read(root/f'measurements-{p}.json') for p in ['P1','P2','P3']]
cases=[c for p in parts for c in p['cases']]
fixtures={v['id']:v for v in read('design/states/D2-payment-modes-v15-fixtures.json')['variants']}
loc=read('design/states/D2-payment-localization-v15.json')['languages']
matrix=read('design/states/D1-canonical-render-matrix.json')
profiles={p['id']:p for p in matrix['profiles']}
geo=read('design/states/D1-pixel-composition-tokens.json')['geometry']
allowed={'NotoSans-Regular','NotoSans-SemiBold','NotoSans-Bold','NotoSansSymbols-Regular'}
assert len(fixtures)==40
expected={(p,f'I{i}',l,s,f) for p in profiles for i in ([0] if p=='P3' else [0,1,2]) for l,s,f in product(loc,[1.0,1.3,2.0],fixtures)}
actual={(c['profile'],c['inset'],c['language'],c['fontScale'],c['fixture']) for c in cases}
assert len(cases)==len(actual)==len(expected)==3360 and actual==expected
assert len({c['id'] for c in cases})==3360
assert all(p['caseCount']==len(p['cases']) and p['missingGlyphs']==0 and set(p['resolvedFonts'])<=allowed for p in parts)
def contains(a,b):
 x,y,w,h=a;X,Y,W,H=b
 return X>=x-.01 and Y>=y-.01 and X+W<=x+w+.01 and Y+H<=y+h+.01
def overlap(a,b):
 x,y,w,h=a;X,Y,W,H=b
 return min(x+w,X+W)-max(x,X)>.01 and min(y+h,Y+H)-max(y,Y)>.01
def near(a,b): return all(abs(x-y)<.01 for x,y in zip(a,b))
paths=set();page_count=0
for c in cases:
 v=fixtures[c['fixture']];l=loc[c['language']];p=profiles[c['profile']];d=p['density']
 assert c['density']==d and c['outputPx']==p['outputPx']
 ins=p['safeInsetsDp'] if c['inset']=='I0' else matrix['insetVariants'][int(c['inset'][1:])]['safeInsetsDp']
 w,h=p['outputPx'];safe=[ins['left']*d,ins['top']*d,w-(ins['left']+ins['right'])*d,h-(ins['top']+ins['bottom'])*d]
 assert near(c['safeRect'],safe)
 unit=d/2; margin=geo['margin']*unit;gap=geo['gap']*unit;pad=geo['inset']*unit
 width=min(safe[2]-2*margin,geo['maxTextWidth']*unit)
 content=[safe[0]+(safe[2]-width)/2,safe[1]+margin,width,safe[3]-2*margin]
 assert near(c['contentRect'],content) and c['gapPx']==gap and c['paddingPx']==pad
 assert c['operationId']==v['operationId']
 texts=[l[v['title']],l[v['status']]]+[l[s] for key in ['left','right'] for s in v[key]]+[l[v['primary']],l['← Geri']]
 roles=['screenTitle','supporting']+[role for key in ['left','right'] for role in ['sectionTitle']+['body']*(len(v[key])-1)]+['label','label']
 groups=['title','status']+['left']*len(v['left'])+['right']*len(v['right'])+['primary','back']
 actual_text=[];items_flat=[];page_for=[]
 for n,page in enumerate(c['pages']):
  path=Path(page['path']);assert str(path) not in paths;paths.add(str(path));page_count+=1
  with path.open('rb') as fh: header=fh.read(24)
  assert header[:8]==b'\x89PNG\r\n\x1a\n' and list(struct.unpack('>II',header[16:24]))==c['outputPx']
  items=page['items'];assert items
  for i,it in enumerate(items):
   actual_text.append(it['text']);items_flat.append(it);page_for.append(n)
   assert contains(content,it['rect']) and contains(it['rect'],it['textRect']),(c['id'],'bounds',it)
   if it['action']:
    assert min(it['rect'][2:])/d>=48
    assert it['enabled']==(v['enabled'] if it['group']=='primary' else True)
   for other in items[i+1:]: assert not overlap(it['rect'],other['rect']),(c['id'],'item overlap')
 assert actual_text==texts and [it['group'] for it in items_flat]==groups
 assert [it['role'] for it in items_flat]==roles
 assert [it['action'] for it in items_flat]==[False]*(len(texts)-2)+[True,True]
 two=all(h<=c['paneAvailablePx'] for h in c['paneRequiredPx'])
 assert (c['layout']=='two-pane')==two
 assert c['cta']==('fixed-bottom-pair' if two else 'flow-stacked')
 # Recompute available height from actual title/status and action geometry.
 if two:
  assert len(c['pages'])==1 and len(c['paneRects'])==2
  title,status=items_flat[:2];primary,back=items_flat[-2:]
  hh=sum(it['rect'][3]+gap for it in [title,status]);ah=max(primary['rect'][3],back['rect'][3])
  available=content[3]-hh-gap-ah
  assert abs(available-c['paneAvailablePx'])<.01
  cw=(width-gap)/2
  panes=[[content[0]+i*(cw+gap),content[1]+hh,cw,available] for i in range(2)]
  assert all(near(a,b) for a,b in zip(panes,c['paneRects']))
  assert not overlap(*panes)
  for pane,group in zip(panes,['left','right']):
   assert contains(content,pane)
   children=[it for it in items_flat if it['group']==group]
   required=2*pad+sum(it['textRect'][3] for it in children)
   assert abs(required-c['paneRequiredPx'][0 if group=='left' else 1])<.01
   for it in children: assert contains(pane,it['rect']) and contains([pane[0]+pad,pane[1]+pad,pane[2]-2*pad,pane[3]-2*pad],it['textRect'])
   for it in [title,status,primary,back]: assert not overlap(pane,it['rect'])
  assert near(primary['rect'],[content[0],content[1]+content[3]-ah,cw,ah])
  assert near(back['rect'],[content[0]+cw+gap,content[1]+content[3]-ah,cw,ah])
 else:
  assert c['paneRects']==[]
  for i,it in enumerate(items_flat):
   assert abs(it['rect'][3]-c['flowBlockHeights'][i])<.01
   if i and page_for[i]==page_for[i-1]: assert abs(it['rect'][1]-(items_flat[i-1]['rect'][1]+items_flat[i-1]['rect'][3]+gap))<.01
   else: assert abs(it['rect'][1]-content[1])<.01
   if (it['role']=='sectionTitle' or it['group']=='primary') and i+1<len(items_flat):
    required=it['rect'][3]+gap+items_flat[i+1]['rect'][3]
    if required<=content[3]: assert page_for[i]==page_for[i+1],(c['id'],'orphan heading/action')
colors=read('design/states/D6-canonical-token-proposal.json')['referenceColors']
def lum(k):
 h=colors[k]['value'].lstrip('#');s=[int(h[i:i+2],16)/255 for i in (0,2,4)]
 return sum(v*k for v,k in zip([v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in s],[.2126,.7152,.0722]))
a,b=sorted([lum('nav'),lum('paper')]);ratio=(b+.05)/(a+.05);assert ratio>=4.5
hashes={p:hashlib.sha256(Path(p).read_bytes()).hexdigest() for p in read('design/states/D2-payment-pilot-v15/verification.json')['sourceHashes']}
assert hashes==read('design/states/D2-payment-pilot-v15/verification.json')['sourceHashes'],'Pilot input changed'
# The seven pilot cases must retain their layout, measurements and text placement.
pilot=read('design/states/D2-payment-pilot-v15/measurements.json')
lookup={c['id']:c for c in cases}
for old in pilot['cases']:
 c=lookup[old['id']+'-mixed-guide-term']
 for key in ['layout','cta','safeRect','density','paneRequiredPx','paneAvailablePx','actionPairHeightPx','headerWithGapsPx']:
  assert c[key]==old[key],(old['id'],key)
 assert [p['items'] for p in c['pages']]==[p['items'] for p in old['pages']]
audit=read(root/'font-audit.json');assert audit['noFallbackPassed'] and not audit['fallbackRuns']
report={'status':'static_geometry_source_font_checks_pass','caseCount':len(cases),'captures':page_count,'layoutCounts':dict(Counter(c['layout'] for c in cases)),'byLanguageLayout':{l:dict(Counter(c['layout'] for c in cases if c['language']==l)) for l in loc},'crossProductComplete':True,'boundsAndPaneOverlapPass':True,'sourceCopyOrderAndStatePass':True,'paginationAndCTAGroupingPass':True,'pilotRegressionPass':True,'minimumActionTargetDp':48,'missingGlyphs':0,'noFallbackPassed':True,'resolvedFonts':sorted({f for p in parts for f in p['resolvedFonts']}),'opaqueTextContrast':ratio,'sourceHashes':hashes,'limits':['Static linearly scaled pagination, not interactive scroll or Android font-scaling/device/TalkBack proof','Geometry checks use renderer text measurements; not independent raster OCR','Existing disabled treatment retained; full control-state/focus palette excluded','Visual sampling recorded separately; not every capture inspected'],'gameCodeChanged':False}
report['evidenceHashes']={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path('design/tools/render-v15-payment-canonical-matrix.swift'),Path('design/tools/verify-v15-payment-canonical-matrix.py'),Path('design/tools/audit-v15-payment-canonical-font.swift'),Path('design/states/D1-font-binary-manifest.json'),Path('design/states/D2-payment-pilot-v15/decision.json')]}
(root/'measurements.json').write_text(json.dumps({'caseCount':len(cases),'cases':cases},ensure_ascii=False,indent=2)+'\n')
(root/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
