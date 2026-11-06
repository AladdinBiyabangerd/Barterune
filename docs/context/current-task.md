# Barterune — D1 miqdar dizaynı

## Completed
- Q/L/F/E dörd mövcud PNG oxunub və vizual baxılıb.
- Miqdar təklifləri docs/decisions.json → designResolutions.D1-quantity-review daxilində yekunlaşdırılıb. Bunlar agentin istifadəçi tapşırığı əsasında dizayn seçimləridir; ayrıca istifadəçi təsdiqi iddiası deyil.
- Ləğv əvvəlki miqdarı bərpa edir; redaktədə Al/Sat kilidlidir; etibarsız giriş saxlanır və təsdiqlənmir; rəqəm həddi6-dır.
- Alış maksimumu pul/tutum/ehtiyatla, satış maksimumu yalnız seçilmiş partiya ilə hesablanır. Ayrı adlandırılır; uyğunlaşdırma əməliyyat etmir.
- 2/5/8 və sağlam partiya5 tətbiqi üçün D1-quantity-applied-v2.png tamamlanıb; düymələr düzəldilib və yekun PNG vizual yoxlanıb.

## Current state
- Yalnız dizayn/sənəd işi; implementasiya başlamayıb.
- Mövcud Q/F/E-də ümumi Max və açıq digit-cap qeydləri tarixi eskizdir; yeni qərarlar üstün mənbədir.
- D1 bütövlükdə və D2–D6 tamamlanmayıb. Rəqəmlər balans deyil.

## Decisions
- 51B/52C/53B/54C/71A/76A/86 qüvvədədir.
- Miqdarın tətbiqi cari HUD, pul, yük, partiya və bazar ehtiyatını dəyişmir. Alış/satış preview-ləri ayrı adlanır.
- Maksimum0 tətbiq edilmir; səbəblə passivdir. Etibarlı, lakin əməliyyat limitindən böyük miqdar üçün uyğun Al/Sat passiv olur.
- Kanonik token yoxdur; mövcud PNG palitrası qorunur. Kontrast/cihaz/toxunma/lokalizasiya yoxlanmayıb, D6-da qalır.

## Remaining work
- D1-market-draft əsas ekran düzəlişləri, faktiki alış/satış uğuru, partiyanın satışla bitməsi və digər D1 coverage halları.
- Sonra D2–D6; bütün axınlar hazır olmadan yekun icra planı və implementasiya yoxdur.

## Relevant files
- docs/decisions.json
- docs/design-coverage.json
- design/states/D1-quantity-review-v2-spec.json
- design/states/D1-quantity-applied-v2.png
- design/states/D1-quantity-input-v2.png
- design/states/D1-quantity-limits-v2.png
- design/states/D1-quantity-actions-v1.png
- design/states/D1-quantity-invalid-v1.png
- design/states/D1-market-draft.png

## Checks performed
- Mövcud4 PNG və yeni yekun A v2 view_image ilə baxılıb; Al/Sat yanaşıdır, rəqəmlər, HUD, preview-lər və partiyalar yoxlanıb. JSON sintaksisi yoxlanıb.
- Hesablar:2×35=70;100−70=30;5×35=175;500−175=325;30+10=40;8×35=280;500−280=220;8×2=16;5×28=140;500+140=640;16−10=6;alış max floor24/2=12, satış max5.
- Oyun/test kodu dəyişməyib.

## Exact next step
- Növbəti dizayn vahidi: D1-market-draft knownIssues düzəlişləri və faktiki alış/satış uğuru, partiyanın tükənməsi. Əvvəl coverage və designResolutions oxu; implementasiyaya başlama.


# Kod planı — 2 noyabr 2026 əlavə konteksti

## Completed
- docs/IMPLEMENTATION_PLAN.az.md yazıldı: stack/modullar, modellər, save/sync/auth, online rekord/nailiyyət, 51–85 PNG mapping, production asset siyahısı, Play qaydaları və M0–M7 qəbul meyarları.
- Arrowz PLAN.md struktur nümunəsi oxundu; rəsmi Google qaydaları yoxlandı, keçidlər plandadır.

## Current state
- Oyun kodu yoxdur. Plan layihədir; implementasiya icazəsi deyil. D1 dizaynı paralel chatdə davam edir, onun son statusunu decisions.json və design-coverage.json-dan götür.

## Decisions
- İstifadəçi: məcburi ilk Google girişi; sonra offline oyun; cloud save və cihazlararası davam; V1 online rekord+nailiyyət; yalnız Android telefon/planşet; AZ/TR/RU/EN; 13+; şəxsi Play hesabı.
- Kotlin/Compose, Room, Firebase auth, Ktor/Cloud Run replay və server leaderboard, PGS achievements texniki tövsiyələrdir, ayrıca təsdiq deyil.

## Remaining work
- Plan §16: minSdk26, stack, ranked online-start, balans, supported rejim və yeni sistem ekranları. Şəxsi Play hesabının açılma tarixi məlum deyil.

## Relevant files
- docs/IMPLEMENTATION_PLAN.az.md
- docs/decisions.json
- docs/design-coverage.json
- docs/MONETIZATION_PLAN.az.md

## Checks performed
- Mənbələr və 35 seçim lövhəsinin qərarları oxundu; reference PNG açılıb baxıldı; rəsmi Play API36/16KB/Billing/deletion/testing mənbələri yoxlandı.
- D1-quantity-applied-v2.png son fayl yoxlamasında mövcuddur; bu plan işində renderi yoxlanmayıb. Build/test/UI render yoxdur, kod yazılmayıb.

## Exact next step
- Plan §16-nı oxu, texniki seçim cavablarını al və planı yenilə; sonra yalnız bir kiçik M0 qərar/dizayn qrupu tamamla.


# §16 qərar yeniləməsi — 2 noyabr 2026

## Completed
- IMPLEMENTATION_PLAN.az.md §1/2/8/15/16 istifadəçi cavabları ilə uyğunlaşdırıldı.
- Ranked online-start və ilkin beş nailiyyət qəbul edildi; V1 yalnız classic, supported sonraya saxlandı.

## Current state
- Yalnız sənəd işi; implementasiya yoxdur. Əvvəlki D1 dizayn statusu dəyişdirilməyib.
- minSdk açıqdır; stack təsdiqlənməyib, əvvəl alternativlər müqayisə edilməlidir.

## Decisions
- Sonrakı məhsul ardıcıllığı: balans təklifi → istifadəçi seçimi → D5 sistem ekranları.
- Privacy/deletion GitHub Pages üzərində olacaq; konkret URL və müraciət emalı açıqdır.
- Play/AdMob/Unity başqa tətbiq üçün mövcuddur; Barterune ID-ləri və Unity inteqrasiyası təsdiqlənməyib.

## Remaining work
- Stack müqayisəsi, minSdk seçimi, balans təklifi, nailiyyət trigger-ləri, D1–D6.
- Play hesab tarixi, developer ictimai məlumatları, applicationId, region/büdcə və tətbiq ID-ləri.

## Relevant files
- docs/IMPLEMENTATION_PLAN.az.md (§16 əsas davam nöqtəsidir)
- docs/decisions.json
- docs/MONETIZATION_PLAN.az.md
- docs/design-coverage.json

## Checks performed
- İki tələb olunan sənəd oxundu; decisions/monetizasiya üzrə hədəfli mətn axtarışı aparıldı.
- Play Console brauzerdə açıldı: qoşulu Chrome başqa Google hesabıdır, istənilən profil seçimdə yoxdur. Console məlumatları təsdiqlənmədi və ayarlar dəyişdirilmədi.
- Yenilənmiş qərar mətnləri və faylların whitespace yoxlaması aparıldı. Git diff mümkün olmadı: qovluq Git repository deyil. Oyun kodu, build/test və vizual render yoxdur.

## Exact next step
- Yalnız stack alternativlərinin müqayisəsini hazırla və seçim üçün təqdim et; sonra ayrıca balans təklifi. Implementasiyaya başlama. Console yoxlaması üçün istifadəçinin göstərdiyi düzgün Chrome profili əlçatan olmalıdır.


## Aktiv brauzerdən sonrakı yoxlama — 2 noyabr 2026
- Native `cua.getApp("com.google.Chrome")` aktiv Aladdin profilini açdı; əvvəlki extension bağlantısı başqa profil idi. Düzgün hesab indi əlçatandır.
- Developer adı: AB Pixel Labs. Barterune — Merchant Adventure Console qeydi var; daxili app ID 4975590916599881823, Android applicationId deyil.
- Dashboard: qurulum 1/13; production üçün 12 tester ilə fasiləsiz 14 gün closed test tələb olunur, hazırda 0 tester.
- Dəqiq hesab tarixi, paket adı və ictimai əlaqə e-poçtu yoxlanmayıb. Ayarlar dəyişdirilməyib; implementasiya yoxdur.
- IMPLEMENTATION_PLAN.az.md §16.4–16.5 yeniləndi. Növbəti addım yenə stack alternativlərinin müqayisəsidir.


# Aktiv dizayn davamı — 2 noyabr 2026

## Completed
- D1-trade-spec.json: düzəldilmiş siyahı/kart və alış/satış nəticələri üçün T01–T06 hesabları və davranışları yazılıb.
- D5 coverage istifadəçinin giriş, cloud konflikt, online rekord, hesab silmə və mağaza tələbləri ilə genişləndirilib.

## Current state
- Dizayn işidir; oyun implementasiyası yoxdur. D1 lövhəsinin renderi hazırlanır; yekun vizual yoxlama aşağıdakı son qeyddə göstəriləcək.
- Aktiv istifadəçi məqsədi D1 qalan hallar → D2–D6-dır; əvvəlki stack müqayisəsi bu chatin davam nöqtəsi deyil.

## Decisions
- Satışın ehtiyata təsiri və böyük əməliyyatdan sonra qiymət modeli açıqdır; uydurma rəqəm əvəzinə bazarın yenilənməsi göstərilir.
- Sağlam partiya bitəndə qalan zədəli partiya avtomatik seçilmir/satılmır; miqdar qorunur, Sat səbəblə passivdir. Bunlar agent dizayn seçimləridir, ayrıca istifadəçi təsdiqi deyil.

## Remaining work
- D1: ehtiyat0/pul/tutum hallarının yeni əsas ekranla uyğunlaşdırılması, maksimum təkmilləşdirmə, əməliyyat gözləmə/xəta lövhələri. Sonra D2–D6.
- D5-də ilk Google girişi, cloud konflikt, online rekord, hesab silmə və mağaza da mütləq hazırlanmalıdır.
- Kanonik tokenlər, kontrast, real cihaz ölçüləri və AZ/TR/RU uzun mətn yoxlaması D6-da açıqdır.

## Relevant files
- design/states/D1-trade-spec.json
- design/states/D1-market-draft.png
- docs/design-coverage.json
- docs/decisions.json
- docs/IMPLEMENTATION_PLAN.az.md

## Checks performed
- Mövcud D1-market-draft.png vizual baxılıb; JSON faylları parserlə yazılıb.
- Hesablar:500−2×35=430;16+2×2=20;500+2×28=556;16−2×2=12;500+5×28=640;16−5×2=6.

## Exact next step
- Son render yoxlama qeydini oxu; D1 qalan məhdudiyyətlər və maksimum təkmilləşdirmə lövhəsini hazırla. D1 bitəndən sonra D2-yə keç; oyun implementasiyasına başlama.


## Spark və ödənişli yükləmə qərarı — 2 noyabr 2026
- Completed: implementasiya planı §2.1/16 və monetizasiya planına son qərar əlavəsi yazıldı; rəsmi Firebase/Play mənbələri yoxlandı.
- Current state: implementasiya yoxdur. Əvvəlki backend arxitekturası Spark məhdudiyyəti ilə həll edilməyib.
- Decisions: yalnız Firebase Spark, Blaze/billing təsdiqlənməyib; Play-də ödənişli yükləmə; könüllü reklam və kosmetik IAP qalır; qiymət açıqdır. V1 classic.
- Remaining work: Spark uyğun save/sync və backend müqayisəsi; ranked replay, SSV, alış doğrulaması və deletion həlli; Console free/paid statusu; qiymət. Əvvəlki minSdk/balans/D1–D6 açıq işləri qalır.
- Relevant files: docs/IMPLEMENTATION_PLAN.az.md (§2.1/16), docs/MONETIZATION_PLAN.az.md, docs/decisions.json, docs/design-coverage.json.
- Checks performed: rəsmi Firebase plan/Storage və Play pricing səhifələri oxundu; yenilənən sənəd əlavələri yoxlandı. Kod/build/test/UI dəyişməyib; Console ayarı dəyişdirilməyib.
- Exact next step: yeni chatdə Spark məhdudiyyətinə uyğun stack/backend alternativlərini müqayisə et; çatışmayan server funksiyalarını açıq göstər və seçim üçün təqdim et. İmplementasiyaya başlama.

## Son render yoxlama qeydi
- design/states/D1-market-trades-v2.png workspace-ə saxlanıb və view_image ilə baxılıb. T01–T06 əsas hesabları, yanaşı Al/Sat, partiya bitməsi və boş inventar yoxlanıb.
- Lövhə draftdır: T03–T06 təkrar HUD xülasəsi var; kanonik kompozisiyada siyahı ilə əvəzlənməlidir. Tam 10 mal, miqdar maksimumları və preview komponentləri son birləşdirmədə qorunmalıdır.
- docs/design-coverage.json və decisions.json yeni lövhə/spec ilə bağlanıb; JSON parser yoxlaması keçib. Kontrast, cihaz və lokalizasiya yoxlanmayıb.
- D1 tam bitməyib; D2–D6 başlanmayıb. Exact next step yuxarıdakı D1 qalan məhdudiyyətlər/təkmilləşdirmə vahididir.

# Aktiv davam nöqtəsi — D1 qalan hallar, 2 noyabr 2026

## Completed
- D1-remaining-spec.json və D1-remaining-board-v1.png: L05–L08 ehtiyat/pul/tutum/çoxlu səbəb; U01–U02 maksimum təkmilləşdirmə; O01–O06 gözləmə, təsdiqlənmiş xəta, naməlum nəticə, yeni qiymət baxışı, bazar yeniləmə xətası və partiya uyğunsuzluğu.
- Təkrar əməliyyat, tətbiq bağlanıb açılma, satış və təkmilləşdirmə xətalarının davranışı spesifikasiyaya bağlandı.
- coverage və decisions yeni spec/lövhə ilə əlaqələndirildi; trade-spec-də etibarlı quote yoxdursa həm Al, həm Sat kilidləndi.

## Current state
- Yalnız dizayn/sənəd işi; oyun implementasiyası yoxdur. Swift yalnız statik dizayn lövhəsinin render alətidir.
- D1 qalan vəziyyət detalları layihə olaraq hazırlanıb; tam kanonik ekran birləşməsi və açıq məhsul parametrləri qalıb. D1 bütövlükdə təsdiqlənmiş/tamamlanmış deyil.
- D2–D6 başlanmayıb. Aktiv sıra D2 → D3 → D4 → D5 → D6; D1 kanonik birləşməsi D6-da da yoxlanmalıdır.

## Decisions
- Agent dizayn seçimləridir, ayrıca istifadəçi təsdiqi deyil. Maksimum səviyyə/effekt/qiymət uydurulmayıb.
- Təsdiqlənmiş tətbiq edilməmə ilə naməlum nəticə ayrıdır. Naməlum nəticədə retry/new trade yoxdur; əvvəl eyni əməliyyatın nəticəsi yoxlanır.
- Lokal ticarət offline işləyir; cloud xətası lokal saxlanmış əməliyyatı geri almır.
- Maksimum səviyyədə yeni qiymət və alış yoxdur; cari effekt göstərilir. Classic başlanğıcına daimi üstünlük əlavə edilmir.

## Remaining work
- D2 coverage halları və seçilmiş 55/56/61/70/72/73/74/78/85 qərarları əsasında spec, keçidlər, qəbul meyarları və vizual lövhə.
- Sonra D3, D4, D5 (Google giriş, cloud konflikt, rekord, hesab silmə, mağaza daxil), D6.
- D1 kanonik tam 10 mal kompozisiyası, maksimum/preview-lər; iqtisadiyyat, səviyyələr, effektlər, partiya birləşdirmə və yuvarlaqlaşdırma açıqdır.
- D6: kanonik tokenlər, cihaz/planşet, toxunma, uzun AZ/TR/RU/EN, hərəkət və animasiya. Review-board tokenləri oyun tokenləri deyil.
- Texniki Spark/backend/balans/minSdk məsələləri ayrıca planda qalır; bu dizayn tapşırığını əvəz etmir.

## Relevant files
- docs/design-coverage.json
- docs/decisions.json (confirmed və visualChoiceBoards)
- design/states/D1-trade-spec.json
- design/states/D1-remaining-spec.json
- design/states/D1-remaining-board-v1.png
- design/states/D1-board-tokens.json
- design/tools/render-d1-board.swift
- docs/IMPLEMENTATION_PLAN.az.md və docs/MONETIZATION_PLAN.az.md (yalnız D5 ehtiyacına görə hədəfli oxu)

## Checks performed
- PNG Swift/AppKit ilə render edildi və view_image ilə açılıb baxıldı; 12 kart, AZ mətnləri və sərhədlər vizual yoxlandı.
- ui-craft contrast.py: nav/paper 10.99:1, ink/paper 7.85:1. Yalnız bu lövhəyə aiddir.
- JSON parse və yeni əlaqəli fayl yolları yoxlandı; hesablar 56, 50, 40, 36, 556 yoxlandı.
- Build/oyun testi/real cihaz/toxunma/lokalizasiya matrisi yoxlanmayıb; oyun kodu yazılmayıb.

## Exact next step
- Yalnız D2 dizayn vahidinə başla: coverage + seçilmiş qərarların hədəfli oxunuşu, açıq üçüncü marşrut və risk modelini təsdiqlənmiş saymadan vəziyyət/keçid spec-i və vizual lövhə hazırla. İmplementasiyaya başlama. D2-dən sonra ardıcıllığı D3–D6 olaraq saxla.

# Aktiv davam nöqtəsi — D2 vəziyyət dizaynı, 2 noyabr 2026

## Completed
- D2-travel-spec.json: M01–M05, S01–S04, T01–T05, W01, A01; keçidlər, qəbul meyarları və açıq məhsul qaydaları yazıldı.
- D2-travel-board-v1.png mövcud review-board tokenləri ilə render edildi və baxıldı; coverage/decisions əlaqələndirildi.

## Current state
- Yalnız dizayn/sənəd işi; oyun implementasiyası yoxdur. Swift statik lövhə alətidir.
- D2 vəziyyət layihəsi hazırlanıb; kanonik xəritə/illüstrasiya kompozisiyası tamamlanmayıb. D2 tam təsdiqlənmiş deyil. D3–D6 görülməyib.

## Decisions
- Agent dizayn seçimləri, ayrıca istifadəçi təsdiqi deyil. 61B əsasdır: ayrıca iki xidmət kartı; xəritədə xülasə/keçid, təkrar ödəniş yoxdur.
- Aktiv səyahətdə Depart/xidmət tut paneli yoxdur. Məcburi hadisədən geri onu ötürmür. Gözləmə yalnız şəhərdə və gün<20 mümkündür.
- Üçüncü yol, risk faizləri, müqavilə rəqəmləri və gecikmə rekord qaydası uydurulmayıb; məhsul blokerləri kimi açıqdır.

## Remaining work
- D3 borc və ödəniş; sonra D4, D5, D6. D2 açıq məhsul qaydaları və kanonik kompozisiya qalır.
- D1 kanonik tam 10 mal kompozisiyası və əvvəlki iqtisadiyyat blokerləri qalır.

## Relevant files
- design/states/D2-travel-spec.json
- design/states/D2-travel-board-v1.png
- design/tools/render-d2-board.swift
- design/states/D1-board-tokens.json (yalnız review-board)
- docs/design-coverage.json
- docs/decisions.json

## Checks performed
- 56/61/74 seçim PNG-lərinə baxıldı; seçilmiş D2 qərarları oxundu.
- 16 kartlıq yekun PNG render edildi və view_image ilə baxıldı; M04 daxili istinadı T04 olaraq düzəldildi.
- Kontrast: nav/paper10.99:1, ink/paper7.85:1. JSON parse və əlaqəli yollar yoxlandı.
- Swift ilk cache-də /tmp alias konflikti verdi; ayrıca cache ilə render uğurludur.
- Oyun/build/real cihaz/toxunma/lokalizasiya yoxlaması yoxdur.

## Exact next step
- D3-ə başla: coverage və confirmed 8/14/37/60/75/83 qərarları, visualChoiceBoards qeydlərini hədəfli oxu. Borc qəbulu, qismən/tam/malla ödəniş, möhlət və son gün hallarına spec/keçid/qəbul meyarı/lövhə hazırla. Sonra D4–D6; implementasiyaya başlama. D2-ni tam bitmiş sayma.

# Aktiv davam nöqtəsi — D3 borc dizaynı, 2 noyabr 2026

## Completed
- D3-debt-spec.json: B01–B03, C01, P01–P02, G01–G02, E01, W01, L01, X01; keçidlər, qəbul meyarları və açıq qaydalar yazıldı.
- D3-debt-board-v1.png mövcud review-board tokenləri ilə render edildi və baxıldı; coverage/decisions bağlandı.
- Coverage-də köhnəlmiş D2 not_started statusu mövcud layihə statusuna uyğunlaşdırıldı; açıq məsələləri qorundu.

## Current state
- Yalnız dizayn/sənəd işi; oyun implementasiyası yoxdur. Swift yalnız statik lövhə renderidir.
- D3 vəziyyət layihəsidir, tam kanonik ofis/iş kompozisiyası deyil və istifadəçi təsdiqi sayılmır. D4–D6 başlanmayıb.

## Decisions
- 8B/14C/37ABC/60C/75B/83C əsasdır; forma iki sütun, ofis yuxarıda və üç alternativ aşağıda, iş ayrıca şəhər ekranıdır.
- Baxış əməliyyat etmir; təsdiq bir dəfə saxlanır. Malla ödəniş bazar satışı deyil; qızıl artmır.
- İşin qızıl qazancı ilə birbaşa borc azaltması ayrılır; gün20 əlavə gün tələb edən işi bloklayır. Digər son gün qaydaları açıqdır.

## Remaining work
- D4 xəbər/hadisə kataloqu, sonra D5 sistem və D6 uyğunlaşma. Böyük növbəti vahidi yeni chatdə davam et.
- D3 limit/faiz/gecikmə, möhlət haqqı üsulu, mal dəyəri/yuvarlaqlaşdırma/artıq təhvil, iş şərtləri və son gün ehtiyat qaydası açıqdır.
- D2 üçüncü yol, risk/qiymət/müddət, müqavilələr və gecikmə rekord qaydası açıq qalır; D1 kanonik 10 mal kompozisiyası və iqtisadiyyat qərarları da qalır.

## Relevant files
- docs/design-coverage.json
- docs/decisions.json
- design/states/D3-debt-spec.json
- design/states/D3-debt-board-v1.png
- design/tools/render-d3-board.swift
- design/states/D2-travel-spec.json
- design/states/D1-board-tokens.json (yalnız review-board)

## Checks performed
- 60/75/83 seçim PNG-ləri və 8/14/37/60/75/83 qərarları oxundu.
- 12 kart render edildi və view_image ilə baxıldı; AZ mətnləri/sərhədlər görünür.
- ui-craft kontrast: nav/paper10.99:1, ink/paper7.85:1. JSON, lövhə yolu və nümunə hesablar yoxlandı.
- Oyun/build/real cihaz/toxunma/dörd dil matrisi yoxlanmayıb.

## Exact next step
- D4-ə başla: coverage və confirmed qərarlarda xəbər/şayiə/hadisə/son qiymət qeydlərini hədəfli oxu; seçilmiş PNG-lərə bax. Təxminən10 hadisə kataloqunu təsdiqlənmiş saymadan vəziyyət/keçid/qəbul meyarı/lövhə hazırla. D2/D3 açıq məsələlərini qoru. Sonra D5–D6; implementasiyaya başlama.


# Aktiv davam nöqtəsi — D4 xəbər və hadisə dizaynı, 2 noyabr 2026

## Completed
- D4-news-events-spec.json: N01–N05 və E01–E07 vəziyyətləri, keçidlər, qəbul meyarları; H01–H10 təklif kataloqunda seçim/nəticə/açıq qaydalar.
- D4-news-events-board-v1.png 12 vəziyyət xülasəsi render edildi və baxıldı; coverage/decisions bağlandı.

## Current state
- Yalnız dizayn/sənəd işi; oyun implementasiyası yoxdur. Swift yalnız statik render alətidir.
- D4 layihədir; lövhə tam illüstrasiyalı 55A/58C/85B kompozisiyası deyil. Kataloq ayrıca istifadəçi təsdiqi deyil. D5/D6 başlanmayıb.

## Decisions
- Xəbər günü, təsirin müddəti və qiymətin müşahidə günü ayrıdır; xəbər qiymət müşahidəsini yeniləmir. Şayiəyə etibarlılıq faizi uydurulmur.
- Hadisə baxışı effekt vermir; qərar/nəticə bir dəfə saxlanır; yenidən açılış reroll etmir. Davam nəticəni təkrarlamır.
- H01–H04 mövcud qərarlara söykənir; H05–H10 yeni kataloq təklifləridir, rəqəmləri açıqdır.

## Remaining work
- D5: ilk açılış/dil, Google giriş və sonrakı offline, save/ehtiyat/yuva, cloud konflikt, rekord, təlim, ayarlar, hesab silmə, mağaza. Sonra D6.
- D4 kataloq/tezlik/rəqəmlər, şayiə/köhnəlmə, bazar effektləri, itki/zədə modeli və kanonik kompozisiya açıqdır.
- D2 üçüncü yol, risk/qiymət/müddət/müqavilə/gecikmə; D3 borc/faiz/limit/möhlət/mal/iş/son gün məsələləri dəyişdirilmədən qorunub.
- D1 kanonik 10 mal kompozisiyası və iqtisadiyyat; D6 token/cihaz/toxunma/dil/hərəkət qalır. Spark/backend ayrıca texniki blokerdir.

## Relevant files
- docs/design-coverage.json
- docs/decisions.json
- design/states/D4-news-events-spec.json
- design/states/D4-news-events-board-v1.png
- design/tools/render-d4-board.swift
- design/states/D1-board-tokens.json (yalnız review-board)
- docs/IMPLEMENTATION_PLAN.az.md və docs/MONETIZATION_PLAN.az.md (D5 üçün hədəfli oxu)

## Checks performed
- 55/58/85 seçim PNG-ləri oxundu; 12 kartlıq yekun render view_image ilə baxıldı.
- Kontrast nav/paper10.99:1, ink/paper7.85:1; JSON və yollar yoxlandı; 240−10=230.
- D2/D3 groupProgress və designResolutions dəyişməzliyi assert ilə yoxlandı.
- Oyun/build/real cihaz/toxunma/dörd dil matrisi yoxlanmayıb.

## Exact next step
- D5-ə başla: coverage və 41–48/63–68/77/81/82 qərarlarını, son Google/cloud/rekord/deletion/mağaza tələblərini hədəfli oxu. Spark/backend imkanlarını həll olunmuş saymadan vəziyyət/keçid/qəbul meyarı/lövhə hazırla. D2–D4 açıq məsələlərini qoru; sonra D6. İmplementasiyaya başlama.


## Spark qoruma modeli təsdiqi — 2 noyabr 2026
- Completed: istifadəçinin online + offline, əlavə serversiz Spark və client/Firebase Rules qoruması seçimi implementasiya və monetizasiya planlarına qeyd edildi.
- Current state: yalnız sənəd; oyun implementasiyası yoxdur.
- Decisions: ilkin versiyada server replay, SSV, server alış doğrulaması yoxdur; client nəticələri doğrulanmış sayılmır. Gələcək Blaze mümkün istiqamətdir, billing/deploy icazəsi deyil.
- Remaining work: save/sync, rules, deduplikasiya, reklam/Billing restore/refund və deletion texniki dizaynı; köhnə backend bölmələri/M3–M5 uyğunlaşdırılmalıdır. UI/oyun stack, balans və D1–D6 açıqdır.
- Relevant files: docs/IMPLEMENTATION_PLAN.az.md (§2.1, §16), docs/MONETIZATION_PLAN.az.md.
- Checks performed: dəyişən sənəd hissələri hədəfli oxundu; kod/build/test/render yoxdur.
- Exact next step: yalnız Spark save/sync və qoruma texniki dizaynını hazırla, sonra əvvəlki backend meyarlarını uyğunlaşdır; implementasiyaya başlama.

# Aktiv davam nöqtəsi — D5 sistem və D6 ilkin uyğunlaşma, 2 noyabr 2026

## Completed
- D5-system-spec.json: 18 vəziyyət xülasəsi, giriş/offline, save/ehtiyat/yuva, konflikt, rekord/nailiyyət, təlim, ayarlar/privacy, hesab silmə, mağaza/reklam; keçidlər və qəbul meyarları.
- D5-system-board-v1.png render edildi və view_image ilə baxıldı; seçilmiş 63/65/66/67/68/77/81/82 eskizləri oxundu.
- D6-adaptation-spec.json: komponent müqavilələri, token alias təklifi, telefon/planşet qaydaları, AZ/TR/RU/EN stress mətnləri, planlaşdırılmış şrift/cihaz matrisi, toxunma/fokus və normal/azaldılmış hərəkət storyboard ardıcıllıqları.
- D6-adaptation-board-v1.png render edildi və view_image ilə baxıldı; coverage/decisions hər iki layihəyə bağlandı.

## Current state
- Yalnız dizayn/sənəd; oyun implementasiyası yoxdur. Swift faylları yalnız mövcud statik review-board rendererinin törəmələridir.
- D5 vəziyyət layihəsidir; bütün alt-vəziyyətlər ayrıca kanonik ekran kimi çəkilməyib. D6 başlanğıc uyğunlaşma müqaviləsidir; kanonik oyun tokenləri və real uyğunlaşmış ekranlar tamamlanmayıb.
- Statik lövhələr real telefon/planşet, 48dp, TalkBack, böyük şrift və dörd dil matrisinin keçdiyini göstərmir.

## Decisions
- Agent dizayn təklifləridir; ayrıca istifadəçi təsdiqi deyil. İlk Google girişi məcburi; sonra həmin UID-nin lokal oyunu offline davam edir.
- Cloud uğuru lokal uğurdan ayrıdır; konflikt avtomatik saat əsasında həll edilmir. Seçilən nüsxə ayrıca əvəzləmə təsdiqi tələb edir.
- Online nəticə pending/verified/rejected ayrılır; offline start yalnız şəxsi rekorddur. Silmə sorğusunun qəbul edilməsi tamamlanma sayılmır.
- Son pullu yükləmə və V1 classic qərarı əsasdır; köhnə supported/tutum bonusu V1-ə daşınmır. Alış/reklam hüququ server təsdiqi olmadan verilmiş sayılmır.
- Review-board palitrası yalnız D6 alias təklifinin mənbəyidir; dp/sp/radius/şrift və kanonik rəng sistemi təsdiqlənməyib.

## Remaining work
- D5: kanonik sistem ekranları, backup restore-un rekord kateqoriyası, təlimin ayrıca sınaq səfəri qaydası, ləqəb/achievement trigger-ləri, privacy/deletion əhatəsi/URL/müddət, mağaza kataloqu və qiymətlər.
- Spark/backend cloud revision/tombstone, ranked ticket/replay, alış doğrulaması, SSV və deletion job həlli açıqdır; bu dizayn texniki həll təsdiqi deyil.
- D6: kanonik token/komponent və D1–D5 ekran birləşməsi, konkret viewport/font seçimi, real render/kontrast/toxunma/TalkBack/dil matrisi; animasiya vaxtı və asset kadrları.
- D2 üçüncü yol/risk/qiymət/müddət/müqavilə/gecikmə; D3 limit/faiz/möhlət/mal/iş/son gün; D4 kataloq/tezlik/şayiə/bazar effekti/itki-zədə və kanonik kompozisiyalar dəyişdirilmədən qorunub.
- D1 kanonik 10 mal/preview/maksimum kompozisiyası və iqtisadiyyat açıqdır.

## Relevant files
- design/states/D5-system-spec.json
- design/states/D5-system-board-v1.png
- design/states/D6-adaptation-spec.json
- design/states/D6-adaptation-board-v1.png
- design/states/D1-board-tokens.json (yalnız review-board)
- design/tools/render-d5-board.swift
- design/tools/render-d6-board.swift
- docs/design-coverage.json
- docs/decisions.json

## Checks performed
- Hər iki PNG render edildi və view_image ilə baxıldı: mətn və düymələr kartlara sığır; bunlar qayda xülasələridir, işlək UI deyil.
- ui-craft contrast.py mövcud tokenlərdən yaradılmış müvəqqəti CSS üzərində nav/paper10.99:1, ink/paper7.85:1 verdi; yalnız lövhəyə aiddir.
- JSON parse, yeni spec/output yolları yoxlandı. D2–D4 stateBoards/groupProgress və designResolutions dəyişməzliyi əvvəlki snapshot-la assert edildi; onların spec faylları redaktə edilmədi.
- Oyun build/test, real cihaz, toxunma, TalkBack və dörd dil matrisi icra edilməyib.

## Exact next step
- Yeni chatdə D6-nın yalnız bir kiçik vahidini davam et: mövcud D6-adaptation-spec.json və D1-board-tokens.json əsasında kanonik token təklifini ayrıca faylda hazırla, review-board piksel ölçülərini oyun ölçülərinə çevrilmiş sayma. Sonra D1-in tam 10 mal kompozisiyasının hansı cihaz/şrift matrisində render ediləcəyini dəqiqləşdir. D2–D5 açıq məsələlərini qoru. İmplementasiyaya başlama.


# Aktiv davam nöqtəsi — D6 kanonik token təklifi, 3 noyabr 2026

## Completed
- D6-canonical-token-proposal.json ayrıca hazırlandı: üç mənbə rəngi, beş semantik alias, komponent istinadları və həll edilməmiş vəziyyət rolları.
- Spacing/type/radius/layout/motion üçün vahid və rol müqavilələri ayrıldı; həll edilməmiş dəyərlər null saxlanıldı. 48dp mövcud tələb kimi qeyd edildi, ölçülmüş nəticə deyil.

## Current state
- Yalnız sənəd təklifi; istifadəçi təsdiqi və implementasiya yoxdur. Review-board px ölçüləri oyun dp/sp ölçülərinə çevrilməyib.
- Yeni kanonik ekran render edilməyib; vizual uyğunluq təsdiqlənməyib.

## Decisions
- D6-nın mövcud surface/textPrimary/actionFill/onAction/emphasisText alias təklifi qorunur; yeni rəng və ölçü literalı seçilməyib.
- ink avtomatik xəta/satış/itki rəngi deyil. Fokus, seçim və status yalnız rənglə verilmir.

## Remaining work
- Şrift, dp/sp şkalaları, radius, vəziyyət palitrası, teksturalı fon, dark mode əhatəsi, viewport/insets və hərəkət vaxtları açıqdır.
- Əvvəlki D5 sistem və D6 ilkin uyğunlaşma qeydindəki bütün D1–D5 məhsul/kompozisiya və Spark texniki açıq məsələləri qüvvədədir; mənbə spec, coverage və decisions dəyişdirilməyib.

## Relevant files
- design/states/D6-canonical-token-proposal.json
- design/states/D6-adaptation-spec.json
- design/states/D1-board-tokens.json
- docs/context/current-task.md (əvvəlki D5/D6 qeydi açıq məsələlərin mənbəyidir)

## Checks performed
- Təklif JSON-u parse edildi; beş alias mənbə palitrasına uyğundur.
- ui-craft contrast.py: textPrimary/surface 10.99:1, onAction/actionFill 10.99:1, emphasisText/surface 7.85:1; düz rəng cütlərində 4.5:1 keçir.
- Oyun kodu/build/test, yeni ekran renderi, real cihaz/toxunma/TalkBack və dil matrisi yoxlanmayıb.

## Exact next step
- D1 tam 10 mal + detal + preview üçün konkret viewport/insets və şrift namizədlərini, AZ/TR/RU/EN × standart/1.3x/2x render matrisini dəqiqləşdir. Sonra ayrıca kanonik statik ekran renderində təklif tokenlərini yoxla. Açıq qaydaları qoru; implementasiyaya başlama.


