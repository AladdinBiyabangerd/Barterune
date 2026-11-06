"""Check the D1 device matrix and build its local browsing index."""
import itertools
import json
import struct
from pathlib import Path
from html import escape

root = Path('design/states/D1-device-matrix-v15')
data = json.loads((root / 'verification.json').read_text())
source = Path('design/states/D1-pixel-composition-v7')
states = sorted(p.name.removeprefix('P1-AZ-1.0x-') for p in source.glob('P1-AZ-1.0x-*') if p.is_dir())
assert len(states) == 30
expected = {f'{p}-{l}-{s}x-{state}' for p, l, s, state in itertools.product(['P2', 'P3'], ['AZ', 'TR', 'RU', 'EN'], ['1.0', '1.3', '2.0'], states)}
profiles = data['profiles']
assert len(profiles) == len(expected) == 720
assert {p['id'] for p in profiles} == expected
assert data['missingGlyphs'] == 0
failures = [p['id'] for p in profiles if not p['allChecksPassed']]
assert not failures, failures
count = 0
rows = []
for p in profiles:
    size = (2400, 1080) if p['id'].startswith('P2-') else (2560, 1600)
    links = []
    for i, name in enumerate(p['captures']):
        path = Path(name)
        header = path.read_bytes()[:24]
        assert header[:8] == b'\x89PNG\r\n\x1a\n'
        assert struct.unpack('>II', header[16:24]) == size, name
        count += 1
        links.append(f'<a href="{escape(str(path.relative_to(root)))}">{i + 1}</a>')
    rows.append(f'<li><strong>{escape(p["id"])}</strong> — '+ ' · '.join(links) + '</li>')
overview = '<p>Overview: ' + ' · '.join(f'<a href="contact-{d}-{l}.png">{d} {l}</a>' for d in ['P2', 'P3'] for l in ['AZ', 'EN', 'RU', 'TR']) + '</p>'
(root / 'index.html').write_text('<!doctype html><meta charset="utf-8"><title>D1 P2/P3 v15</title><h1>D1 P2/P3 v15</h1><p>720 state / language / font combinations. Static linear font scaling; scroll crops, not Android screenshots.</p>' + overview + '<ul>' + ''.join(rows) + '</ul>')
summary = {'combinations': len(profiles), 'statesPerCombination': 30, 'captures': count, 'missingGlyphs': 0, 'allChecksPassed': True, 'nativeDimensionsChecked': True, 'contrastNavPaper': 10.994, 'limits': data['limits']}
(root / 'coverage.json').write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps(summary, indent=2))
