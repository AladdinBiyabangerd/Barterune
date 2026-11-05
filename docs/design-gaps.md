# Barterune — dizayn boşluqları (dizayn gözlənilir)

Bu sənəd AI dizayner üçün hazır tapşırıqdır. Aşağıdakı hər bənd kodda **həyata keçirilməyib** və ya müvəqqəti saxlanılıb, çünki mövcud dizayn mənbəyi yoxdur. Kod yalnız mövcud PNG, spec və renderer skriptlərinə əsaslanır; heç nə uydurulmur.

## Ümumi qaydalar (hər tapşırıq üçün)

- Profillər (D1-canonical-render-matrix.json):
  - **P1** — kiçik landşaft telefon, 640×360dp, density 2 (1280×720px), safe inset yuxarı/aşağı 24dp.
  - **P2** — uzun telefon, 800×360dp, density 3 (2400×1080px), sol inset 32dp (kəsik).
  - **P3** — planşet, 1280×800dp, density 2 (2560×1600px).
- Dillər: AZ, EN, RU, TR (D1-render-localization.json). Şrift miqyası: 1.0x, 1.3x, 2.0x.
- Tokenlər: D1-pixel-composition-tokens.json, D6-canonical-token-proposal.json. Rənglər: paper #FCECD0, nav #1A3546. Tip rolları D1-canonical-render-matrix.json `typeTrial.roles`.
- Üslub nümunələri: `design/states/D1-pixel-composition-v7/`, `design/states/D1-device-matrix-v15/`, `design/states/D1-keypad-fixed-v16/`, `design/states/D1-D6-design-v15/D1-P3-master-detail.png`.
- Pul vahidinin adı: **Qızıl** (bütün ekranlarda; istifadəçi 2026-11-05 təsdiqləyib). Köhnə PNG-lərdəki "Pul" yeniləmə gözləyir.
- Çıxış: hər vəziyyət üçün `scroll-N.png` + `verification.json` (rect-lər dp ilə), renderer skripti `design/tools/` altında.

## 1. Maldan Alış/Satış önizləməsinə keçid (bütün profillər)
- Vəziyyət: v7 bölmələrində (list → good → batches) `buyPreview` və `sellPreview` ekranları var, amma ora aparan düymə/keçid yoxdur (v16 decision.json "remaining.3").
- Kodda: önizləmə ekranları hazırdır, lakin telefonda onlara keçid **yoxdur** — telefonda alış/satış hazırda əlçatmazdır.
- Lazım olan: "Mal" bölməsində (və/və ya Partiyalar bölməsində) Al/Sat önizləməsinə aparan sətirlərin yeri, mətni (4 dil), aktiv/passiv halları; önizləmədən geri qayıdış hədəfi. P1, P2, P3; AZ/EN/RU/TR; 1.0x/1.3x/2.0x.

## 2. Bazar kökündə "← Bazara qayıt" sətri
- v7/v15 siyahı ekranında sətir görünür, amma hədəfi müəyyən deyil (v16 "remaining.4"). Kodda göstərilir, heç nə etmir.
- Lazım olan: siyahı ekranında bu sətir gizlənsinmi, yoxsa hara aparsın? P1/P2 siyahı vəziyyətləri yenidən.

## 3. Zədəli partiyanın satış qiyməti və marjası
- D1-render-fixture.json-da zədəli partiya üçün `sellUnit: null`, v7-də "Vahid satış qiyməti —". Kod hazırda bunu göstərir.
- v16 "remaining.6": qayda hələ uzlaşdırılmayıb. Lazım olan: zədəli partiya satıla bilərmi, qiymət/marja necə göstərilir, Sat düyməsi halı. Partiyalar və satış önizləməsi, P1/P2/P3.

## 4. Mal ikonları
- 10 malın hamısı üçün ikon mövcuddur: cloth/grain/wood — `iconSource` kəsikləri, digər 7 — `atlas-normalized-v13`. Kodda hamısı istifadə olunur.
- v7/v15 renderləri ikonu yalnız 3 mal üçün göstərir (v15 matrix: "seven dedicated icons pending"). Lazım olan: 7 mal üçün təsdiqlənmiş ikonla siyahı/kart renderləri (P1, P2, P3) və ya atlasın təsdiqi.

## 5. P3 planşet: master-detail və keçid nöqtəsi
- Kod P3-də `D1-device-matrix-v15/P3-*` (tək mərkəzi sütun) tətbiq edir. `D1-D6-design-v15/D1-P3-master-detail.png` (iki sütun, D6 V04) yalnız AZ 1.0x üçün var və matrix ilə ziddiyyət təşkil edir — hazırda istifadə olunmur.
- Lazım olan: (a) P3 üçün yekun qərar: tək sütun, yoxsa master-detail; (b) master-detail seçilərsə, 30 vəziyyətin hamısı AZ/EN/RU/TR × 1.0x/1.3x/2.0x; (c) telefon/planşet keçid eni. v16 klaviaturası planşetdə mərkəzləşir — kod bunun üçün müvəqqəti 1160dp (2×maxTextWidth) həddini istifadə edir; v16 "remaining.12": təsdiqlənməyib.

## 6. Sabit klaviatura (v16) — tamamlanma
- `D1-keypad-fixed-v16` tətbiq olunub (P1/P2/P3). Status: "static_design_revision_in_progress".
- Lazım olan: yekun təsdiq; mənfi/onluq daxiletmə hallarının (negative, decimal) necə yarana biləcəyi — klaviaturada "−" və "." yoxdur, bu vəziyyətlər əldə edilə bilmir.

## 7. Token cədvəli (aralıq və tipoqrafiya)
- D6-canonical-token-proposal.json yalnız təklifdir (v16 "remaining.10"). Lazım olan: təsdiqlənmiş istehsal cədvəli — margin, gap, inset, target, safe inset, maxTextWidth, artWidth/artHeight, frameEdge; tip rolları (ölçü/sətir hündürlüyü/çəki) və miqyasda davranış.

## 8. Animasiya vaxtları və storyboard
- Səyahət, gün keçidi, alış/satış nəticəsi üçün vaxtlar və kadrlar yoxdur (v16 "remaining.11"). Lazım olan: hər keçid üçün müddət (ms), easing, kadr ardıcıllığı; P1 və P3.

## 9. P2 əlavə vəziyyətlər
- P2 üçün `D1-device-matrix-v15` 30 vəziyyəti əhatə edir, kod onlarla uyğun gəlir. Lazım olan yalnız: yuxarıdakı 1–3 bəndlərinin P2 variantları (sol 32dp inset ilə).

## 10. Yük/Xəritə alt naviqasiyası
- Alt paneldə "Xəritə" və "Yük" görünür, amma ekranlar M2-yə aiddir. Lazım olan: onların ekranları (D2 travel, yük) — ayrıca tapşırıq.