# Aktiv davam nöqtəsi — D1 konkret render matrisi, 3 noyabr 2026

## Completed
- design/states/D1-canonical-render-matrix.json: üç sintetik üfüqi profil, insets və safe rect; iki font namizədi; dörd dil × üç fontScale matrisi hazırlandı.
- P1 640×360dp → safe640×312; P2 800×360dp → safe768×312; P3 1280×800dp → safe1280×752. Bunlar cihaz ölçməsi və supported minimum qərarı deyil.
- F1 Noto Sans; F2 yalnız başlıqlarda Noto Serif, qalan mətn Noto Sans. Ayrı render-trial sp/lineHeight/weight şkalası təklif edildi; kanonik tokenlər dəyişmədi.
- 72 baza kombinasiya, hər birində ən azı üç capture (216 minimum); sağ cutout/yan naviqasiya üçün əlavə24 minimum capture. Layout keçidi əlavə screenshot tələb edə bilər.

## Current state
- Yalnız dizayn planı; implementasiya və yeni render yoxdur. Bütün case-lər planned_not_rendered-dir.
- 10 malın əlçatanlığı, detal, ayrı preview/maksimum və Al/Sat müqavilələri yazılıb. Hamısının eyni anda görünməsi tələb deyil.

## Decisions
- Böyük şrift üçün mətn kiçildilmir; dekor azalır, sürüşmə və lazım olduqda master/detail sınağı var. Breakpoint təsdiqlənməyib.
- Statik xətti fontScale simulyasiyası real Android font scaling testi sayılmır. Font binary/hash və glyph/fallback yoxlaması renderdən əvvəl tələb olunur.

## Remaining work
- Qalan malların tam deterministik qiymət/ehtiyat/yük fixture-i və AZ/TR/RU/EN tam D1 mətnləri yoxdur; ayrıca hazırlanmalıdır, balans/tərcümə təsdiqi deyil.
- Font binary/versiya/lisenziya manifesti, faktiki screenshot və visual QA yoxdur. dp spacing/radius, vəziyyət palitrası, cihaz/minSdk və animasiya qərarları açıqdır.
- Əvvəlki D1–D5 məhsul/kompozisiya və Spark texniki açıq məsələləri qorunur; mənbə spec, coverage və decisions dəyişdirilməyib.

## Relevant files
- design/states/D1-canonical-render-matrix.json
- design/states/D6-canonical-token-proposal.json
- design/states/D6-adaptation-spec.json
- design/states/D1-trade-spec.json
- design/states/D1-quantity-review-v2-spec.json
- design/states/D1-remaining-spec.json
- design/states/D1-generation-spec.json

## Checks performed
- JSON parse,72 unikal case,10 mal ID-si və üç safe rect hesabı assert ilə yoxlandı.
- Rəsmi Noto sənədlərində Sans/Serif Latin/Cyrillic əhatəsi oxundu: https://notofonts.github.io/noto-docs/website/use/ ; konkret binary glyph testi icra edilməyib.
- Yeni ekran renderi, cihaz/build/test, kontrast/toxunma/TalkBack və lokalizasiya QA yoxdur.

## Exact next step
- Yeni chatdə yalnız D1 render fixture/localization və font binary manifestini hazırla. Sonra ayrıca P1-RU-2x üzrə F1/F2 statik kompozisiya renderini müqayisə et; bütün10 mal, detal/preview/maksimum və açıq məsələləri qoru. Oyun implementasiyasına başlama.

# Aktiv davam nöqtəsi — D1 render məlumatları və font binary, 3 noyabr 2026

## Completed
- D1-render-fixture.json: eyni sıralı 10 mal, tam deterministik alış/satış/ehtiyat/yük dəyərləri, cloth healthy5 + damaged3, T01/T02 baza, ayrı maksimum/preview, C1–C3 capture müqaviləsi, L05–L08/O01/O03/O05/T05 stress snapshot-ları və giriş nümunələri.
- D1-render-localization.json: AZ/TR/RU/EN üzrə 101 eyni açar; mal adları, HUD/detal/partiya/maya/marja, miqdar/keypad, səbəb/status/əməliyyat və maksimum emalatxana etiketləri. Bunlar redaktə və render QA gözləyən tərcümə layihəsidir.
- D1-font-binary-manifest.json: Noto Sans və Noto Serif upright variable binary-ləri, Version2.015, wght400/600/700 və wdth100 instansiya müqaviləsi, SHA-256, pin edilmiş Google Fonts commit-i və lokal OFL-1.1 faylları. Binary-lər design/fonts/notosans və notoserif daxilindədir.

## Current state
- Yalnız dizayn məlumatı/mətn/font hazırlığı; oyun implementasiyası və renderer yazılmayıb. Matrisin bütün case-ləri əvvəlki kimi planned_not_rendered-dir.
- Bu işdə yeni şəkil render edilməyib; vizual uyğunluq təsdiqlənmir. Binary cmap yoxlaması shaping və faktiki font instansiyası testi deyil.

## Decisions
- Cloth35/28, load2, stock30, healthy5/cost24 və damaged3/cost20 əvvəlki mənbələrdən qorunur. Digər9 malın rəqəmləri yalnız sintetik render fixture-idir, balans qərarı deyil.
- Damaged sellUnit null saxlanılıb; köhnə eskizdəki17 qəbul edilməyib. Satışdan sonra stock/quote null/yenilənir; ehtiyata təsir uydurulmayıb.
- Noto Sans U+2192 → qlifini daşımır. Mətn fixture-i bu işarədən istifadə etmir; cari/alışdan sonra/satışdan sonra etiketləri mənanı verir. Səssiz fallback yoxdur.
- Bütün fontlar eyni pin edilmiş upstream commit-dən endirilib: 2fe1e8c6b137fb13041a7cfca6fdcd8a910ea4dc. İstehsal şrift seçimi təsdiqi deyil.

## Remaining work
- P1-RU-2x üzrə F1/F2 ilk statik kompozisiya müqayisəsi; resolved font/axes, screenshot və real scroll mövqeləri qeydə alınmalıdır. Bu chatdə icra edilməyib.
- Variable instansiyalarının faktiki çözülməsi, shaping, tnum və hər çəkidə vizual qlif yoxlaması; native-language redaktə, böyük şrift/layout və cihaz QA qalır.
- D1 iqtisadiyyat, partiya birləşdirmə/yuvarlaqlaşdırma, satışın ehtiyata təsiri; D2–D5 məhsul/kompozisiya; D6 token/dp/radius/palitra/cihaz/minSdk/motion və Spark save/sync/alış/deletion açıq məsələləri dəyişmir. Mənbə spec, matrix, coverage və decisions redaktə edilməyib.

## Relevant files
- design/states/D1-render-fixture.json
- design/states/D1-render-localization.json
- design/states/D1-font-binary-manifest.json
- design/fonts/notosans/NotoSans[wdth,wght].ttf və OFL.txt
- design/fonts/notoserif/NotoSerif[wdth,wght].ttf və OFL.txt
- design/states/D1-canonical-render-matrix.json
- design/states/D6-canonical-token-proposal.json

## Checks performed
- JSON parse; 10 malın sıra/ID uyğunluğu; base yük16; buyMax12/sellMax5; alış70→430/20, satış56→556/12 və L05–L08 tam inventar/limit hesabları assert ilə yoxlandı.
- 101 açar ×4 dil, NFC və placeholder dəstləri uyğunluğu yoxlandı. Mətn/səbəb istinadları mövcuddur.
- Hər binary-də versiya, fvar axis-ləri və Unicode cmap yoxlandı: mətnlər + AZ/TR kritik hərflər + tam RU əlifbası + rəqəm/işarələr üzrə152 unikal tələb olunan codepoint üçün sıfır olmayan glyph ID var. Bu, çəkilərdə render/fallback ölçməsi deyil.
- Binary və lisenziya SHA-256 yoxlandı; OFL1.1 başlığı oxundu. Standart rəqəm advance-ləri manifestdədir; tnum/variable advance ayrıca yoxlanmayıb.
- Yeni ekran renderi, contrast/touch/TalkBack/dil vizual QA, oyun build/test yoxdur.

## Exact next step
- Yeni chatdə yalnız P1-RU-2x F1/F2 statik kompozisiya renderini müqayisə et. Yuxarıdakı üç fayl, matrix və token təklifini oxu; exact font binary/hash/axes istifadə et. Bütün10 malın əlçatanlığını, cloth detal/ayrı preview/maksimum və yanaşı Al/Sat müqaviləsini qoru. Renderləri açıb bax, nəticə manifestində həqiqi yoxlamaları qeyd et; açıq məhsul/texniki məsələləri həll olunmuş sayma. Oyun implementasiyasına başlama.

# Aktiv davam nöqtəsi — P1-RU-2x F1/F2 statik müqayisə, 3 noyabr 2026

## Completed
- Yalnız P1/I0/RU/2x üçün AppKit/CoreText statik kompozisiya sınağı: F1/F2, 1280×720px, safe640×312dp; 126 scroll capture və üç müqayisə contact sheet.
- Exact lokal font SHA-256 yoxlanıb; wght400/600/700, wdth100 tələb olunub. CoreText resolved ad/variation və screenshot offsetləri manifestdədir. Default axis-lər CoreText dictionary-də buraxılır; binary manifestdə default400/100-dür.
- Hər namizəddə 26 list +11 detail +26 cards capture. Bütün10 mal, cloth healthy5/damaged3,35/28, miqdar2, maksimum12/5, ayrı preview430/20 və556/12, yanaşı70/56 düymələri saxlanıb.

## Current state
- Dizayn sınağıdır; oyun implementasiyası yoxdur. Mənbə matrix/coverage/decisions/token/fixture dəyişməyib; matrix planned_not_rendered tarixi statusu qalır, yeni sübut ayrıca manifestdədir.
- Nəticə qisməndir, canonical qəbul deyil. Statik scroll koordinatları text layout-dan hesablanıb; canlı UI scroll ölçməsi və işlək master/detail yoxdur.

## Decisions
- Bu stress sınağı üçün F1 daha yığcam namizəddir, font təsdiqi deyil: alış preview başlığı F1-də1, F2-də2 sətir; detail4416px/4512px, fərq48dp. Hər ikisi11 detail capture tələb edir.
- Padding16dp/gap8dp/radius0/navigation48dp yalnız renderer trial ölçüləridir, canonical null-lar doldurulmayıb.

## Remaining work
- C1 HUD+detal+iki preview eyni capture-da və C2 maksimumlar+əməliyyatlar eyni capture-da sübut edilməyib; əlavə scroll capture istifadə olunub. Siyahı26 capture ilə həddən artıq uzundur.
- Panorama/xidmət girişləri bu sınaqda yoxdur; cards eyni etiketli sahələrin təkrarıdır, ayrıca kart dizaynı yoxlanmayıb. Bunlar qəbul bloklarıdır.
- Per-glyph fallback/.notdef, bütün çəkilərdə qlif/tnum, AZ/TR/EN, native dil redaktəsi, Android fontScale/cihaz/toxunma/TalkBack açıqdır. Resolved run ailələri gözlənən Sans/Serif ilə məhdud olub; bu tam glyph auditi deyil.
- Əvvəlki bütün D1 iqtisadiyyat, D2–D5 məhsul/kompozisiya, D6 token/dp/radius/palitra/cihaz/minSdk/motion və Spark save/sync/alış/deletion məsələləri dəyişməz açıqdır.

## Relevant files
- design/tools/render-d1-p1-ru-2x.swift
- design/states/D1-P1-RU-2x/manifest.json (render zamanı yenilənir)
- design/states/D1-P1-RU-2x/review.json (ayrıca yoxlama nəticəsi)
- design/states/D1-P1-RU-2x/compare-detail.png, compare-list.png, compare-cards.png
- Əvvəlki qeyd üzrə fixture/localization/font manifest/matrix/token təklifi.

## Checks performed
- Renderlər açıldı: F1/F2 detail1, detail/list contact sheet, F2 detail9, F1 list26. Hər126 capture tam ölçüdə ayrıca baxılmayıb; cards contact sheet ayrıca vizual yoxlanmayıb.
- Faktiki resolved run adları: NotoSans Regular/SemiBold/Bold, NotoSerif SemiBold/Bold. SHA-256 mənbələr review.json-da; offset/content height manifestdə.
- ui-craft contrast.py düz rənglər:10.99/10.99/7.85,4.5 həddi keçir. Texture/state kontrastı deyil. Oyun build/test və canlı interaction yoxdur.

## Exact next step
- Yalnız bu müqayisənin review.json və compare-detail/list şəkillərini istifadəçi ilə qiymətləndir. Növbəti ayrıca dizayn vahidində C1/C2 qəbul bloklarını və çox uzun scroll-u həll edən kompozisiya sınağını dəqiqləşdir; font/breakpoint təsdiqi kimi qəbul etmə. Açıq məsələləri qoru; implementasiyaya başlama.

# Aktiv davam nöqtəsi — F1 C1/C2 kompozisiya v2, 3 noyabr 2026

## Completed
- İstifadəçi F1 ilə davam etməyi seçdi; bütün ekranlarda responsivliyin qorunmasını ayrıca tələb etdi. Bu tələb bütün D1–D5 üçün saxlanır; yalnız P1/RU2x renderi ümumi yoxlama deyil.
- design/tools/render-d1-f1-composition-v2.swift ilə10 statik PNG: 3 ad-seçim səhifəsi, C1 xülasə, C2 maksimum/əməliyyat,5 tam detal bölmə səhifəsi. Əvvəlki26 verbose siyahı scroll capture əvəzinə3 seçim səhifəsi namizədi.
- C1 xülasə: HUD500/16, cloth/quantity2, ayrı after-buy70/430/20 və after-sale56/556/12. C2: maksimum12/5 və yanaşı70/56 Al/Sat eyni kadrda.

## Current state
- Qismən statik kompozisiya sınağı; oyun implementasiyası yoxdur. Mənbə fixture/localization/matrix/token/coverage/decisions dəyişməyib.
- Strict C1 tam detalı eyni kadrda göstərmir; strict C2 son malı maksimum/əməliyyatlarla eyni kadrda göstərmir. Capture müqaviləsi dəyişdirilməyib və tam qəbul iddiası yoxdur.

## Decisions
- Uzun fasiləsiz scroll yerinə ad-seçim və bölünmüş detal namizədi. Başqa malların qiymətləri bu seçim ekranında deyil, ayrıca detal route-da nəzərdə tutulur; yalnız cloth detail render edilib.
- F1 ölçüləri saxlanır: full-detail body16sp, supporting14sp; mətn auto-fit ilə kiçildilmir. Preview xülasə label-ləri supporting rolundadır; bu hierarchy sınaqdır, təsdiq deyil.
- Yeni geometry trial; kanonik dp/radius null-ları doldurulmayıb. Ümumi ekran breakpoint-i seçilməyib.

## Remaining work
- Strict C1/C2 tam ödənmir. Page keçidləri, geri/fokus/scroll-seçim bərpası, digər malların detal renderləri və ümumi naviqasiya bu sınaqda tamamlanmayıb. Səhifələrin mövcudluğu işlək əlçatanlıq sübutu deyil.
- Bütün digər məhsul/texniki açıq məsələlər, real cihaz/Android scaling, AZ/TR/EN, insets, toxunma/TalkBack, glyph/tnum, cards/panorama/xidmətlər açıqdır.

## Relevant files
- design/tools/render-d1-f1-composition-v2.swift
- design/states/D1-F1-composition-v2/manifest.json
- design/states/D1-F1-composition-v2/review.json
- design/states/D1-F1-composition-v2/C1-summary.png və C2-actions.png
- design/states/D1-render-fixture.json (dəyişməyən qəbul müqaviləsi)

## Checks performed
- Cari10 PNG tam ölçüdə açılıb baxılıb; C1 son geometry düzəlişindən sonra təkrar baxılıb.48 text block üçün lineHeight + safe rect yoxlaması keçib. Bu live UI/toxunma testi deyil.
- Exact font SHA256 renderer tərəfindən yoxlanıb; resolved font/axis sübutu manifestdə. Dəyişməyən paper/nav palitrasının əvvəlki10.99:1 ölçməsi tətbiq edilir; tam state/texture kontrastı deyil.
- Build/test və oyun implementasiyası yoxdur; bütün ekranların responsivliyi təsdiqlənməyib.

## Exact next step
- Yeni chatdə yalnız v2 review.json, C1-summary/C2-actions PNG və dəyişməyən captureContract-a bax. C1 tam detal/C2 son malın eyni kadrda olmaması bloklarını qiymətləndir; capture müqaviləsini səssizcə yumşaltma. Sonra yalnız ayrıca icazə verilən kiçik statik kompozisiya vahidini davam et. Bütün ekranların responsivliyini tələb kimi saxla; implementasiyaya başlama.

# Aktiv davam nöqtəsi — F1 kompozisiya v3, 3 noyabr 2026

## Completed
- Kiçik statik sınaq: P1 C1/C2 və mövcud P3 C1; bütün üç PNG açılıb baxıldı, son C2 təkrar baxıldı.
- P1 C2-də son mal + maksimum12/5 + yanaşı Al70/Sat56 görünür; 9 text block fit/safe yoxlaması keçir.
- P3 C1-də siyahı başlanğıcı + HUD + tam cloth detalı/iki partiya/maya/marja + ayrı preview-lər eyni kadrdadır;18 block keçir.

## Current state
- Qismən sınaqdır: P1 C1 keçmir;15 block fit/safe xətası və HUD overlap var. Diaqnostik renderdir, qəbul deyil. P3 nəticəsi P1-i əvəz etmir.
- Oyun implementasiyası yoxdur. Capture müqaviləsi, mənbə fixture/localization/matrix/token faylları dəyişməyib.

## Decisions
- F1/RU2x və eyni şrift binary/hash/ölçüləri qorunur. C2 quantity label supporting14sp, numeric16sp: hierarchy sınağıdır.
- Bütün D1–D5 ekranlarda responsivlik məcburidir; heç bir ümumi responsivlik təsdiqi yoxdur.

## Remaining work
- P1 C1 tam detalın eyni kadrda sığması; canlı scroll/reachability/focus/selection; digər dil/profil/insets/native scaling/touch/TalkBack. Əvvəlki məhsul/texniki blokerlər qalır.

## Relevant files
- design/tools/render-d1-f1-composition-v3.swift
- design/states/D1-F1-composition-v3/manifest.json və review.json
- design/states/D1-F1-composition-v3/P1-C1.png, P1-C2.png, P3-C1.png
- design/states/D1-render-fixture.json captureContract

## Checks performed
- Swift render; exact font SHA256; text height/safe rect; üç PNG vizual baxışı; son C2 təkrar baxışı; captureContract mənbə ilə eyni; review JSON parse.
- P1 C1 HUD overlap vizual aşkarlanıb. Yeni palette yoxdur; əvvəlki düz rəng kontrastı10.99:1, texture/state yoxlanmayıb. Build/oyun/cihaz testi yoxdur.

## Exact next step
- Yalnız P1 C1 üçün alternativ tam-detal sütun bölgüsünü ölçülən line count ilə ayrıca kiçik statik sınaqda yoxla; bütün label/ölçüləri və capture müqaviləsini qoru. C2 statik məzmun nəticəsini live UI qəbulu sayma. İmplementasiyaya başlama.

# Aktiv davam nöqtəsi — yalnız P1 C1 statik yoxlama, 3 noyabr 2026

## Completed
- Son qeyd və v3 review oxundu; F1 RU2x P1 C1 üçün 2/3/4 bərabər sütunda bütün ardıcıl blok bölgüləri ölçüldü; diaqnostik PNG açılıb baxıldı.
## Current state
- C1 FAIL qalır: HUD overlap aradan qalxır, tam detal/iki preview kadrdan çıxır;18 blokdan14 safe yoxlamadan keçmir. Oyun implementasiyası yoxdur.
## Decisions
- Bütün v3 C1 label/rol/şrift ölçüləri, font hash/axis və captureContract qorunub. Mənbə fixture/localization/matrix/token SHA256 v3 ilə eynidir. List-start aşağıda yalnız diaqnostikdir, qəbul edilən kompozisiya deyil.
## Remaining work
- P1 C1 qəbul bloku; əvvəlki responsivlik/cihaz/dil və məhsul/texniki açıq işlər dəyişmir. Bu nəticə bütün mümkün geometriyaların qeyri-mümkünlüyünün sübutu deyil.
## Relevant files
- design/tools/render-d1-f1-p1-c1-v4.swift
- design/states/D1-F1-P1-C1-v4/{manifest.json,review.json,P1-C1.png}
## Checks performed
- Swift statik render, CoreText line count, exact font SHA256, safe rect, PNG vizual baxışı, mənbə SHA256 müqayisəsi və JSON parse. 2/3/4 sütun minimum content-bottom2208/2144/2400px; safe-bottom672px; siyahı bu ölçüyə daxil deyil.
- Canlı UI/build/cihaz testi yoxdur.
## Exact next step
- P1 C1 blokunu açıq saxla; yalnız ayrıca razılaşdırılan kiçik statik kompozisiya sınağı. Müqavilə/şriftləri yumşaltma, implementasiyaya başlama.
# Plan yeniləməsi — M1.5 oynanış sınağı, 3 noyabr 2026

## Completed
- İstifadəçi tapşırığı ilə IMPLEMENTATION_PLAN.az.md §15-də M1 və M2 arasına M1.5 əlavə edildi; M2 başlanğıcı sınağın keçid şərtinə bağlandı.
## Current state
- Yalnız plan yenilənib; prototip və oyunçu sınağı hazırlanmayıb. Mövcud dizayn blokerləri və implementasiyaya başlama məhdudiyyəti qüvvədədir.
## Decisions
- İki şəhər, bir neçə mal, iki yol; ilk alış–səfər–satış təlimi və sonra sərbəst növbəti ticarət. V1 dörd şəhər/20 gün qalır.
- Qərarların anlaşılması və könüllü davam davranışı müşahidə edilir. Zəif nəticədə məlumat/qiymət/yol seçimləri düzəldilib təkrar sınaq aparılır; M2 başlanmır.
## Remaining work
- M1.5 icrasından əvvəl sınaq balansı, iştirakçı sayı və konkret uğur həddi müəyyənləşdirilməlidir. Əvvəlki məhsul/texniki/dizayn açıq məsələlər dəyişməyib.
## Relevant files
- docs/IMPLEMENTATION_PLAN.az.md §15
## Checks performed
- M1 → M1.5 → M2 ardıcıllığı və M2 asılılığı mətn üzrə yoxlanıb. Kod/build/test yoxdur; sənəd dəyişikliyidir.
## Exact next step
- Növbəti plan işində §15-dəki M1.5-i əsas götür; onun icrasına keçməzdən əvvəl protokol və uğur həddini bağla. Bu qeyd ayrıca dizayn işinin davam nöqtəsini əvəz etmir.


# Aktiv davam nöqtəsi — P1 C1 hizalanmış kompozisiya ölçməsi, 3 noyabr 2026

## Completed
- Yalnız P1/F1/RU2x: qiymət/ehtiyat/yük label–dəyər sətirləri, yanaşı sağlam/zədəli partiya və ayrı yanaşı preview blokları CoreText ilə ölçüldü. Hər cell üçün sətir sayı/hündürlük saxlanıldı.
## Current state
- FAIL: tələb2528px, mövcud624px;1904px artıqdır. İstifadəçinin şərtinə görə sığmadığı üçün render edilmədi; vizual baxış iddiası yoxdur.
## Decisions
- C1 captureContract, bütün v3 C1 label/dəyərləri, F1 rol/ölçü/çəki/line-height və font hash/axis qorunub; yalnız ayırıcılar sətirlərə bölünüb. Mənbə fixture/localization/matrix/token hash-ləri v3 ilə eynidir. Oyun implementasiyası yoxdur.
## Remaining work
- C1 hələ blokdur. Bu tək kompozisiya bütün həllərin qeyri-mümkünlüyünü sübut etmir. Əvvəlki məhsul/texniki və responsivlik yoxlamaları açıqdır.
## Relevant files
- design/tools/measure-d1-f1-p1-c1-v5.swift
- design/states/D1-F1-P1-C1-v5/measurement.json
- design/states/D1-F1-P1-C1-v5/review.json
## Checks performed
- Exact font SHA256/axes, CoreText line count;38 cell üzrə hündürlük formulu yoxlandı; mənbə hash müqayisəsi və JSON parse. HUD+siyahı208px, mal göstəriciləri560px, yanaşı partiyalar848px, ayrı yanaşı preview640px; qalan272px başlıq/qeyd/gap. Yeni PNG yoxdur.
## Exact next step
- Ölçmə nəticəsini istifadəçi ilə qiymətləndir; C1 müqaviləsini və şriftləri özbaşına dəyişmə. Yeni böyük addım və implementasiya başlatma.

# Aktiv davam nöqtəsi — C1 dəyişiklik təklifinin PNG izahı

## Completed
- Mövcud eyni-kadr tələbi ilə Mal/Partiyalar/Önizləmə bölmələri təklifi PNG-də müqayisə edildi; PNG açılıb baxıldı.
## Current state
- Bu yalnız izah sxemidir, P1 viewport/font-fit renderi deyil. Təklif təsdiqlənməyib; captureContract dəyişməyib.
## Decisions
- Təklif: P1 C1 eyni vəziyyət üzrə ayrı capture-lar; HUD detal bölmələrində sabit, siyahı ayrıca; şriftlər/məlumat/seçim qorunur. C2 dəyişmir. Oyun implementasiyası yoxdur.
## Remaining work
- İstifadəçinin müqavilə təklifi barədə qərarı; sonra ayrıca ölçülmüş ekran sınağı. Əvvəlki blokerlər qalır.
## Relevant files
- design/states/D1-C1-contract-proposal/comparison.png
- design/states/D1-C1-contract-proposal/manifest.json
- design/tools/render-d1-c1-contract-proposal.swift
- design/states/D1-F1-P1-C1-v5/measurement.json
## Checks performed
- Swift ilə sxem renderi, PNG vizual baxışı; eyni paper/nav palitrası və pin edilmiş font hash-ləri. Sxemin redaksiya şrift ölçüləri oyun typography təklifi deyil.
## Exact next step
- İstifadəçi ilə PNG-dəki müqavilə dəyişikliyini qiymətləndir; təsdiqsiz müqavilə və implementasiya dəyişmə.


# M1.5 konkret protokol — 3 noyabr 2026

## Completed
- docs/M1_5_PLAYTEST.az.md yaradıldı və IMPLEMENTATION_PLAN.az.md §15-ə bağlandı.
## Current state
- Sənəd hazırdır; build, pilot, iştirakçı cəlbi və real sınaq yoxdur. Dizayn və implementasiya blokerləri dəyişməyib.
## Decisions
- 2 pilot +8 yeni yetkin iştirakçı (4 təcrübəli/4 az-təcrübəli), sabit iki-şəhər/üç-mal/iki-yol fixture-i.
- U1:7/8 təlim+məqsəd; U2:6/8 könüllü növbəti ticarət; U3:6/8 seçim/məlumat anlayışı; U4:6/8 risk/zərər anlayışı; U5:3/4 az-təcrübəli U2. Hamısı və texniki etibarlılıq M2 üçün şərtdir.
- Sınaq qiymətləri V1 balansı deyil; əsas turdan əvvəl protokol/build dondurulur.
## Remaining work
- M0/M1 və dizayn məhdudiyyətləri həll olunmalıdır; sonra ayrıca icazəli test build, pilot və əsas tur.
## Relevant files
- docs/M1_5_PLAYTEST.az.md
- docs/IMPLEMENTATION_PLAN.az.md §15
## Checks performed
- Təlim116, ikinci ticarət142, risk112/104, zərər94 hesabları Python assert ilə yoxlandı; M1→M1.5→M2 və protokol keçidi yoxlandı. Oyun/build/real iştirakçı testi yoxdur.
## Exact next step
- Yeni chatdə yalnız protokolu və §15-i oxu; əvvəlcə protokolun icra önşərtlərini qiymətləndir. Implementasiyaya avtomatik başlama; əvvəlki dizayn müqavilələrini dəyişmə.


# Aktiv davam nöqtəsi — təsdiqlənmiş bölməli C1 statik sınağı, 3 noyabr 2026

## Completed
- İstifadəçi bölməli C1 müqaviləsini təsdiqlədi. Fixture captureContract.C1 və render matrisinin C1 təsviri yeniləndi: eyni vəziyyət üzrə ayrıca siyahı/Mal/Partiyalar/Önizləmə capture-ları; detalda sabit HUD. C2 dəyişməyib.
- P1/F1/RU2x üçün11 statik PNG: siyahı1, Mal2, Partiyalar4, alış önizləməsi2, satış önizləməsi2. Bütün yekun PNG-lər açılıb baxıldı.

## Current state
-51/51 text fit/safe yoxlaması keçir; bütün mənbə mətnləri davam capture-larından dəqiq bərpa edilir. Bu, yalnız statik məzmun/sığma nəticəsidir, tam C1 istifadə rahatlığı və canlı UI qəbulu deyil. Oyun implementasiyası yoxdur.

## Decisions
- F1 rol/ölçü/çəki/line-height, font binary/hash/axis, localization, palette, fixture base/derived və seçimlər qorunub. C2 pre-change baseline ilə tam eynidir.
- Əlavə capture-lar ölçülmüş mətn davamıdır;11 ayrı məhsul səhifəsinin təsdiqi deyil. Kanonik tokenlər/breakpoint dəyişməyib.

## Remaining work
- Davam kadrlarında kontekst zəifdir: vahid yük label-i növbəti kadra keçir; sağlam partiya maya/marja məlumatı onun keyfiyyət/sayından ayrılır.11 capture naviqasiya yükü yaradır.
- Bölmə keçidləri, geri/fokus/scroll-seçim bərpası, bütün mallara çıxış və bütün D1–D5 responsivliyi açıqdır. Əvvəlki cihaz/dil/native scaling/toxunma/TalkBack və məhsul/texniki blokerlər qalır.

## Relevant files
- design/states/D1-render-fixture.json captureContract.C1
- design/states/D1-canonical-render-matrix.json C1 təsviri
- design/tools/render-d1-c1-sectioned-v1.swift
- design/states/D1-C1-sectioned-v1/{manifest.json,review.json,baseline.json,C1-*.png}

## Checks performed
- Swift statik render, exact font SHA256/axis,51 fit/safe block,11 yekun PNG vizual baxışı, mətnin dəqiq rekonstruksiyası, base/derived/C2 bərabərliyi, typography/profile və digər mənbə hash yoxlamaları.
- Dəyişməyən palitranın əvvəlki düz rəng10.99:1 kontrast sübutu; texture/state testi yoxdur. Build/oyun/cihaz və canlı interaction testi yoxdur.

## Exact next step
- Əvvəl bu sınağın review.json və PNG-lərini qiymətləndir. Sonra yalnız ayrıca razılaşdırılmış kiçik statik vahiddə davam konteksti/naviqasiya kompozisiyasını yaxşılaşdır; şriftləri/məlumatı/seçimləri qoru, C2-ni dəyişmə. İmplementasiyaya başlama.


# Aktiv davam nöqtəsi — C1 kontekstli statik variant v2, 3 noyabr 2026

## Completed
- Son qeyd və sectioned-v1 review oxundu. P1/F1/RU2x üçün C1-context-v2: 11→7 statik kadr; yekun 7 PNG vizual baxılıb.
- Ayrı sətir padding-i əvəzinə dəyişməyən line-height ilə davamlı mətn axını; mal göstəriciləri birlikdə, hər partiyanın kimlik/seçim/keyfiyyət/say/maya məlumatı bir kadrda, önizləmələr ayrı tam kadrlarda.
## Current state
- 35/35 fit/safe keçir; yalnız statik dizayn nəticəsidir. Oyun implementasiyası yoxdur.
## Decisions
- Bütün v1 mənbə mətnləri və rolları təmsil olunur; font binary/hash/axis/ölçü/çəki/line-height eynidir. Fixture base/derived/seçimlər, C2 və qeydə alınmış mənbə hash-ləri dəyişməyib.
- Alış önizləməsində təkrar sağlam-partiya başlığı çıxarılıb; seçim partiya və satış kadrında, həmçinin eyni fixture-də qalır. Kanonik spacing tokeni və müqavilə dəyişməyib; sınaq davamlı mətn axınıdır.
## Remaining work
- Marja qeydi ayrıca kadrdır; sıx mətnin oxunaqlılığı və bölmə naviqasiyası hələ qəbul edilməyib. Canlı scroll/geri/fokus/seçim bərpası, bütün mallara çıxış, cihaz/dil/profil və bütün D1–D5 responsivlik yoxlamaları açıqdır.
## Relevant files
- design/tools/render-d1-c1-context-v2.swift
- design/states/D1-C1-context-v2/{manifest.json,review.json,C1-*.png}
- design/states/D1-C1-sectioned-v1/{manifest.json,review.json,baseline.json}
## Checks performed
- Swift statik render, 35 fit/safe block; bütün mənbə sətirlərinin mətn rekonstruksiyası, v1 source text/role coverage, font evidence equality, base/derived/C2 bərabərliyi və mənbə SHA256 müqayisəsi; yekun 7 PNG baxışı.
- Dəyişməyən paper/nav palitrası; əvvəlki düz rəng 10.99:1 sübutu, texture/state testi yoxdur. Oyun/build/cihaz/canlı interaction testi yoxdur.
## Exact next step
- 7 kadrı qiymətləndir; yalnız ayrıca kiçik dizayn vahidində naviqasiya və marja qeydinin kontekstini sına. Şrift/məlumat/seçim və C2-ni qoru; implementasiyaya başlama.


# Aktiv davam nöqtəsi — marja qeydi eyni kadrda, v3, 3 noyabr 2026

## Completed
- İstifadəçi tapşırığı ilə marja qeydi sağlam partiyanın marja sətrinin qalan üfüqi yerinə yerləşdirildi; ayrıca qeyd kadrı çıxarıldı: 7→6 statik kadr. Yekun 6 PNG açılıb baxıldı.
## Current state
- P1/F1/RU2x üçün 33/33 fit/safe, blok düzbucaqlıları arasında overlap yoxdur. Yalnız statik dizayndır; oyun implementasiyası yoxdur.
## Decisions
- Qeyd əvvəlki supporting rolu/ölçüsü/çəkisi/line-height ilə bir sətirdədir; 849px daxili enə sığır. Body marja mətni dəyişməyib. Ümumi Partiyalar başlığı zədəli partiya kadrına daşınıb.
- Bütün v2 mənbə mətnləri/rolları və başlıqları təmsil olunur; font binary/hash/axis evidence eynidir. Base/derived/seçimlər, C2 və mənbə hash-ləri dəyişməyib. Kanonik token/müqavilə dəyişməyib.
## Remaining work
- Qeydin üfüqi ehtiyatı azdır; digər dil/profil üçün qəbul deyil. Naviqasiya, geri/fokus/scroll/seçim bərpası, bütün mallara çıxış və D1–D5 responsivlik/cihaz/TalkBack yoxlamaları açıqdır.
## Relevant files
- design/tools/render-d1-c1-margin-v3.swift
- design/states/D1-C1-margin-v3/{manifest.json,review.json,C1-*.png}
- design/states/D1-C1-context-v2/{manifest.json,review.json}
- design/states/D1-C1-sectioned-v1/baseline.json
## Checks performed
- Swift/CoreText statik render; 33 fit/safe; düzbucaqlı overlap; dəqiq source-row rekonstruksiyası, v2 source/header role coverage; font evidence equality; base/derived/C2 və SHA256 müqayisələri. 6 yekun PNG vizual baxışı.
- Dəyişməyən palitranın əvvəlki düz rəng 10.99:1 sübutu; yeni texture/state testi yoxdur. Build/oyun/canlı interaction/cihaz testi yoxdur.
## Exact next step
- 6 kadrın review və PNG-lərini qiymətləndir. Sonrakı iş yalnız ayrıca kiçik naviqasiya/interaction dizayn vahidi olsun; şrift/məlumat/seçim/C2-ni qoru, implementasiyaya başlama.


# Aktiv davam nöqtəsi — C1 statik naviqasiya təklifi, 3 noyabr 2026

