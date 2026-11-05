"""Check native captures and fixed control geometry; write the browsing index."""
import itertools
import json
import struct
from pathlib import Path
from html import escape
root = Path('design/states/D1-keypad-fixed-v16')
d = json.loads((root / 'verification.json').read_text())
expected = {f'{p}-{l}-{s}x-{v}' for p,l,s,v in itertools.product(['P1','P2','P3'],['AZ','EN','RU','TR'],['1.0','1.3','2.0'],['quantity','empty','zero','negative','decimal','seven-digits'])}
assert len(d['cases']) == 216 and {x['id'] for x in d['cases']} == expected
assert d['allFit'] and d['missingGlyphs'] == 0
geometries = {}
rows = []
count = 0
for x in d['cases']:
    assert x['allFit'] and len(x['fixedControls']) == 13
    assert x['applyEnabled'] == x['id'].endswith('-quantity')
    key = '-'.join(x['id'].split('-')[:3])
    rects = [c['rect'] for c in x['fixedControls']]
    assert geometries.setdefault(key, rects) == rects, x['id']
    pid = x['id'].split('-')[0]
    size = {'P1':(1280,720),'P2':(2400,1080),'P3':(2560,1600)}[pid]
    links = []
    for i,name in enumerate(x['captures']):
        p = Path(name)
        header = p.read_bytes()[:24]
        assert header[:8] == b'\x89PNG\r\n\x1a\n' and struct.unpack('>II',header[16:24]) == size
        links.append(f'<a href="{escape(p.name)}">{i+1}</a>')
        count += 1
    rows.append(f'<li>{escape(x["id"])}: '+ ' · '.join(links) + '</li>')
(root / 'index.html').write_text('<!doctype html><meta charset="utf-8"><title>D1 fixed keypad v16</title><h1>D1 fixed keypad v16</h1><p>All keys, value field and Back stay fixed. Only instruction content may scroll. Static design; Android runtime not tested.</p><ul>'+''.join(rows)+'</ul>')
print(f'PASS: 216 cases, {count} native PNGs, fixed controls identical across valid/error states, missingGlyphs=0')
