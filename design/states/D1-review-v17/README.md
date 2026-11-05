# D1 — beş hissə üçün baxış paketi

Status: istifadəçinin nəzərdən keçirməsi üçün təklif; istehsal təsdiqi deyil. Runtime kodu dəyişdirilməyib.

- **7 ikon:** spices, iron, salt, wool, herbs, mana_crystal, dragon_resin mövcud v13 atlasından. `P1/P2/P3-icons-{list,cards}-scroll-N.png` bütün 10 malı əhatə edir. Yeni yeddi rəsm yaradılmayıb; mövcud ikonların siyahı/kartda istifadəsi hazırlanıb.
- **Token cədvəli:** `tokens.json`, adlandırılmış dp və sp/line-height/weight rolları. Mövcud geometry px/2, typography matrix mənbəyindən. Safe inset runtime cihaz sabiti deyil.
- **Animasiya:** `motion.json`; səyahət800ms, gün240ms, ticarət180ms; easing və reduced motion0ms. `P1/P3-*-storyboard.png` sxematik dörd kadrdır; hazır animasiya və final araba asset-i deyil.
- **← Bazara qayıt:** kök siyahıda gizlənir. Detal/önbaxışdan LIST-ə qayıdır, ticarət etmir; keypad isə redaktəni ləğv edib əvvəlki bölməyə qayıdır. `interaction.json` dəqiq state qaydalarını saxlayır.
- **Planşet:** bounded master-detail təklifi; safe width616dp, fontScale≥1.3 üçün1196dp. Bunlar minimum panel eninə əsaslanan dizayn namizədidir; mövcud kodun1160dp həddi dəyişdirilməyib. `P3-{AZ,EN,RU,TR}-{1.0,1.3,2.0}x-master-detail.png` kompozisiya nümunələridir.

Planşet nümunəsi yalnız yeddi ilk sətri və seçilmiş malın sadələşdirilmiş detalını göstərir. Bütün state-lər, boundary viewport-ları, real scroll və Android font scaling matrisi bu paketdə yoxlanmayıb. Storyboard-lar təqdimat lövhəsidir; P1/P3 native ekran kadrları kimi qəbul edilməməlidir.

## Yoxlama

`swiftc design/tools/render-d1-review-v17.swift -o /tmp/render-d1-review-v17` sonra `/tmp/render-d1-review-v17`.

32 PNG, missingGlyphs=0. Mövcud palitra: Ink/Paper7.85:1, Nav/Paper10.99:1. PNG ölçüləri və bütün ikon səhifələrinin mövcudluğu yoxlanıb. Nümunələr vizual baxılıb; hər PNG fərdi yoxlanmayıb. App build/test və cihaz sınağı aparılmayıb, çünki bu vahid yalnız statik dizayn paketidir.

Dizaynı olmayan Xəritə/Yük və digər ekranlar gözləyir. Runtime tətbiqindən əvvəl istifadəçi rəyi və real boundary/render yoxlaması lazımdır.
