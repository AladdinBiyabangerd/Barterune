"""Build a local evidence index from the rendered manifest; no runtime UI."""
import json,html
from pathlib import Path
root=Path('design/states/D2-payment-control-matrix-v15')
m=json.loads((root/'measurements.json').read_text())
h=['<!doctype html><meta charset="utf-8"><title>D2 control matrix evidence</title><h1>D2 static control matrix</h1><p>Accepted D2 static binding and padding; full static matrix. Contact sheets are reduced previews; native captures below. No device/accessibility proof.</p>']
for c in m['cases']:
 h.append('<details><summary>'+html.escape(c['id']+' / '+c['fixture']+' / '+c['layout'])+'</summary>')
 for p in c['pages']:
  name=Path(p['path']).name;h.append(f'<a href="{name}"><img loading="lazy" width="640" src="{name}" alt="{html.escape(name)}"></a>')
 h.append('</details>')
(root/'index.html').write_text('\n'.join(h)+'\n')