## Completed
- margin-v3 review və 6 PNG qiymətləndirildi. Sonra yalnız kiçik naviqasiya storyboard-u hazırlandı və yekun PNG açılıb baxıldı.
## Current state
- D1-C1-navigation-v1/navigation.png: 6 mənbə kadrı dəyişmədən native 1280×720 ölçüdə, keçid/geri izahları kadr xaricindədir. Bu, P1 daxilində düymə sığması və ya canlı interaction sübutu deyil; təsdiqlənməmiş statik təklifdir.
## Decisions
- İrəli keçid açıldığı bölməni saxlayır; Geri həmin bölməyə qaytarır. Açıq qayıdış linki yeni history yaratmır. Bölmə mövqeyi/fokusun bərpası nəzərdə tutulur, yoxlanmayıb. Zədəli partiyaya baxış seçimi dəyişmir.
- Mənbə 6 PNG, review/manifest, fixture/matrix/localization/token/font manifest hash-ləri dəyişməyib. Parça/sağlam partiya/miqdar2 və C2 qorunub. Oyun implementasiyası yoxdur.
## Remaining work
- Naviqasiya təklifini qiymətləndirmək; sonra ayrıca icazəli kiçik statik vahiddə kadr daxilində naviqasiya sığmasını ölçmək. Siyahıdan Parçaya faktiki çıxış, bütün mallar və canlı geri/fokus/scroll hələ açıqdır.
## Relevant files
- design/states/D1-C1-navigation-v1/navigation.png
- design/states/D1-C1-navigation-v1/review.json
- design/tools/render-d1-c1-navigation-v1.swift
- design/states/D1-C1-margin-v3/{review.json,manifest.json,C1-*.png}
## Checks performed
- Swift/CoreText render, pin edilmiş font SHA256 yoxlaması, yekun PNG vizual baxışı, mənbə hash bərabərliyi. Yeni palitra yoxdur; əvvəlki düz rəng kontrast sübutu qüvvədədir. Canlı UI/build/cihaz testi yoxdur.
## Exact next step
- Yalnız navigation.png və review.json-u oxu; keçid/geri təklifini istifadəçi ilə qiymətləndir. Şrift/məlumat/seçim/C2-ni dəyişmə; implementasiyaya başlama.

# Aktiv davam nöqtəsi — C1 kadrdaxili naviqasiya sınağı, 3 noyabr 2026

## Completed
- İstifadəçinin icazəsi ilə yalnız statik kadrdaxili naviqasiya render edildi; 10 ədəd 1280×720 PNG və navigation.png lövhəsi açılıb vizual baxıldı.
- Düymələr aşağı y576–672 zolağında, məzmun örtülmədən əlavə kadrlara bölünüb. İlk uzun yazılar sığmadı; yekun qısa draft yazılar və ölçülən enlərlə 70/70 fit/safe keçir.
## Current state
- D1-C1-navigation-inframe-v2 statik sınaqdır; yekun UI kimi qəbul edilməyib. Oyun implementasiyası yoxdur.
## Decisions
- Şrift evidence, captureContract, bütün mənbə hash-ləri, məlumat, Parça/sağlam partiya/miqdar2 və C2 qorunub. Preview düymələri yalnız baxışı əvəz edir, history artırmır və əməliyyat etmir; Geri açan bölməyə qayıdır. Canlı yoxlanmayıb.
- Sığma uğurludur, kompozisiya geriləyib: 6→10 kadr; sağlam partiyanın keyfiyyət/say və maya/marja məlumatları, satış yekunu və nəticə pul/yük ayrılıb. Bu variant yekun üçün tövsiyə edilmir.
- Yeni canonical token yoxdur; mövcud palitra/role/inset istifadə olunur, footer/enlər yalnız sınaq həndəsəsidir. RU naviqasiya mətnləri draftdır.
## Remaining work
- Ayrı icazəli kiçik statik vahiddə naviqasiya ilə birlikdə əlaqəli məlumatları eyni kadrda saxlamaq; preview düymələrini əməliyyatdan aydın ayırmaq və aktiv baxışı göstərmək.
- Parça shortcut-u bütün mallara çıxış sübutu deyil. Canlı geri/scroll/fokus, cihaz, toxunma, native scaling və TalkBack açıqdır.
## Relevant files
- design/tools/render-d1-c1-navigation-inframe-v2.swift
- design/states/D1-C1-navigation-inframe-v2/{navigation.png,manifest.json,review.json,C1-*.png}
- design/states/D1-C1-margin-v3/{manifest.json,review.json}
## Checks performed
- Swift/CoreText render; 70 fit/safe; bütün 10 kadrın lövhədə vizual baxışı; source-row dəqiq rekonstruksiyası; font evidence/captureContract bərabərliyi; navigation-v1 review-dəki bütün mənbə SHA256-ları eynidir.
- Düz paper/nav rənglərində kontrast 10.99:1 yenidən hesablandı. C2 rerender edilmədi. Oyun/build/cihaz/canlı interaction yoxlaması yoxdur.
## Exact next step
- Yeni sınağın review.json və navigation.png fayllərini qiymətləndir; yalnız ayrıca razılaşdırılmış kiçik statik kompozisiya vahidində davam et. Şrift/məlumat/seçim/miqdar2/C2 qorunsun; implementasiyaya başlama.

# Aktiv davam nöqtəsi — C1 əlaqəli məlumatların qruplaşdırılması v3, 3 noyabr 2026

## Completed
- Son kontekst və navigation-inframe-v2 review oxundu. İstifadəçi tapşırığı ilə yalnız kiçik statik grouped-v3 variantı hazırlandı: 10→6 kadr. Yekun 6 PNG native ölçüdə açılıb baxıldı.
## Current state
- P1/F1/RU2x 1280×720; 42/42 fit/safe, blok overlap yoxdur. Statik sınaqdır, yekun UI qəbulu və oyun implementasiyası yoxdur.
## Decisions
- Footer/naviqasiya dəyişmir. Cari HUD yalnız siyahı başlanğıcındadır; detalda Parça/miqdar2 və bölmə konteksti qalır. Sağlam partiyanın keyfiyyət/say/maya/marja/qeydi, satış yekunu və nəticə pul/yük eyni kadrlardadır.
- Şrift evidence, captureContract, sourceRows/state v2 ilə eynidir; mətn dəqiq rekonstruksiya olunur. navigation-v1-də qeydə alınmış bütün mənbə SHA256-ları qorunub, o cümlədən fixture/matrix/token/localization/font manifest. C2 dəyişmir/rerender yoxdur.
- Cari HUD-u detalda təkrarlamamaq təsdiqlənməmiş kompromisdir: cari və preview pul/yük eyni anda müqayisə edilmir. Kanonik tokenlər dəyişməyib.
## Remaining work
- Variantı qiymətləndirmək. Preview aktiv baxış göstəricisi və düymələrin əməliyyatdan fərqi, zədəli partiya linkinin aydınlığı hələ açıqdır. Marja qeydinin üfüqi ehtiyatı azdır. Canlı geri/fokus/scroll, bütün mallar, cihaz/dil/native scaling/TalkBack yoxlanmayıb.
## Relevant files
- design/tools/render-d1-c1-navigation-grouped-v3.swift
- design/states/D1-C1-navigation-grouped-v3/{navigation.png,manifest.json,review.json,C1-*.png}
- design/states/D1-C1-navigation-inframe-v2/{manifest.json,review.json}
## Checks performed
- Swift/CoreText render; 42 fit/safe, overlap yoxlaması, sourceRows/state/font/captureContract bərabərliyi, source rekonstruksiyası, navigation-v1 baseline hash müqayisəsi; 6 yekun PNG vizual baxışı.
- Palitra dəyişməyib; əvvəlki düz rəng 10.99:1 sübutu; yeni texture/state testi yoxdur. Build/oyun/cihaz/canlı interaction testi yoxdur.
## Exact next step
- grouped-v3 review və 6 PNG-ni qiymətləndir; yalnız ayrıca kiçik statik dizayn vahidində davam et. Şrift/məlumat/seçim/miqdar2/C2-ni qoru; implementasiyaya başlama.

# Aktiv davam nöqtəsi — C1 preview baxış keçidləri v4, 3 noyabr 2026

## Completed
- İstifadəçi tapşırığı ilə grouped-v3 qruplaşmasını saxlayan kiçik preview-views-v4 statik variantı hazırlandı.
- Preview footer-də dolu əməliyyat görünüşü çıxarıldı: «Вид: покупка / Вид: продажа» düz mətn keçidləri; yalnız aktiv baxışın altında nav rəngli xətt. Hər iki yekun preview PNG native ölçüdə açılıb baxıldı.
## Current state
- 6 kadr, 42/42 fit/safe, blok overlap yoxdur; digər 4 PNG grouped-v3 ilə byte-identical. Yalnız statik sınaqdır, yekun UI qəbulu və oyun implementasiyası yoxdur.
## Decisions
- Məzmun mətn/rol/düzbucaqlıları, sourceRows/state, font evidence, captureContract grouped-v3 ilə eynidir. Parça/sağlam partiya/miqdar2/C2 və bütün qeydə alınmış source SHA256-lar qorunur.
- Preview tam başlıqları qalır; keçidlər yalnız baxışı əvəz edir, əməliyyat/history yaratmır; Geri açan bölməyə qayıdır. Canlı yoxlanmayıb.
- Eyni paper/nav palitrası; mövcud 16px sınaq həndəsəsi altxətt üçün istifadə edilib. Yeni kanonik selectedIndicator tokeni təsdiqlənməyib; RU yazıları draftdır.
## Remaining work
- v4 görünüşünü istifadəçi ilə qiymətləndirmək. «Вид» ifadəsinin anlaşılması və altxəttin aktiv vəziyyəti bildirməsi istifadəçi ilə yoxlanmayıb.
- Canlı selected semantics/TalkBack/fokus/geri/scroll/toxunma, cihaz/dil/native scaling; bütün mallara çıxış və zədəli partiya linkinin aydınlığı açıqdır. Cari-vs-preview HUD eyni anda görünmür; marja qeydi en ehtiyatı azdır.
## Relevant files
- design/tools/render-d1-c1-preview-views-v4.swift
- design/states/D1-C1-preview-views-v4/{navigation.png,manifest.json,review.json,C1-*.png}
- design/states/D1-C1-navigation-grouped-v3/{manifest.json,review.json}
## Checks performed
- Swift/CoreText render; 42 fit/safe, overlap, aktiv göstəricinin hər preview-də yalnız bir olması, preview footer-də actionFill olmaması; font/content/state/pages/contract bərabərliyi; digər 4 PNG hash bərabərliyi; bütün source hash müqayisəsi.
- 2 dəyişən yekun PNG vizual baxışı; düz paper/nav kontrastı 10.99:1 hesablandı. Texture/state/device/live UI/build testi yoxdur. C2 rerender edilməyib.
## Exact next step
- Yeni chatdə yalnız v4 review və 2 preview PNG-ni qiymətləndir; növbəti ayrıca kiçik statik vahidi seç. Şrift/məlumat/seçim/miqdar2/C2-ni qoru; implementasiyaya başlama.


# Aktiv davam nöqtəsi — C1 preview konturlu keçid sınağı v5, 3 noyabr 2026

## Completed
- v4 review və iki preview qiymətləndirildi. İstifadəçinin ayrıca tapşırığı ilə yalnız footer affordance üçün v5 statik variantı yaradıldı; iki yekun PNG 1280×720-də açılıb baxıldı.
## Current state
- D1-C1-preview-affordance-v5: 6 kadr, 42/42 fit/safe, overlap yoxdur. Digər 4 PNG v4 ilə byte-identical. Yekun UI qəbulu deyil; implementasiya yoxdur.
## Decisions
- Üç preview footer keçidi nav/paper konturludur; aktiv preview tam enli 16px alt kənarla ayrılır. Kontur 4px (mövcud 16px sınaq ölçüsünün dörddə biri); yalnız sınaq həndəsəsidir, canonical border/selected token deyil.
- Bütün mətn/rol/düzbucaqlılar, font evidence/run names, pages/sourceRows/state/captureContract v4 ilə eynidir. Parça/sağlam partiya/miqdar2 və bütün qeydə alınmış source SHA256-lar qorunur. C2 dəyişmir/rerender yoxdur.
## Remaining work
- İstifadəçi ilə kontur/aktiv göstərici anlaşılmasını qiymətləndirmək. Mətn aktiv alt kənara yaxındır; əlavə padding iddiası yoxdur. Canlı selected semantics/TalkBack/fokus/geri/scroll/toxunma, cihaz/dil/native scaling açıqdır; əvvəlki digər açıq məsələlər qalır.
## Relevant files
- design/tools/render-d1-c1-preview-affordance-v5.swift
- design/states/D1-C1-preview-affordance-v5/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png,navigation.png}
- design/states/D1-C1-preview-views-v4/{review.json,manifest.json}
## Checks performed
- Swift/CoreText render; 42 fit/safe, rect overlap, preview başına 3 kontur/1 aktiv/no actionFill; v4 text/role/rect/font/pages/state/contract equality; 4 digər PNG və protected source SHA256 equality. İki yekun PNG vizual baxışı.
- ui-craft contrast.py nav/paper 10.99:1. Canlı UI/build/cihaz/texture testi yoxdur. İlk render cache alias konflikti ilə dayanıb; ayrıca cache yolunda render uğurludur.
## Exact next step
- Yeni chatdə yalnız v5 review və iki preview PNG-ni qiymətləndir; ayrıca kiçik statik vahid seç. Şrift/məlumat/seçim/miqdar2/C2-ni qoru; implementasiyaya başlama.


# Aktiv davam nöqtəsi — C1 preview xətt boşluğu v6, 3 noyabr 2026

## Completed
- İstifadəçi tapşırığı ilə yalnız aktiv xətt/mətn boşluğu üçün kiçik v6 statik variant yaradıldı; iki yekun preview PNG native 1280×720-də açılıb baxıldı.
## Current state
- D1-C1-preview-gap-v6: 6 kadr, 42/42 fit/safe, overlap yoxdur. Yekun UI qəbulu deyil; implementasiya yoxdur.
## Decisions
- Yalnız preview footer y576→560, h96→112; mətn başlanğıcı da 16px yuxarıdır. Alt sərhəd672, aktiv xətt656…672 və kontur qalınlığı dəyişmir. Üç yazının baseline-ı birlikdə qorunur. Mövcud16px sınaq ölçüsüdür, yeni kanonik token deyil.
- Şrift/mətn/rol/məlumat/sourceRows/pages/state/contract v5 ilə eynidir; yalnız6 footer rect y/h dəyişib. Parça/sağlam partiya/miqdar2 və bütün protected source SHA256-lar qorunur. C2 dəyişmir/rerender yoxdur.
## Remaining work
- v6 variantını istifadəçi ilə qiymətləndirmək; canlı semantics/TalkBack/fokus/geri/scroll/toxunma, cihaz/dil/native scaling və əvvəlki digər açıq məsələlər qalır.
## Relevant files
- design/tools/render-d1-c1-preview-gap-v6.swift
- design/states/D1-C1-preview-gap-v6/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png,navigation.png}
- design/states/D1-C1-preview-affordance-v5/{review.json,manifest.json}
## Checks performed
- Swift/CoreText render;42 fit/safe, rect overlap; v5 font/pages/state/contract equality; protected source hashes və digər4 PNG byte equality.
- İki yekun PNG vizual baxışı. Native AppKit raster ölçməsi: aktiv label qlif sətrləri582…644, xətt656-da başlayır, arada11 boş piksel sətri; preview y560-dan yuxarı v5 ilə pixel-identical. İlk8px offset sınağı kifayət etmədi, yekun16px genişləndirmə ilə əvəzləndi.
- Palitra dəyişməyib; v5 düz rəng10.99:1 sübutu saxlanır. Yeni texture/device/live UI/build testi yoxdur.
## Exact next step
- Yalnız v6 review və iki preview PNG-ni qiymətləndir. Şrift/məlumat/seçim/miqdar2/C2-ni qoru; implementasiyaya başlama. Sonrakı dizayn vahidi ayrıca seçilməlidir.


# Aktiv davam nöqtəsi — C1 preview keçid mətni v7, 3 noyabr 2026

## Completed
- v6 review və iki preview qiymətləndirildi; istifadəçi tapşırığı ilə v7 statik mətn variantı yaradıldı və hər iki PNG açılıb baxıldı.
## Current state
- Yalnız statik sınaq; implementasiya və yekun UI qəbulu yoxdur.
## Decisions
- «Показать покупку / Показать продажу» eyni şriftlə iki sətrə keçir. Preview footer y560…768/h208, kadr1280×816; aktiv xətt752…768. Bu variant1280×720 uyğunluğu iddiası deyil.
- Şrift/məlumat/seçim/miqdar2/C2 qorunur; digər4 PNG byte-identical.
## Remaining work
- Mətnin aydınlığını və daha hündür footer kompromisini istifadəçi ilə qiymətləndir. Canlı UI/cihaz və əvvəlki açıq məsələlər qalır.
## Relevant files
- design/tools/render-d1-c1-preview-labels-v7.swift
- design/states/D1-C1-preview-labels-v7/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png}
## Checks performed
- Swift/CoreText render42/42 fit/safe; iki yekun PNG vizual baxışı. Font/run names/contract və pages (yalnız outputPx istisna) bərabərliyi; protected source SHA256 və digər4 PNG byte equality. Palitra dəyişmir, əvvəlki10.99:1 düz rəng sübutu saxlanır. Cihaz/live/build testi yoxdur.
## Exact next step
- Yalnız v7 mətn və footer hündürlüyü kompromisini qiymətləndir; yeni dizayn vahidi ayrıca seçilməlidir. Qorunanları dəyişmə, implementasiyaya başlama.

# Aktiv davam nöqtəsi — C1 yığcam preview v8, 3 noyabr 2026

## Completed
- V7 mətn/footer qiymətləndirildi; istifadəçi tapşırığı ilə v8 statik variant yaradıldı, iki yekun1280×720 PNG açılıb baxıldı.
## Current state
- Yalnız statik sınaq; implementasiya və yekun UI qəbulu yoxdur.
## Decisions
- «Показать покупку / Показать продажу» eyni şriftlə tək sətirdədir. Footer y560…672/h112; enlər608/624, sol inset16/sağ8 (mövcud16px sınaq ölçüsündən). Aktiv16px xətt və4px kontur saxlanır; yeni kanonik token deyil.
- «Назад» yuxarı sağa x1008/y48/w256/h96 köçürülüb; identity rect eni976 olub, mətn/şrift/mövqe dəyişməyib. Bu yeni layout sınağıdır, təsdiq deyil.
- Şrift/məlumat/sourceRows/pages(outputPx istisna)/state/contract/miqdar2 qorunur. C2 rerender yoxdur; digər4 PNG byte-identical; qorunan source hash-lar eynidir.
## Remaining work
- V8-də yuxarı sağ Back yeri və sıx sağ mətn boşluğunu qiymətləndirmək. Canlı UI/cihaz/native scaling/lokalizasiya və əvvəlki açıq məsələlər qalır.
## Relevant files
- design/tools/render-d1-c1-preview-compact-v8.swift
- design/states/D1-C1-preview-compact-v8/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png}
## Checks performed
- Swift/CoreText render42/42 fit/safe, rect overlap0; hər preview-də2 tək sətirli keçid/1 aktiv/no actionFill. Font/run names/contract/page content equality, protected SHA256 və digər4 PNG byte equality.
- İki yekun PNG vizual baxışı. Palitra eynidir, əvvəlki10.99:1 düz rəng sübutu saxlanır; yeni kontrast/cihaz/live/build testi yoxdur.
## Exact next step
- Yalnız v8 review və iki PNG-ni qiymətləndir; şrift/məlumat/seçim/miqdar2/C2-ni qoru; implementasiyaya başlama.


# Aktiv davam nöqtəsi — C1 footer sağ boşluğu v9, 3 noyabr 2026

## Completed
- V8 qiymətləndirildi; istifadəçinin ayrıca tapşırığı ilə yalnız iki footer yazısını8px sola çəkən v9 statik variant hazırlandı. İki yekun1280×720 PNG açılıb vizual baxıldı.
## Current state
- Yalnız statik dizayn sınağı; implementasiya və yekun UI qəbulu yoxdur.
## Decisions
- Footer mətn insetləri16/8→8/16; mətn eni, footer rect-lər, aktiv xətt və yuxarı sağ Назад v8 ilə eynidir. Mövcud16px sınaq ölçüsünün yarısı istifadə olunub; kanonik token dəyişməyib.
- Şrift/məlumat/seçim/miqdar2/C2 qorunur; digər4 PNG byte-identical; protected source SHA256-lar eynidir.
## Remaining work
- V9 sağ boşluq/sol sıxlıq kompromisini istifadəçi ilə qiymətləndir. Canlı UI/cihaz/native scaling/lokalizasiya və əvvəlki açıq məsələlər qalır.
## Relevant files
- design/tools/render-d1-c1-preview-padding-v9.swift
- design/states/D1-C1-preview-padding-v9/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png}
- design/states/D1-C1-preview-compact-v8/{review.json,manifest.json}
## Checks performed
- Swift/CoreText render42/42 fit/safe; blok overlap0; v8 font/run/pages/state/contract və əvvəlki check sahələri eynidir. Protected SHA256 və digər4 PNG byte equality yoxlanıb.
- İki yekun PNG vizual baxışı: kəsilmə yoxdur, sağ boşluq artıb, sol inset daha sıxdır. Palitra dəyişməyib; əvvəlki10.99:1 düz rəng sübutu saxlanır; yeni kontrast/device/live/build testi yoxdur.
## Exact next step
- Yalnız v9 review və iki PNG-ni qiymətləndir; növbəti kiçik statik vahidi ayrıca seç. Qorunanları dəyişmə; implementasiyaya başlama.


# Aktiv davam nöqtəsi — C1 balanslı footer v10, 3 noyabr 2026

## Completed
- V9 review və iki PNG qiymətləndirildi; istifadəçi tapşırığı ilə v10 statik variant yaradıldı. İki yekun1280×720 PNG render edilib açılıb baxıldı.
## Current state
- Yalnız statik sınaq; implementasiya və yekun UI qəbulu yoxdur.
## Decisions
- Footer nominal insetləri8/16→12/12; hər iki mətn v9-dan4px sağa çəkilib. Mətn eni, footer rect, aktiv xətt, Back və bütün digər həndəsə dəyişmir.12px mövcud16px sınaq ölçüsünün3/4-üdür; kanonik token deyil.
- Şrift/məlumat/seçim/miqdar2/C2 qorunur. Digər4 PNG byte-identical; bütün qeydə alınmış protected source SHA256-lar eynidir.
## Remaining work
- V10 balansını istifadəçi ilə qiymətləndir. Əvvəlki canlı UI/cihaz/native scaling/lokalizasiya açıq məsələləri qalır.
## Relevant files
- design/tools/render-d1-c1-preview-padding-v10.swift
- design/states/D1-C1-preview-padding-v10/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png}
## Checks performed
- Swift/CoreText render42/42 fit/safe; blok overlap0. V9 ilə yalnız4 footer inset qeydinin dəyişməsi; fonts/run names/pages/state/contract equality, protected hashes və digər4 PNG byte equality yoxlanıb.
- İki PNG vizual baxılıb: kəsilmə yoxdur, sol sıxlıq yumşalıb, sağ boşluq saxlanır. Palitra dəyişmir; əvvəlki10.99:1 düz rəng sübutu saxlanır, yeni kontrast/device/live/build testi yoxdur.
## Exact next step
- Yalnız v10 review və iki PNG-ni qiymətləndir; növbəti kiçik statik vahidi ayrıca seç. Qorunanları dəyişmə; implementasiyaya başlama.

# Aktiv davam nöqtəsi — V10 footer balansı qəbul edildi, 3 noyabr 2026

## Completed
- İstifadəçi V10 footer balansını açıq qəbul etdi. Əvvəlki baxışda hər iki preview PNG yoxlanıb: mətn kəsilmir, nominal12/12 insetlər tarazdır, aktiv alt xətt aydındır.
## Current state
- Qəbul yalnız V10 statik footer balansına aiddir; bütün UI və ya canlı davranış qəbulu deyil. Implementasiya başlamayıb.
## Decisions
- Qəbul edilmiş footer həndəsəsi saxlanır. Şrift/məlumat/seçim/miqdar2/C2 və digər qorunanlar dəyişdirilmir; kanonik token qərarı verilməyib.
- Növbəti kiçik vahid təklifi: iki mövcud preview-də yuxarı sağ «Назад» yerləşməsinin və başlıqla vizual iyerarxiyasının ayrıca statik qiymətləndirilməsi. Bu yalnız təklifdir; yeni variant hazırlamaq tapşırığı deyil.
## Remaining work
- «Назад» yerləşməsinin ayrıca qiymətləndirilməsi; əvvəlki canlı UI/cihaz/native scaling/lokalizasiya və digər açıq məsələlər qalır.
## Relevant files
- docs/context/current-task.md
- design/states/D1-C1-preview-padding-v10/{review.json,manifest.json,C1-preview-buy-1.png,C1-preview-sell-1.png}
## Checks performed
- Bu yeniləmədə son kontekst qeydi oxunub və qəbul qeydi əlavə edilib. Əvvəlki PNG baxışı və review nəticələri əsas götürülüb; yeni render/test/hash yoxlaması aparılmayıb. Dizayn artefaktları və oyun kodu dəyişdirilməyib.
## Exact next step
- Yeni chatdə bu son qeydi oxu; ayrıca tapşırıq verilərsə, yalnız mövcud iki V10 PNG-də «Назад» yerləşməsini və başlıqla iyerarxiyasını qiymətləndir. Qəbul edilmiş footeri və bütün qorunanları dəyişmə; implementasiyaya başlama.

# Aktiv davam nöqtəsi — «Назад» yerləşməsi və iyerarxiyası qəbul edildi, 3 noyabr 2026

## Completed
- İki V10 preview PNG-də «Назад» yerləşməsi və başlıqla iyerarxiyası vizual qiymətləndirildi; istifadəçi hər ikisini açıq qəbul etdi.
## Current state
- V10 footer balansı və «Назад» yerləşməsi/iyerarxiyası qəbul edilib. Bu, bütün UI və ya canlı davranışın qəbulu deyil; implementasiya yoxdur.
## Decisions
- Qəbul edilmiş footer və «Назад» saxlanır; düymənin vurğusunu azaltmaq işi açılmır. Şrift/məlumat/seçim/miqdar2/C2 və digər qorunanlar dəyişdirilmir.
- Növbəti kiçik statik vahid təklifi: iki mövcud preview-də əsas məlumat blokunun şaquli ritmini qiymətləndirmək — başlıq, nəticə sətirləri və footerə qədər boşluq. Yeni variant və ya dəyişiklik hələ tapşırılmayıb.
## Remaining work
- Təklif olunan məlumat bloku qiymətləndirməsi; əvvəlki canlı UI/cihaz/native scaling/lokalizasiya və digər açıq məsələlər qalır.
## Relevant files
- docs/context/current-task.md
- design/states/D1-C1-preview-padding-v10/{review.json,C1-preview-buy-1.png,C1-preview-sell-1.png}
## Checks performed
- Əvvəlki qiymətləndirmədə iki PNG açılıb baxılıb: «Назад» mətnlərlə toqquşmur, mövqeyi sabitdir, vizual çəkisi güclü olsa da iyerarxiya qənaətbəxşdir.
- Bu yeniləmədə yalnız kontekst qeydi dəyişdirilib; yeni render/test/hash yoxlaması aparılmayıb. Dizayn artefaktları və oyun kodu dəyişməyib.
## Exact next step
- Yeni chatdə son qeydi oxu; ayrıca tapşırıq verilərsə, iki V10 PNG-də yalnız əsas məlumat blokunun şaquli ritmini qiymətləndir. Qəbul edilmiş footer/«Назад» və bütün qorunanları dəyişmə; implementasiyaya başlama.


# Aktiv davam nöqtəsi — Spark texniki plan uyğunlaşdırıldı, 3 noyabr 2026

## Completed
- IMPLEMENTATION_PLAN.az.md §2.1/3–8/12/14 və M3–M5 Spark + əlavə serversiz modelə uyğunlaşdırıldı; §16 statusları yeniləndi.
- Monetizasiya üstünlük qeydi və D5 coverage-də köhnə server tələbləri uyğunlaşdırıldı.
## Current state
- Yalnız sənəd layihəsi; kod, Rules, infrastruktur və veb səhifə yaradılmayıb. Deploy/Console dəyişikliyi yoxdur.
- V10 footer və «Назад» qəbul statusu dəyişmir; vizual iş aparılmayıb.
## Decisions
- Firebase Auth + Firestore, Room outbox/CAS, bounded iki snapshot, generation tombstone və atomik əməliyyat qəbzləri layihələndirilib.
- Rekord/nailiyyət client-reported; SSV/server replay/purchase verification V1-dən çıxarılıb. App/web deletion Auth-last və yazını bloklayan minimal control baryeri ilə layihələndirilib.
- Bunlar texniki layihədir; stack/minSdk və açıq məhsul seçimləri təsdiqlənmiş kimi göstərilmir.
## Remaining work
- Snapshot ölçü həddi/kvota hesabı/qəbz retention-u, deletion support/retention müddətləri/URL-lər, App Check konfiqurasiyası, Play↔Firebase hüquq və post-deletion restore siyasəti.
- Balans təklifi, stack müqayisəsi/minSdk və D1–D6 açıq qalır.
## Relevant files
- docs/IMPLEMENTATION_PLAN.az.md (§6–8/12/16)
- docs/MONETIZATION_PLAN.az.md (son qərar əlavəsi)
- docs/design-coverage.json (D5 remaining)
## Checks performed
- Rəsmi Firebase transaction/Rules/kvota/App Check/Auth delete və Play Billing/rewarded sənədləri oxundu; mənbə keçidləri plana əlavə edildi.
- Mətn üzrə köhnə server tələbləri yoxlandı; JSON sintaksisi və diff/whitespace yoxlamaları aparıldı. Build/test/render yoxdur; implementasiya edilməyib.
## Exact next step
- Ayrıca balans təklifi hazırla, decisions.json ilə tutuşdur və istifadəçiyə seçim üçün təqdim et. Texniki açıq inputları tamamlanmış sayma; implementasiyaya başlama. Yalnız dizayn davamı istənərsə əvvəlki V10 qəbul qeydlərini əsas götür.

# Aktiv davam nöqtəsi — classic balans təklifi hazırdır, 3 noyabr 2026

## Completed
- docs/BALANCE_PROPOSAL.az.md hazırlandı: qəbul edilmiş çərçivə və B01–B10 yeni təkliflər ayrıldı. Başlanğıc, 10 mal/4 şəhər, bazar, 3 yol, xidmət/təkmilləşdirmə, borc/iş, hadisə itkisi/keyfiyyət, xəbər, son gün və nailiyyət trigger-ləri əhatə olundu.
- IMPLEMENTATION_PLAN.az.md §16.3/16.5 təklifə bağlandı; istifadəçi seçimi növbəti addımdır.
## Current state
- Bütün yeni balans rəqəmləri və dəqiqləşdirmələr təklifdir; istifadəçi hələ qəbul etməyib. decisions.json və dizayn artefaktları dəyişdirilməyib.
- Spark texniki layihəsi əvvəlki qeyddəki kimidir; implementasiya, deploy və Console dəyişikliyi yoxdur. V10 footer/«Назад» qəbul statusu qorunur.
## Decisions
- Tövsiyə olunan, qəbul edilməmiş baza: 300 qızıl/30 tutum, Sünbülova; 20 günlük classic çərçivəsi qorunur.
- Tövsiyə: hadisə üzrə 15% ümumi aktiv itkisi büdcəsi, hadisədən sonra bir təhlükəsiz yol; 10% sabit kredit haqqı; vaxtında/gecikmiş nəticələrin mövcud rewind kateqoriyalarına əlavə ayrımı. Bunlar ayrıca seçim gözləyir.
## Remaining work
- Əvvəl B01–B03 iqtisadi baza seçimi, sonra B04–B07 yol/risk/borc və B08–B10 xəbər/son gün/trigger qərarları. Yalnız açıq qəbuldan sonra seçilmiş maddələri decisions.json/D1–D5 ilə uyğunlaşdır.
- Stack/minSdk, Spark ölçü/kvota/retention, deletion support və Play↔Firebase hüquq siyasəti, D1–D6 və real oynanış sınağı açıqdır.
## Relevant files
- docs/BALANCE_PROPOSAL.az.md
- docs/IMPLEMENTATION_PLAN.az.md (§16)
- docs/decisions.json (86 confirmed + open; dəyişməyib)
- design/states/D2-travel-spec.json
- design/states/D3-debt-spec.json
- design/states/D4-news-events-spec.json
- docs/M1_5_PLAYTEST.az.md (mövcud protokol, dəyişməyib)
## Checks performed
- Qəbul edilmiş qərarlar və D2–D4 açıq qaydaları oxunub; əvvəlki PNG rəqəmləri qəbul edilmiş balans sayılmayıb.
- Müvəqqəti hesablamada dəqiq kəsrlərlə 10 000 baza üçün eyni-gün qiymət arbitraj bərabərsizliyi, 367/361/469 ticarət nümunələri, 100→110→70→74 borc və risk ehtimal cəmləri yoxlanıb.
- B01–B10 tamlığı, yerli Markdown keçidləri, whitespace və decisions JSON sintaksisi yoxlanıb. Stochastic oyun simulyasiyası, build, render və oyunçulu balans testi yoxdur.
## Exact next step
- Yeni chatdə bu son qeydi və BALANCE_PROPOSAL.az.md B01–B03-ü oxu; istifadəçinin hansı maddələri qəbul etdiyini dəqiqləşdir və yalnız onları qərar mənbəyinə köçür. Qalan təklifləri avtomatik qəbul edilmiş sayma; implementasiyaya başlama.


# Aktiv davam nöqtəsi — B01–B03 qəbul edildi, 3 noyabr 2026

## Completed
- İstifadəçinin açıq qəbulu decisions.json → balanceDecisions.confirmed daxilində B01–B03 qaydaları ilə saxlanıldı; təklif və implementasiya planının statusu uyğunlaşdırıldı.
## Current state
- 300 qızıl/30 tutum, Sünbülova startı, şəhər/mal/ehtiyat bölgüsü və qiymət modeli qəbul edilib. Alternativlər qəbul edilməyib. İmplementasiya yoxdur.
## Decisions
- B01–B03 əsas qaydaları qüvvədədir; B04–B10 ayrıca seçim gözləyir. Bir gün oyundaxili vaxt vahididir; real vaxtla çevirmə və animasiya müddəti bu qəbulda təyin edilməyib.
## Remaining work
- B04–B07 yol/risk/xidmət/borc, sonra B08–B10. Oynanış balans testi və əvvəlki texniki/dizayn açıq işləri qalır.
## Relevant files
- docs/decisions.json (balanceDecisions)
- docs/BALANCE_PROPOSAL.az.md (B01–B03)
- docs/IMPLEMENTATION_PLAN.az.md (§16.3/16.5)
## Checks performed
- JSON parse və B01–B03 qaydalarının təkliflə eyniliyi yoxlandı. Kod/build/test/render yoxdur.
## Exact next step
- İstifadəçi istəyəndə B04–B07-ni qısa izah et və seçimlərini al; yalnız açıq qəbul edilənləri qərarlara yaz. İmplementasiyaya başlama.


# Aktiv davam nöqtəsi — B01–B07 qəbul edilib, B08–B10 seçimdə, 3 noyabr 2026

## Completed
- İstifadəçinin B04–B07 açıq qəbulu decisions.json → balanceDecisions.confirmed daxilində tam əsas qaydalarla yazıldı; alternativlər daxil edilmədi. Təklif/plan statusları uyğunlaşdırıldı.
## Current state
- B01–B07 qəbul edilib; B08–B10 yalnız təklifdir. Kod/UI/infrastruktur dəyişməyib, implementasiya yoxdur.
## Decisions
- Qəbul edilmiş balans qaydaları əvvəlki D1–D5 eskiz açıq qeydlərinə üstün gəlir; dizaynların tamamlandığı iddia edilmir. B06/B07-nin B08/B09-a istinad etdiyi dəqiqləşdirmələr ayrıca qəbul gözləyir.
## Remaining work
- B08 xəbər/şayiə, B09 son-gün yardım/gecikmə/rekord ayrımı, B10 dəqiq nailiyyət trigger-ləri. Texniki və D1–D6 açıq işləri qalır.
## Relevant files
- docs/BALANCE_PROPOSAL.az.md (B08–B10)
- docs/decisions.json (balanceDecisions)
- docs/IMPLEMENTATION_PLAN.az.md (§16)
## Checks performed
- JSON parse, B04–B07 qaydalarının mənbə ilə eyniliyi və B01–B07 açarları yoxlandı. Build/test/render yoxdur.
## Exact next step
- İstifadəçinin B08–B10 cavabını al, yalnız qəbul edilmiş maddələri qərarlara yaz və statusları uyğunlaşdır. İmplementasiyaya başlama.

