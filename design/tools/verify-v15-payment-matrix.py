import json, pathlib, itertools, hashlib, html
root=pathlib.Path('design/states/D2-payment-matrix-v15')
parts=[json.load(open(root/f'verification-{p}.json')) for p in ['P1','P2','P3']]
cases=[c for p in parts for c in p['cases']]
fixtures=json.load(open('design/states/D2-payment-modes-v15-fixtures.json'))['variants']
expected={(p,i,l,s,v['id']) for p,ins in [('P1',range(3)),('P2',range(3)),('P3',range(1))] for i,l,s,v in itertools.product(ins,['AZ','TR','RU','EN'],[1.,1.3,2.],fixtures)}
actual={(c['profile'],int(c['inset'][1:]),c['language'],c['fontScale'],c['fixture']) for c in cases}
assert actual==expected and len(actual)==len(cases)==3360
by_id={v['id']:v for v in fixtures}
for c in cases:
 assert c['operationId']==by_id[c['fixture']]['operationId']
 assert c['allFit']
 assert all(pathlib.Path(p).is_file() for p in c['pages'])
assert all(p['missingGlyphs']==0 for p in parts)
report={'caseCount':len(cases),'captures':sum(p['captures'] for p in parts),'allFit':True,'missingGlyphs':0,'uniqueCases':True,'allPathsExist':True,'operationIdsPreserved':True,'fontCandidates':['F1/NotoSans'],'fontScales':[1.,1.3,2.],'profileInsetPairs':['P1/I0','P1/I1','P1/I2','P2/I0','P2/I1','P2/I2','P3/I0'],'languages':['AZ','TR','RU','EN'],'limits':['TR/RU/EN reviewed against AZ; no native-speaker approval','F2 Noto Serif alternative not part of canonical payment font scope','Static stacked scroll pagination; not original two-pane V15 layout','Linear font scaling; no Android accessibility/runtime/device/provider proof','allFit tests block geometry and text width, not independent image overlap detection'],'cases':cases}
report['fontAudit']=json.load(open(root/'font-audit.json'))
assert report['fontAudit']['noFallbackPassed']
assert all(set(p['resolvedFonts']) <= {'NotoSans-Regular','NotoSans-SemiBold','NotoSans-Bold','NotoSansSymbols-Regular'} for p in parts)
report['resolvedFonts']=sorted({f for p in parts for f in p['resolvedFonts']})
report['status']='geometry_and_bundled_fonts_pass'
report['symbolFont']='design/states/D2-payment-symbol-font.json'
report['sourceHashes']={p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest() for p in ['design/tools/render-v15-payment-matrix.swift','design/states/D2-payment-symbol-font.json','design/fonts/notosanssymbols/NotoSansSymbols[wght].ttf','design/states/D2-payment-localization-v15.json','design/states/D2-payment-modes-v15-fixtures.json','design/states/D1-canonical-render-matrix.json','design/states/D1-pixel-composition-tokens.json']}
json.dump(report,open(root/'verification.json','w'),ensure_ascii=False,indent=2)
# Native browser controls make every matrix case and every page available without a UI dependency.
items=[]
for c in cases:
 label=f"{c['profile']} / {c['inset']} / {c['language']} / {c['fontScale']}× / {c['fixture']}"
 links=' '.join(f'<a href="{html.escape(str(pathlib.Path(p).relative_to(root)))}">{i+1}</a>' for i,p in enumerate(c['pages']))
 items.append(f'<details><summary>{html.escape(label)} — {len(c["pages"])} pages</summary>{links}</details>')
(root/'index.html').write_text('<!doctype html><meta charset="utf-8"><title>V15 payment matrix</title><h1>V15 payment matrix</h1><p>3360 static cases. AZ-reviewed TR/RU/EN; no native-speaker approval. Noto Sans F1; 1 / 1.3 / 2×. P1–P3, I0–I2 where applicable. Runtime untested. Geometry and bundled-font audit pass; ← / → explicitly use pinned Noto Sans Symbols Regular.</p>'+''.join(items))
print({k:v for k,v in report.items() if k not in ['cases','sourceHashes']})
