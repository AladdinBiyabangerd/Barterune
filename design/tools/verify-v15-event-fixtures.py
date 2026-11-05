"""Independent integer checks for static B04/B07 design examples, not game code."""
import json
from pathlib import Path
source = Path('design/states/D2-event-outcomes-v15-fixtures.json')
data = json.loads(source.read_text())
risk = data['roadDistributionBasisPoints']
assert sum(risk[k] for k in ['H01','H02','H05','H06','H07','H08','none']) == 10000
assert risk['H02'] == risk['H06'] == 600//2
assert risk['H05'] == risk['H07'] == 600//2
assert risk['days'] == 2*risk['distance'] and risk['fee'] == 8*risk['distance']
checks = []
for f in data['variants']:
    b, a, d = f['before'], f['after'], f['damage']
    n, q, u = b['quantity'], b['quality'], b['frozenHealthyUnitSale']
    cargo = n * (u*q//100)
    limit = (b['cash']+cargo)*15//100
    points = d['requestedPoints']//2 if d['cover'] else d['requestedPoints']
    quality = max(25, q-points)
    damaged = d['affectedQuantity']*((u*q//100)-(u*quality//100))
    transferred = f.get('transferQuantity', 0)*(u*q//100)
    assert cargo == b['cargoValue']
    assert limit == f['lossBudget']
    assert quality == d['afterQuality']
    assert damaged+transferred == f['cargoLoss']
    assert b['cash']-f['cashLoss'] == a['cash'] >= 0
    assert cargo-f['cargoLoss'] == a['cargoValue']
    assert f['totalLoss'] == f['cashLoss']+f['cargoLoss'] <= limit
    assert a['debt'] == b['debt']
    assert 0 <= a['extraDays'] <= 1
    assert a['arrivalDay'] == f['trip']['plannedArrivalDay']+a['extraDays']
    assert f['frozenResult']
    assert d['splitCost'] == (b['totalCost']*d['affectedQuantity']//n if n else 0)
    assert d['splitCost']+d['remainingCost'] == b['totalCost']
    if transferred:
        assert f['transferCost'] == b['totalCost']*f['transferQuantity']//n
        assert a['quantity'] == n-f['transferQuantity']
    assert f['nextTripDangerBlocked'] == (f['event'] != 'H08')
    checks.append(f['id'])
by = {f['id']: f for f in data['variants']}
assert by['ambush']['cashLoss'] == min(20, by['ambush']['lossBudget'])
assert by['repair']['cashLoss'] == min(12, by['repair']['lossBudget'])
assert by['blocked-detour']['cashLoss'] == min(12*2, by['blocked-detour']['lossBudget'])
assert by['ambush-escape-damage']['cargoLoss'] == 45
assert 10*5 > by['ambush-escape-damage']['lossBudget']  # full batch cannot fit
assert by['spill-cover']['damage']['afterQuality'] == 93
assert by['damage-floor']['damage']['afterQuality'] == 25
assert by['damage-tiny']['totalLoss'] == 0
assert by['empty-escape']['after']['debt'] == by['empty-escape']['before']['debt']
assert by['blocked-return']['after']['returnTravelDays'] == max(1, 2)
out = dict(fixture=str(source), checkedVariants=checks, checksPassed=True,
           scope='Integer valuation, 15% budget, quality/cover/floor, split-cost conservation, payments, time and next-trip protection. No runtime test.')
Path('design/states/D1-D6-design-v15/event-outcome-verification.json').write_text(json.dumps(out, indent=2)+'\n')
print(f'{len(checks)} numeric fixture variants passed')