# Aktiv davam nöqtəsi — B01–B10 qəbul edilib, 3 noyabr 2026

## Completed
- B08–B10 istifadəçinin açıq qəbulu ilə decisions.json → balanceDecisions.confirmed daxilində saxlanıldı; BALANCE_PROPOSAL.az.md və IMPLEMENTATION_PLAN.az.md §16 statusları uyğunlaşdırıldı.
- B08: oyunçu olmasa da bütün şəhərlərdə hər oyun günü xəbər yaranması; bitmiş hadisənin doğruluğunun yerli xəbər tarixçəsindən yoxlanması.
- B09: gün 20-də yalnız satış, mövcud borcun nağd/malla ödənməsi və bitirmə; B01 ifadəsi uyğunlaşdırıldı. Yardım/gecikmə və dörd rekord kateqoriyası qəbul edilib.
- B10: dəqiq beş trigger, gecikmiş/yardımlı səfərlərin uyğun nailiyyətləri və təlimin ayrılması qəbul edilib.
## Current state
- B01–B10 qəbul edilib; alternativlər qəbul edilməyib. Sınaq meyarları yoxlama planıdır, balansın sınaqdan keçməsi deyil.
- Yalnız qərar/sənəd yeniləməsi; oyun kodu/UI/infrastruktur dəyişməyib, implementasiya yoxdur.
## Decisions
- B06/B07-nin B08/B09-a istinadları bağlanıb. Qəbul edilmiş balans köhnə D1–D5 açıq balans qeydlərinə üstün gəlir; dizaynlar tamamlanmış sayılmır.
## Remaining work
- Qəbul edilmiş balansın D1–D5 axın və qəbul meyarlarına uyğunlaşdırılması, D1–D6 yekun dizaynı və real oynanış balans testi.
- Stack/minSdk, Spark ölçü/kvota/retention, deletion və Play↔Firebase hüquq siyasəti açıq qalır.
## Relevant files
- docs/decisions.json (balanceDecisions və open)
- docs/BALANCE_PROPOSAL.az.md (B08–B10 və qəbul sərhədi)
- docs/IMPLEMENTATION_PLAN.az.md (§16.3/16.5)
## Checks performed
- JSON parse, B01–B10 açarları, B08–B10 əsas mətnlərinin qərar mənbəyi ilə eyniliyi və yenilənmiş faylların whitespace yoxlaması aparıldı.
- Build/test/render və oyunçulu balans testi aparılmayıb; implementasiya edilməyib.
## Exact next step
- Ayrıca dizayn tapşırığı verilərsə qəbul edilmiş balansı D5 xəbər, son-gün nəticə/rekord və nailiyyət axınlarının qəbul meyarlarına uyğunlaşdır. Əvvəl yalnız aidiyyəti spec/coverage hissələrini oxu; implementasiyaya başlama.

# Aktiv davam nöqtəsi — D5 balans qəbul meyarları uyğunlaşdırıldı, 3 noyabr 2026

## Completed
- D5-system-spec.json-da B01–B10 mənbəli dörd mətn müqaviləsi: xəbər/şayiə davamlılığı, son-gün/final hesablaşması, rekord kateqoriyaları və beş nailiyyət trigger-i; cəmi 31 qəbul meyarı.
- R01/R02/T01 mətnləri və D5 coverage/statusları uyğunlaşdırıldı. Təlim ayrımı və trigger-lər artıq açıq məhsul qərarı kimi göstərilmir.
## Current state
- Yalnız spesifikasiya/coverage sənədləri yeniləndi. PNG, oyun kodu və infrastruktur dəyişməyib; implementasiya yoxdur.
- B01–B10 qəbul edilib; D5 bütöv kanonik dizaynı və işlək davranışı tamamlanmış/yoxlanmış deyil. Əvvəlki PNG yeni müqavilələrin vizual sübutu deyil.
## Decisions
- D5 xəbər meyarları D4-dən, son-gün meyarları D2/D3/D4-dən keçid müqavilələridir; həmin spec-lər bu vahiddə dəyişdirilməyib. Köhnə açıq balans qeydlərinə qəbul edilmiş qaydalar üstün gəlir.
- Backup restore-un rekord kateqoriyası ayrıca açıqdır. Online nəticə client-reported olaraq qalır; upload təsdiqi anti-cheat sübutu deyil.
## Remaining work
- D2–D4 köhnə balans/bloker qeydlərinin ayrıca uyğunlaşdırılması; D5 kanonik ekranlar, konkret təlim fixture-i və texniki inteqrasiya yoxlaması.
- D5 spec-də əvvəlki Spark-dan öncəki texniki açıq sualların §6–8/12 ilə ayrıca uyğunlaşdırılması; stack/minSdk/kvota/retention/deletion/hüquq işləri qalır.
## Relevant files
- design/states/D5-system-spec.json (balanceAlignment, contracts, R01/R02/T01)
- docs/design-coverage.json (D5 progress/resolution)
- docs/decisions.json (balanceDecisions.confirmed)
- docs/BALANCE_PROPOSAL.az.md
- docs/IMPLEMENTATION_PLAN.az.md (§6–8/12/16)
## Checks performed
- D5 və coverage JSON parse, B01–B10 mənbə açarları, state ID unikallığı, müqavilələrdə qəbul meyarlarının mövcudluğu və whitespace yoxlandı.
- Yeni render/build/test/cihaz/online xidmət və oyunçulu balans yoxlaması aparılmayıb.
## Exact next step
- Yeni chatdə yalnız D2–D4 balans uyğunlaşdırılması üçün tapşırıq verilərsə aidiyyəti spec və coverage hissələrini oxu; B01–B10-a görə köhnə açıq balans qeydlərini uyğunlaşdır. D5-in texniki açıq suallarını ayrıca vahid kimi saxla; implementasiyaya başlama.

# Aktiv davam nöqtəsi — D2–D4 balans uyğunlaşdırıldı, 3 noyabr 2026

## Completed
- D2/D3/D4 spec-lərində köhnə açıq balans blokerləri qəbul edilmiş B01–B10 mənbə istinadları, vəziyyət mətnləri və qəbul meyarları ilə əvəzləndi; coverage statusları uyğunlaşdırıldı.
- D2 üç yol/risk/xidmət/gün sırası/son-gün çıxışları; D3 kredit/möhlət/mal/iş/final; D4 H01–H10/şayiə/itki/keyfiyyət qaydaları bağlandı. D3 köhnə 100+20 nümunəsi 100+10=110 ilə düzəldildi.

## Current state
- Yalnız spesifikasiya və coverage mətnləri dəyişib; implementasiya yoxdur. PNG-lər dəyişməyib, yeni qaydaların vizual sübutu deyil.
- D2–D4 balans baxımından uyğunlaşdırılıb; kanonik ekranlar/runtime və oynanış balans testi tamamlanmayıb.

## Decisions
- Normativ mənbə docs/decisions.json → balanceDecisions.confirmed; alternativlər qəbul edilməyib.
- D5-system-spec.json və D5 texniki sualları bu işdə dəyişdirilməyib; ayrıca vahid kimi qalır. Backup restore rekord kateqoriyası da bu işlə həll olunmur.

## Remaining work
- D2–D4 kanonik kompozisiyalarının qəbul edilmiş qaydalarla birləşdirilməsi, D6 və real oynanış yoxlamaları.
- D5 texniki suallarını plan §6–8/12 ilə ayrıca uyğunlaşdırmaq; stack/minSdk/kvota/retention/deletion/hüquq açıq işləri qalır.

## Relevant files
- design/states/D2-travel-spec.json
- design/states/D3-debt-spec.json
- design/states/D4-news-events-spec.json
- docs/design-coverage.json
- docs/decisions.json (balanceDecisions.confirmed)
- design/states/D5-system-spec.json (dəyişməyib)
- docs/IMPLEMENTATION_PLAN.az.md (§6–8/12/16; dəyişməyib)

## Checks performed
- Üç spec və coverage JSON parse; state ID unikallığı, qəbul edilmiş qərar açarları, PNG yolları, whitespace və kredit nümunəsinin hesabı yoxlandı.
- Hədəfli axtarışla köhnə açıq balans/bloker ifadələri yoxlandı. Render/build/runtime/cihaz/online/oyunçulu balans testi aparılmayıb.

## Exact next step
- Növbəti ayrıca tapşırıq D5 texniki uyğunlaşdırılması olarsa yalnız D5 texniki açıq suallarını və IMPLEMENTATION_PLAN §6–8/12-ni oxu; qəbul edilmiş balansı yenidən açma. Kanonik dizayn istənərsə yalnız seçilmiş bir kiçik vahidi işlə. İmplementasiyaya başlama.

# Aktiv davam nöqtəsi — D5 texniki suallar planla uyğunlaşdırıldı, 3 noyabr 2026

## Completed
- D5-system-spec.json texniki state/müqavilə/variant/entryFlow mətnləri IMPLEMENTATION_PLAN.az.md §6–8/12 ilə uyğunlaşdırıldı; coverage D5 qeydləri yeniləndi.
- Köhnə server replay/SSV/backend purchase verification/deletion job xidmət seçimi blokerləri V1 serversiz Spark layihəsi ilə əvəzləndi. Bunlar implementasiya və ya təhlükəsizlik sınağının tamamlanması deyil.
- technicalAlignment daxilində DT01–DT09 ayrıca statuslu açıq input/retention/policy/konfiqurasiya/yoxlama maddələri saxlandı; təlim fixture-i və kanonik ekranlar remainingDesignWork-a ayrıldı.

## Current state
- Yalnız D5 spec, coverage və bu kontekst qeydi dəyişib. Kod/Rules/infrastruktur/veb səhifə yaradılmayıb; implementasiya yoxdur.
- Plan və B01–B10 qərar mənbələri dəyişməyib. D5 balanceAlignment və dörd balans müqaviləsi tam eyni saxlanıb.

## Decisions
- Cloud server commit/qəbzi yalnız cloud qəbuldur; online nəticə client-reported, pending_upload→published-dir. Client Billing/reward server verification deyil.
- Deletion deleting baryeri→sənəd silmə/server yoxlaması→Auth-last→lokal təmizlik layihəsidir; URL/support/retention/PGS əhatəsi açıqdır.
- Plan §8-də köhnə trigger-open/natamam kateqoriya ifadələri B09/B10-u yenidən açmır; balans mənbəyi decisions.json-dır.

## Remaining work
- DT01–DT09: ölçü/kvota, branch/qəbz retention, Rules/Auth/App Check/backup konfiqurasiyası və sınağı, deletion policy/support, moderasiya/event ID mapping, reklam settle/consent, SKU/Play↔Firebase/post-deletion restore, backup restore rekord kateqoriyası, ayrıca stack/minSdk.
- Kanonik D5 ekranları/təlim fixture-i və D6; real runtime/oyunçulu yoxlamalar.

## Relevant files
- design/states/D5-system-spec.json (technicalAlignment.unresolved, openQuestions, remainingDesignWork)
- docs/design-coverage.json (D5)
- docs/IMPLEMENTATION_PLAN.az.md (§6–8/12/16; dəyişməyib)
- docs/decisions.json (balanceDecisions.confirmed; dəyişməyib)

## Checks performed
- JSON parse, state ID unikallığı, DT01–DT09 tamlığı, coverage uyğunluğu və whitespace yoxlandı.
- Snapshot/hash müqayisəsi: D5 balanceAlignment+dörd balans müqaviləsi, decisions.json, BALANCE_PROPOSAL, IMPLEMENTATION_PLAN və D2–D4 spec-ləri dəyişməyib.
- Yeni render/build/runtime/Firestore/Billing/reklam/deletion testi aparılmayıb; PNG-lər tarixi eskizdir.

## Exact next step
- Yeni chatdə bu son qeydi və D5 technicalAlignment.unresolved-u oxu; istifadəçinin seçdiyi yalnız bir DT maddəsini dəqiqləşdir. Qəbul edilmiş balansı dəyişmə və implementasiyaya başlama. Böyük yeni işi bu chatə əlavə etmə; istifadəçi burada davam etməyi seçərsə seçiminə hörmət et.

# Aktiv davam nöqtəsi — DT02 dəqiqləşdirmə təklifi, 3 noyabr 2026

## Completed
- İstifadəçi DT02-ni seçdi; D5 technicalAlignment.unresolved → DT02.clarification əlavə edildi. Digər DT-lər və D5 bölmələri dəyişməyib.
- Lokal həll edilməmiş branch, həll edilmiş ehtiyat, previous, adi sync qəbzi və replay-blocking qeydlər üçün ayrı saxlanma/təmizləmə sərhədləri və 7 qəbul meyarı yazıldı.

## Current state
- Status: clarified_proposal_pending_approval_capacity_and_validation. Müddət/saylar agent təklifidir, istifadəçi təsdiqi deyil. Kod/Rules/infrastruktur/UI dəyişməyib; implementasiya yoxdur.

## Decisions
- Təklif: həll edilmiş branch 30 gün, slot başına 3 ehtiyat; say həddində silmə üçün ayrıca razılıq. Həll edilməmiş/naməlum branch avtomatik silinmir.
- Previous bir sağlam nüsxədir; vaxt əsaslı arxiv deyil. Adi sync qəbzi üçün 30 gün + köhnə base-in rədd edilməsi + cari lastOpId olmaması; keçid başına ən çox 50 namizəd/50 silmə.
- Replay-blocking reward/start/completion/nailiyyət qeydləri hesab ömrü boyu qorunur; təhlükəsiz arxiv protokolu olmadan avtomatik silinmir. Bu artan saxlanmadır, sərt tutum həddi deyil.
- B01–B10, DT04/06/07/08 və plan dəyişməyib.

## Remaining work
- 30 gün / 3 ehtiyat / 50-lik səhifə təklifini qəbul etmək və ya dəyişmək; DT01 tutum hesabı və DT03 icra/sınaq ayrıca qalır.

## Relevant files
- design/states/D5-system-spec.json (technicalAlignment.unresolved → DT02.clarification)
- docs/IMPLEMENTATION_PLAN.az.md (§7.1–7.3; dəyişməyib)

## Checks performed
- D5 JSON parse və struktur müqayisəsi: technicalAlignment xaricində bütün bölmələr və DT02 xaricində bütün DT maddələri eynidir. Yeni qəbul meyarları sınaq planıdır; runtime/Rules/build/render aparılmayıb.

## Exact next step
- Yalnız DT02 təklifinin 30 gün / 3 ehtiyat / 50-lik səhifə parametrlərinə istifadəçi rəyini al; təsdiq olmadan qəbul edilmiş siyasət kimi göstərmə. Balansı dəyişmə və implementasiyaya başlama.

# Aktiv davam nöqtəsi — DT02 parametrləri qəbul edildi, 3 noyabr 2026

## Completed
- İstifadəçi 30 gün / slot başına 3 ehtiyat / 50-lik təmizləməni açıq qəbul etdi; D5 DT02 status/authority/acceptedParameters və plan §7.2 əlavəsində təsdiq qeydə alındı. Əvvəlki pending-approval qeydi bu təsdiqlə əvəz olunur.
## Current state
- DT02: parameters_accepted_capacity_and_validation_pending. Yalnız sənəd dəyişikliyi; implementasiya yoxdur.
## Decisions
- Həll edilmiş branch retention 30 gün, slot başına 3 ehtiyat; adi sync qəbzi üçün minimum 30 gün və keçid başına ən çox 50 namizəd/50 uyğun silmə qəbul edilib. Mövcud qoruma şərtləri saxlanıb.
- B01–B10, digər DT maddələri və balans müqavilələri dəyişməyib.
## Remaining work
- DT01 tutum/kvota hesabı və DT03 Rules/schema/retry sınaqları; təsdiqlənmiş parametrlər bunların tamamlanması deyil.
## Relevant files
- design/states/D5-system-spec.json (DT02.clarification)
- docs/IMPLEMENTATION_PLAN.az.md (§7.2 DT02 əlavəsi)
## Checks performed
- JSON parse; struktur müqayisəsində digər D5 bölmələrinin və DT maddələrinin eyniliyi yoxlandı. Parametr/status və whitespace yoxlaması keçdi. Runtime/Rules/build/render yoxlaması yoxdur.
## Exact next step
- İstifadəçinin ayrıca növbəti tapşırığını gözlə; DT02 parametr təsdiqini yenidən istəmə. DT01 hesabı və ya DT03 icrası ayrıca tapşırıqdır; balansı dəyişmə, implementasiyaya başlama.

# Aktiv davam nöqtəsi — DT01 ölçü/kvota modeli, 3 noyabr 2026

## Completed
- DT01.clarification və IMPLEMENTATION_PLAN §7.3 əlavəsində rəsmi limitlər, ölçü büdcəsi/fixture tələbi, DT02 hesabı, sync/coalesce təklifi və 3 yük ssenarisi yazıldı.
- Rəsmi Firestore quotas/storage-size/pricing səhifələri 3 noyabr 2026-da yoxlandı. Arifmetika lokal hesablandı; xidmət və ya oyun implementasiyası edilmədi.

## Current state
- DT01: capacity_model_drafted_parameters_and_measurement_pending. Daxili byte/sync hədləri təklifdir; real schema worst-case və tutum təsdiqlənməyib.
- DT02-nin qəbul edilmiş 30 gün / slot başına 3 ehtiyat / 50-lik təmizləməsi və statusu tam eynidir. B01–B10 dəyişməyib.

## Decisions
- DT01 təklifi: snapshot96 KiB; current+previous+envelope208 KiB; indekslə256 KiB/slot; receipt/run1 KiB; digər hesab16 KiB; adi sync minimum60 saniyə. İstifadəçi bunları hələ qəbul etməyib.
- DT02 lokal3×3 ehtiyat =864 KiB, current/previous ilə1440 KiB; journal/outbox/unresolved xaricdir, cloud-a əlavə branch yazılmır.
- İstinad ssenarisi s12/c2:614,5 read/42 write/100 delete/4,25 MiB aktiv hesab-günü. 20% ehtiyatla read65 DAU, outbound30 günlük ayda64/31 gündə62 DAU. Bunlar şərti modeldir, ölçülmüş tutum deyil.
- Yaddaş ümumi hesab sayı və aktiv hesab yaşı ilə hesablanır; reference30 gündə1384 KiB/hesab (606 hesab),365 gündə4064 KiB (206 hesab),80% storage büdcəsində.

## Remaining work
- DT01 təklif parametrlərinə istifadəçi qərarı; gözlənən DAU/ümumi hesab, cihaz/sessiya/aktivlik və hesab yaşı inputları.
- Implementasiya ayrıca icazələndirilərsə schema/serializer maksimum fixture, indeks/Query Explain, Rules trace və wire payload ölçməsi; DT03 sınaqları. Hazırda heç biri aparılmayıb.

## Relevant files
- design/states/D5-system-spec.json (technicalAlignment.unresolved → DT01.clarification; DT02 dəyişməyib)
- docs/IMPLEMENTATION_PLAN.az.md (§7.3 DT01 əlavəsi)
- docs/decisions.json və docs/BALANCE_PROPOSAL.az.md (dəyişməyib)

## Checks performed
- JSON parse, ssenari düsturları və floor hədləri, whitespace yoxlandı. Struktur müqayisəsi: DT01 xaricində D5 bölmələri və DT02–DT09 eynidir; balans mənbələri/D2–D4 hash müqayisəsi eynidir.
- Real fixture/Firestore/Rules/runtime/build/render/yük testi yoxdur. Yeni byte/interval rəqəmləri qəbul edilmiş balans və ya təsdiqlənmiş parametr kimi göstərilmir.

## Exact next step
- Yeni chatdə son bu qeydi və yalnız DT01.clarification/plan §7.3 DT01 əlavəsini oxu. İstifadəçi ilə təklif ölçü/sync parametrlərini və real yük inputlarını dəqiqləşdir; DT02 təsdiqini yenidən istəmə. Balansı dəyişmə, implementasiyaya başlama.

# Aktiv davam nöqtəsi — DT01 ölçü/sync semantikası dəqiqləşdirildi, 3 noyabr 2026

## Completed
- Son DT01 qeydi, D5 DT01.clarification və plan §7.3 əlavəsi oxundu; yalnız DT01 məzmunu və uyğun plan əlavəsi dəqiqləşdirildi.
- Byte/storage/wire ayrımı, UID+slot+cihaz üzrə sync interval təklifi, dəyişməz in-flight retry, davranışdan sync hesabı və dəyişən əməliyyat düsturları yazıldı.
- Dolu cleanup səhifələrinin xərc rezervi olduğu, daimi silmə proqnozu olmadığı və 0,5 MiB əlavə trafik rezervinin bootstrap-da aşa biləcəyi açıq qeyd edildi.

## Current state
- DT01 capacity_model_drafted_parameters_and_measurement_pending qalır; real ölçmə və tutum təsdiqi yoxdur. İmplementasiya başlamayıb.
- İstifadəçi açıq seçdi: ölçməyədək bütün DT01 ölçü/sync parametrləri təklif qalsın. Yeni parametr təsdiqi yoxdur.

## Decisions
- 96/208/256 KiB, 1 KiB/16 KiB və 60 saniyə daxil DT01 parametrləri təklifdir.
- s=12 intervaldan törəmir; bütün cihaz/slot commit-lərinin fərziyyə cəmidir. Əvvəlki DAU rəqəmləri şərti ssenaridir, zəmanət deyil.
- DT02 və D5-in DT01 xaricində bütün məzmunu, decisions.json/balans qərarları dəyişməyib.

## Remaining work
- İstifadəçiyə real yük inputları üçün sual verilib, cavab hələ yoxdur: buraxılış/12 ay hesab+DAU, cihaz/sessiya/dirty dəqiqə/slot, əməliyyat sıxlığı, aktivlik/hesab yaşı/offline backlog. Məlum olmayan rəqəmlər uydurulmasın.
- Real schema/serializer/index/Rules/wire ölçməsi yalnız ayrıca implementasiya icazəsi ilə; DT03 sınaqları açıqdır.

## Relevant files
- design/states/D5-system-spec.json (yalnız DT01.clarification, xüsusən refinement)
- docs/IMPLEMENTATION_PLAN.az.md (§7.3 DT01 dəqiqləşdirməsi)

## Checks performed
- JSON parse, ümumiləşdirilmiş düsturların əvvəlki 3 ssenariyə uyğunluğu, 31 günlük outbound floor və whitespace yoxlandı.
- Struktur hash ilə DT01 xarici bütün D5, DT02–DT09 və decisions.json eyniliyi təsdiqləndi.
- Rəsmi Firestore quotas/pricing/storage-size mənbələri yenidən oxundu. Runtime/Rules/fixture/build/render/yük testi yoxdur.

## Exact next step
- Real yük inputlarına istifadəçi cavabı gələndə yalnız DT01 modelini həmin inputlarla yenidən hesabla. Ölçməyədək parametrləri təsdiqlənmiş kimi göstərmə. DT02 və balansı dəyişmə; implementasiyaya başlama.

# Aktiv davam nöqtəsi — D5 kanonik ekran dizaynına keçid, 3 noyabr 2026

## Completed
- DT01 sənəd dəqiqləşdirməsi əvvəlki qeyddədir. İstifadəçi bu texniki mövzunu hələlik keçməyi, sonra D5 kanonik ekranlarına başlamağı seçdi.
- Yeni chat üçün davam nöqtəsi hazırlandı; bu keçiddə ekran yaradılmayıb.

## Current state
- Aktiv məqsəd D5 kanonik ekran dizaynıdır; ilk kiçik vahid giriş axınıdır. DT01 yük inputlarını toplamaq aktiv tapşırıq deyil.
- Oyun implementasiyası üçün icazə yoxdur; DT02 və qəbul edilmiş balans qorunur.

## Decisions
- DT01 ölçü/sync parametrləri təsdiqlənməmiş təklif qalır; mövzu istifadəçi yenidən istəməyincə açılmasın.
- D5-in giriş, cloud konflikt, rekord, deletion və mağaza ekranları bir-bir işlənməlidir; əvvəl giriş.
- Vizual işdə ui-craft oxunmalı, mövcud token/palitra mənbəyi tapılmalı, nəticə render edilərək görüntüyə baxılmalıdır.

## Remaining work
- D5 giriş axınının mövcud spec/coverage və vizual mənbələrini hədəfli oxumaq; yalnız həmin kiçik vahidin kanonik dizaynını hazırlamaq.
- Digər D5 axınları və D6 sonrakı ayrıca vahidlərdir.

## Relevant files
- design/states/D5-system-spec.json (entryFlow, giriş state-ləri, remainingDesignWork)
- docs/design-coverage.json (D5)
- docs/decisions.json (giriş/dizayn qərarları və qüvvədə olan balans)
- docs/IMPLEMENTATION_PLAN.az.md (§6, yalnız girişə lazım olan hissə)
- /Users/mac/.agents/skills/ui-craft/SKILL.md

## Checks performed
- Son kontekst qeydi və D5-də entryFlow/remainingDesignWork yerləri yoxlandı. Yeni render/build/runtime yoxlaması yoxdur; ekranın hazır olduğu iddia edilmir.

## Exact next step
- Yeni chatdə bu son qeydi və ui-craft skill-ini oxu; yalnız D5 giriş axınına aid spec/coverage/qərar və mövcud vizual mənbələri yoxla, token mənbəyini tap, kanonik giriş ekranlarını hazırla və renderə bax. DT01-i yenidən açma, DT02 və balansı dəyişmə, oyun implementasiyasına başlama.

# Aktiv davam nöqtəsi — D5 giriş ekranları v1, 3 noyabr 2026

## Completed
- Yalnız giriş vahidi: F01/A01/A02 və C01 giriş yoxlaması/keçidi üçün 16 tam ekran PNG, overview, ayrıca spec və adlandırılmış lokal sınaq tokenləri hazırlandı.
- Mənbələr: D5 spec/coverage, plan §6, D5 tarixi lövhəsi, D1 son kompozisiya nümunəsi, D6 rəng namizədləri və D1 Noto Sans/type manifesti.
- İlk vizual baxışdan sonra dil seçimləri ayrıca 48dp hədəflərə ayrıldı, əsas mətnlə qeyd arasındakı boşluq artırıldı; yenidən render edilib baxıldı.

## Current state
- Kanonik giriş dizaynı v1 layihəsidir; istifadəçi təsdiqi və production UI deyil. Yalnız AZ, sintetik P1 640×360dp/2x.
- Swift yalnız statik dizayn rendereridir; oyun/auth implementasiyası yoxdur. Google sistem seçicisi təqlid edilmir, yalnız host gözləmə ekranı var.

## Decisions
- Mövcud paper/nav və Noto Sans namizədləri saxlanır; D5 ölçüləri ayrıca lokal trial tokenləridir, qlobal D6 null-ları doldurulmayıb.
- İlk login xətası qonaq yaratmır; server yoxlaması olmadan cloud boş sayılmır. Tanınmış UID lokal oyunla offline davam edə bilər.
- Restore/konflikt/hesab dəyişmə yalnız keçid müqaviləsidir; həmin ekranlar bu vahiddə hazırlanmayıb.
- D5-system-spec.json tam hash və decisions.json hash dəyişməyib; DT01/DT02, balans və digər müqavilələr qorunub.

## Remaining work
- Giriş layihəsinə istifadəçi rəyi; TR/RU/EN tam ekran mətnləri, böyük şrift və digər viewport/real cihaz yoxlamaları.
- Rəsmi Google brend asset/düymə yoxlaması, privacy URL; real sistem seçicisi, back/foreground və UID davranışları implementasiya mərhələsində yoxlanmalıdır.
- Digər D5 axınları ayrıca vahiddir; avtomatik başlanmasın.

## Relevant files
- design/states/D5-entry-spec.json
- design/states/D5-entry-trial-tokens.json
- design/states/D5-entry-v1/overview.png (və 16 ayrı PNG)
- design/states/D5-entry-v1/verification.json
- design/tools/render-d5-entry.swift
- docs/design-coverage.json (canonicalEntry əlavələri)

## Checks performed
- 16 PNG render olundu; son overview və F01-language/A01-ready tam ölçüdə view_image ilə baxıldı.
- Mətn ölçmə: allFit=true, allSafe=true; font binary SHA256 manifestə uyğundur. Bu toxunma/TalkBack testi deyil.
- ui-craft contrast.py: nav/paper və paper/nav 10.99:1, 4.5 həddini keçdi.
- JSON parse və qorunan mənbələrin hash yoxlaması keçdi. Android/build/runtime/Google/Firebase/dil matrisi yoxlanmayıb.

## Exact next step
- Giriş v1 üzrə istifadəçi rəyini tətbiq et və ya yalnız girişin dil/böyük şrift render matrisini ayrıca vahid kimi yoxla. DT01-i açma, DT02/balansı dəyişmə və oyun implementasiyasına başlama. Digər D5 axını yalnız ayrıca tapşırıqla.

# DT09 qərar yeniləməsi — 3 noyabr 2026

## Completed
- Kotlin + Jetpack Compose istifadəçi seçimi kimi decisions, D5 spec, coverage və icra planına yazıldı; yüngül xəritə/at arabası animasiyası qeyd edildi.

## Current state
- Stack və target siyasəti təsdiqlənib; minSdk təxirə salınıb. Oyun kodu və vizual fayllar dəyişdirilməyib.

## Decisions
- targetSdk buraxılış vaxtındakı Google Play tələbinə uyğun olacaq.
- minSdk SDK uyğunluğu və cihaz sınaqlarından sonra seçiləcək; API26 təsdiqlənməyib.
- Room, PGS və digər arxitektura detalları bu qərarla avtomatik təsdiqlənmir; implementasiyaya başlama icazəsi verilmir.

## Remaining work
- SDK uyğunluğu və real cihaz sınaqları ilə minimum Android versiyasını müəyyənləşdirmək.
- Əvvəlki D5 giriş v1 rəyi/dil və cihaz yoxlamaları ayrıca açıq qalır.

## Relevant files
- docs/decisions.json → technologyDecision
- design/states/D5-system-spec.json → DT09
- docs/design-coverage.json → DT09 istinadları
- docs/IMPLEMENTATION_PLAN.az.md → §1, §13–14, §16

## Checks performed
- Üç dəyişdirilmiş JSON parse edildi; DT09 istinadları və köhnə stack/minSdk mətnləri yoxlandı.
- Git metadatası yoxdur; build/runtime testi sənəd dəyişikliyinə tətbiq edilmir.

## Exact next step
- Növbəti istifadəçi tapşırığını gözlə; minSdk-ni özbaşına bağlama və oyun implementasiyasına başlama.

# Aktiv davam nöqtəsi — DT08 qəbul edildi, 3 noyabr 2026

## Completed
- DT09: Kotlin + Compose; target buraxılış vaxtındakı Play tələbinə uyğun, minSdk SDK/cihaz sınaqlarından sonraya saxlanıb.
- DT08 variant 2 qərar mənbəyinə, D5 spec/coverage və icra planına yazıldı.

## Current state
- Ən son cloud save-dən davam geri dönüş yaratmır, mövcud rewind statusunu saxlayır. Köhnə backup və ya konflikt nüsxəsindən bərpa geri dönüşdür; lineage bayrağı silinmir.
- Siyasət təsdiqlənib; oyun kodu, Rules/schema və runtime sınaqları yoxdur.

## Decisions
- Mövcud dörd rekord kateqoriyası qalır. Geri dönüşlü səfər geri dönüşsüz bitir nailiyyətini vermir; əvvəl açılmış nailiyyətlər geri alınmır.
- İlkin online-start və bir completion/lineage qaydaları qalır; restore üçün yeni run ID onları sıfırlamır. DT02 retention dəyişmir.

## Remaining work
- Növbəti təklif: DT07 — kosmetik alışların Play hesabı/Firebase UID bağlanması və hesab silindikdən sonra restore siyasəti; sonra DT06, DT04, DT05.
- DT01 ölçü parametrləri ölçməyədək təklif olaraq qalır; DT02 parametrləri qəbul edilib, tutum/sınaqlar qalır. DT03 implementasiya/yoxlama gözləyir.
- D5 giriş v1 layihəsinin əvvəlki rəy/dil/cihaz yoxlamaları ayrıca açıqdır.

## Relevant files
- docs/decisions.json → backupRestoreDecision, technologyDecision, balanceDecisions
- design/states/D5-system-spec.json → technicalAlignment.unresolved → DT07/DT08
- docs/IMPLEMENTATION_PLAN.az.md → §7.2, §12.2, §16.2
- docs/design-coverage.json → DT08 istinadları

## Checks performed
- Üç JSON parse edildi; struktur müqayisəsi ilə confirmed, balanceDecisions, DT09 və DT01–DT07 dəyişməzliyi yoxlandı.
- Build/runtime/Firestore sınağı aparılmayıb; dəyişiklik yalnız sənəddir.

## Exact next step
- İstifadəçi DT07-ni seçərsə yalnız §12.2 və DT07-ni oxu, Play↔Firebase bağlanma/post-deletion restore seçimlərini təqdim et. Təsdiqsiz siyasət və implementasiya əlavə etmə.

# Aktiv davam nöqtəsi — D5 giriş lokalizasiya/böyük şrift renderi, 3 noyabr 2026

## Completed
- Yalnız əvvəlki 16 giriş vəziyyətinin AZ/TR/RU/EN mətnləri və 1×/1.3×/2× şrift matrisinin statik renderi: 12 profil, 192 vəziyyət kombinasiyası, sürüşmə mövqeləri daxil 535 PNG.
- D5-entry-localization.json tam title/body/note/action/privacy/chrome və dil seçimi mətnlərini saxlayır. TR/RU/EN tərcümələri layihədir, native-speaker təsdiqi deyil.
- Sabit hündürlükdə 428 mətn sahəsi daşması ölçüldü. Mətn blokları ölçülərək axına düzülür, düymələr mətnə görə böyüyür; kiçiltmə/ellipsis yoxdur.
- İlk adaptiv renderdə 2× sol panel 64 vəziyyətdə daşdı; həmin ölçüdə tək sütun və şaquli sürüşmə ilə düzəldildi. Dil seçimləri 1×-dən yuxarı tək sütundur.

## Current state
- Giriş dizaynı v2 statik matris yoxlamasını keçir; oyun/auth implementasiyası yoxdur. AZ v1 renderləri tarix kimi saxlanıb, yeni matris ayrıca qovluqdadır.
- Mətnin öz qutusuna və eninə sığması, blokların toqquşmaması, hər sətrin və bütöv düymənin ən azı bir scroll capture-da görünməsi yoxlanır. Scroll kənarında qismən görünmə normaldır; məzmun itmir.
- P1 sintetik 640×360dp/2x, xətti fontScale simulyasiyasıdır; Android-in faktiki qeyri-xətti şrift miqyası deyil.

## Decisions
- Mövcud rəng/font/type mənbələri qorundu; adaptasiya ölçüləri D5 lokal trial tokenlərinə əlavə edildi. D6 qlobal token null-ları dəyişməyib.
- 2×-də brand + ekran başlığı əvvəl, əsas mətn və əməliyyatlar sonra; dil/tagline aşağıda saxlanır. Şrift kiçildilmir, bütün mətnlər sürüşmə ilə əlçatandır.
- Bu iş DT01-i açmayıb və D5-system-spec/decisions/IMPLEMENTATION_PLAN/balans fayllarına yazmayıb. İlk aralıq hash yoxlaması keçdi; son yoxlamada D5-system-spec, decisions və IMPLEMENTATION_PLAN üçün paralel xarici dəyişiklik aşkarlandı, qorunub və geri yazılmayıb. BALANCE_PROPOSAL və qlobal D6 token hash-ları başlanğıcla eynidir.

## Remaining work
- Faktiki Android nonlinear fontScale, dil dəyişmə, scroll/fokus/TalkBack və başqa viewport/cihaz yoxlamaları; native-speaker mətn rəyi.
- Simvollarda LucidaGrande sistem fallback-i müşahidə olundu; production Android font/fallback ayrıca yoxlanmalıdır. Google rəsmi brend asset-i və privacy URL açıqdır.
- Digər D5 axınları bu işə daxil deyil; yalnız ayrıca istifadəçi tapşırığı ilə başlanmalıdır.

