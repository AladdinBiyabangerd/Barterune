"""Build a plain HTML evidence index; native screenshots are the design output."""
import json,html
from pathlib import Path
root=Path('design/states/D2-payment-canonical-matrix-v15')
cases=json.loads((root/'measurements.json').read_text())['cases']
review=json.loads((root/'visual-review.json').read_text())
native=set(review['nativeInspected'])
contacts=set(review['contactsInspected'])
out=['<!doctype html><html lang="az"><meta charset="utf-8"><title>D2 canonical static matrix v15</title><h1>D2 canonical statik matris</h1>', '<p>3360 hal. Tokenlər və pilot siyasəti saxlanır. Statik səhifələr interaktiv scroll, Android font scaling və ya TalkBack sübutu deyil. Yalnız vizual baxış qeydində sadalanan kadrlar açılıb yoxlanıb.</p>', '<p><a href="verification.json">Avtomatik yoxlamalar</a> · <a href="decision.json">Qərar və məhdudiyyətlər</a> · <a href="visual-review.json">Vizual baxış qeydi</a> · <a href="font-audit.json">Şrift auditi</a></p>']
for lang in ['AZ','TR','RU','EN']:
 out.append('<h2>'+lang+'</h2>')
 for c in cases:
  if c['language']!=lang:continue
  cid=html.escape(c['id']);contact='contact-'+c['id']+'.png'
  out.append(f'<details><summary>{cid} — {c["layout"]}, {len(c["pages"])} səhifə</summary>')
  out.append(f'<p>Pane tələb: {c["paneRequiredPx"]}; mövcud: {c["paneAvailablePx"]} px. CTA: {c["cta"]}.</p>')
  if (root/contact).exists():out.append(f'<p><a href="{contact}">İcmal'+(' — baxılıb' if contact in contacts else '')+'</a></p>')
  for n,p in enumerate(c['pages']):
   rel=str(Path(p['path']).relative_to(root));status=' — native baxılıb' if rel in native else ''
   out.append(f'<p><a href="{html.escape(rel)}">Səhifə {n+1}{status}</a></p><img loading="lazy" width="960" src="{html.escape(rel)}" alt="{cid}, səhifə {n+1}">')
  out.append('</details>')
out.append('</html>');(root/'index.html').write_text('\n'.join(out)+'\n')
print('Index built:',len(cases),'cases')
