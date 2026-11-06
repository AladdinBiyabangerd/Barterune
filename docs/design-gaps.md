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

## 1. Maldan Alış/Satış önizləməsinə keçid — v20 tətbiq olunub (qalanlar)
- `D1-trade-flow-v20` telefonda tətbiq olunub: mal detalı → Alış/Satış önbaxışı → təsdiq; geri mal detalına qayıdır. Limitdə səbəb + Miqdarı/Partiyanı dəyiş.
- Planşet: P3 trade chrome yoxdur (v20 yalnız P1). Siyahıdan mal açılınca kompakt v20 axınına keçir — P3-ə uyğun iki panelli Al/Sat dizaynı hələ yoxdur.
- Lazım olan: P2/P3 × EN/RU/TR × 1.3x/2.0x trade-flow renderləri; planşet master-detail içində Al/Sat/miqdar/partiya.

## 2. Zədəli partiya etiketi — v19 tətbiq olunub (qiymət açıq)
- Etiket: `Zədəli · {quality}%` / `Sağlam · 100%` (Aladdin 2026-11-06, variant 02). "—" çıxarılıb; maya/marja göstərilir.
- v19 README: satış qiyməti/marja layout-u bu paketə daxil deyil. Lazım olan: zədəli partiya üçün Partiyalar/satış önizləməsinin təsdiqlənmiş qiymət sətirləri (P1/P2/P3, 4 dil, 3 miqyas).

## 3. Planşet siyahısı — v18 tətbiq olunub
- classic-v1 sırası, 10 mal, müstəqil scroll, seçim qorunur, header/footer hint. Qalan: böyük şrift/EN/RU/TR siyahı renderləri; görünən sətir sayının dizaynla sıx uyğunluğu.

## 4. P3 planşet — tam vəziyyətlər və keçid həddi
- Kod v17 `P3-*-master-detail` kompozisiyasını tətbiq edir (fərq 1,2%). README: nümunə sadələşdirilib, bütün vəziyyətlər yoxdur.
- Lazım olan: master-detail üçün Partiyalar, Al/Sat önizləməsi, uğur/xəta, stress (L05–L08, O01–O05, T05) vəziyyətləri; 4 dil × 3 miqyas.
- Keçid həddi: **Aladdin 2026-11-05 təsdiqləyib** — bütün şrift miqyaslarında safeWidth ≥ **1196dp** (`DefaultTabletMinWidth` = 2×580 + 2×12 margin + 12 gap). Safe inset-lər ölçmədən əvvəl çıxılır; 1196dp-dən aşağı tək panel qalır. v17-dəki 616dp namizədi istifadə olunmur (P1/P2 master-detail renderi yoxdur; dar panellər üçün ayrıca adaptiv dizayn lazımdır).

## 5. Klaviatura — v18 tətbiq olunub
- Dörd sütun `1 2 3 ←` / `4 5 6 −` / `7 8 9 .` / `0 [✓×3]`; README validasiya qaydaları + unit testlər. Qalan: digər dillər/şrift miqyası üçün yekun vizual təsdiq.

## 6. Token cədvəli — təsdiq gözləyir
- `design/states/D1-review-v17/tokens.json` təklifdir; kodda qəbul edilməyib. Lazım olan: istifadəçi təsdiqi (margin, gap, inset, target, safe inset, maxTextWidth, artWidth/artHeight, frameEdge; tip rolları).

## 7. Animasiya — müddətlər təsdiqlənib
- `D1-review-v17/motion.json` müddətləri **Aladdin 2026-11-05 təsdiqləyib** və `BarteruneMotion` ilə kodda tətbiq olunub: səyahət 800ms, gün 240ms, ticarət 180ms, cubic-bezier(0.4,0,0.2,1), reduced motion 0ms. Bunlar yalnız vizual müddətlərdir; pending/DB və oyun qaydalarını idarə etmir.
- Lazım olan (açıq qalan): yekun kadrlar/araba asset-i və səyahət/gün ekranlarında faktiki animasiya consumer-ləri (M2).

## 8. P2 əlavə vəziyyətlər
- P2 üçün `D1-device-matrix-v15` 30 vəziyyəti əhatə edir, kod onlarla uyğun gəlir. Lazım olan yalnız: yuxarıdakı 1–2 bəndlərinin P2 variantları (sol 32dp inset ilə).

## 9. Yük/Xəritə alt naviqasiyası
- Alt paneldə "Xəritə" və "Yük" görünür, amma ekranlar M2-yə aiddir. Lazım olan: onların ekranları (D2 travel, yük) — ayrıca tapşırıq.

## 2026-11-05 — Aladdin hədd və motion müddətlərini təsdiqlədi
Planşet keçidi: bütün şrift miqyaslarında **1196dp** (`DefaultTabletMinWidth`). `TabletMarket` xarici 12dp margin tətbiq edir. 616dp istifadə olunmur.

`BarteruneMotion` mərkəzi konfiqurasiyadır (səyahət 800ms, gün 240ms, ticarət 180ms, reduced motion 0ms). Market HUD gün keçidi və təsdiqlənmiş ticarət fade-i bunlardan istifadə edir; səyahət/gün ekranları ayrıca işdir. Digər dizayn boşluqları (1–3, 5–6, 8–9) bu qərarla bağlanmır.

### Motion runtime əlavəsi — 5 noyabr2026
- CompactMarketScreen: committed gün dəyişməsi240ms Crossfade; ticarətin TRADE_SAVED məlumat sətirləri180ms fade-in. Çərçivə və geri düyməsi animasiya edilmir; ilk kompozisiya/bərpa sabit göstərilir.
- Android/Compose MotionDurationScale istifadə olunur: sistemdə0 olduqda ticarət dərhal snap edir, Crossfade isə Compose-un0 miqyasını izləyir. Mövcud1.7.6 versiyasında davam edən animasiya söndürüldükdə iki kadradək tamamlanma test edilib.
- Səyahət runtime ekranı/əmri yoxdur; TravelMs800 hələ qoşulmayıb. Gün consumer-i hazırdır, amma WaitDay/StartTravel əmrləri hələ yoxdur. Bu iş onları yaratmır.

## 2026-11-06 — v18/v19/v20 runtime
- v18 klaviatura + planşet siyahısı, v19 zədəli etiket, v20 Al/Sat keçidi `feat/m1-skeleton-engine`-ə tətbiq olunub. §1/§2/§3/§5 yuxarıda qalan dizayn boşluqları ilə yenilənib.