## Relevant files
- design/states/D5-entry-localization.json
- design/states/D5-entry-trial-tokens.json (localizationTrial)
- design/tools/render-d5-entry-localized.swift
- design/states/D5-entry-localized-v2/verification.json
- design/states/D5-entry-localized-v2/initial-overflow-audit.json
- design/states/D5-entry-localized-v2/{AZ,TR,RU,EN}-{1.0,1.3,2.0}x/overview.png və scroll PNG-ləri
- design/states/D5-entry-localized-v2/review/ (tam ölçülü seçilmiş son nümunələr)
- design/states/D5-entry-spec.json (localizationRender)
- docs/design-coverage.json (canonicalEntry.localizationRender)

## Checks performed
- 4 dil × 16 vəziyyət mətn/düymə tamlığı; 192 state-profile geometriyası; bütün 535 manifest PNG-si mövcuddur, allChecksPassed=true, missingGlyphs=0.
- 12 profil overview-si və seçilmiş tam ölçülü böyük şrift nümunələri view_image ilə baxıldı; 2× panel düzəlişindən sonra yenidən render edildi.
- NotoSans binary SHA256 manifestə uyğundur; faktiki NotoSans və simvol fallback adları verification.json-da var.
- ui-craft contrast.py: nav/paper və paper/nav 10.99:1; 4.5 həddini keçir.
- JSON və mənbə hash-ları yoxlandı; son xarici dəyişiklik qeydi verification.json externalSourceChangesObserved bölməsindədir. Android/build/auth/Firebase/TalkBack/runtime testi aparılmayıb.

## Exact next step
- Yeni chatdə bu son qeydi və yalnız D5-entry-spec.json localizationRender / verification.json xülasəsini oxu. Giriş v2 üzrə istifadəçi rəyini tətbiq et; növbəti axını ayrıca tapşırıq olmadan başlama. DT01-i açma, DT02/balansı dəyişmə, oyun implementasiyasına başlama.

# DT07 — ilk Firebase UID bağlanması seçildi, 3 noyabr 2026

## Completed
- İstifadəçi variant 1-i seçdi: pullu daimi kosmetika ilk alış Firebase UID-sinə bağlanır; eyni Play hesabı başqa UID-də avtomatik hüquq açmır.
- Qərar mənbəyi, D5 spec/coverage və plan §12.2 uyğunlaşdırıldı.

## Current state / Decisions
- Eyni UID üçün uyğun Play alışından restore nəzərdə tutulur; cloud cache alış sübutu deyil.
- Hesab silindikdən sonra restore/istisna qaydası seçilməyib; avtomatik köçürmə təsdiqlənməyib.
- Spark/client-only ilə etibarlı eksklüziv UID bağlanması həll edilməyib. Server/reyestr ehtiyacı açıqdır, əlavə server/Blaze icazəsi yoxdur.

## Remaining work
- Post-deletion restore/istisna seçimi; DT04 silmə/retention ilə uyğunlaşdırma; etibarlı icra modeli; SKU/qiymətlər və Billing sınaqları.
- Əvvəlki D5 giriş v2 vizual yoxlamaları ayrıca qüvvədədir; bu işdə vizual dəyişiklik yoxdur.

## Relevant files
- docs/decisions.json → purchaseAccountDecision
- docs/IMPLEMENTATION_PLAN.az.md → §12.2, M5
- design/states/D5-system-spec.json → DT07
- docs/design-coverage.json → DT07

## Checks performed
- Üç JSON parse; confirmed/balance/DT08/DT09 və DT07 xarici DT maddələrinin struktur dəyişməzliyi yoxlandı. Runtime testi yoxdur.

## Exact next step
- İstifadəçidən post-deletion qaydasını dəqiqləşdir: avtomatik restore bağlansın və istisna olmasın, yoxsa ayrıca support istisnası nəzərdə tutulsun? Sonra serversiz sərhəddə icra məhdudiyyətini həll et; özbaşına Blaze/server və ya alış reyestri retention-u əlavə etmə.

# DT07 — post-deletion A seçildi, 3 noyabr 2026

## Completed
- İstifadəçi A seçdi: silinmiş Firebase hesabının alışları yeni UID-yə bərpa/köçürülmür; support istisnası yoxdur.
- decisions purchaseAccountDecision, D5 DT07, coverage və plan §12.2/M5 uyğunlaşdırıldı.

## Current state / Decisions
- İlk UID-yə bağlanma və post-deletion siyasəti qəbul edilib. Məhdudiyyət alışdan əvvəl və silmə təsdiqində bildirilməlidir.
- Bu siyasət Play sifarişinin silinməsi və ya avtomatik refund deyil.

## Remaining work
- Spark/client-only modeldə etibarlı eksklüziv bağlanma; DT04 ilə saxlanılan minimum bağlanma məlumatı/müddəti; SKU/qiymət və Billing sınaqları açıqdır.
- Server/Blaze və qeyri-müəyyən retention icazəsi yoxdur.

## Relevant files
- docs/decisions.json → purchaseAccountDecision
- design/states/D5-system-spec.json → DT07
- docs/design-coverage.json → DT07
- docs/IMPLEMENTATION_PLAN.az.md → §12.2/M5

## Checks performed
- Üç JSON parse edildi; purchaseAccountDecision xarici bütün decisions açarları və DT07 xarici DT maddələri dəyişməzdir. Runtime testi yoxdur.

## Exact next step
- İstifadəçi ilə DT07 icra modelini ayrıca həll et: seçilmiş tək-UID siyasətinin Spark/client-only məhdudiyyətini izah et; server və ya retention dəyişikliyini özbaşına təsdiqləmə.

# Ortaq backend — AppBackend, 3 noyabr 2026

## Completed
- İstifadəçi ayrıca Railway servisi üçün ortaq backend hazırlamağı tapşırdı; sonra aktiv əhatəni Barterune və Wobbrik ilə məhdudlaşdırdı. Qidalanma tətbiqi gələcək adapterdir.
- `/Users/mac/My Workspace/AppBackend` yaradıldı: Go/net-http/PostgreSQL alış nüvəsi, Firebase JWT, Google Play yoxlaması, ilk UID bağlanması, durable hüquqlar və Wobbrik consumable kredit ledger-i, encrypted worker jobs.

## Current state / Decisions
- Lokal kod və native executable hazırdır; ayrı backend üçün yeni tapşırıq əvvəlki serversiz sərhədi bu alış nüvəsi daxilində dəyişir. Firebase Spark saxlanır; Academy və Console dəyişdirilməyib, deploy yoxdur.
- DT07 siyasətləri saxlanır; real provider/mobil/deletion inteqrasiyası tamamlanmayıb. Wobbrik purchased-wallet hələ marketplace/Firestore balansına atomik qoşulmayıb.

## Remaining work
- Real app ID/SKU/credentials, mobil billing, Wobbrik vahid wallet authority, DT04 retention/deletion, consumable refund siyasəti və provider sandbox sınaqları.

## Relevant files
- /Users/mac/My Workspace/AppBackend/README.md
- /Users/mac/My Workspace/AppBackend/docs/context/current-task.md
- /Users/mac/My Workspace/AppBackend/docs/integration.md
- /Users/mac/My Workspace/AppBackend/docs/verification.json

## Checks performed
- go vet; 13 race test, 5 real PostgreSQL testi daxil; 24 paralel eyni alış bir kredit verdi.
- Native/Linux amd64 build; iki proses, 1000 readiness sorğusu; ilkin RSS təxminən 15 MiB/proses, yükdən sonra 19–20 MiB. PostgreSQL RAM-ı daxil deyil; Railway/provider benchmark deyil.
- Live Google Play/Firebase, Docker image və Railway deploy yoxlanmayıb.

## Exact next step
- Backend işi üçün yeni chatdə AppBackend README və onun context qeydini oxu; istifadəçi ilə ilk mobil inteqrasiya və real app inputlarını müəyyənləşdir. Production deploy və Academy dəyişikliyini avtomatik etmə.


# Aktiv davam nöqtəsi — adapter tamamlanması, 3 noyabr 2026

## Completed
- Go billing adapterinə authenticated catalog endpoint, rental/preorder/quantity qoruması və app-lərarası OAuth lock izolyasiyası əlavə edildi.
- Barterune/android-billing: Kotlin core + Play Billing 9.1 Android adapteri, HTTPS client, UID/epoch qoruması və Keystore journal. Rədd edilmiş alışdan sonra entitlement cache reconcile edilir.

## Current state
- Yalnız adapter işi aktivdir. Son istifadəçi göstərişi: real SKU, credential, variable doldurulması və Console/upload işlərini indi davam etdirmə.
- AppBackend config/apps.example.json dəyişməyib; aktiv real config və SKU əlavə edilməyib.
- Əvvəlki hissədə istifadəçinin istəyi ilə Firebase barterune Spark layihəsi və com.aladdin.barterune Android qeydiyyatı yaradılıb. Google-services faylı Barterune/config/firebase daxilində ignored saxlanır. Play upload/SKU yaradılması olmayıb.
- Başlanmış bootstrap source/build .local/deferred-play-bootstrap-a ayrılıb, aktiv Gradle build-də yoxdur. Yerli imzalama hazırlığı .local/signing-dədir; istifadə edilməyib və serverə ötürülməyib.

## Decisions
- Backend URL, Firebase session/project, paket və SKU kataloqu sonradan xaricdən verilir. Client ack/consume etmir; hüquq server snapshot-ından gəlir.
- DT07 ilk UID/no-transfer siyasəti dəyişmir. SDK library minSdk23 texniki lower bound-dur, oyunun minimum versiya qərarı deyil.

## Remaining work
- Yalnız tələb edilən yeni adapter düzəlişi/sınağı; real variable və provider/device yoxlaması istifadəçi ayrıca istəyəndə.
- Host Firebase/lifecycle/backup/deletion inteqrasiyası, Wobbrik wallet/marketplace və refund siyasətləri əvvəlki kimi açıqdır.

## Relevant files
- AppBackend/internal/platform/{google,server,platform_test}.go
- AppBackend/docs/{barterune-billing,adapter-verification}.md və adapter-verification.json
- Barterune/android-billing/README.md
- Barterune/android-billing/core/src/main/kotlin/appbackend/barterune/billing/
- Barterune/android-billing/android/src/main/kotlin/appbackend/barterune/billing/

## Checks performed
- 16 Go race test (5 real lokal PostgreSQL daxil), go vet, native/Linux amd64 build.
- 13 Kotlin test; Android AAR build; lint 0 error, 3 xəbərdarlıq.
- Canlı alış, real credential, cihaz Keystore-u və Railway yoxlanmayıb. Əvvəlki RAM ölçməsi təkrar edilməyib.

## Exact next step
- README və docs/barterune-billing.md-ni oxu. İstifadəçinin son əhatəsini qoru: yalnız adapter; SKU/Console/upload/signing/variable qurulumunu avtomatik davam etdirmə.

# Aktiv davam nöqtəsi — Wobbrik adapteri, 3 noyabr 2026

## Completed
- İstifadəçinin tapşırığı ilə Wobbrik/android-billing yaradıldı: durable kosmetika, consumable paket, pending/retry/restore, server snapshot cache-i və hesab/epoch izolyasiyası.
- AppBackend billing/state və tarixi consumable delivery receipt yoxlaması əlavə edildi. Eyni alış təkrar kreditləşmir; client-də +coins yoxdur.

## Current state
- Kod və kitabxana artefaktları saxlanıb. SKU/credential/Console/deploy işi edilməyib. Barterune mobil adapteri dəyişməyib.

## Decisions
- Sikkə/kosmetika server snapshot-ından gəlir. Qəbz yalnız əvvəlki çatdırılmanı təsdiqləyir, yeni grant/refund qərarı deyil.
- Purchased-wallet ilə gameplay/bazar arasında vahid xərcləmə authority-si ayrıca işdir.

## Remaining work
- Host auth/lifecycle/backup/deletion, wallet/marketplace və sonradan real provider/device testləri.

## Relevant files
- /Users/mac/My Workspace/Wobbrik/android-billing/README.md
- /Users/mac/My Workspace/Wobbrik/docs/context/current-task.md
- /Users/mac/My Workspace/AppBackend/docs/context/current-task.md
- /Users/mac/My Workspace/AppBackend/docs/wobbrik-billing.md
- /Users/mac/My Workspace/AppBackend/docs/wobbrik-adapter-verification.json

## Checks performed
- 21 Go race test (10 real PostgreSQL), go vet, native/Linux amd64 build.
- 19 Kotlin test, Android AAR build/lint: 0 error, 3 xəbərdarlıq.
- 20 paralel HTTP sorğusu bir coin krediti verdi; consumed replay və lost consume reply retry-si kredit yaratmadı. Canlı provider/cihaz/deploy yoxlanmayıb.

## Exact next step
- Növbəti chatdə Wobbrik və AppBackend-in son kontekstini oxu. Yalnız istifadəçinin seçdiyi növbəti işi et; SKU/credential/Console-a avtomatik keçmə.


## Adapter davamı — köhnə sessiyanın rədd cavabı, 3 noyabr 2026

- Completed: Wobbrik BillingCoordinator.drain daxilində PurchaseDenied yoluna stillCurrent(session) əlavə edildi. Hesab və ya eyni UID-nin login epoch-u dəyişəndə gec rədd cavabı köhnə alış növbəsini silmir. İki reqressiya testi əlavə edildi.
- Current state: yalnız Wobbrik core və testləri dəyişdi; AppBackend və Barterune adapter kodu dəyişmədi. SKU/credential/Console/deploy qurulumu edilmədi.
- Decisions: uğurlu və rədd verify cavabları eyni sessiya qorumasından keçir; aktiv sessiyada həqiqi rədd əvvəlki kimi növbədən çıxarılır və snapshot reconcile edilir.
- Remaining work: host auth/lifecycle/backup/deletion; vahid wallet/marketplace və real provider/device sınaqları əvvəlki kimi açıqdır.
- Relevant files: /Users/mac/My Workspace/Wobbrik/android-billing/core/src/main/kotlin/appbackend/wobbrik/billing/BillingCoordinator.kt; /Users/mac/My Workspace/Wobbrik/android-billing/core/src/test/kotlin/appbackend/wobbrik/billing/BillingCoordinatorTest.kt.
- Checks performed: ./gradlew :core:test --no-daemon uğurlu; XML nəticəsi 21 test, 0 failure/error/skipped. Yeni testlər hesab dəyişməsi və eyni UID ilə yenidən girişdən sonra rədd cavabını yoxlayır; birincidə orijinal hesaba qayıdıb retry də yoxlanır. Android AAR/lint/backend testləri təkrar edilmədi; canlı provider/cihaz yoxlanmadı.
- Exact next step: yalnız növbəti kiçik adapter vahidini davam et; real SKU/Console qurulumuna keçmə. Wobbrik/AppBackend-in öz davam qeydləri əvvəlki host/wallet sərhədlərini saxlayır; bu əlavə son core düzəlişini qeyd edir.


## Aktiv davam — Barterune rədd cavabının sessiya qoruması, 3 noyabr 2026

### Completed
- Barterune BillingCoordinator.drain rədd cavabında journal.remove-dan əvvəl stillCurrent(session) çağırır; Wobbrik qoruması ilə uyğunlaşdırıldı.
- Hesab dəyişməsi və eyni UID ilə yeni login epoch-u üçün iki reqressiya testi əlavə edildi; orijinal hesaba qayıdıb retry də yoxlanır.

### Current state
- Bu kiçik vahid tamamlandı. SKU/credential/Console/deploy işi edilmədi; Wobbrik və AppBackend kodu bu vahiddə dəyişmədi.

### Decisions
- Gecikmiş rədd cavabı əvvəlki sessiyanın alışını növbədən silmir. Aktiv sessiyada rəddin təmizlənməsi və hüquq reconcile davranışı saxlanır.

### Remaining work
- Host auth/lifecycle/backup/deletion, vahid wallet/marketplace və real provider/device sınaqları açıqdır.
- Növbəti kiçik namizəd: Barterune activeEntitlements cache oxunarkən logout/epoch dəyişməsinə qarşı Wobbrik activeSnapshot kimi son sessiya yoxlaması etmir; hələ dəyişdirilməyib və reqressiya testi ilə təsdiqlənməyib.

### Relevant files
- android-billing/core/src/main/kotlin/appbackend/barterune/billing/BillingCoordinator.kt
- android-billing/core/src/test/kotlin/appbackend/barterune/billing/BillingCoordinatorTest.kt
- /Users/mac/My Workspace/Wobbrik/android-billing/core/src/main/kotlin/appbackend/wobbrik/billing/BillingCoordinator.kt

### Checks performed
- Əvvəl yeni testlərlə 15 testdən məhz 2-si uğursuz oldu; düzəlişdən sonra :core:test uğurlu, XML: 15 test, 0 failure/error/skipped.
- Android AAR/lint, backend və canlı provider/device sınaqları bu core düzəlişində təkrar edilmədi.

### Exact next step
- Yeni chatdə bu son qeydi və yalnız göstərilən core faylları oxu. Barterune activeEntitlements cache oxuma zamanı sessiya dəyişikliyi namizədini testlə təsdiqlə və bir kiçik vahid kimi düzəlt. SKU/Console qurulumuna keçmə.

## Aktiv davam — Barterune cache oxunuşunun sessiya qoruması, 3 noyabr 2026

### Completed
- BillingCoordinator.activeEntitlements cache oxunduqdan sonra UID və epoch daxil olmaqla sessiyanı yenidən yoxlayır; dəyişibsə boş hüquq dəsti qaytarır.
- Logout, başqa hesaba keçid və eyni UID ilə yeni login epoch-u üçün üç deterministik reqressiya testi əlavə edildi. Journal oxunuş callback-i ilə dəyişmə məhz oxunuş zamanı yaradılır; cache-in qorunduğu və növbəti sabit sessiya oxunuşunun düzgün olduğu da yoxlanır.

### Current state
- Bu kiçik core vahidi tamamlandı. SKU/Console/credential/deploy işi edilmədi; digər layihələr dəyişdirilmədi.

### Decisions
- Sessiya dəyişən oxunuş boş nəticə verir; disk cache-i silinmir. Sabit sessiyanın mövcud cache davranışı saxlanır.

### Remaining work
- Host auth/lifecycle/backup/deletion, vahid wallet/marketplace və real provider/device sınaqları əvvəlki kimi açıqdır.

### Relevant files
- android-billing/core/src/main/kotlin/appbackend/barterune/billing/BillingCoordinator.kt
- android-billing/core/src/test/kotlin/appbackend/barterune/billing/BillingCoordinatorTest.kt

### Checks performed
- Düzəlişdən əvvəl :core:test: 18 testdən məhz yeni 3 test uğursuz oldu. Düzəlişdən sonra :core:test --no-daemon uğurlu, 18 test, 0 failure/error/skipped.
- Android AAR/lint, backend və canlı provider/device yoxlamaları bu core vahidində təkrar edilmədi.

### Exact next step
- Yalnız istifadəçinin seçdiyi növbəti kiçik adapter işini et; SKU/Console qurulumuna avtomatik keçmə.

## Gələcək auth işi üçün tələb — 3 noyabr 2026

- İstifadəçi tapşırığı: oyunda auth hissəsi qurulanda billing adapterinin uyğun inteqrasiyasını da həmin işin tərkibində et; ayrıca unudulmuş iş kimi saxlama.
- Giriş, çıxış, hesab dəyişməsi və eyni UID ilə yenidən giriş hadisələrini adapterin AccountSessions mexanizminə bağla; hər yeni login sessiyasında epoch yenilənsin və köhnə sessiyanın gec cavabları qəbul edilməsin. Token təminatını aktiv Firebase sessiyasına bağla.
- Tətbiqin açılması/arxa plandan qayıtması lifecycle-ını billing bağlantısı və uyğun refresh/retry axını ilə əlaqələndir; gözləyən alışların bərpasını və cache hüquqlarının aktiv hesaba uyğun göstərilməsini yoxla.
- Auth inteqrasiyasının qəbul yoxlamalarına logout, hesab dəyişməsi, eyni UID ilə yeni login, gec verify/cache cavabı və gözləyən alışın retry hallarını daxil et.
- Bu qeyd gələcək inteqrasiya tələbidir; həmin inteqrasiya hazırda edilməyib. SKU/Console/credential qurulumuna ayrıca göstəriş olmadan keçmə.


## Texniki planın billing ilə uyğunlaşdırılması — 3 noyabr 2026

- Completed: IMPLEMENTATION_PLAN.az.md §2.1/3/12/14/15/16 mövcud AppBackend + Android billing adapterinə uyğunlaşdırıldı; client acknowledgment və serversiz IAP tələbləri çıxarıldı.
- Current state: yalnız sənəd düzəlişi; oyun kodu, config, SKU, Console və deploy dəyişməyib.
- Decisions: IAP hüququ server snapshot-ından gəlir, client ack/consume etmir; Spark save/sync, client reklam callback və client-reported rekord modeli saxlanır.
- Remaining work: host auth/lifecycle/backup/deletion, DT04 retention və real provider/device sınaqları açıqdır.
- Relevant files: docs/IMPLEMENTATION_PLAN.az.md; android-billing/README.md; /Users/mac/My Workspace/AppBackend/docs/barterune-billing.md.
- Checks performed: mobil README və backend müqaviləsi ilə mətn tutuşduruldu; köhnə client Billing/serversiz M5 və server verification qadağası üçün hədəfli axtarış aparıldı. Kod dəyişmədiyindən build/test işlədilmədi.
- Exact next step: istifadəçinin seçdiyi növbəti M0 vahidi; real SKU/credential/Console/deploy işinə ayrıca göstərişsiz keçmə.

# Aktiv dizayn davamı — D5 giriş planşet matrisi, 3 noyabr 2026

## Completed
- D5 giriş rendererinə --tablet əlavə edildi; mövcud P3 1280×800dp/2x profili və P1 sütun enləri istifadə olunur. Mətn sahəsi mərkəzləşdirilir; 2× şriftdə tək sütun qalır.
- 4 dil × 3 şrift × 16 vəziyyət: 192 kombinasiya, 207 scroll PNG; coverage-a tabletRender istinadı əlavə edildi.

## Current state
- D1–D6 yekunlaşdırma istifadəçinin aktiv məqsədidir. Bu chat yalnız D5 giriş planşet yoxlamasını tamamladı; ümumi dizayn yekun deyil. Oyun implementasiyası edilməyib.

## Decisions
- Mövcud rəng/font/ölçü namizədləri qorundu; qlobal D6 tokenləri qəbul edilmiş sayılmır. Planşet ölçüsü mövcud render matrisindən gəlir; yeni palitra yoxdur.

## Remaining work
- D1 tam kanonik kompozisiya; D2–D4 balansla uyğun tam ekranlar; D5 cloud konflikt, rekord, deletion və mağaza; D6 vahid komponent/token və cihaz matrisi.
- Real Android nonlinear fontScale, touch/TalkBack, Google brendi/privacy URL və dil redaktəsi açıqdır. DT01 təxirə salınması və qəbul edilmiş qərarlar qorunur.

## Relevant files
- design/tools/render-d5-entry-localized.swift (--tablet)
- design/states/D5-entry-tablet-v1/verification.json
- design/states/D5-entry-spec.json
- design/states/D5-entry-trial-tokens.json
- docs/design-coverage.json
- design/states/D6-canonical-token-proposal.json

## Checks performed
- Swift render uğurlu; 192 kombinasiya/207 PNG, allChecksPassed=true, missingGlyphs=0; manifestdə bütün PNG-lər mövcuddur.
- Mətn qutuları, blokların toqquşmaması, sətir və bütöv düymələrin scroll ilə əlçatanlığı, minimum48dp hədəf geometriyası ölçüldü.
- AZ1× giriş, RU2× overview, TR1.3× overview və EN2× giriş PNG-ləri view_image ilə baxıldı; digər şəkillər ayrıca vizual baxılmayıb. Palitra dəyişmədiyindən əvvəlki10.99:1 düz rəng ölçümü saxlanır, yenidən ölçülməyib.
- Runtime/Android/build/auth/real cihaz testi yoxdur. Qovluq git repository deyil.

## Exact next step
- Yeni chatdə bu son qeydi oxu; D5-system-spec.json C02 cloud konflikt müqaviləsini və son backupRestoreDecision/DT08 qərarını hədəfli yoxla, vahid komponentlərlə cloud konflikt ekranlarını telefon/P3 planşet üçün hazırla və renderə bax. Sonra coverage və bu handoff-u yenilə. Oyun implementasiyasına keçmə; D1–D6 tamamlandı iddiası etmə.


## Hesab silmə istinadı — 3 noyabr 2026
- Completed: istifadəçinin “Arrowz-dakı kimi” qərarı IMPLEMENTATION_PLAN.az.md §6.1-ə yazıldı; Arrowz AccountCoordinator və DeleteAccountViewModel oxundu.
- Current state: sənəd qərarıdır; silmə inteqrasiyası yoxdur.
- Decisions: Arrowz reauth → cloud/əlaqəli məlumatlar → Auth-last və xəta/retry axını əsasdır; billing server baryeri Barterune-a uyğun əlavə olunmalıdır.
- Remaining work: Arrowz lokal gameplay-i guest kimi saxlayır; Barterune məcburi Google/UID təmizliyi ilə fərq açıq qeyd edildi, anonim oyun və IAP transfer icazəsi çıxarılmadı. DT04 retention açıqdır.
- Relevant files: docs/IMPLEMENTATION_PLAN.az.md §6.1; /Users/mac/My Workspace/arrowz/app/src/main/kotlin/com/aladdin/arrowz/account/AccountCoordinator.kt; Arrowz ui/AccountRoutes.kt.
- Checks performed: mənbə kodu oxunub; yalnız sənəd dəyişdiyindən test/build yoxdur.
- Exact next step: silmə implementasiyasından əvvəl lokal gameplay fərqini dəqiqləşdir; mövcud billing/auth qərarlarını qoru.


## Hesab silmə — lokal məlumat və qonaq rejimi qərarı, 3 noyabr 2026
- Completed: IMPLEMENTATION_PLAN.az.md §6.1-də lokal gameplay fərqi istifadəçi cavabı ilə bağlandı.
- Current state: sənəd yeniləndi; implementasiya yoxdur.
- Decisions: hesab silinəndə həmin UID-nin bütün lokal oyun məlumatları, save/backup, cache/outbox və billing journal/cache silinir. Qonaq/anonim rejim yoxdur; silmədən sonra məcburi Google giriş ekranı. Yarımçıq lokal təmizlik növbəti açılışda tamamlanır, köhnə məlumat göstərilmir.
- Remaining work: auth/deletion/billing inteqrasiyası və DT04 retention; lokal məlumatın saxlanması artıq açıq sual deyil.
- Relevant files: docs/IMPLEMENTATION_PLAN.az.md §6.1; android-billing/README.md.
- Checks performed: yeni qərarın §6.1 protokoluna uyğunluğu oxunub yoxlandı; kod dəyişməyib, test/build işlədilməyib.
- Exact next step: gələcək auth/deletion işində bu qərarı tətbiq et; qonaq sessiyası yaratma.

# Aktiv dizayn davamı — D5 cloud konflikt, 3 noyabr 2026

## Completed
- D5-cloud-spec.json: 22 statik vəziyyət; C02 oxuma/müqayisə/lokal-cloud baxışı/iki ayrıca təsdiq/yazılma/uğur/reviziya dəyişikliyi/xəta/naməlum nəticə. Offline, UID/schema/icazə bloklanması, reauth, disk dolması, DT02 dördüncü ehtiyat razılığı və cloud commit-dən sonra lokal yazı bərpası daxildir.
- DT08 fərqi ekranlarda göstərildi: ən son cloud save-dən adi davam statusu qoruyur; konflikt/köhnə ehtiyat bərpası geri dönüşdür. Lineage üzrə status silinmir, ikinci online nəticə hüququ yaranmır.
- Mövcud D5 giriş rendererinin komponentləri/token namizədləri ilə P1 telefon/P3 planşet AZ 1/1.3/2 şrift matrisi render edildi. Coverage cloudConflict əlavəsi ilə bağlandı.

## Current state
- Yalnız dizayn artefaktları və statik Swift renderer; oyun/sync implementasiyasına keçilməyib. D1–D6 bütövlükdə tamamlanmayıb.
- 22 vəziyyət × 3 şrift × 2 cihaz = 132 kombinasiya; 173 telefon + 72 planşet = 245 viewport PNG (overview-lər ayrıca).

## Decisions
- Mənbə D5-system-spec C02 + qəbul edilmiş backupRestoreDecision/DT08 + DT02 retention müqaviləsidir; yeni məhsul qərarı qəbul edilməyib.
- 1/1.3× müqayisə xülasələri yanaşı; 2× alt-alta, ölçülən mətn axını və scroll. D6 qlobal token qəbulu deyil.
- AZ bu vahidin dil əhatəsidir; TR/RU/EN ayrıca tamamlanmalıdır.

## Remaining work
- Cloud TR/RU/EN mətn/render matrisi və dil redaktəsi. Real Android nonlinear fontScale, touch/TalkBack və iki cihaz CAS/receipt/restore/Rules sınaqları yoxdur.
- Digər D5 rekord/deletion/mağaza, D1–D4 kanonik birləşmə və D6 ümumi işləri qalır. Köhnə backup üçün yalnız DT08 baxış sərhədi var; ayrıca S03 tam restore axını deyil.

## Relevant files
- design/states/D5-cloud-spec.json
- design/states/D5-cloud-localization.json
- design/tools/render-d5-cloud.swift
- design/states/D5-cloud-review.json
- design/states/D5-cloud-phone-v1/verification.json
- design/states/D5-cloud-tablet-v1/verification.json
- design/states/D5-entry-trial-tokens.json
- design/states/D5-system-spec.json
- docs/decisions.json (backupRestoreDecision)
- docs/design-coverage.json

## Checks performed
- Hər iki Swift render uğurlu, allChecksPassed=true, missingGlyphs=0. Bütün manifest PNG yolları mövcuddur; JSON parser yoxlaması keçib.
- Bütün kombinasiya üzrə mətn/blok toqquşması, üfüqi/şaquli tutum, hər sətrin və tam düymələrin ən az bir scroll kadrında görünməsi, minimum 48dp hədəf geometriyası ölçüldü.
- ui-craft contrast.py: dəyişməyən nav/paper və paper/nav 10.99:1 (4.5 həddini keçir).
- 7 seçilmiş PNG view_image ilə baxıldı: telefon müqayisə1×, təsdiq2× scroll, latest-confirm1×, unknown1.3×; planşet confirm-cloud1×, müqayisə2× və retention1×. Hamısı ayrıca vizual baxılmayıb; dəqiq siyahı D5-cloud-review.json-dadır.
- Runtime/Android/build/device/Firebase sınağı yoxdur; adapter və oyun kodu dəyişdirilməyib.

## Exact next step
- Yeni chatdə yalnız bu son qeydi, D5-cloud-spec/localization və render-d5-cloud.swift-i oxu; cloud axınının TR/RU/EN mətnlərini əlavə et, mövcud komponentlərlə P1/P3 1/1.3/2 matrisini renderlə və seçilmiş uzun mətn kadrlarına bax. Coverage/handoff-u yenilə. İmplementasiyaya keçmə.

# Aktiv dizayn davamı — D5 cloud TR/RU/EN, 3 noyabr 2026

## Completed
- D5-cloud-localization.json: bütün 22 vəziyyət üçün TR/RU/EN mətnləri və chrome əlavə edildi; AZ saxlanıldı. State/source/target və düymələrin mövcudluğu kanonik spec ilə yoxlandı.
- Renderer mövcud localizationTrial.locales siyahısını oxuyur; komponentlər və tokenlər dəyişməyib. TR 1.3× müqayisə baxışından sonra yeni dillərdə reviziya/nəsil məlumatı ayrı sətirlərə keçirildi və matris yenidən render edildi.
- Coverage-in hər iki cloudConflict qeydi və D5-cloud-review.json yeniləndi.

## Current state
- Yalnız dizayn JSON-ları, statik Swift renderer və PNG artefaktları. Oyun/sync/auth/billing implementasiyası edilməyib.
- AZ/TR/RU/EN × 22 vəziyyət × 3 şrift × 2 cihaz = 528 kombinasiya. Telefon 721, planşet 293: 1014 viewport PNG; overview-lər ayrıca. Cari capture siyahısı verification.json manifestləridir.

## Decisions
- DT08 adi ən son cloud davamı / konflikt və köhnə ehtiyat geri dönüşü, DT02 30 gün / 3 həll edilmiş ehtiyat / dördüncü üçün razılıq, unknown əməliyyat statusu və cloud commit-dən sonrakı lokal recovery fərqləri tərcümələrdə qorundu.
- Məhsul qaydası və qlobal D6 token təsdiqi əlavə edilmədi. Tərcümələr agent redaktəsidir; native dil redaktəsi açıqdır.

## Remaining work
- Real Android nonlinear fontScale, touch/TalkBack və iki cihaz sync/CAS/receipt/Rules sınaqları yoxdur. P1/P3 yalnız sintetik üfüqi ölçülərdir.
- D5 rekord/deletion/mağaza, ayrıca S03 tam restore axını; D1–D4 kanonik birləşmə və D6 ümumi işləri qalır. D1–D6 tamamlanmayıb.

## Relevant files
- design/states/D5-cloud-localization.json
- design/states/D5-cloud-spec.json
- design/tools/render-d5-cloud.swift
- design/states/D5-cloud-review.json
- design/states/D5-cloud-phone-v1/verification.json
- design/states/D5-cloud-tablet-v1/verification.json
- docs/design-coverage.json

## Checks performed
- Hər iki yekun Swift render uğurlu: allChecksPassed=true, missingGlyphs=0; 528 kombinasiya üzrə block overlap, horizontal/vertical fit, bütün sətirlərin scroll ilə görünməsi, bütöv düymə əlçatanlığı və minimum 48dp hədəf geometriyası keçdi. Cari manifestdə bütün PNG yolları mövcuddur.
- Yekun 14 seçilmiş PNG view_image ilə baxıldı; dəqiq siyahı D5-cloud-review.json visualReview-dədir. TR müqayisə, RU uzun təsdiq/retention/recovery, EN latest-confirm/retention/recovery və 2× düymə kadrları daxildir. Hər PNG ayrıca vizual baxılmayıb; scroll kənarında qismən görünən sətirlər qəsdlidir.
- ui-craft contrast.py dəyişməyən nav/paper və paper/nav üçün yenidən işlədi: 10.99:1, 4.5 həddini keçir. JSON strukturu və state/transition/action parity yoxlandı.
- Android/runtime/build/device testi aparılmadı; tətbiq kodu dəyişdirilmədi.

## Exact next step
- Cloud TR/RU/EN statik dizayn vahidi tamamlandı. Növbəti ayrıca dizayn vahidi üçün D5-system-spec.json online rekord vəziyyətlərini və qəbul edilmiş rekord/DT08 qaydalarını hədəfli oxu, ekran/keçid dizaynını hazırla. İmplementasiyaya keçmə; cloud üzrə real cihaz və dil redaktəsi məhdudiyyətlərini qoru.

## Aktiv məqsəd — bütün UI şəkillərinin tamamlanması, 3 noyabr 2026

### Completed
- İstifadəçi ardıcıllığı müəyyənləşdirdi: əvvəl bütün UI şəkilləri, sonra oyun kodu.
- Mövcud üsluba uyğun avtomatik dizayn seçimi səlahiyyəti verdi; variant/seçim soruşulmasın.
- ui-craft SKILL.md oxundu. Bu vahiddə yeni şəkil yaradılmayıb.

### Current state
- D1–D6 yekunlaşmayıb; docs/design-coverage.json draft statusundadır. Mövcud PNG-lər yekun kanonik ekranlar sayılmır.
- Oyun implementasiyasına başlanmasın. Əvvəlki prototip-first təklifi son istifadəçi qərarı ilə əvəz edildi.

### Decisions
- Mövcud seçilmiş 51–85 üslubunu, qəbul edilmiş B01–B10/DT qərarlarını qoru; vizual variantları istifadəçiyə seçdirmə.
- Hesab silinəndə həmin UID-nin bütün lokal oyun məlumatları silinir, qonaq rejimi yoxdur.
- IAP AppBackend/Android adapterinə əsaslanır; cloud save Spark olaraq qalır.

### Remaining work
- Mövcud istinad PNG-ləri/tokenləri yoxla; kanonik vizual sistem və D1–D6 tam ekran/vəziyyət şəkillərini tamamla.
- Telefon/planşet, AZ/TR/RU/EN uzun mətn, kontrast, toxunma ölçüləri və animasiya storyboard-larını yoxla.
- Coverage-ni faktiki render və şəkilə baxış sübutu ilə yenilə; eskizləri avtomatik tamamlanmış sayma.

### Relevant files
- docs/design-coverage.json
- docs/decisions.json
- docs/IMPLEMENTATION_PLAN.az.md
- design/states/D1-board-tokens.json
- design/states/D1-market-trades-v2.png
- design/states/D1-remaining-board-v1.png
- design/states/D2-travel-spec.json
- design/states/D3-debt-spec.json
- design/states/D5-system-spec.json
- /Users/mac/.agents/skills/ui-craft/SKILL.md

### Checks performed
- Bu chatdə billing planı və silmə qərarları sənədləşdirildi; billing core Gradle yoxlaması uğurlu, mövcud 18 test nəticəsi 0 xəta (UP-TO-DATE).
- Bu UI tapşırığı üzrə render/kontrast/cihaz yoxlaması hələ aparılmayıb.

### Exact next step
- Yeni chatdə bu son bölməni və ui-craft skill-ini oxu; coverage/decisions-dan D1 kanonik bazar ekranının tələblərini çıxar, mövcud istinad PNG-lərini vizual aç və token mənbəyini yoxla. Sonra D1-i render edib baxışla tamamla, eyni üslubda D2–D6-ya davam et; seçim soruşma, oyun kodu yazma.

## Aktiv dizayn davamı — D1 inventar ölçü matrisi, 3 noyabr 2026

### Completed
- `design/tools/render-d1-inventory.swift` əlavə edildi: 10 mal, siyahı/kart, AZ/TR/RU/EN × 1/1.3/2 × P1/P2/P3 = 72 statik profil, 1079 viewport PNG.
- Mənbələr: D1-render-fixture/localization, D1-canonical-render-matrix, D1-font-binary-manifest; rənglər D6 təklifindən, məsafə və düymələr mövcud D5 trial tokenlərindən. Yeni palitra/font yoxdur.
- Vizual iterasiya: xidmət girişləri ilk malı gizlədirdi, siyahı sonuna keçirildi; sətirlərdə artıq padding mövcud 4dp addımı ilə azaldıldı. Aktuallıq mənbəyi yalnız v3 verification manifestidir; v1/v2 yarımçıq tarixi renderlərdir.

### Current state
- **D1–D6 tamamlanmayıb.** Bu vahid inventar ölçü və əlçatanlıq sınağıdır; adında canonical olsa da yekun seçilmiş 51–85 piksel art ekranı deyil. Flat rəng kompozisiyası panorama/tekstura/mal ikonlarını əvəz etmir.
- Oyun/auth/sync/billing kodu dəyişdirilməyib. İstifadəçinin məqsədi dəyişmir: bütün UI şəkilləri əvvəl, oyun kodu sonra; seçim soruşma.

### Decisions
- Bölməli C1, ayrı alış/satış preview, yanaşı Al/Sat, açıq partiya seçimi və əvvəlki B01–B10/DT qərarları saxlanır. Bu vahid onların davranışını implementasiya etmir.
- 2× kartlar tək sütuna keçir; mətn kiçilmir; cari HUD scroll sahəsindən ayrı qalır. Yalnız sintetik baza insets; I1/I2 ayrıca yoxlanmayıb.

### Remaining work
- D1 üçün seçilmiş piksel panorama/perqament/dekor/mal ikonlarını inteqrasiya et, planşet mətn enini məhdudlaşdır. Sonra detal/partiyalar/miqdar keypad/iki preview/Al-Sat/limit/uğur/saxlama vəziyyətlərini eyni tam ekran kompozisiyasına birləşdir.
- D2–D4 qəbul edilmiş balansla kanonik tam ekranlar; D5 rekord/deletion/mağaza/S03/təlim; D6 komponent/token və animasiya storyboard-ları.
- Android nonlinear fontScale, real touch/TalkBack, native dil redaktəsi və texniki provider sınaqları statik PNG sübutu deyil.

### Relevant files
- design/tools/render-d1-inventory.swift
- design/states/D1-inventory-canonical-v3/verification.json
- design/states/D1-inventory-canonical-v3/review.json
- design/states/D1-render-fixture.json
- design/states/D1-render-localization.json
- design/states/D1-market-trades-v2.png
- design/states/D1-C1-preview-padding-v10/review.json
- docs/design-coverage.json
- docs/decisions.json

### Checks performed
- Swift yekun render exit0; 72 profil/1079 PNG, allChecksPassed=true, missingGlyphs=0; bütün manifest yolları mövcuddur.
- Bütün profillərdə mətn tutumu, blok overlap, hər sətrin scroll kadrında tam görünməsi, hər idarəetmənin bütöv görünməsi və minimum48dp hədəf geometriyası ölçüldü.
- 6 yekun PNG view_image ilə baxıldı; dəqiq siyahı review.json-dadır. İlk mal, onuncu mal və uzun RU/TR mətnləri seçilmiş kadrlarda görüldü. Bütün PNG-lərə ayrı-ayrı baxılmadı.
- ui-craft contrast.py nav/paper və paper/nav10.99:1, ink/paper7.85:1, hədd4.5 keçdi. Qliflər pin edilmiş NotoSans SHA256 ilə yoxlandı.
- Oyun build/runtime/device testi yoxdur. Tam UI və seçilmiş art üslubu tamamlandı iddiası yoxdur.

### Exact next step
- Yalnız bu bölməni və review.json-u oxu. D1-market-trades-v2.png + seçilmiş51–85 istinadlarını vizual aç; mövcud art mənbələrini hədəfli tap və D1 tam ekranı üçün panorama/perqament/ikon inteqrasiyasını et. V3 ölçü rendererini köməkçi sübut kimi saxla, yekun vizual kimi təqdim etmə. D1 tam kompozisiyadan sonra D2–D6-ya davam et. Oyun koduna başlama, seçim soruşma.


## Aktiv dizayn davamı — D1 piksel kompozisiya sınağı, 4 noyabr 2026

### Completed
- `render-d1-pixel-composition.swift` və lokal `D1-pixel-composition-tokens.json`: seçilmiş51B panoraması, perqament kənarları, taxıl/odun/parça ikonları mövcud istinadlardan statik ekran rendererinə inteqrasiya edildi. Yeni oyun kodu yoxdur.
- 23 bölmə/vəziyyət ×6 təmsilçi profil =138 kombinasiya,933 manifest PNG. Siyahı, mal/partiya, iki preview, miqdar, limit, pending/unknown/refresh və uğur eskizləri eyni art qabığındadır.
- HUD L06/L07/L08/O05/T05 və uğur fixture-lərinə uyğunlaşdırıldı; Al/Sat enablement ayrı bağlandı. 2× panorama yığılır, naviqasiya scroll-a keçir; cari HUD sabitdir. P3 mətn eni1160px lokal tokenlə məhduddur.

### Current state
- **D1 tam və ya kanonik yekun deyil; D2–D6-ya bu vahiddə keçilməyib.** Bu, art inteqrasiya sınağıdır. Çox scroll və planşetdə seyrək kompozisiya hələ cilalanmalıdır.
- Aktuallıq mənbəyi yalnız `D1-pixel-composition-v5/verification.json` capture siyahısıdır. V1–v4 yarımçıqdır; v5-də manifestdən kənar qalmış köhnə PNG-lər də sübut deyil.
- Təmsilçi profillər: P1 AZ1/AZ2/TR1/RU2/EN1; P3 AZ1. Bütün dil/ölçü/inset matrisi deyil.

### Decisions
- 51B seçimi `docs/decisions.json` ilə yoxlandı; qlobal D6 token təsdiqi elan edilmədi. Mövcud paper/nav/ink, pin edilmiş NotoSans, ən az48dp hədəf tələbi saxlandı.
- İstifadəçi seçim soruşulmamasını və bütün şəkillərdən əvvəl oyun koduna başlanmamasını istəyir; qüvvədədir.

### Remaining work
- Ayrı kart grid-i (hazırda list axını təkrar istifadə olunur), qalan7 malın ikonu, daha yığcam telefon və planşet master/detail kompozisiyası.
- Kompakt3-sütun keypad; hazırda rəqəmlər birsütunlu scroll storyboard-dur. Mənfi/kəsr/7rəqəm və digər bütün input vəziyyətləri, satılacaq mal yoxdur, yeni qiymətin məbləğ/təsdiqi, alışdan sonrakı yeni partiya, təkmilləşdirmə/final-level tamamlanmalıdır.
- Tam D1 section/back/focus/persistence, action-specific disabled sahələr, dil/şrift/inset matrisi və Android touch/TalkBack sübutu yoxdur.
- Sonra D2–D4 kanonik kompozisiyaları; D5 rekord/deletion/mağaza/S03/təlim; D6 komponentlər və animasiya storyboard-ları.

### Relevant files
- design/tools/render-d1-pixel-composition.swift
- design/states/D1-pixel-composition-tokens.json
- design/states/D1-pixel-composition-v5/review.json
- design/states/D1-pixel-composition-v5/verification.json
- design/states/D1-render-fixture.json
- design/states/D1-render-localization.json
- docs/design-coverage.json
- docs/decisions.json

### Checks performed
- Yekun Swift render exit0,138 profil/933PNG, allChecksPassed=true, allHorizontalFit=true, missingGlyphs=0; bütün manifest yolları mövcuddur.
- Mətnin üfüqi tutumu, hər sətrin ən az bir scroll kadrında görünməsi, aktiv düymənin bütöv görünməsi və minimum96px/48dp geometriya ölçüldü. Bu renderer ayrıca block-overlap və real klik sahəsi/semantika testi iddiası etmir.
- 12 yekun PNG view_image ilə baxıldı; siyahı review.json-dadır. AZ2 yanaşı Al70/Sat56, RU2 mətn, EN onuncu mal, TR partiya, L06 və satış uğuru daxildir. Hamısına ayrıca baxılmayıb.
- ui-craft contrast.py: nav/paper və paper/nav10.99:1; ink/paper7.85:1;4.5 həddini keçir. Mətn düz səthdədir; art dekorativdir.
- Oyun/build/runtime/device testi aparılmadı; tətbiq kodu dəyişməyib.

### Exact next step
- Bu son bölməni və v5 review.json-u oxu; yalnız renderer/token/fixture/localization fayllərini aç. Əvvəl D1-in ayrıca kart grid-i və kompakt3-sütun keypad-ini eyni51B/perqament qabığında tamamla; sonra review.remaining-dəki çatışmayan D1 vəziyyətlərini bağla. Yekun renderlərə bax, coverage-ni dar sübutla yenilə; D1 tamamlanmadan D2–D6-nı tamamlanmış sayma. Seçim soruşma, oyun koduna başlama.

# Hesab silmə baryeri və oyun izolyasiyası — 4 noyabr 2026

## Completed
- BlockAccount UPDATE-only boşluğu düzəldildi: hesab yoxdursa da (app,uid) üçün blocked=true INSERT/ON CONFLICT ilə davamlı baryer yaranır. İlk sorğu ilə yarış da PostgreSQL account kilidi ilə sıralanır.
- internal/platform/account_deletion_isolation_test.go əlavə edildi: əvvəlcə yox hesabın yenidən yaranması testi FAIL verdi, düzəlişdən sonra PASS.
- Barterune/Wobbrik/thirdgame ayrı-ayrılıqda bloklanır: digər oyunların bütün account/purchase/wallet/ledger/job/domain cədvəl sətirləri əvvəl/sonra eyni qalır. Alış hüquqları qalır, başqa UID bloklanmır, təkrar bloklama və gecikmiş grant rədd edilir. 12 first-request/purchase/deletion yarışı yoxlandı.

## Current state / Decisions
- Bu, mövcud silmə baryerinin düzəlişidir. Tam Firebase/provider/data purge coordinator-u və public deletion endpoint HƏLƏ YOXDUR; tam hesab silmə testi iddiası deyil.
- Retention/alış sahiblik minimum sahələri siyasəti uydurulmadı. Bloklama məlumatları silmir; gələcək coordinator hər addımda app+uid istifadə etməli, yalnız həmin Firebase layihəsinin hesabını silməlidir.

## Remaining work
- App-specific retention/reauth/revocation/Firebase/provider/purge və mobil cache koordinasiyasını ayrıca tamamlamaq; sonra end-to-end silmə testi. Digər oyunların alışlarına toxunmamaq məcburidir.

## Relevant files
- internal/platform/store.go: BlockAccount
- internal/platform/account_deletion_isolation_test.go
- docs/{architecture,integration}.md

## Checks performed
- Real lokal PostgreSQL: tam go test -race -count=1 -v ./... keçdi, skip yoxdur. Yeni 3 əsas test və 3 app subtesti daxil.
- go vet və native build keçdi. Production/provider/deploy dəyişdirilmədi.
- DB postgres://postgres@127.0.0.1:55439/wobbrik_domain_test?sslmode=disable; Go /private/tmp/appbackend-toolchain/go/bin/go; GOCACHE=/private/tmp/appbackend-gocache.

## Exact next step
- Silmə işini davam etdirəndə bu qeydi və docs/integration.md retention sərhədini oxu; tam coordinator-u hazır sayma. Cari düzəliş/test vahidi tamamdır.


## D1 nümunəsinin göstərilməsi — 4 noyabr 2026

### Completed
- İstifadəçinin istəyi ilə D1-pixel-composition-v5/P1-AZ-1.0x-good/scroll-0.png açılıb vizual yoxlandı və chatdə göstərildi.

### Current state
- İstifadəçi bundan sonra qalan bütün dizaynların hazırlanmasını istəyir. Bu icazə qüvvədədir; yenidən seçim/təsdiq soruşma.
- Nümunə ilkin art kompozisiyasıdır; D1–D6 yekun deyil. Bu gedişdə yeni dizayn/render və oyun kodu hazırlanmadı.

### Decisions
- Rəngli piksel panorama, perqament və mal ikonları saxlanır. Bütün dizayn şəkilləri oyun kodundan əvvəl tamamlanmalıdır.

### Remaining work
- Əvvəlki “D1 piksel kompozisiya sınağı” bölməsinin remaining siyahısı və v5 review.json.remaining qüvvədədir: əvvəl D1 grid/keypad/ikon/kompakt kompozisiya və çatışmayan hallar; sonra D2–D6.

### Relevant files
- design/tools/render-d1-pixel-composition.swift
- design/states/D1-pixel-composition-tokens.json
- design/states/D1-pixel-composition-v5/review.json
- design/states/D1-render-fixture.json
- design/states/D1-render-localization.json
- docs/design-coverage.json
- docs/decisions.json

### Checks performed
- ui-craft SKILL.md, v5 review.json və renderer oxundu; yuxarıdakı bir PNG view_image ilə baxıldı. Yeni test/render yoxdur.

### Exact next step
- ui-craft skill-ini oxu, yuxarıdakı scoped mənbələrdən D1 ayrıca kart grid-i və kompakt 3-sütun keypad-i hazırla, render et və şəkillərə bax. Sonra D1 remaining hallarını bağla və D2–D6 üzrə davam et. Oyun koduna başlama; istifadəçidən yenidən seçim soruşma.

## D1 grid və kompakt keypad — 4 noyabr 2026

### Completed
- Statik Swift renderer v6: ayrıca iki sütunlu kart grid-i; 2× şriftdə ad/qiymət göstərən bir sütunlu kartlar. Üç sütun × dörd sıra keypad, bütün 12 düymə üçün ayrıca tam görünən scroll kadrı. Invalid input-da ✓ aktiv deyil.
- Kart/keypad fokus görünüşündə panorama və alt naviqasiya gizlənir; digər D1 ekranlarının art qabığı saxlanıb. Oyun kodu dəyişməyib.

### Current state
- Bu yalnız D1 grid/keypad render vahididir; D1 və D2–D6 tamamlanmayıb. v6 verification.json manifesti əsasdır; yarımçıq renderlərdən qalmış manifestdənkənar PNG-lər nəzərə alınmır.

### Decisions
- Mövcud rəng/ölçü/type tokenləri dəyişməyib. İstifadəçi seçim soruşulmamasını, bütün şəkillərdən əvvəl oyun koduna başlanmamasını tələb edir; qüvvədədir.

### Remaining work
- Fokus görünüşünə açıq Geri affordance-i və keypad yanında miqdar/xəta konteksti; 2× kartların ehtiyat/yük məlumatına detail çıxışı. Tam statik naviqasiya sübutu yoxdur.
- Yeddi mal ikonu və kartlara ikonlar, planşet master/detail, mənfi/kəsr/7-rəqəm və qalan D1 vəziyyətləri. Sonra D2–D6 rəngli ekranlar və animasiya storyboard-ları. Əvvəlki v5 remaining siyahısı da qüvvədədir.

### Relevant files
- design/tools/render-d1-pixel-composition.swift
- design/states/D1-pixel-composition-tokens.json
- design/states/D1-pixel-composition-v6/{review,verification}.json
- design/states/D1-render-{fixture,localization}.json
- docs/design-coverage.json

### Checks performed
- swift -module-cache-path /private/tmp/barterune-swift-module-cache design/tools/render-d1-pixel-composition.swift: exit0, 138 profil/670 manifest PNG, allChecksPassed=true, allHorizontalFit=true, missingGlyphs=0; bütün manifest yolları mövcuddur.
- Son renderdən P1 AZ1 cards/scroll-0, quantity/scroll-2; P1 AZ2 cards/scroll-0; P3 AZ1 cards/scroll-0 açılıb baxıldı. Hamısına baxılmayıb. Kart grid-ində qismən növbəti sətrin görünməsi scroll kəsiyidir.
- ui-craft contrast.py: JSON rənglərindən /private/tmp/d1-contrast.css çıxarılıb ölçüldü: nav/paper10.99, paper/nav10.99, ink/paper7.85; 4.5 həddindən keçir.
- Android/runtime/touch/TalkBack/build yoxlanmayıb. Bu qovluqda git status mümkün olmadı: git repository deyil.

### Exact next step
- v6 review.json və renderer/tokenlərdən başla. Əvvəl grid/keypad üçün Geri və miqdar/xəta kontekstini tamamla; yeddi ikon və çatışmayan D1 vəziyyətlərini bağla, renderləri aç. D1-dən sonra D2–D6-nı hazırla. Seçim soruşma və bütün şəkillər hazır olmadan oyun koduna başlama.


## D1 naviqasiya, input və əməliyyat render vahidi — 4 noyabr 2026

### Completed
- Renderer v7: hər bölməyə açıq Geri sətri; keypad scroll zamanı görünən miqdar/xəta zolağı; mənfi, kəsr və 7-rəqəm invalid halları. Invalid ✓ aktiv deyil.
- Satılacaq mal yoxdur; yeni qiymət 35→40, cəm70→80 və ayrıca təsdiq; alışdan yaranan yeni partiya2/keyfiyyət100/maya35. Alış HUD430/yük20-dir. Bunlar statik fixture-lərdir; yeni qiymət40 balans qaydası dəyişikliyi deyil.
- 2× kartlarda yığcam detal oxu; stock/owned/load yalnız mövcud parça detail fixture-ində göstərilir. Bütün malların detail parity-si hələ yoxdur.

### Current state
- D1 tamamlanmayıb; D2–D6-ya yeni rəngli render əlavə edilmədi. Oyun kodu dəyişməyib.
- Yalnız v7 verification.json capture siyahısı əsasdır; əvvəlki renderdən qalan equipment-final və digər manifestdənkənar şəkillər sübut deyil.

### Decisions
- Mövcud palitra/geometriya/type tokenləri saxlandı. Seçim soruşma; bütün dizayn şəkillərindən əvvəl oyun koduna başlama.
- navigation.json statik keçid müqaviləsidir; runtime/fokus/persistence sübutu deyil.

### Remaining work
- Yeddi mal ikonu və kart ikonları; bütün malların detal renderləri. Geri scroll sətridir, keypad bütöv panel kimi hələ scroll-suz görünmür.
- Planşet master/detail; equipment upgrade/final-level və v5 state parity; tam dil/font/inset matrisi.
- Sonra D2–D6 kanonik rəngli dizaynlar və animasiya storyboard-ları; texniki/provider açıq sualları həll edilmiş sayma.

### Relevant files
- design/tools/render-d1-pixel-composition.swift
- design/states/D1-pixel-composition-tokens.json
- design/states/D1-pixel-composition-v7/{review,verification,navigation}.json
- design/states/D1-render-{fixture,localization}.json
- docs/design-coverage.json
- Sonrakı qruplar: design/states/D2-travel-spec.json, D3-debt-spec.json, D4-news-events-spec.json, D5-system-spec.json, D6-adaptation-spec.json

### Checks performed
- Swift exit0;174 profil/1010 manifestPNG; allChecksPassed=true, allHorizontalFit=true, missingGlyphs=0; bütün manifest yolları mövcuddur.
- Altı seçilmiş son PNG açıldı; dəqiq siyahı v7 review.json-dadır. Hamısına ayrı-ayrı baxılmayıb. Scroll kəsikləri var.
- ui-craft contrast.py nav/paper10.99, ink/paper7.85 keçdi. Palette dəyişməyib.
- Android/runtime/touch/TalkBack/build testi yoxdur. İnteraktiv naviqasiya yoxlanmayıb.

### Exact next step
- Bu son bölməni və v7 review.json-u oxu. D1 üçün yeddi ikon/kart ikonları və bütün malların detail renderlərini mövcud art/token mənbələrindən tamamla; sonra kompakt keypad və P3 master/detail-i cilala. D1 qalanlarını bağladıqdan sonra D2→D3→D4→D5→D6 rəngli tam ekranları və storyboard-ları hazırla, renderləri aç. Seçim soruşma, oyun koduna başlama.


## D1–D6 statik dizayn paketi v8 — 4 noyabr 2026

### Completed
- Son D1 v7 qeydi və review oxundu. Mövcud palitra, geometriya, pinned NotoSans və 51B panorama saxlandı.
- Yeni ayrıca renderer və fixture: 306 manifest render (D1 54 / D2 38 / D3 24 / D4 26 / D5 61 / D6 103).
- D1: on mal detalı, yeddi sadə piksel silueti/kart ikonları, bütöv 12-key keypad, P3 master/detail, B05 upgrade/final səviyyələr. D2–D5 state ekranları, ayrıca route/service/debt/news/slots/deletion/final kompozisiyaları; 7 təlim addımı.
- D6: komponent vəziyyətləri, normal/reduced storyboard-lar, dörd dil × 1/1.3/2x × 3 inset üçün shared-shell stress kadrları. Oyun kodu dəyişməyib.

### Current state
- Paket statik dizayn keçididir; bütün dizaynlar yekun deyil. Review.remaining əsasdır. Sadə siluetlər üç köhnə rəngli ikonun art səviyyəsinə çatmır; generic panel/scroll capture-ları son interaktiv kompozisiya deyil.
- Yalnız design/states/D1-D6-design-v8/verification.json yolları aktual sübutdur; köhnə/artıq PNG-ləri sayma. Əvvəlki v7 sübutu öz scope-u daxilində qalır.

### Decisions
- Seçim/təsdiq soruşma; bütün şəkillər tamamlanmadan oyun koduna başlama. Texniki/provider açıq sualları həll edilmiş sayma.
- B05 çanta60/+10, araba140/+20, örtük70/50% istifadə edildi. Route müqayisəsi Sünbülova→Daşqala, məsafə1-dir. D1 köhnə bazar rəqəmləri sintetik fixture olaraq qalır.

### Remaining work
- Yeddi silueti mövcud rəngli artla eyni keyfiyyətə gətirmək; iki xidmət personajı və ayrıca yol/hadisə səhnələri. Generic state panellərini qruplara uyğun kanonik kompozisiyalara birləşdirmək.
- Tam D1–D5 AZ/TR/RU/EN × P1/P2/P3 × font/inset matrisi yoxdur; D6 yalnız shared-shell stress-dir. Bütün renderlər ayrıca baxılmayıb.
- Android/runtime/touch/TalkBack, real fokus/scroll/persistence sübutu yoxdur; oyun koduna icazə kimi yozma.

### Relevant files
- design/tools/render-design-suite.swift
- design/tools/render-suite-contact-sheets.swift
- design/states/D1-D6-screen-fixtures.json
- design/states/D1-D6-design-v8/{review,verification}.json
- design/states/D1-pixel-composition-tokens.json
- design/states/D{2-travel,3-debt,4-news-events,5-system,6-adaptation}-spec.json
- docs/design-coverage.json

### Checks performed
- Swift final exit0:306 capture, missingGlyphs0, renderer allFit=true; bütün manifest faylları mövcuddur.
- Generic panel mətnləri ölçülür; xüsusi layout-ların allFit-i ayrıca overlap testi deyil. Bu məhdudiyyət review-da açıqdır.
- 23 seçilmiş PNG və beş contact sheet baxıldı (dəqiq siyahı review-da). İtən düymə affordance-i, sığmayan RU2x, route/slot parçalanması və uzun sətir üst-üstə düşməsi aşkar edilib düzəldildi.
- ui-craft contrast: nav/paper10.99, ink/paper7.85, paper/nav10.99 keçir. Fokus paper/nav-dır. Runtime/build yoxdur.

### Exact next step
- Bu bölmə və v8 review.remaining-dən başla. Əvvəl yeddi ikonun rəngli art parity-sini və D2 xidmət/yol/hadisə səhnələrini tamamla; sonra generic D2–D5 panellərini kanonik tam ekranlarda birləşdir, tam lokalizasiya matrisini render et və bax. Seçim soruşma, oyun koduna başlama. V8-i bütün dizaynların yekunu adlandırma.

## D1–D6 v9 art inteqrasiyası — 4 noyabr 2026

### Completed
- Son bölmə və v8 review oxundu. Yeni rəngli atlas: yeddi mal, bələdçi/mühafizəçi portretləri, yol/quldur/fırtına/təmir səhnələri.
- Ayrı v9 renderer: ikonlar kart/detail-də, D2 state art sütununda yeni səhnə/portret; ayrıca services-art və road-events-art baxış ekranları. Xidmət caption boşluğu renderdən sonra düzəldildi.

### Current state
- 308 statik render. Bütün remaining tamamlanmayıb; v9 review.remaining əsasdır. Oyun kodu dəyişməyib.
- Atlasın perqament fonu ikonlarda görünür, köhnə ikonlarla piksel sıxlığı tam eyni deyil. Art review ekranları tam xidmət/hadisə interaksiyası deyil.

### Decisions
- Mövcud UI tokenləri/palitra saxlandı. Yeni bitmap art ayrıca versiyadır. Seçim soruşma və oyun koduna başlama.

### Remaining work
- Atlas fon/piksel sıxlığı normalizasiyası; kanonik xidmət ekranına portretləri və hadisələrin hər vəziyyətinə düzgün səhnələri bağlamaq.
- D2–D5 generic panelləri kanonik tam ekranlara birləşdirmək; D1–D5 AZ/TR/RU/EN × P1/P2/P3 × font/inset matrisini hazırlamaq. D6 shell matrisi əvəz deyil.
- Bütün capture-ların vizual baxışı. Provider/policy sualları və runtime/fokus/scroll/persistence/touch/TalkBack açıqdır, statik dizayn işi ilə bağlanmır.

### Relevant files
- design/tools/render-design-suite-v9.swift
- design/assets/barterune-art-v9.png
- design/states/D1-D6-design-v9/{review,verification}.json
- design/states/D1-D6-screen-fixtures.json
- design/states/D1-pixel-composition-tokens.json
- D2–D6 spec-lər əvvəlki bölmədədir.

### Checks performed
- Swift exit0: captures308, missing0, allFit=true; manifestdə bütün yollar mövcuddur. allFit xüsusi layout-larda müstəqil overlap testi deyil.
- V9 D1-cards-1/2/3, D2-services-art, D2-road-events-art açılıb baxıldı. Services və events son düzəlişdən sonra yenidən açıldı. Digər v9 capture-lara ayrıca baxılmayıb.
- UI palitrası dəyişməyib; v8 kontrast nəticələri dəyişməyən mətn səthləri üçün qalır. Runtime/device/build yoxlanmayıb.

### Exact next step
- Bu bölmə və v9 review.remaining oxu. Əvvəl art fon/piksel normalizasiyası və xidmət/hadisə kanonik inteqrasiyasını bitir; sonra D2–D5 generic kompozisiyalar və tam lokalizasiya matrisi. Render et və şəkilləri aç. Seçim soruşma, oyun koduna başlama.


## D2 kanonik art bağlanması v10 — 4 noyabr 2026

### Completed
- V9 son handoff və review oxundu; tokenlər saxlandı. Xidmətlərin kanonik iki kartına portretlər əlavə edildi.
- Səhnə seçimi başlıqdan deyil, stabil state ID-dən edilir; naməlum hadisə neytral panorama alır. T01/T02/A01 yol səhnəsidir. S01/S03/S04 iki portret göstərir.
- T05 üçün quldur/fırtına/təmir art variantları; rəqəmli nəticələr hələ yoxdur. Səhnə panel hündürlüyünə sığdırıldı.

### Current state
- V10: 311 statik capture; tam remaining tamamlanmayıb. Oyun kodu dəyişməyib. V10 review/verification əsasdır.

### Decisions
- Seçim soruşma, oyun koduna başlama. Hadisə növü verilməyibsə fırtına/quldur uydurma.
- Palitra dəyişməyib; art normalizasiyası edilməyib.

### Remaining work
- V10 review.remaining qüvvədədir: atlas fon/piksel sıxlığı; xidmət seçim/müddət/aktiv əhatə/təsdiq/xəta variantları; hadisələrin dəqiq nəticələri.
- D2–D5 generic panellərin kanonik inteqrasiyası; D1–D5 tam AZ/TR/RU/EN × P1/P2/P3 × font/inset matrisi; bütün capture-lara baxış.
- Provider/policy və runtime/fokus/scroll/persistence/touch/TalkBack açıq qalır.

### Relevant files
- design/tools/render-design-suite-v10.swift
- design/states/D1-D6-design-v10/{review,verification}.json
- design/states/D1-D6-screen-fixtures.json
- design/states/D2-travel-spec.json
- design/assets/barterune-art-v9.png
- design/states/D1-pixel-composition-tokens.json

### Checks performed
- Swift exit0: captures311, missing0, allFit=true; manifest yolları yoxlanıb. allFit müstəqil overlap testi deyil.
- Son renderdən services-canonical, T01-1, T03-1 və üç T05 canonical art variantı açılıb baxıldı. İlk renderdə səhnə daşması tapılıb düzəldildi, son render yenidən açıldı. Hamısına baxılmayıb.
- Palitra dəyişməyib, əvvəlki kontrast ölçüləri yalnız dəyişməyən səthlərə aiddir. Runtime/build yoxdur.

### Exact next step
- Bu son bölmə və v10 review.remaining-dən davam et. Əvvəl atlas normalizasiyası və D2 xidmət seçim/təsdiq variantlarını bitir; sonra hadisə nəticələrinin fixture parity-si, D2–D5 kanonik ekranlar və tam lokalizasiya matrisi. Renderləri aç. Seçim soruşma, oyun koduna başlama.

## D2 xidmət vəziyyətləri v11 — 4 noyabr 2026

### Completed
- Son v10 bölməsi və review.remaining oxundu; oyun koduna toxunulmadı.
- Ayrı statik renderer və fixture: 14 xidmət vəziyyəti + bələdçi/mühafizəçi üçün 2 müqavilə seçicisi, cəmi 16 PNG. Bir-yol, 4-gün, iki xidmət, təsdiq, aktiv/qismən əhatə, pul çatışmazlığı, pending/failed/unknown, bitmə/yenilənmə/imtina nümunələri.
- B05 qiymətləri və d+4 başlanğıcında bitmə qaydası normativ mənbə ilə yoxlandı. Mövcud rəng/geometriya/type tokenləri saxlandı.

### Current state
- Yalnız AZ / P1 / 1x xidmət render vahidi tamamlanıb. Bütün v10 remaining tamamlanmayıb. V11 review.remaining dəqiq yeni siyahıdır; v10 geniş scope üçün qüvvədədir.
- 16 yeni PNG-nin hamısı ayrıca açılıb baxıldı. Yeni navigation.json statik keçid müqaviləsidir, işlək naviqasiya deyil.

### Decisions
- Seçim soruşma; oyun koduna başlama. Sintetik gün/pul nümunələri balans dəyişikliyi deyil.
- V9 atlası dəyişməyib; fon/piksel sıxlığı normallaşdırılmış sayılmır. Provider/policy və runtime sualları açıqdır.

### Remaining work
- Xidmət seçicilərini iki kartlı overview-a açıq seçim hədəfləri ilə inteqrasiya et; aktiv müqavilə üçün bağlı seçici renderi; hər iki 4-gün və qarışıq seçimlər; uğurlu ödəniş; D3 mal/borc yenilənmə və geri dönüş kompozisiyaları. Qismən əhatə üçün rəqəmli orta risk fixture-i yoxdur.
- Atlas normalizasiyası; hadisə nəticələrinin dəqiq rəqəmləri; D2–D5 kanonik ekranlar; tam AZ/TR/RU/EN × P1/P2/P3 × font/inset matrisi; köhnə paketin bütün capture-larına baxış.
- Runtime/fokus/scroll/persistence/touch/TalkBack və D5 provider/policy statik dizaynla bağlanmır.

### Relevant files
- design/tools/render-d2-services-v11.swift
- design/states/D2-services-v11-fixtures.json
- design/states/D2-services-v11/{review,verification,navigation}.json
- design/tools/render-design-suite-v10.swift
- design/states/D1-D6-design-v10/review.json
- design/states/D2-travel-spec.json
- docs/decisions.json#/balanceDecisions/confirmed/B05
- design/states/D1-pixel-composition-tokens.json
- docs/design-coverage.json

### Checks performed
- Swift exit0: captures16, missing0, allFit=true; bütün manifest yolları mövcuddur.
- İlk renderdə 14 panelin son sətri daşırdı; token əsaslı boşluq düzəlişindən sonra 14-ü yenidən render/açılışla yoxlandı. Sonra 2 seçici renderi də ayrıca açıldı.
- Panel contentBottom/availableBottom və action label hündürlükləri ölçülür; müstəqil pixel overlap və runtime testi deyil.
- ui-craft contrast.py: ink/paper7.85, nav/paper10.99, paper/nav10.99; 4.5 həddindən keçir. Atlas/dekor bu ölçüyə daxil deyil.

### Exact next step
- Bu son bölmə və D2-services-v11/review.json-u oxu. Əvvəl xidmət overview seçim hədəfləri və aktiv/paid-success/D3 geri dönüş renderlərini bağla, şəkilləri aç. Sonra v10 geniş remaining-dən art normalizasiyası və hadisə rəqəmlərinə keç. Seçim soruşma, oyun koduna başlama.

## D2 xidmət axını v12 — 4 noyabr 2026

### Completed
- V11 son handoff/review oxundu. 17 əlavə statik AZ/P1/1x render: overview seçim hədəfləri, aktiv overview və iki bağlı picker, hər iki 4-gün/iki qarışıq seçim və təsdiqləri, paid-success, D3 mal/borc baxışları və uğurlu/imtina geri dönüşləri.
- Hamısı ayrıca açılıb vizual yoxlandı; ilk kart düyməsi/mətn örtüşməsi düzəldildi və son renderlər açıldı.

### Current state
- V11 + v12 xidmət statik axını bir-birini tamamlayır. Oyun kodu dəyişməyib. Navigation yalnız statik müqavilədir.

### Decisions
- Mövcud palitra/geometriya/type tokenləri saxlandı. B05/B06 sintetik nümunələr: mal 2×8=16, haqq12, artıq4; borc əsas8+haqq1=9, gün11 tarix. Balans dəyişikliyi deyil.
- Seçim soruşma; oyun koduna başlama.

### Remaining work
- Kanonik qismən əhatə risk-orta fixture-i; atlas normalizasiyası; hadisələrin dəqiq rəqəmləri; D2–D5 kanonik inteqrasiya və tam dil/cihaz/font/inset matrisi.
- V10 köhnə capture-lara tam baxış; runtime/fokus/scroll/persistence/touch/TalkBack və provider/policy açıqdır.

### Relevant files
- design/tools/render-d2-services-v12.swift
- design/states/D2-services-v12-fixtures.json
- design/states/D2-services-v12/{review,verification,navigation}.json və 17 PNG
- design/states/D2-services-v11/{review,navigation}.json
- design/states/D1-D6-design-v10/review.json

### Checks performed
- swift -module-cache-path /tmp/barterune-swift-cache design/tools/render-d2-services-v12.swift: captures17, missing0, allFit=true; bütün capture yolları mövcuddur.
- 17 PNG ayrıca açıldı; pane/primary label ölçüləri müstəqil pixel overlap və runtime testi deyil. Palitra dəyişməyib, v11 kontrast nəticələrinin scope-u saxlanır.

### Exact next step
- Bu bölmə və v12 review.remaining oxu. Növbəti ayrıca vahid: atlas fon/piksel sıxlığı normalizasiyası; mövcud art mənbələrini və v10 rendererin artCell/crop hissələrini yoxla, normallaşdırılmış ayrıca versiya yarat, render et və aç. Seçim soruşma; oyun koduna başlama.


## Atlas normalizasiyası v13 — 4 noyabr 2026

### Completed
- Son v12 handoff və review oxundu; v10 artCell/crop yoxlandı.
- V9 əsasında ayrıca imagegen cleanup mənbəyi və deterministik v13 atlas exportu yaradıldı: 4×4, 1024×1024, 128 logical pixel/cell → 2x nearest neighbor.
- İkon/portret fonları şəffaf, 7/10/11 hüceyrələri tam boş; 12–15 səhnələri qeyri-şəffaf. İndekslər qorundu.
- 4 statik proof renderi yaradıldı və hamısı açılıb baxıldı; ilk overview mətn/sıra örtüşməsi düzəldilib yenidən yoxlandı.

### Current state
- V13 ayrıca asset/proof vahididir; v10/v11/v12 avtomatik miqrasiya edilməyib. Oyun kodu dəyişməyib.

### Decisions
- Mövcud paper/nav/ink tokenləri saxlandı. Art cleanup generativdir, v9 ilə piksel-identik deyil.
- Texniki piksel şəbəkəsi vahiddir; artın tekstura/detail sıxlığı vizual mühakimədir.
- Köhnə panorama/frame və grain/wood/cloth crop-ları v9 atlas scope-undan kənardır və dəyişməyib.
- Seçim soruşma; oyun koduna başlama.

### Remaining work
- Kanonik qismən əhatə risk-orta fixture-i; hadisələrin dəqiq rəqəmləri; D2–D5 kanonik inteqrasiya və tam dil/cihaz/font/inset matrisi.
- V13 artın kanonik statik rendererə miqrasiyası ayrıca işdir. Runtime/accessibility və provider/policy açıqdır.

### Relevant files
- design/assets/barterune-art-v13{,-source}.png
- design/tools/normalize-atlas-v13.swift
- design/tools/render-atlas-v13.swift
- design/states/atlas-normalized-v13/{review,verification}.json və 4 PNG
- design/tools/render-design-suite-v10.swift
- design/states/D2-services-v12/review.json

### Checks performed
- Hər iki Swift script exit0; renderer missingGlyphs=0.
- 16 hüceyrə üzrə binary alpha; boş 7/10/11 tam şəffaf; 12–15 tam opaque assert-ləri keçdi.
- Son 4 render ayrıca açıldı; kontrast ink/paper7.85, nav/paper və paper/nav10.99.
- Runtime/build və müstəqil overlap testi yoxdur.

### Exact next step
- V13 review-ni oxu. Növbəti istifadəçi tapşırığına görə v13 atlasını ayrıca kanonik statik rendererə inteqrasiya et və ya qismən əhatə risk-orta fixture-ini bağla. Renderləri aç; seçim soruşma; oyun koduna başlama.


## V13 atlasının kanonik statik inteqrasiyası v14 — 4 noyabr 2026

### Completed
- V10 kompozisiyalarından ayrıca v14 kanonik statik renderer yaradıldı; bütün atlas draw-ları v13 assetinə keçirildi.
- Asset hash/ölçü/hüceyrə və boş indeks qoruması əlavə edildi. Mövcud tokenlər saxlandı.
- İlk vizual baxışda shared D1/D3/D4 preview ikonunun çərçivəyə toxunması aşkarlandı; qalan panel sahəsinə sığdırıldı, alt sərhəd ölçümü əlavə edildi və yenidən render olundu.

### Current state
- 311 capture; missing0; allFit=true. V10 screen manifest parity keçdi; 49 PNG dəyişib (atlas və preview sizing), 262 bayt-identikdir.
- 12 seçilmiş render ayrıca açıldı; bütün 49 dəyişmiş render 5 contact sheet-də açılıb baxıldı. Hamısına native ölçüdə fərdi baxış deyil.
- Oyun kodu dəyişməyib. V11/V12 xidmət əlavələri ayrıca qalır; v14 onların kanonik inteqrasiyası deyil.

### Decisions
- V14 əsas renderer design/tools/render-design-suite-v14.swift-dir; V10 tarixi baseline saxlanır.
- Atlas13 və indekslər qorundu; panorama/frame/grain/wood/cloth artı dəyişməyib. Legacy sıxlıq fərqi atlas13 scope-undan kənardır.
- Seçim soruşma; oyun koduna başlama.

### Remaining work
- V11/V12 xidmət axınının kanonik inteqrasiyası; qismən əhatə risk-orta fixture-i; hadisələrin dəqiq rəqəmləri.
- Tam dil/cihaz/font/inset matrisi və köhnə capture-lara fərdi baxış; runtime/accessibility/provider/policy açıqdır.

### Relevant files
- design/tools/render-design-suite-v14.swift
- design/tools/render-v14-atlas-contact.swift
- design/states/D1-D6-design-v14/{review,verification,atlas-integration-diff}.json və PNG-lər
- design/assets/barterune-art-v13.png
- design/states/atlas-normalized-v13/review.json
- design/states/D2-services-v12/{review,navigation}.json

### Checks performed
- Son Swift render exit0: captures311, missing0, allFit=true; bütün manifest yolları mövcuddur.
- Manifest screen parity, asset SHA256/ölçü/indeks qoruması, dəyişən/dəyişməyən PNG müqayisəsi keçdi.
- Son preview düzəlişi ayrıca və contact sheet-lərdə vizual yoxlandı. Palitra dəyişməyib; əvvəlki opaque kontrast scope-u saxlandı.
- allFit müstəqil overlap testi deyil. Runtime/build yoxdur.

### Exact next step
- Bu son bölmə və v14 review.remaining oxu. İstifadəçinin növbəti istəyi üzrə xidmət axınının kanonik inteqrasiyasına və ya risk-orta fixture-inə ayrıca vahid kimi keç. V14 əsasdır; render et və aç. Seçim soruşma; oyun koduna başlama.


## V11/V12 xidmət axınının kanonik inteqrasiyası v15 — 4 noyabr 2026

### Completed
- V14 əsasından V15 vahid statik renderer yaradıldı; V11/V12 xidmət variantları, aktiv/adi picker-lər, təsdiqlər, ödəniş və D3 dönüşləri paylaşılan funksiyalara inteqrasiya edildi.
- Köhnə kanonik xidmət icmalı V12 seçim target-ləri ilə əvəzləndi; V11 empty/active icmalları V12 ilə supersede edildi. D3 goods/debt review art bağlaması düzəldildi.
- 341 capture, xidmət üzrə 31; 310 V14 capture bayt-identikdir. 30 əlavə capture və 1 əvəzlənmiş icmal.

### Current state
- V15 əsas statik rendererdir; oyun kodu dəyişməyib. V13 atlas hash/ölçü/indeks qoruması saxlanıb.
- Statik navigation.json keçidləri eyni paketdəki mövcud capture-lara bağlanır; runtime naviqasiya deyil.

### Decisions
- Mövcud palitra/type/geometriya tokenləri və sintetik B05/B06 rəqəmləri saxlanır.
- Term/mixed təsdiqləri var; pending/success rəqəmli nümunələri yalnız road/road üçündür. Digər mode-ların nəticəsi kimi təqdim edilmir.
- Seçim soruşma; oyun koduna başlama.

### Remaining work
- Kanonik qismən əhatə risk-orta fixture-i; hadisələrin dəqiq rəqəmləri; mode-specific ödəniş nəticə capture-ları.
- Tam dil/cihaz/font/inset matrisi; köhnə capture-lara fərdi baxış; runtime/accessibility/provider/policy yoxlamaları.

### Relevant files
- design/tools/render-design-suite-v15.swift
- design/tools/render-v15-service-contact.swift
- design/states/D1-D6-design-v15/{review,verification,navigation,service-integration-diff}.json
- design/states/D2-services-v11-fixtures.json və D2-services-v12-fixtures.json

### Checks performed
- Son Swift render exit0: captures341, missing0, allFit=true; unikal manifest yolları mövcuddur.
- Bütün statik keçid target-ləri mövcuddur; V14 baseline müqayisəsi keçdi.
- 31 xidmət capture-ı 3 contact sheet-də, 5 seçilmiş capture ayrıca açılıb baxıldı. D3 art düzəlişindən sonra təsirlənən 2 native capture və contact sheet yenidən açıldı.
- Palitra dəyişməyib: əvvəlki opaque kontrast scope-u saxlanır. allFit müstəqil overlap/runtime testi deyil.

### Exact next step
- Bu bölmə və V15 review.remaining oxu; növbəti ayrıca vahid kimi kanonik qismən əhatə risk-orta fixture-ini bağla. V15 əsasdır; render et və aç. Seçim soruşma; oyun koduna başlama.


## Kanonik qismən əhatə risk ortalaması — V15, 4 noyabr 2026

### Completed
- Qəbul edilmiş decisions.json B04/B05 üzrə strukturlaşdırılmış D2-partial-risk-v15-fixture.json yaradıldı və V15-in partial capture-ına inteqrasiya edildi.
- Karvan Sünbülova→Yaşıldərə, məsafə2, gün5→9: bərabər sərhədlər6/7/8/9. Gün4 alınmış bələdçi gün8 başlanğıcında riskdən əvvəl bitir; bir-yol mühafizəçisi gəliş sərhədini də əhatə edir.
- Gecikmə (3+3+6+6)/4=4,5%; quldur4%, yük6%; təhlükə14,5%, xəbər15%, hadisəsiz70,5%. Yenilənmə daxil deyil.

### Current state
- V15 render: captures341, missing0, allFit=true; yalnız D2-services-partial.png dəyişib, digər340 capture bayt-identikdir.
- Partial native render və yenilənmiş contact-services-1.png açılıb vizual yoxlandı. Oyun kodu dəyişməyib.

### Decisions
- Risk bütün səfər üçündür, gündəlik müstəqil roll deyil. Bir sərhəd bərabər ehtimalla seçilib saxlanır; azalan ehtimal hadisəsiz hissəyə keçir.
- Əvvəlki partial-dəki gün6→9 ilə 6/7 əhatə mətninin uyğunsuzluğu kanonik gün5→9 fixture-i ilə aradan qaldırıldı.
- Mövcud palitra/geometriya/type tokenləri saxlandı; bu yalnız statik dizayn hesablamasıdır.

### Remaining work
- Hadisələrin dəqiq rəqəmli nəticələri; mode-specific ödəniş nəticələri.
- Tam dil/cihaz/font/inset matrisi; köhnə capture-lara fərdi baxış; runtime/accessibility/provider/policy yoxlamaları.

### Relevant files
- design/states/D2-partial-risk-v15-fixture.json
- design/tools/render-design-suite-v15.swift
- design/states/D1-D6-design-v15/{review,verification,partial-risk-verification,partial-risk-diff,navigation}.json
- design/states/D1-D6-design-v15/D2-services-partial.png
- docs/decisions.json → balanceDecisions.confirmed.B04/B05

### Checks performed
- Swift render exit0; basis-point expiry/boundary/category-average assert-ləri keçdi.
- Müstəqil Python Fraction hesabı: 4 sərhəd, gün8 bitmə, kateqoriya ortaları, ehtimal cəmi100%, tam/əhatəsiz13%/16% kontrolu keçdi.
- Manifest yolları mövcuddur; yalnız partial dəyişib. Native və contact vizual baxış keçdi; allFit müstəqil overlap və runtime testi deyil.

### Exact next step
- Bu son bölmə və V15 review.remaining oxu; növbəti ayrıca vahid kimi hadisələrin dəqiq rəqəmli nəticələrini qəbul edilmiş B04/B07 qaydalarına əsasən fixture-lərə bağla. V15 rendererində render et və aç; seçim soruşma; oyun koduna başlama.

## Hadisələrin rəqəmli nəticələri — V15, 4 noyabr 2026

### Completed
- B04/B05/B07 əsasında D2-event-outcomes-v15-fixtures.json: 22 müstəqil statik nəticə nümunəsi; H01 ödəniş/qaçış/mühafizəçi/mal/mənbə, H02 gözləmə/yan yol/dönüş, H05 yağış/örtük/sığınma/metal, H06 təmir, H07 zədə/örtük/bərpa, keyfiyyət və sıfır büdcə sərhədləri, H08 xəbər.
- V15 nəticələri fixture-dən render edir. Üç əvvəlki T05 ambush/storm/repair kadrı əvəzləndi; 19 əlavə kadr, digər338 əvvəlki kadr bayt-identikdir.

### Current state
- V15: 360 capture, missing0, allFit=true; unikal manifest yolları mövcuddur. Oyun kodu dəyişməyib.
- 22 fixture müstəqil integer yoxlamadan keçdi; B04 karvan bütün-səfər ehtimal bölgüsü10000bp, L15%, dondurulmuş qiymət, örtük aşağı yuvarlaqlaşması, minimum25%, maya bölgüsü, vaxt və növbəti yol qoruması yoxlandı.

### Decisions
- Nümunələr alternativdir, ardıcıl hadisələr deyil. Sintetik dondurulmuş sağlam satış20 və maya203 açıq saxlanır; borc aktivdən çıxılmır, əvvəlki yol haqqı itki büdcəsinə daxil deyil.
- H03/H04 xidmət/son-gün axınlarında qalır; H09/H10 bazar effektidir, yol nəticəsi deyil. Runtime məntiqi yazılmayıb.
- Palitra/type/geometriya tokenləri qorunub. Contact renderer hər prosesdə bir səhifə yaradır: argument0 və1; çoxsəhifəli eyni prosesdə ikinci sheet sürüşürdü, ayrıca prosesdə düzəldi.

### Remaining work
- Mode-specific ödəniş nəticələri; tam dil/cihaz/font/inset matrisi; köhnə kadrların fərdi baxışı.
- Əlçatmaz seçimlərin tam matrisi, ardıcıl zədə/reload və B09 son-gün nəticələri ayrıca yoxlanmayıb; runtime/accessibility/provider/policy açıqdır.

### Relevant files
- design/states/D2-event-outcomes-v15-fixtures.json
- design/tools/render-design-suite-v15.swift
- design/tools/verify-v15-event-fixtures.py
- design/tools/render-v15-event-contact.swift (0 və1 argumentləri ilə ayrı işə sal)
- design/states/D1-D6-design-v15/{review,verification,event-outcome-verification,event-outcome-diff}.json
- design/states/D1-D6-design-v15/contact-events-{1,2}.png

### Checks performed
- Swift tam render exit0: 360 capture, missing0, allFit=true. Python22 nümunə keçdi; manifest unikal/mövcud, diff3 dəyişən+19 yeni+338 eyni.
- Bütün22 nəticə iki contact sheet-də; ambush-escape-damage, damage-floor, spill-cover ayrıca native açılıb baxıldı. Son ikinci contact ayrıca prosesdən yenidən yaradılıb baxıldı.
- Palitra dəyişməyib; əvvəlki kontrast scope-u saxlanır. allFit müstəqil overlap və runtime testi deyil.

### Exact next step
- Bu son bölmə və V15 review.remaining oxu; növbəti ayrıca vahid kimi mode-specific ödəniş nəticələrini mövcud V11/V12 fixture-lərə bağla, V15-də render et və aç. Seçim soruşma; oyun koduna başlama.

## Mode-specific ödəniş nəticələri — V15, 4 noyabr 2026

### Completed
- D2-payment-modes-v15-fixtures.json: bələdçi/mühafizəçi üçün none/road/term-dən 8 qeyri-boş kombinasiya × confirm/pending/paid-success/failed/unknown =40 strukturlaşdırılmış statik fixture.
- V15 V11/V12-dəki eyni ID-li8 kadrı yeni fixture ilə əvəzləyir,32 əlavə edir. V11/V12 tarixçəsi saxlanır. Statik navigation.json hər rejimdə eyni əməliyyat və seçimlə nəticə/retry keçidlərini saxlayır.
- Müddətli/müddətli40, bələdçi müddətli+guard road22, guide road+guard müddətli32; qalıqlar60/78/68.

### Current state
- Son V15 render exit0:392 capture, xidmət üzrə63, missing0, allFit=true. Oyun kodu dəyişməyib.
- Əvvəlki360 manifest kadrından8 dəyişib,352 bayt-identikdir;32 yeni kadr var.5 köhnə contact sheet capture sayına daxil deyil.
- Bütün statik keçid source/target-ləri mövcuddur; manifest yolları unikal və mövcuddur.

### Decisions
- Başlanğıc alış nümunəsi gün4/qızıl100/məsafə1-dir. Müddətli xidmət uğurlu ödənişdə başlayır, gün8 başlanğıcında bitir; bir-yol əhatəsi çıxışdan təyinat/geri dönüş gəlişinədəkdir.
- Pending/unknown son təsdiqlənmiş100-ü göstərir, resolvedCash null-dır; bu, pul tutulmadığını iddia etmir. Failed100, success bir dəfə tutulmuş qalıqdır. Bunlar runtime idempotency sübutu deyil.
- Tək guide-term və guard-road təsdiqləri picker mənşəli nümunələrdir; ayrıca yeni overview kadrları əlavə olunmayıb.
- Palitra/type/geometriya tokenləri dəyişməyib. Yeni contact renderer PNG-ni ImageIO ilə oxuyur; hər səhifə ayrıca0..3 argumenti ilə render edilir. Köhnə contact-services ödəniş təsvirləri tarixi sayılsın; cari40 kadr contact-payments-1..4-dədir.

### Remaining work
- Tam dil/cihaz/font/inset matrisi; köhnə kadrların fərdi baxışı; əlçatmaz seçimlərin tam matrisi və B09 son-gün nəticələri.
- Runtime/persistence/idempotency/accessibility/provider/policy validation; oyun implementasiyası üçün ayrıca tapşırıq lazımdır.

### Relevant files
- design/states/D2-payment-modes-v15-fixtures.json
- design/tools/render-design-suite-v15.swift
- design/tools/verify-v15-payment-modes.py
- design/tools/render-v15-payment-contact.swift (ayrı proseslərdə0,1,2,3)
- design/states/D1-D6-design-v15/{review,verification,navigation,payment-mode-verification,payment-mode-diff}.json
- design/states/D1-D6-design-v15/contact-payments-{1,2,3,4}.png

### Checks performed
- Python8 rejim ×5 state: tam kombinasiya, B05 qiymət/cəm/qalıq, müqavilə vaxtı, operationId qoruması, unknown/failed/success fərqi, statik keçidlər keçdi.
- Tam Swift render392/missing0/allFit=true; diff8+32+352; manifest və navigation yoxlamaları keçdi.
- Bütün40 kadr4 contact sheet-də baxıldı; both-term və iki mixed success, mixed-guide-term pending, guide-road success, road/road confirm və mixed-guard-term unknown ayrıca native baxıldı. Sheet3 original ölçüdə də açıldı.
- Palitra dəyişməyib, əvvəlki kontrast scope-u saxlanır; allFit müstəqil overlap/runtime testi deyil.

### Exact next step
- Bu son bölmə və V15 review.remaining oxu. Növbəti ayrıca vahid kimi xidmət ödəniş fixture-ləri üçün dil/font/cihaz/inset yoxlama matrisini mövcud token və localization mənbələri əsasında qur; statik render et və aç. Seçim soruşma; oyun koduna başlama.

## Ödəniş dil/font/cihaz/inset matrisi — V15, 4 noyabr 2026

### Completed
- 40 fixture × AZ/TR/RU/EN × 1/1,3/2× fontScale × 7 profil/inset cütü =3360 hal; 9544 PNG səhifəsi. P1/P2 I0–I2, P3 I0; ölçü/density/insetlər D1-canonical-render-matrix mənbəyindən.
- Ayrı statik stacked scroll-flow renderer: bütün mətn və düymələr səhifələnir, şrift kiçilmir; əvvəlki V15 iki-pane kadrları dəyişmir. Matris indeksi və4 dil contact PNG-si açıldı.
- D2-payment-localization-v15.json AZ orijinalı və draft TR/RU/EN; mövcud D1 localization D2-ni əhatə etmirdi. Oyun kodu dəyişməyib.

### Current state
- verification.json:3360 unikal/tam hal,9544 mövcud capture,allFit=true,missingGlyphs0,operationId qorunur. Status geometry_pass_font_fallback_open.
- Font auditi: ← və → üçün LucidaGrande fallback; faktiki resolvedFonts siyahısında LucidaGrande-Bold da var. No-fallback yoxlaması keçmir. Bu çatışmazlıq gizlədilməyib.

### Decisions
- Kanonik F1 NotoSans, mövcud type/geometriya/palitra; F2 Serif alternativi scope-dan kənardır.
- Bu, ayrı adaptiv statik axındır: əvvəlki iki-pane layoutun bütün matrisdə işlədiyini sübut etmir. FontScale xətti simulyasiyadır; real Android/cihaz yoxlaması deyil.
- TR/RU/EN tərcümələri təsdiqlənməyib. Bütün9544 səhifəyə fərdi vizual baxış iddiası yoxdur.

### Remaining work
- Ox simvolları üçün bundled font/ikon həlli və təkrar font audit; draft tərcümələrin dil baxışı.
- Kanonik iki-pane uyğunlaşması və digər xidmət/ekranların matrisi, köhnə kadrların fərdi baxışı.
- Runtime/accessibility/persistence/provider/policy; oyun implementasiyası ayrıca tapşırıqdır.

### Relevant files
- design/tools/render-v15-payment-matrix.swift (compile once; P1/P2/P3 ayrı proseslər)
- design/tools/audit-v15-payment-font.swift
- design/tools/verify-v15-payment-matrix.py
- design/tools/render-v15-payment-matrix-contact.swift (AZ/TR/RU/EN ayrı, ardıcıl proseslər)
- design/states/D2-payment-localization-v15.json
- design/states/D2-payment-matrix-v15/{index.html,verification.json,verification-P1.json,verification-P2.json,verification-P3.json,font-audit.json,contact-AZ.png,contact-TR.png,contact-RU.png,contact-EN.png}
- design/states/D1-D6-design-v15/review.json → paymentMatrix

### Checks performed
- Üç Swift render exit0; Python tam cross-product3360, fayl mövcudluğu, operationId/geometriya/glyph yoxlamaları keçdi. Əvvəlki payment verifier8×5 də keçdi.
- Dörd contact sheet: P1/I2/2× mixed-guide-term bütün5 state; native P1/RU unknown, P1/TR confirm, P2/I1/EN/1,3× success-both-term page1, P3/RU/2× failed-mixed-guard-term page0 açılıb baxıldı.
- Paralel contact renderində TR icmalında sürüşmə göründü; tək prosesdə yenidən render edib açdım, düzəldi. Native TR kadrı sağlam idi. Sonrakı contact-ləri ardıcıl işə sal.
- Palitra dəyişməyib; əvvəlki opaque kontrast scope-u saxlanır. allFit müstəqil overlap/runtime/accessibility sübutu deyil.

### Exact next step
- Bu son bölməni, paymentMatrix review qeydi və font-audit.json-u oxu. Ayrı kiçik vahid kimi ←/→ fallback problemini bundled font və ya mövcud ikon mənbəyi ilə həll et; əvvəl seçilmiş stress kadrlarını render edib aç, audit et. Tərcümə və oyun koduna keçmə; seçim soruşma.

## Ödəniş oxlarının bundled font həlli — 4 noyabr 2026

### Completed
- ←/→ üçün Noto Sans Symbols variable binary eyni Google Fonts commitindən bundled edildi; ayrıca D2-payment-symbol-font.json binary/lisenziya SHA-256 və scope saxlayır.
- Matrix renderer və audit ox run-larına Symbols Regular şriftini açıq təyin edir, glyph mövcudluğunu yoxlayır. NotoSans mətn rolları və type/palitra/geometriya tokenləri dəyişməyib.
- İcmal renderer birbaşa CoreGraphics bitmap istifadə edir. 4 contact sheet yeniləndi, TR icmalı Preview-də açıldı. Oyun kodu dəyişməyib.

### Current state
- 3360 hal / 9544 PNG yenidən render edildi; allFit=true, missingGlyphs=0, noFallbackPassed=true; status geometry_and_bundled_fonts_pass.
- Audit bütün localization mətnlərini bütün canonical rollarda × 1/1.3/2 scale ilə yoxlayır: 6264 run, yalnız NotoSans Regular/SemiBold/Bold və NotoSansSymbols Regular.

### Decisions
- Symbols 2 əsas U+2190/U+2192-ni daşımadığı üçün glyph yoxlamasında rədd edildi və layihədən çıxarıldı; Noto Sans Symbols hər iki glyph-i daşıyır.
- Oxlar regular-weight face ilə text role ölçüsündədir; synthetic bold yoxdur. Həll yalnız statik payment matrix üçündür; əvvəlki V15 iki-pane kadrları dəyişmir.

### Remaining work
- Draft TR/RU/EN dil baxışı; canonical iki-pane uyğunlaşması; digər ekranların matrisi və əvvəlki qeydlərdəki runtime/accessibility/provider işləri.
- Bütün 9544 səhifəyə fərdi vizual baxış aparılmayıb. Oyun implementasiyası ayrıca tapşırıqdır.

### Relevant files
- design/states/D2-payment-symbol-font.json; design/fonts/notosanssymbols/{NotoSansSymbols[wght].ttf,OFL.txt}
- design/tools/{render-v15-payment-matrix.swift,audit-v15-payment-font.swift,verify-v15-payment-matrix.py,render-v15-payment-matrix-contact.swift}
- design/states/D2-payment-matrix-v15/{font-audit.json,verification.json,index.html,contact-AZ.png,contact-TR.png,contact-RU.png,contact-EN.png}
- design/states/D1-D6-design-v15/review.json → paymentMatrix

### Checks performed
- Swift compile/render P1/P2/P3 exit0; full matrix Python verifier və 8×5 payment modes verifier keçdi.
- 4 dil contact sheet baxıldı; TR/EN təkrar görüntülər köhnə image cache göstərdiyindən EN finalı unikal /tmp/payment-en-final.png yolundan açılıb sağlam təsdiqləndi.
- Native P1/I2/TR/2x confirm page2 (hər iki ox), P1/I2/RU/2x unknown page2, P2/I1/EN/1.3x paid-success-both-term page1, P3/I0/RU/2x failed-mixed-guard-term page0 baxıldı.
- Palitra dəyişməyib; kontrast yenidən hesablanmayıb. allFit runtime/device/accessibility və müstəqil overlap sübutu deyil.

### Exact next step
- Font fallback vahidi tamamdır. Növbəti ayrıca dizayn tapşırığı verilənədək oyun koduna başlama. Dil baxışı istənərsə D2-payment-localization-v15.json və son verification limits ilə başla.


## D2 TR/RU/EN dil baxışı — 4 noyabr 2026

### Completed
- AZ mənbəyinə görə bütün 64 açarın TR/RU/EN baxışı: TR 14, RU 19, EN 17 mətn dəyişdi; AZ və JSON açarları dəyişmədi.
- Əhatə TR/RU-da yalnız mühafizə mənası vermir; xidmət əhatəsi kimi verilir. Ödəniş CTA-ları, təsdiqli balans və 8-ci günün əvvəli ifadələri təbiiləşdirildi.
- Tam statik matris və font auditi təkrar işlədi; 4 contact sheet yeniləndi. Oyun kodu dəyişməyib.

### Current state
- 3360 hal / 9582 manifest PNG səhifəsi; allFit=true, missingGlyphs=0, noFallbackPassed=true; 6264 audit run.
- Status: az_source_reviewed_tr_ru_en_not_native_speaker_approved. Dil baxışı ana dili redaktorunun təsdiqi deyil.

### Decisions
- Məbləğlər, əməliyyat ID-ləri, 5 payment state fərqi, son təsdiqli balans semantikası qorunur.
- Tokenlər dəyişməyib; kontrast yenidən hesablanmayıb. Mövcud statik stacked pagination saxlanır, iki-pane uyğunluğu iddia edilmir.

### Remaining work
- Ana dili redaktorunun təsdiqi; canonical iki-pane uyğunlaşması; digər ekranların matrisi. Runtime/device/accessibility/provider/policy ayrıca scope-dur.
- Bütün 9582 səhifə fərdi vizual yoxlanmayıb; allFit müstəqil overlap sübutu deyil. Köhnə artıq PNG-lər qovluqda qala bilər; cari capture sayı manifestə əsaslanır.

### Relevant files
- design/states/D2-payment-localization-v15.json
- design/tools/verify-v15-payment-matrix.py
- design/states/D2-payment-matrix-v15/{verification.json,verification-P1.json,verification-P2.json,verification-P3.json,font-audit.json,index.html,contact-TR.png,contact-RU.png,contact-EN.png}
- design/states/D1-D6-design-v15/review.json → paymentMatrix.copyReview

### Checks performed
- Swift compile və P1/P2/P3 render exit0; full matrix verifier və 8×5 payment modes verifier keçdi.
- TR/RU/EN P1/I2/2× mixed-guide-term contact sheet-lərində 5 state baxıldı.
- Native P1/I2/TR/2× confirm page2, P1/I2/RU/2× unknown page2, P2/I1/EN/1.3× paid-success-both-term page1, P3/I0/RU/2× failed-mixed-guard-term page0 açıldı: mətn kəsilməsi görünmədi.
- Swift ilk sandbox compile modul keşinə yazma icazəsində dayandı; icazəli compile uğurlu oldu. Workspace git repository deyil; git diff mümkün olmadı.

### Exact next step
- Dil baxışı vahidi tamamdır. Növbəti ayrıca dizayn tapşırığı üçün bu bölmə və review.paymentMatrix oxunsun; canonical iki-pane uyğunlaşması scope-u dəqiqləşdirilsin. Oyun koduna başlanmasın.

## D2 canonical iki-pane uyğunlaşması — scope, 4 noyabr 2026

### Completed
- Son dil baxışı bölməsi, review.paymentMatrix və hər iki statik rendererin kompozisiya mənbələri oxundu. Bu vahid yalnız scope müəyyənləşdirir; render və oyun implementasiyası başlanmayıb.

### Current state
- Canonical xidmət rendererində başlıq/status, yanaşı left/right panelləri və aşağı əməliyyat sətri var; mövcud sübut AZ/P1/1× ilə məhduddur.
- Ayrı stacked matris 3360 hal/9582 manifest səhifəsini yoxlayır; iki-pane üçün sübut deyil. Dil baxışı tamamdır, ana dili redaktoru təsdiqi açıq qalır.

### Decisions
- İlk uyğunlaşma yalnız D2 payment: 8 qeyri-boş xidmət rejimi × confirm/pending/paid-success/failed/unknown =40 fixture. Overview/picker, aktiv/bitmiş müqavilə, partial-risk, yol hadisələri və D1/D3–D6 bu vahidə daxil deyil.
- Hədəf matris həmin 40 fixture × AZ/TR/RU/EN × 1/1.3/2 fontScale × 7 profil/inset cütü =3360 haldır. P1/P2 üçün I0–I2, P3 üçün I0; F1 NotoSans və bundled Symbols. PNG sayı əvvəlcədən dondurulmur.
- Mənbə canonical left/right məzmun bölgüsü və semantik ardıcıllıqdır. Yanaşı panellərin sığdığı hallarda iki-pane saxlanır; sığmayan hallarda eyni iki məzmun qrupunu qoruyan reflow/scroll namizədi ayrıca göstərilir. Bütün hallara məcburi iki sütun və ya avtomatik stacked uğuru elan edilmir. Layout seçimi ölçülmüş mətn, safe rect və hədəflərlə əsaslandırılmalıdır; yeni production breakpoint bu scope-da təsdiqlənmir.
- Başlıq/status və əməliyyatların böyük şriftdə davranışı stress renderində seçilməlidir: mətn kiçiltmək, kritik məzmunu kəsmək və ya CTA-nı üst-üstə qoymaq həll sayılmır. Sabit əməliyyat sətri sığmırsa axına keçid ayrıca sənədləşdirilir.
- Mövcud geometry/type/palitra/art token mənbələri və yenilənmiş localization istifadə olunur. Qiymət, operationId, pending/unknown son təsdiqli balansı, failed/success fərqi, enabled və statik retry keçidləri dəyişmir.
- Yeni statik nəticələr ayrıca çıxış qovluğuna yazılmalıdır; hazırkı V15 canonical və stacked sübutları ilkin mərhələdə əvəz edilmir.

### Remaining work
- Əvvəl kiçik stress pilotu: P1/I2/RU/2× mixed-guide-term bütün 5 state; P1/I0/AZ/1× və P3/I0/AZ/1× confirm baza müqayisəsi. Məqsəd layout/CTA siyasətini seçməkdir; bu pilot tam matris keçidi deyil.
- Pilot qəbulundan sonra 3360 hal: manifest tamlığı, hər mətn blokunun/pane-in/CTA-nın bounds və overlap yoxlaması, safe rect və ən az 48dp hədəflər, kritik mətnin tam əlçatanlığı, glyph/fallback auditi və payment verifier. Scroll/reflow hallarında bütün məzmunun capture-ları və sıra uyğunluğu saxlanmalıdır.
- Vizual baxış: pilotun bütün kadrları, sonra hər dil/layout mode üçün seçilmiş stress kadrları; baxılmamış səhifələr baxılmış kimi işarələnmir. Faktiki mətn/fon və mənalı control-state kontrastı yoxlanır; tokenlər dəyişərsə kontrast təkrar hesablanır.
- Real Android font scaling, cihaz/emulator, TalkBack/fokus, runtime/persistence/idempotency/provider/policy və oyun kodu ayrıca scope-dur. Statik scroll capture interaktiv scroll sübutu deyil.

### Relevant files
- design/tools/render-design-suite-v15.swift — canonical xidmət kompozisiyası
- design/tools/render-v15-payment-matrix.swift — localization/font/inset və stacked müqayisə mənbəyi
- design/states/D2-payment-modes-v15-fixtures.json; D2-payment-localization-v15.json; D2-payment-symbol-font.json
- design/states/D1-canonical-render-matrix.json — profiles/insetVariants/typeTrial; D1-pixel-composition-tokens.json — geometry/art; D6-canonical-token-proposal.json — referenceColors
- design/states/D1-D6-design-v15/{review,navigation}.json
- design/tools/{verify-v15-payment-modes.py,verify-v15-payment-matrix.py,audit-v15-payment-font.swift}

### Checks performed
- Scope mənbə kodu və review məhdudiyyətləri ilə tutuşduruldu. Yeni render/test icra olunmadı; vizual dəyişiklik və uyğunluq iddiası yoxdur.

### Exact next step
- Yalnız ayrıca statik dizayn vahidi kimi yuxarıdakı 7 haldan ibarət pilotu hazırla; əvvəl tokenləri və canonical panel/CTA davranışını oxu, render et və şəkilləri aç. Ölçmələr əsasında iki-pane/reflow siyasətini qeyd et; tam matrisi və oyun kodunu həmin pilotla birlikdə başlama.

## D2 canonical 7 hallıq statik pilot — 4 noyabr 2026

### Completed
- Ayrı pilot renderer, contact renderer və müstəqil geometry/source verifier hazırlandı. Yalnız mixed-guide-term: P1/I2/RU/2× bütün 5 state, P1/I0/AZ/1× confirm və P3/I0/AZ/1× confirm render edildi.
- 7 hal / 22 native PNG; hər RU halı 4 səhifə, hər AZ baza halı 1 səhifə. Final 5 RU contact sheet bütün 20 stress kadrını göstərir; hər iki AZ baza native açıldı, failed CTA səhifəsi ayrıca native baxıldı.

### Current state
- 2 baza halı two-pane/fixed-bottom-pair, 5 stress halı reflow/flow-stacked. P1 və P3 AZ üçün tələb olunan pane hündürlüyü 240px, mövcud sahə 264/1144px.
- RU üçün pane tələbi confirm 816/816, pending 816/1104, success 816/1008, failed 816/816, unknown 816/1104px. Sabit başlıq/status/CTA-dan sonra mövcud sahə müvafiq -16/112/16/-96/0px; mənfi nəticə həmin sabit kompozisiyanın özünün sığmadığını göstərir.
- Tokenlər, localization və payment fixture dəyişməyib; əvvəlki canonical/stacked renderlər saxlanıb. review.paymentMatrix.canonicalPilot ayrıca sübuta yönəlir. Tam matris və oyun kodu başlanmayıb.

### Decisions
- İki-pane yalnız başlıq/status və ən uzun CTA etiketi ölçüldükdən sonra hər iki panel bütöv sığanda seçilir. CTA hündürlüyü ən az 48dp, lazım gələrsə bükülən mətn+canonical padding qədər artır; iki-pane-də altda yanaşıdır.
- Sığmayan halda left sonra right semantik ardıcıllığı ilə reflow; primary sonra Back tam enli və məzmundan sonra axındadır, sticky deyil. İki CTA bir səhifəyə sığırsa birlikdə saxlanır. Bölmə başlığı ilk sətrindən ayrılmır, birləşmiş hündürlük səhifəyə sığdığı hallarda.
- İlkin baxışda başlıq yetim qalması və failed CTA-ların ayrılması görüldü, düzəldilib yenidən render və baxış edildi. Şrift kiçildilməyib.
- Bu ölçməyə əsaslanan pilot siyasətidir, production breakpoint təsdiqi deyil. Tablet mövcud maxTextWidth tokenini saxlayır; uzun boş panel sahəsi var, yeni tablet eni icad edilməyib.
- Pending/unknown primary passivdir; Back aktivdir. Əvvəlki passiv paper görünüşü saxlanır; tam state/fokus palitrası sübutu deyil.

### Remaining work
- 3360 hallıq canonical uyğunlaşma matrisi yalnız ayrıca tapşırıqla; pilotun 7 halı onun əvəzi deyil. Tam control-state/fokus, runtime/device/TalkBack/provider/policy açıqdır.
- Statik səhifələr interaktiv scroll sübutu deyil; Android-in qeyri-xətti font scaling davranışı yoxlanmayıb. Ana dili redaktoru təsdiqi əvvəlki kimi açıqdır.

### Relevant files
- design/tools/render-v15-payment-pilot.swift
- design/tools/render-v15-payment-pilot-contact.swift
- design/tools/verify-v15-payment-pilot.py
- design/states/D2-payment-pilot-v15/{measurements,verification,decision}.json; contact-*.png və manifestdəki native PNG-lər
- design/states/D1-D6-design-v15/review.json → paymentMatrix.canonicalPilot

### Checks performed
- Swift compile və pilot render exit0; verifier 7 hal/22 capture: safe rect, text bounds, pairwise item overlap, bütün mətnlərin mənbə və sıra uyğunluğu, operationId/enabled və ən az 48dp CTA keçdi.
- missingGlyphs=0; resolved fonts yalnız bundled NotoSans Regular/SemiBold/Bold və NotoSansSymbols Regular. Nav/paper real opaque mətn fonu kontrastı 10.994:1; dekorativ tekstura kənarları mətn fonu deyil.
- 8×5 payment modes verifier keçdi. Bütün final capture-lar yuxarıdakı contact/native baxışla yoxlandı; görünən clipping/collision müşahidə edilmədi.
- Təkrar icra: swiftc -module-cache-path /tmp/barterune-swift-cache design/tools/render-v15-payment-pilot.swift -o /tmp/render-payment-pilot; /tmp/render-payment-pilot; python3 design/tools/verify-v15-payment-pilot.py. Contact üçün ayrıca Swift tool-u compile et və measurements.cases[].id-ni hər çağırışda ayrıca ötür.

### Exact next step
- Pilot vahidi tamamdır. Yeni chatdə bu bölmə və D2-payment-pilot-v15/decision.json oxunsun; ayrıca verilən dizayn tapşırığının scope-u tətbiq edilsin. İstifadəçi ayrıca istəmədən tam matrisə və oyun koduna başlama.


## D2 canonical 3360 hallıq statik matris — 4 noyabr 2026

### Completed
- Pilot rendererindən ayrıca canonical matris renderer, müstəqil verifier, şrift auditi və HTML evidence index hazırlandı. 40 fixture × 4 dil × 3 scale × 7 profil/inset cütü =3360 hal; 8327 native PNG.
- 1143 iki-pane/fixed-bottom-pair; 2217 reflow/flow-stacked. Pilotun 7 halı üzrə ölçmə və bütün səhifələrin text/action geometry regressiyası keçdi.
- 36 native kadr açılıb baxıldı; dəqiq yollar visual-review.json-dadır. Hər dil üçün hər iki layout, bütün 5 payment state, 1/1.3/2 scale, P1/P2/P3 və I0/I1/I2 nümunələri əhatə olunur. Bütün PNG-lərə fərdi vizual baxış iddiası yoxdur.

### Current state
- Status: full_static_matrix_verified_and_selected_stress_inspected. Nəticələr ayrıca D2-payment-canonical-matrix-v15 qovluğundadır; pilot, canonical V15 və əvvəlki stacked sübutlar saxlanıb.
- Token/localization/fixture/symbol manifest hash-ləri pilotla eynidir. Oyun kodu dəyişməyib.

### Decisions
- Pilot siyasəti dəyişməyib: iki panel tam sığırsa altda CTA cütü; əks halda left→right reflow, primary→Back məzmundan sonra. Heading/first-row və sığan CTA cütləri birlikdədir.
- Production breakpoint təsdiqi yoxdur. Planşetin dar maxTextWidth sütunları və passiv paper görünüşü saxlanıb.

### Remaining work
- Real Android qeyri-xətti font scale, interaktiv scroll, cihaz/emulator, TalkBack/fokus, runtime/persistence/idempotency/provider/policy ayrıca scope-dur.
- Tam control-state/fokus palitrası və ana dili redaktoru təsdiqi açıqdır. Digər ekranların matrisi bu işə daxil deyil.

### Relevant files
- design/tools/render-v15-payment-canonical-matrix.swift
- design/tools/verify-v15-payment-canonical-matrix.py; audit-v15-payment-canonical-font.swift; build-v15-payment-canonical-index.py
- design/states/D2-payment-canonical-matrix-v15/{measurements,verification,decision,visual-review,font-audit}.json; index.html və manifest PNG-ləri
- design/states/D1-D6-design-v15/review.json → paymentMatrix.canonicalMatrix
- Mənbələr: D2-payment-pilot-v15/decision.json; D2-payment-modes-v15-fixtures.json; D2-payment-localization-v15.json; D1-canonical-render-matrix.json; D1-pixel-composition-tokens.json; D6-canonical-token-proposal.json.

### Checks performed
- Swift compile və P1/P2/P3 render exit0. Full cross-product, PNG mövcudluğu/ölçüsü, safe/content rect, text/pane/action bounds, pairwise overlap, minimum48dp CTA, source-copy/role/ardıcıllıq, enabled/operationId və pagination/CTA grouping yoxlamaları keçdi.
- missingGlyphs=0; yalnız bundled NotoSans Regular/SemiBold/Bold və NotoSansSymbols Regular; font audit noFallbackPassed=true. Nav/paper real opaque mətn və aktiv control fill kontrastı 10.994:1; dekorativ frame və tam disabled/fokus fərqləndirilməsi ayrıca məhdudiyyətdir.
- 8×5 payment modes verifier keçdi; 36 seçilmiş native kadrda görünən clipping/collision müşahidə edilmədi. Statik text ölçmələri raster OCR və runtime sübutu deyil.
- Təkrar icra: swiftc -module-cache-path /tmp/barterune-swift-cache design/tools/render-v15-payment-canonical-matrix.swift -o /tmp/render-payment-canonical; binary-ni P1/P2/P3 arqumentləri ilə ayrıca işə sal. Audit Swift tool-unu compile/run et; python3 design/tools/verify-v15-payment-canonical-matrix.py; python3 design/tools/build-v15-payment-canonical-index.py.

### Exact next step
- Bu vahid tamamdır. Yeni ayrıca dizayn scope-u veriləndə bu son bölmə və D2-payment-canonical-matrix-v15/decision.json oxunsun. Əlavə dizayn scope-u və oyun implementasiyası özbaşına başlanmasın.


## D2 payment control-state/fokus statik pilot — 4 noyabr 2026

### Completed
- Normal, primary/back pressed və focused üçün 31 tətbiq edilə bilən kombinasiya / 94 PNG. Əvvəlki 7 pilot ssenarisi: AZ P1/P3 1× two-pane; RU P1/I2 2× reflow bütün 5 payment state.
- Ayrı renderer, control contact renderer, geometry/source/state verifier və HTML evidence index hazırdır. 6 control sheet və 4 tam native nümunə açılıb baxıldı; dəqiq siyahı visual-review.json-dadır.

### Current state
- Status static_candidate_verified_and_sampled_not_production_approved. Oyun kodu, tokenlər, localization, fixture və əvvəlki matris dəyişməyib.
- Fokus: frameEdge qalınlığında bütöv paper çərçivə, içəridə nav. Pressed: nav kontur, paper səth/nav mətn. Normal və passiv əvvəlki görünüşdədir.

### Decisions
- Yalnız mövcud nav/paper və frameEdge/inset/target/type tokenləri. Yeni rəng, opacity və ölçü tokeni yoxdur; qlobal pending fokus/pressed/disabled tokenləri həll edilmiş sayılmır.
- Disabled primary focused/pressed render edilmir; pending/unknown Back aktivdir. Mövcud unavailable izahı saxlanır.
- Namizəd statik pilot üçün saxlanır; production təsdiqi deyil. Eyni vaxtda pressed+focused bu vahiddə yoxdur.

### Remaining work
- TR/EN və bütün dillərdə ən uzun etiketlər, combined focused+pressed; real fokus naviqasiyası, Android scale/device/TalkBack və passiv izahın accessibility əlaqəsi ayrıca işdir.
- 94 native səhifənin hamısına fərdi baxış yoxdur. P3 control sheet preview qeyri-müəyyən idi; tam P3 focused native açılıb baxıldı.

### Relevant files
- design/tools/render-v15-payment-control-pilot.swift
- design/tools/render-v15-payment-control-contact.swift
- design/tools/verify-v15-payment-control-pilot.py
- design/states/D2-payment-control-pilot-v15/{decision,measurements,verification,visual-review}.json; index.html; controls-*.png; native PNG-lər
- design/states/D1-D6-design-v15/review.json → paymentMatrix.controlStatePilot

### Checks performed
- Swift compile/render keçdi. 31 hal/94 capture: safe/text/action bounds, overlap, minimum48dp, copy/order/enabled/operationId, focused/pressed flags və əvvəlki pilotla bütün layout/text/action geometry regressiyası keçdi.
- missingGlyphs=0; yalnız bundled NotoSans Regular/SemiBold/Bold və Symbols Regular.
- ui-craft contrast.py explicit nav/paper cütləri və müstəqil verifier: 10.994:1, mətn və mənalı fokus/pressed sərhədləri; dekorativ tekstura üçün kontrast iddiası yoxdur.
- 8×5 payment modes verifier keçdi. Baxılmış renderlərdə görünən clipping/collision yoxdur.
- Təkrar: swiftc -module-cache-path /tmp/barterune-swift-cache design/tools/render-v15-payment-control-pilot.swift -o /tmp/render-payment-control; /tmp/render-payment-control; python3 design/tools/verify-v15-payment-control-pilot.py. Contact Swift ayrıca compile/run edilir.

### Exact next step
- Pilot tamamdır. Yeni chatdə bu son bölmə və D2-payment-control-pilot-v15/decision.json oxunsun; növbəti ayrıca dizayn scope-u seçilsin. Tam control matrisinə və oyun koduna özbaşına başlanmasın.

## D2 dörd dil / focused+pressed statik genişləndirmə — 4 noyabr 2026

### Completed
- Dörd dil × beş payment state üzrə səkkiz fixture-in real primary etiketləri CoreText unwrapped advance ilə sıralandı; ən enli etiketli fixture seçildi. Back hər dildə tək real tərcümədir. Ölçmələr measurements.labelSelection-dadır.
- P3/I0/1× two-pane və P1/I2/2× reflow; normal, primary/back pressed, focused və focused+pressed. Disabled primary variantları çıxarılıb: 232 hal / 545 native PNG; 116 two-pane, 116 reflow.
- Ayrı renderer, contact renderer, verifier və HTML evidence index hazırlandı. 8 control sheet və 11 native capture açılıb baxıldı; dəqiq siyahı visual-review.json-dadır.

### Current state
- Status static_extension_verified_and_sampled_not_production_approved. Oyun koduna toxunulmayıb. Əvvəlki pilot/matris və source token/localization/fixture hash-ləri dəyişməyib.
- review.paymentMatrix.controlStateExtension ayrıca sübuta yönəlir.

### Decisions
- Combined state: paper xarici frameEdge fokus çərçivəsi → nav frameEdge kontur → paper pressed səth, nav mətn. Yeni rəng/ölçü tokeni yoxdur.
- İlk verifier combined daxili konturun köhnə vertical padding-ə girdiyini tutdu. Bütün action variantlarında üst/alt padding mövcud inset qədər edildi (əvvəl hər tərəfdə inset/2); action height=max(target, text height+2×inset). Horizontal inset dəyişməyib. Yenidən render/yoxlama/baxış keçdi.
- Bu padding əvvəlki canonical/pilot geometry-dən fərqlənir və pagination-a təsir edə bilər; köhnə baseline ilə tam geometry regressiyası iddiası yoxdur. Yeni extension daxilində normal və bütün interaction variantları geometry-identikdir.
- Namizəd ayrıca dizayn qərarıdır; qlobal token, production və tam control matris təsdiqi deyil. Ən enli düymə etiketi ən uzun body məzmununa zəmanət vermir.

### Remaining work
- Combined binding və artmış action padding barədə dizayn qərarı; yalnız bundan sonra ayrıca tapşırıqla tam control matrisi.
- P2/1.3× və bütün profil/inset kombinasiyaları bu pilotda yoxdur. Real Android scale, scroll, fokus naviqasiyası, TalkBack, disabled izahın accessibility əlaqəsi, ana dili redaktoru və runtime/provider açıqdır.
- Bütün 545 native capture fərdi baxılmayıb; contact sheet-lər kiçildilmiş control kəsikləridir.

### Relevant files
- design/tools/render-v15-payment-control-extension.swift
- design/tools/render-v15-payment-control-extension-contact.swift
- design/tools/verify-v15-payment-control-extension.py
- design/tools/build-v15-payment-control-extension-index.py
- design/states/D2-payment-control-extension-v15/{decision,measurements,verification,visual-review}.json; index.html; controls-*.png və native capture-lar
- design/states/D1-D6-design-v15/review.json → paymentMatrix.controlStateExtension

### Checks performed
- Swift renderer/contact compile və render exit0. Verifier: 232 hal/545 capture, PNG ölçüləri, full selected cross-product, safe/text/action bounds, overlap, minimum48dp, copy/order/enabled/operationId, focused/pressed flags, extension daxilində geometry regressiyası keçdi.
- Source hash-ləri əvvəlki control pilotla eynidir. missingGlyphs=0; yalnız bundled NotoSans Regular/SemiBold/Bold və Symbols Regular.
- ui-craft contrast.py explicit nav/paper cütləri və verifier: 10.994:1. Dekorativ tekstura və tam disabled fərqləndirilməsi üçün kontrast iddiası yoxdur.
- 8×5 payment modes verifier keçdi; baxılmış 8 sheet/11 native capture-da görünən clipping/collision yoxdur.
- Təkrar: swiftc -module-cache-path /tmp/barterune-swift-cache design/tools/render-v15-payment-control-extension.swift -o /tmp/render-payment-control-extension; /tmp/render-payment-control-extension; python3 design/tools/verify-v15-payment-control-extension.py. Contact Swift ayrıca compile/run; python3 design/tools/build-v15-payment-control-extension-index.py.

### Exact next step
- Bu vahid tamamdır. Yeni chatdə bu son bölmə və D2-payment-control-extension-v15/decision.json oxunsun; combined state və artmış action padding qərarı nəzərdən keçirilsin. Tam control matrisi və oyun implementasiyası ayrıca göstərişsiz başlanmasın.

## D2 qəbul edilmiş control qaydaları və tam statik matris — 4 noyabr 2026

### Completed
- İstifadəçinin açıq göstərişi ilə combined focused+pressed binding və artmış action padding D2 statik dizayn qərarı kimi qəbul edildi; extension decision və əsas review yeniləndi.
- 40 fixture × 4 dil × 3 scale × 7 profil/inset cütü =3360 baza; disabled primary istisnaları ilə 19 488 control halı / 49 278 native capture hazırlandı. 6828 two-pane, 12 660 reflow.
- Ayrı matrix renderer, contact renderer, verifier, pixel regression auditi və HTML evidence index hazırdır. 12 control sheet və 14 native capture açılıb baxıldı; dəqiq yollar visual-review.json-dadır.

### Current state
- Status full_static_control_matrix_verified_and_sampled_d2_design_accepted_not_production_approved. Nəticələr D2-payment-control-matrix-v15 qovluğundadır.
- Oyun kodu dəyişməyib. Token/localization/fixture/symbol hash-ləri əvvəlki pilotla eynidir; köhnə renderlər saxlanıb.

### Decisions
- Combined: xarici paper frameEdge fokus çərçivəsi → nav frameEdge kontur → paper pressed səth, nav mətn.
- Bütün action variantlarında yuxarı/aşağı inset; height=max(target, shaped text height+2×inset). Horizontal inset dəyişməyib. Interaction variantlarında geometry identikdir; enlarged padding əsasında pagination yenidən hesablanıb.
- Əvvəlki two-pane/reflow və primary→Back axın siyasəti saxlanıb. Production breakpoint/qabaqcadan qlobal token təsdiqi yoxdur.
- Renderer hər baza halını ölçür; interaction variantları normal PNG-də yalnız seçilmiş control-u yenidən çəkir. Dəyişməyən səhifələr hardlink-dir; manifestdə hər capture ayrıdır. Yaddaş üçün hər hal autoreleasepool-dadır.

### Remaining work
- Real Android qeyri-xətti scale, interaktiv scroll, cihaz/emulator, fokus naviqasiyası, TalkBack, disabled izahın accessibility əlaqəsi və ana dili redaktoru ayrıca scope-dur.
- Runtime/persistence/idempotency/provider/policy və oyun implementasiyası başlanmayıb.
- 49 278 capture fərdi baxılmayıb; contact sheet-lər kiçildilmiş action kəsikləridir. Bəzi sheet annotation mətnləri qismən kəsilmiş görünür; case identity üçün index və native adları istifadə edilir. Bu, native product mətn kəsilməsi deyil.

### Relevant files
- design/states/D2-payment-control-matrix-v15/{decision,measurements,verification,visual-review,extension-pixel-regression}.json; index.html; controls-*.png və native capture-lar
- design/tools/render-v15-payment-control-matrix.swift; render-v15-payment-control-matrix-contact.swift
- design/tools/verify-v15-payment-control-matrix.py; audit-v15-payment-control-pixels.swift; build-v15-payment-control-matrix-index.py
- design/states/D2-payment-control-extension-v15/decision.json → designAcceptance
- design/states/D1-D6-design-v15/review.json → paymentMatrix.controlStateMatrix

### Checks performed
- Swift optimized compile və render exit0. Full cross-product, PNG header/ölçülər, safe/text/action bounds, pairwise overlap, minimum48dp, mətn/role/sıra/enabled/operationId, focused/pressed və bütün interaction geometry regressiyası keçdi.
- Qəbul edilmiş extension-in 232 halı ilə bütün item geometry və state metadata eynidir; 545 capture decoded RGBA piksel müqayisəsi: 0 fərq.
- missingGlyphs=0; yalnız bundled NotoSans Regular/SemiBold/Bold və Symbols Regular. ui-craft explicit nav/paper kontrastı 10.994:1; dekorativ tekstura və tam disabled auditinə şamil edilmir.
- 8×5 payment modes verifier keçdi. Baxılmış native renderlərdə görünən clipping/collision müşahidə edilmədi. Mətn ölçmələri OCR/runtime sübutu deyil.
- Təkrar: swiftc -O -module-cache-path /tmp/barterune-swift-cache design/tools/render-v15-payment-control-matrix.swift -o /tmp/render-payment-control-matrix; binary-ni arqumentsiz işə sal. --resume yalnız tam dəyişməz source/renderer üçün yarımçıq run davamıdır; mənbə dəyişəndə işlətmə. Contact Swift-i ayrıca compile/run et. Pixel audit Swift-i compile/run et, sonra python3 design/tools/verify-v15-payment-control-matrix.py; python3 design/tools/build-v15-payment-control-matrix-index.py.

### Exact next step
- Bu vahid tamamdır. Yeni chatdə bu son bölmə və D2-payment-control-matrix-v15/decision.json oxunsun; yalnız ayrıca verilən növbəti dizayn/device/accessibility scope-u tətbiq edilsin. Oyun koduna ayrıca göstərişsiz başlama.

## D2 fokus və accessibility davranış spesifikasiyası — 4 noyabr 2026

### Completed
- `design/states/D2-focus-accessibility-v15.md` hazırlandı: input/TalkBack fokus fərqi, semantik sıra, ilkin fokus, Tab/D-pad, press lifecycle, disabled səbəb əlaqəsi, status elanları, scroll və bərpa qaydaları.
- 18 Given/When/Then qəbul ssenarisi, icra əhatəsi və evidence qeyd tələbləri yazıldı.

### Current state
- Sənəd hazırdır; bütün qəbul ssenariləri NOT RUN. Production/device/accessibility pass iddiası yoxdur.
- Oyun kodu, tokenlər, localization, fixture və qəbul edilmiş matris qərarları dəyişməyib.

### Decisions
- Disabled primary input keçidindən çıxır, TalkBack semantikasında disabled və səbəbi ilə qalır. Pending/unknown Back aktivdir.
- State yenilənməsi TalkBack fokusunu primary-yə məcbur etmir; input primary disabled olduqda Back fallback-dır. Yeni elanlar polite və state dəyişikliyinə bağlıdır.
- D2 davranış qaydaları platforma faktlarından ayrılıb; Android-in rəsmi semantics/traversal sənədlərinə istinad var.

### Remaining work
- Android harness/device icrası, nonlinear scale, TalkBack audio/event sübutları, D-pad-only scroll uyğunlaşdırılması və native-language editorial təsdiqi.
- Runtime/persistence/provider/idempotency/policy və oyun implementasiyası ayrıca scope olaraq qalır.

### Relevant files
- design/states/D2-focus-accessibility-v15.md
- design/states/D2-payment-control-matrix-v15/decision.json
- design/states/D2-payment-modes-v15-fixtures.json
- design/states/D2-payment-localization-v15.json

### Checks performed
- Mənbə state/enabled/etiket mənaları və matris qərarları ilə sənəd uyğunluğu nəzərdən keçirildi; AC ID və qayda istinadları yoxlandı.
- Sənəd işi: render, cihaz, TalkBack və oyun testləri icra edilmədi. Workspace-də git metadata olmadığı üçün git diff/status alınmadı.

### Exact next step
- Bu son bölmə və D2-focus-accessibility-v15.md oxunsun. Ayrı göstəriş verilərsə sənəddəki AC-lər üçün yalnız dizayn test harness/device scope-u müəyyənləşdirilsin; oyun koduna başlanmasın.

## D2 Android harness və cihaz sınağı scope — 4 noyabr 2026

### Completed
- `design/states/D2-android-harness-device-scope-v15.md` yazıldı: ayrıca offline debug-only Compose harness, fixture/state driver, action/focus/event evidence, emulator/fiziki cihaz slotları və AC01–AC18 yoxlama xəritəsi.
- Plan: 3360 native baza halı avtomatik yoxlama; 40 manual dil/state/layout hüceyrəsi, ayrıca keçid və cihaz regressiyaları. Bunlar nəticə sayı deyil, nəzərdə tutulan əhatədir.

### Current state
- Yalnız scope hazırdır. Harness, testlər və cihaz inventarı icra edilməyib; bütün sınaqlar NOT RUN.
- Mövcud tokenlər, dizayn qərarları, fixture/localization və oyun kodu dəyişməyib.

### Decisions
- Ayrı `design/android-d2-harness/` Gradle root nəzərdə tutulur; oyun modullarından asılılıq və provider yoxdur.
- Android native nonlinear scale Swift linear rasterdən ayrılır; platformalararası pixel equality qəbul meyarı deyil.
- E34/E-current emulator və H-phone/H-large fiziki slotları planlaşdırılır; inventar çatışmazlığı gizlədilmir.
- D-pad-only scroll və TalkBack announcement queue açıq risklərdir; uğursuzluğu spesifikasiyanı səssiz dəyişməklə həll etmək olmaz.

### Remaining work
- Ayrı implementasiya göstərişindən sonra toolchain/adb/device inventarı, minimal isolated harness və confirm/pending spike; sonra AC genişlənməsi.
- Oyun inteqrasiyası və runtime/provider/persistence scope-dan kənardır.

### Relevant files
- design/states/D2-android-harness-device-scope-v15.md
- design/states/D2-focus-accessibility-v15.md
- design/states/D2-payment-control-matrix-v15/decision.json

### Checks performed
- AC01–AC18 xəritəsinin tamlığı script ilə yoxlandı; sənəd və əvvəlki davranış spesifikasiyası oxunub uyğunlaşdırıldı.
- Android rəsmi accessibility testing və Android 14 nonlinear scaling sənədləri yoxlandı, scope-a linkləndi.
- Build, render, emulator, fiziki cihaz və TalkBack testləri edilmədi.

### Exact next step
- Yeni chatdə bu son bölmə və iki D2 scope/spec sənədi oxunsun. İstifadəçi harness implementasiyasını istəsə yalnız toolchain/cihaz inventarı və minimal confirm/pending spike vahidindən başla; oyun koduna toxunma.


## M1 — skeleton + engine (feat/m1-skeleton-engine) — 5 noyabr 2026

### Completed
- Root Gradle (AGP 8.9.1, Kotlin 2.1.10, Gradle 8.13, version catalog). Modullar: `:app` (com.aladdin.barterune, target/compile 36, minSdk 24 müvəqqəti), `:engine` (saf JVM), `:content` (schema + `classic-v1.json`, B01–B03), `:core:designsystem`, `:core:database` (Room), `:core:data` (GameRepository), `:feature:market`.
- Engine: `BuyGoods`/`SellBatch`, revision yoxlaması, bütün imtina səbəbləri, B03 qiymət/təsir/ehtiyat tavanı, Long pul + overflow yoxlaması.
- Room: `save_slot` (versiyalı JSON snapshot) + `command_log` (eyni commandId iki dəfə tətbiq olunmur).
- UI: D1-P3 master/detail bazar + D1-keypad miqdar ekranı; tokenlər D6 proposal + D1 composition geometry (2 px = 1 dp); art `design/tools/export-m1-drawables.swift` ilə kəsilib.
### Current state
- `android-billing` toxunulmayıb, ayrıca build kimi qalır (host inteqrasiyası M5).
- `config/firebase/google-services.json` varsa app build-i onu `app/`-a kopyalayıb google-services plugin-i tətbiq edir (gitignored). Firebase SDK hələ əlavə edilməyib.
### Decisions
- Hilt əvəzinə M1-də manual `AppContainer`. Telefon üçün P3 düzülüşü: siyahı eni = min(580dp, yarı en) — telefon master/detail PNG-si yoxdur.
- `feature:market` compileSdk 35 (Paparazzi 1.3.5 + android-36 crash; Arrowz ilə eyni workaround).
### Remaining work
- M1.5 playtest (iki şəhər, səyahət); WaitDay/gün dalğalanması; batch seçimi UI; TR/RU/EN; real cihaz/emulator yoxlaması; minSdk qərarı.
### Relevant files
- engine/src/main/kotlin/barterune/engine/TradeEngine.kt, content/src/main/resources/content/classic-v1.json
- core/data/src/main/kotlin/barterune/core/data/RoomGameRepository.kt
- feature/market/src/main/kotlin/barterune/feature/market/MarketScreen.kt
### Checks performed
- `./gradlew clean assembleDebug testDebugUnitTest :engine:test :content:test :feature:market:verifyPaparazziDebug` — BUILD SUCCESSFUL; 22 test, 0 xəta. Restart testi (Robolectric, DB bağla/yenidən aç) eyni RunState verdi.
- Paparazzi render-ləri D1-P3 və D1-keypad PNG-ləri ilə yan-yana müqayisə edildi (output/m1/, commit edilmir). Emulator/cihazda yoxlanmayıb.
### Exact next step
- İstifadəçi branch-ı nəzərdən keçirib OK versin; sonra M1.5 üçün ayrıca branch.

## D1 P2/P3 dil və şrift matrisi — 5 noyabr 2026

### Completed
- P2 və P3 üçün mövcud 30 D1 vəziyyəti × AZ/TR/RU/EN × 1.0/1.3/2.0: 720 kombinasiya, 3313 scroll PNG. İndeks və 8 kontakt lövhəsi hazırdır.
### Current state
- `design/states/D1-device-matrix-v15/`; yalnız statik Swift/CoreText dizayn renderi. Oyun/harness kodu dəyişməyib; əvvəlki v15 saxlanılıb.
### Decisions
- Mənbə generator 29 vəziyyət verirdi; ayrıca tarixi `equipment-final` 30-cu vəziyyət kimi daxil edildi.
- P2 2400×1080/3×, sol cutout 32dp; P3 2560×1600/2×. Mövcud token/art/localization saxlanılıb.
- 1.3x/2.0x kartlarda bir sütun; məlumat və detalları aç düyməsi ayrıdır. Scroll kənarında qismən sətirlər nəzərdə tutulur; hər sətir və bütöv action ən az bir capture-da görünür.
### Remaining work
- Android nonlinear font scaling, real scroll/touch/TalkBack və ana dili redaktəsi yoxlanmayıb. Bütün 3313 PNG fərdi nəzərdən keçirilməyib.
### Relevant files
- design/tools/render-d1-device-matrix-v15.swift
- design/tools/verify-d1-device-matrix-v15.py
- design/tools/render-d1-device-matrix-contact.swift
- design/states/D1-device-matrix-v15/{index.html,README.md,review.json,verification.json,coverage.json}
### Checks performed
- Swift compile/render exit0; verifier:720 kombinasiya,3313 düzgün native PNG ölçüsü,missingGlyphs=0,allChecksPassed=true. Nav/paper kontrast10.994:1.
- 8 kontakt lövhəsində128 başlanğıc thumbnail, əlavə native P2 AZ preview/P3 AZ detail/P2 AZ2 cards/P2 RU1.3 cards/P3 RU2 preview/P2 RU2 quantity nümunələri açılıb baxıldı. Native scroll kənar clipping nəzərdə tutulur.
### Exact next step
- Bu vahid tamamdır. İstifadəçi `D1-device-matrix-v15/index.html` ilə nəticələrə baxsın; yeni iş verilərsə yalnız konkret ekran/device düzəlişindən başla. Bu nəticə oyun implementasiyasına yeni göstəriş deyil.

## D1 sabit klaviatura + Qızıl qərarı — 5 noyabr 2026

### Completed
- İstifadəçinin 12 bəndlik siyahısından 2/7: telefon və planşet üçün sabit klaviatura statik dizaynı. P1/P2/P3 × AZ/EN/RU/TR × 1.0/1.3/2.0 × 6 valid/error vəziyyəti:216 hal,222 PNG.
- 9: istifadəçi açıq seçim sualında “Qızıl” seçdi; docs/decisions.json → designResolutions.D1-currency-name daxilində təsdiqlənmiş qərardır.
### Current state
- `design/states/D1-keypad-fixed-v16/`; əvvəlki v15 matrisinə toxunulmayıb. Yeni renderer və verifier ayrıca fayllardır. Oyun/runtime kodu dəyişməyib.
### Decisions
- Giriş sahəsi,12 düymə və Geri sabitdir; yalnız sol təlimat sahəsi lazım olsa scroll olur. Telefon split layout; planşetdə bounded iki panel və vertikal mərkəzlənən klaviatura.
- Geri redaktəni ləğv edir, əvvəlki miqdarı bərpa edir və açıldığı detal/önbaxışa qaytarır. ✓ yalnız miqdarı tətbiq edir; ticarət etmir. Invalid giriş saxlanır, ✓ passivdir.
- Mövcud proposal tokenləri saxlanılıb; bu iş onları production-approved etmir. Tarixi PNG-lərdə Pul qalır; Qızıl ümumi localization/yenidən render mərhələsində tətbiq olunmalıdır.
### Remaining work
- 3/4: Al/Sat önbaxışına açıq giriş düymələri və axın; bazar siyahısında Back göstərilməməsi/qaydasının dizaynı.
- 5/6: v15 normalized atlas-dakı yeddi ikonun v7 tipli siyahı/kartlara tətbiqi; zədəli partiyanın satış qiyməti ilə marjanın qaydasını tutuşdurmaq.
- 10/11/12: təsdiqlənmiş token cədvəli, animasiya müddətləri/storyboard,1160dp həddinin ölçmə ilə yoxlanması. Bunlar hazırlanmayıb/təsdiqlənməyib.
- 1/8 əvvəlki D1-device-matrix-v15 daxilində statik hazırdır; yeni fixed keypad revision həmin tarixi PNG-lərə birləşdirilməyib. Android nonlinear scale, real cihaz və TalkBack yoxlanmayıb.
### Relevant files
- design/tools/render-d1-keypad-fixed-v16.swift; design/tools/verify-d1-keypad-fixed-v16.py
- design/states/D1-keypad-fixed-v16/{index.html,verification.json,decision.json}
- docs/decisions.json → designResolutions.D1-currency-name
- design/states/D1-device-matrix-v15/; design/states/D1-render-localization.json
### Checks performed
- Swift compile/render exit0:216 hal,allFit=true,missingGlyphs=0. Verifier:222 düzgün native PNG ölçüsü,13 control minimum48dp/safe bounds,geometry eyni profil/dil/scale daxilində valid/error vəziyyətlərində sabitdir. Palitra dəyişməyib.
- view_image: P2 AZ2 valid,P1 RU2 seven-digits,P3 EN2 valid native renderləri baxılıb; sabit düymələr və Geri görünür. Bütün PNG fərdi baxılmayıb. Runtime/device test yoxdur.
### Exact next step
- Yeni chatdə bu son bölmə və D1-keypad-fixed-v16/decision.json oxunsun. Növbəti kiçik vahid kimi yalnız 3/4: detal → Al/Sat önbaxış axını və bazar kök ekranının Back davranışı hazırlansın. Sonra 5/6 ayrıca vahid olsun; bütün12 bəndin bitdiyini iddia etmə.


## D1 beş hissə — v17 baxış paketi, 5 noyabr 2026

### Completed
- Yeddi mövcud atlas ikonunun P1/P2/P3 siyahı/kart nümunələri; token cədvəli; Back davranışı; planşet hədd təklifi; üç keçidin müddət/easing/reduced-motion spesifikasiyası və sxematik storyboard.
### Current state
- Yalnız statik dizayn paketi; runtime dəyişməyib. 32 PNG. İstifadəçi təsdiqi deyil. Əvvəlki uncommitted kod və sənəd dəyişiklikləri ayrıca saxlanıb.
### Decisions
- Root Back gizli; detail → LIST, keypad cancel → açıldığı bölmə. Master-detail safeWidth616dp; fontScale≥1.3 üçün1196dp namizəddir; kodun1160dp həddi dəyişməyib. Motion800/240/180ms, reduced0ms təklifdir.
### Remaining work
- İstifadəçi rəyi; planşet real boundary ölçmə/state matrisi; Android nonlinear scaling/cihaz/scroll/touch; final animasiya art və runtime. Dizaynı olmayan hissələr gözləyir.
### Relevant files
- design/states/D1-review-v17/{README.md,tokens.json,interaction.json,motion.json,verification.json}
- design/tools/render-d1-review-v17.swift
### Checks performed
- Swift compile/render;32PNG;missingGlyphs0; JSON/PNG sanity. Kontrast7.85/10.99. P1 kart/P2 son ikon səhifəsi/P3 RU2/storyboard nümunələri vizual baxılıb. Bütün PNG fərdi yoxlanmayıb; app build və runtime test yoxdur.
### Exact next step
- Yeni chatdə v17 README və istifadəçinin konkret rəyini oxu; yalnız göstərilən düzəlişi et. Təsdiq olmadan production token/hədd/motion qərarı kimi tətbiq etmə.
