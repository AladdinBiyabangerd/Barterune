# Barterune — Android kod və buraxılış planı

Tarix: 2 noyabr 2026; Spark texniki yeniləməsi: 3 noyabr 2026. Status: detallı icra layihəsi; implementasiyaya başlama icazəsi deyil. D1–D6 dizaynları və açıq balans qərarları tamamlanmadan yekun icra spesifikasiyası sayılmır. Narrativ AZ, kod identifikatorları EN.

## 1. Mənbələr və qərarların üstünlüyü

Oyun qaydaları: `docs/decisions.json`; dizaynın hazır olma vəziyyəti: `docs/design-coverage.json`; monetizasiya: `docs/MONETIZATION_PLAN.az.md`. Bu sənəd onların texniki tətbiqini müəyyənləşdirir, açıq qaydanı özündən tamamlamır. Arrowz-un `/Users/mac/My Workspace/arrowz/design/PLAN.md` sənədindən mərhələ, asset xəritəsi və qəbul meyarı quruluşu nümunə götürülüb; onun ürək, coin, banner, puzzle və digər funksiyaları Barterune-a köçürülmür.

Bu chatdə istifadəçinin təsdiqlədikləri:

- İlk açılışda məcburi Google girişi. Qonaq rejimi yoxdur.
- İlk girişdən sonra əsas oyun offline işləyir.
- Bulud yaddaşı və Android cihazları arasında davam var.
- İlk buraxılışda onlayn rekordlar və nailiyyətlər var.
- Yalnız Android telefon və planşet; AZ/TR/RU/EN.
- Məhsul 13+ auditoriya üçün hazırlanır; IARC nəticəsi ayrıca müəyyənləşir.
- Play Console şəxsi hesabdır; hesabın yaradılma tarixi məlum deyil. Play Console, AdMob və Unity başqa tətbiq üçün mövcuddur; Barterune tətbiq/məhsul ID-lərinin hazır olduğu təsdiqlənməyib.
- Ranked səfər internetlə start qeydiyyatı alaraq başlanır (§8), sonra offline tamamlana bilər. Tam offline başlanmış səfər yalnız şəxsi rekord verir.
- V1 yalnız classic-dir; supported sonrakı mərhələyə saxlanır.
- İlkin beş nailiyyət kataloqu qəbul edilib; dəqiq trigger-lər hələ açıqdır.
- Privacy və hesab silmə səhifələri digər tətbiqdəki kimi GitHub Pages (`github.io`) üzərində idarə ediləcək; konkret URL və işlək silmə müraciəti axını hələ müəyyənləşməyib.

DT09 — 3 noyabr 2026: istifadəçi Kotlin + Jetpack Compose seçib. Xəritə və at arabası kimi yüngül hərəkətlər Compose Canvas/animasiya vasitələri ilə qurulacaq. Digər kitabxana və arxitektura detalları aşağıda texniki tövsiyədir. Mövcud təsdiqlənmiş oyun dizaynı üfüqidir; böyük ekran üçün sadəcə telefon şəklini böyütmək olmaz.

## 2. Buraxılış sərhədi

V1: dörd şəhər, on mal, 20 günlük səfər, üç yuva, bazar/satış, partiyalar və keyfiyyət, xəritə və marşrut, xəbər/şayiə, hadisələr, xidmət müqavilələri, borc/bərpa işi, təkmilləşdirmə, şəhər checkpoint-i, yekun hesablaşma, şəxsi və onlayn rekordlar, nailiyyətlər, təlim, ayarlar, Google hesabı, cloud sync, hesab silmə, kosmetik mağaza və könüllü rewarded reklam.

Daimi inkişaf rejimi sonrakı mərhələdir. İstifadəçi qərarı ilə V1 yalnız classic-dir. Supported səfər sonrakı mərhələyə saxlanır; V1-də onun seçimi və iqtisadi reklam mükafatları açılmır. Monetizasiya planındakı supported təklifləri V1 tələbi deyil. Multiplayer, chat, oyunçulararası mal/valyuta ötürülməsi, abonəlik və məcburi bildiriş bu V1 scope-na daxil edilmir. Bildiriş funksiyası olmadığı üçün notification icazəsi soruşulmur.

Google Play müəyyən sayda ekran, Google girişi, cloud save, nailiyyət və ya leaderboard tələb etmir. Bunlar məhsul funksiyalarıdır. Minimum funksionallıq üçün bizim qəbul hədəfimiz tam oynanıla bilən dövr, düzgün saxlanma, mənalı məzmun və işləyən idarələrdir; mağaza və giriş ekranlarından ibarət demo buraxılmır.

## 2.1. Son istifadəçi qərarı: Spark və ödənişli yükləmə

2 noyabr 2026: Firebase yalnız pulsuz **Spark** planında işləməlidir. Blaze və billing hesabı qoşulması təsdiqlənməyib; pulsuz istifadə kvotalı Blaze bu qərara bərabər deyil. Google Play-də oyun ödənişli yüklənəcək; qiymət hələ açıqdır. Ödənişli oyunla yanaşı könüllü reklam və kosmetik alışlar qalır; V1 yenə yalnız classic-dir.

V1 texniki sərhədi: Firebase Authentication + Cloud Firestore-un Spark kvotası; Android client birbaşa Firebase SDK ilə işləyir. Cloud Run, Cloud Functions, Cloud Tasks, Cloud Storage, reklam SSV endpoint-i və gameplay server replay bu mərhələyə daxil deyil. 3 noyabr yeniləməsi: kosmetik IAP üçün ayrıca AppBackend alış doğrulaması və server hüquq reyestri hazırlanıb; bu, Firebase Spark save/sync sərhədini dəyişmir. Mobil adapter `android-billing/README.md`, backend müqaviləsi isə `/Users/mac/My Workspace/AppBackend/docs/barterune-billing.md` daxilindədir. Adapter hazırdır, host inteqrasiyası və canlı provider yoxlaması tamamlanmayıb. GitHub Pages yalnız privacy/deletion veb axınını host edir. Billing hesabı, Blaze, deploy və Console dəyişikliyi bu sənəd işi ilə icazələndirilmir.

Online + offline oyun saxlanır. Rules UID icazəsini, sahələri, revision keçidlərini və atomik deduplikasiyanı məhdudlaşdırır; lokal gameplay hesabının, reklam callback-inin və Play alışının həqiqiliyini sübut etmir. Onlayn nəticələr client tərəfindən hesablanır. App Check + Play Integrity əlavə qoruma namizədidir, etibarlı iqtisadiyyat serverinin əvəzi deyil. Gameplay server replay və reklam SSV gələcək ayrıca mərhələdir; IAP doğrulaması §12.2-dəki AppBackend yolundadır.

§3–8, §12, §14 və M3–M5 aşağıda bu modelə uyğunlaşdırılıb. Bu, texniki layihədir; minSdk, məhsul qərarları və release yoxlamaları açıq olduğu üçün bütöv plan hələ icraya hazır deyil.

Ödənişli yükləməni Play Store idarə edir; bunu oyun daxilində ikinci unlock alışına çevirmək nəzərdə tutulmur. Kosmetik IAP ayrıca Play Billing axınıdır. Console-da tətbiqin indiki free/paid statusu yoxlanmayıb və dəyişdirilməyib. Google-a görə əvvəl pulsuz təklif edilmiş tətbiq eyni paket adı ilə sonradan ödənişli edilə bilmir; buraxılışdan əvvəl uyğunluq yoxlanmalıdır.

Rəsmi mənbələr (2 noyabr 2026): [Firebase planları](https://firebase.google.com/docs/projects/billing/firebase-pricing-plans), [Storage billing tələbi](https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024), [Play qiymətləndirmə](https://support.google.com/googleplay/android-developer/answer/6334373?hl=en).

## 3. Texnologiya və səbəbi

- Kotlin + Jetpack Compose: məlumat və idarəetmə ağırlıqlı 2D oyunda bazar, inventar, modal və lokalizasiya üçün. Material3 yalnız baza davranışları; görünüş Barterune komponentləri ilə verilir.
- Compose Canvas: xəritə, yol xətləri, şəhər hotspot-ları və qısa araba hərəkəti. Unity/Godot və WebView bu scope üçün tələb olunmur; ayrıca oyun mühərriki yükü daşımırıq.
- Saf Kotlin/JVM `engine`: qiymət, gün, yük, hadisə, borc və nəticə qaydaları. Android/Firebase asılılığı yoxdur; deterministik lokal yoxlama və save migration üçün istifadə olunur. V1-də server replay yoxdur.
- Coroutines/Flow, ViewModel, dəyişməz `UiState`, tək istiqamətli state axını; Hilt ilə asılılıqlar.
- Room: səfərlər, checkpoint, jurnal, outbox və lokal cache; Proto DataStore: dil, səs, görünüş, təlim və bazar list/card seçimi. Oyun iqtisadiyyatı DataStore-a bölünmür.
- Kotlin Serialization: versiyalı save və content JSON. WorkManager: internet olduqda sync və təkrar göndərmə. Bulud əməliyyatlarında autentifikasiyalı Firebase SDK və TLS; ayrıca REST backend yoxdur.
- Credential Manager + Google ID + Firebase Authentication: Google hesabı. Köhnə GoogleSignInClient əsaslı yeni axın qurulmur. Firebase UID daxili hesab açarıdır, e-poçt deyil.
- Seçilmiş backend sərhədi: Firebase Authentication və Cloud Firestore Spark. Firestore Security Rules, indeks təsvirləri və Emulator Suite qayda sınaqları ayrıca fayllarda versiyalanır. Private save və minimal public rekord məlumatları ayrılır; böyük jurnal/asset Firebase Storage-a göndərilmir. Lokal outbox bulud təsdiqini izləyir (§7).
- Play Games Services v2 nailiyyət inteqrasiyası namizəddir; dəqiq SDK seçimi inteqrasiya uyğunluğu yoxlamasında qalır. Google/Firebase girişi PGS sessiyasını avtomatik təsdiqləmir. Əsas onlayn cədvəl Firestore-da client nəticələrini saxlayır; serverdə doğrulanmış adlandırılmır. PGS yoxdur/xəta verir halları əsas oyunu bloklamır.
- AdMob rewarded + UMP; mövcud Android adapterində Play Billing 9.1.0. Crashlytics; analitika yalnız təsdiqlənmiş event kataloqu və uyğun privacy konfiqurasiyası ilə.
- Gradle Kotlin DSL, version catalog və dependency locking. Dəqiq Kotlin/AGP/Compose/Firebase versiyaları skeleton mərhələsində qarşılıqlı uyğun stable versiyalardan pin olunur; bu sənəd yoxlanmamış patch nömrəsi təyin etmir. Toolchain AGP tələbinə uyğun seçilir.

## 4. Layihə quruluşu

```text
app/                         # Activity, nav, DI, lifecycle, manifest
engine/                      # pure JVM: model, commands, rules, RNG, replay
content/                     # cities, goods, routes, events, balance versions
core/designsystem/           # tokens, fonts, components, asset registry
core/database/               # Room entities, DAO, migrations, transactions
core/data/                   # repositories, mappings, save export/import
core/auth/                   # Google/Firebase sessions, account switch/delete
core/sync/                   # snapshots, outbox, revision conflicts, WorkManager
core/network/                # Firebase adapter helpers, retry/error models
core/monetization/           # billing, rewarded, consent, entitlements
core/gameservices/           # PGS bridge, achievement publication queue
core/telemetry/              # crash and event interfaces, redaction
feature/onboarding/          # language, Google login, restore, tutorial
feature/home/                # main menu, three slots, new run, profile
feature/market/              # list/cards, quantity, buy/sell previews
feature/cargo/               # grouped goods, quality batches
feature/map/                 # map transforms, routes, travel, arrival
feature/events/              # choice, result, blocked route, final-day rescue
feature/city/                # upgrades, creditor, work, guide/guard
feature/results/             # final sale, ledger, personal records
feature/social/              # client-reported online records, achievements
feature/settings/            # sound, locale, motion, privacy, account, support
feature/shop/                # cosmetics, preview, purchases, reward inbox
firebase/                    # Firestore rules, indexes, emulator rule tests (no server)
docs/                        # plans, asset manifest, policy and release evidence
```

Feature-lər repository interfeyslərindən istifadə edir; UI birbaşa Firebase/DAO çağırmır. Başlanğıcda hər feature-ni ayrıca Gradle moduluna çevirmək məcburi deyil: paket sərhədləri qorunur, build vaxtı və asılılıqlar tələb etdikcə ayrılır. `engine` və Android sərhədi əvvəldən ayrıdır.

## 5. Modellər və oyun əmrləri

`AccountProfile(uid, createdAt, schemaVersion)`, `AccountProgress(unlocks, cosmetics, achievements)`, `SaveSlot(slotId, runId, revision, syncState)`, `RunState(runId, lineageId, seed, rngState, rulesetVersion, contentVersion, day, cityId, gold, capacity, phase, rewindUsed)`, `CargoBatch(batchId, goodId, quantity, quality, acquisitionCost)`, `MarketState(cityId, day, prices, stock, revision)`, `Debt`, `ServiceContract`, `UpgradeState`, `NewsObservation`, `PendingEvent`, `Checkpoint`, `RunResult`, `CommandLog`, `SyncOutbox`, `Entitlement`, `RewardGrant`, `CloudSlotEnvelope`, `AccountControl`, `OnlineRunRegistration`. Son üç model aşağıdakı Spark protokolunun layihəsidir; server təsdiqi daşımır.

- Pul vahidləri `Long` ilə tam ədəd; miqdar və vurma üçün overflow yoxlaması. Floating point ilə pul hesablanmır. Yuvarlaqlaşdırma və faiz vahidi balans spesifikasiyasında müəyyənləşir.
- `BuyGoods`, `SellBatch`, `StartTravel`, `ChooseEventOption`, `WaitDay`, `TakeLoan`, `RepayDebt`, `HireService`, `Upgrade`, `LoadCheckpoint`, `FinalizeRun` engine əmrləridir. Hər biri command ID, gözlənən revision, doğrulama, nəticə və ledger delta qaytarır.
- Preview mutasiya etmir. Miqdar OK yalnız forma dəyərini dəyişir; Al/Sat ayrıca əmrdir. Ləğv əvvəlki miqdarı qaytarır. 6 rəqəm həddi və ayrı alış/satış maksimumları `designResolutions` qaydasından götürülür.
- Alış maksimumu pul/tutum/ehtiyat; satış maksimumu seçilmiş partiya üzrədir. Əməliyyat anında qiymət revision-u və bütün şərtlər yenidən yoxlanır. Böyük ticarətin qiymətə təsiri əməliyyatdan sonra baş verir.
- Hadisə əvvəl seed/RNG və seçimləri ilə yazılır, sonra göstərilir. Seçim nəticəsi və pul/yük/gün dəyişikliyi bir tranzaksiyada yazılır. Yenidən açılış nəticəni yeniləmir.
- `FinalizeRun` qalan yük satışı, borc, nəticə və completion ID-ni atomik yaradır; təkrar toxunuş yenidən satış etmir. Təkmilləşdirməyə yekun qalıq dəyəri verilmir.
- Checkpoint yalnız run vəziyyətini qaytarır. `rewindUsed` lineage üzrə monoton qalır; hesab kosmetikası, grant, reklam limiti və satınalma geri qaytarılmır. Nəticə kateqoriyası `mode + ruleset + rewindUsed + rulesetVersion` ilə ayrılır.
- Content/balance versiyası başlanmış səfərdə pin olunur. Yeni konfiqurasiya köhnə səfərin qiymətlərini və təsadüfi nəticələrini səssiz dəyişmir.

## 6. Google girişi və offline davranış

İlk axın: sistem splash → dil → Google ilə davam → hesab/bulud baxışı → lazım olduqda restore → təlim/əsas menyu. Məxfilik keçidi giriş ekranından da açılır. Reklam razılığı yalnız aid axında, ilk reklam sorğusundan əvvəl həll olunur.

İlk cihaz girişi internet tələb edir. İmtina, hesab tapılmaması, Play Services problemi, şəbəkə və server xətası üçün ayrıca retry/back halları var. Giriş ləğv ediləndə oyun qonaq hesabı yaratmır. Sonrakı açılışlarda həmin UID-yə bağlı lokal save ilə offline davam edilir; bulud, reklam, alış və onlayn cədvəl əlaqə gözləyir. Tokenin yenilənməsi şəbəkə olmadığından alınmayanda lokal səfər silinmir.

Google credential Firebase Authentication-a verilir; Firestore sessiyası və Rules `request.auth.uid` ilə hesab sərhədini qoruyur. APK-də Admin SDK/service-account sirri yoxdur. Debug/release və Play App Signing izləri OAuth/Firebase konfiqurasiyasında ayrıca yoxlanır. PGS player ID client-dən gəlirsə etibarlı UID əlaqəsi kimi qəbul edilmir; e-poçt bərabərliyi ilə hesab birləşdirilmir.

Hesab dəyişməzdən əvvəl pending sync xəbərdarlığı; Room/cache/outbox UID üzrə ayrılır. Çıxışda listener və işlər dayandırılır, gecikmiş callback əvvəlki UID nəticəsini yeni hesaba yazmır. Yeni cihaz bulud məlumatını almayınca mövcud hesabın boş ilkin state-ini buluda yazmır.

### 6.1. Arrowz əsaslı hesab silmə layihəsi

3 noyabr 2026 istifadəçi qərarı: hesab silmə axını Arrowz-dakı kimi olacaq. İstinad: `/Users/mac/My Workspace/arrowz/app/src/main/kotlin/com/aladdin/arrowz/account/AccountCoordinator.kt` (`deleteAccount`, `deleteSteps`, `reauthGoogleAndDelete`) və `ui/AccountRoutes.kt` (`DeleteAccountViewModel`). Əsas davranış: təsdiq → lazım olduqda silmədən əvvəl təzə Google girişi → cloud save/backuplar və əlaqəli public hesab məlumatlarının təmizlənməsi → Firebase Auth-un ən sonda silinməsi; xəta zamanı uğur göstərilmir, yenidən cəhd mümkündür. Barterune billing server baryeri və lokal journal təmizliyini bu ardıcıllığa daxil etməlidir; bu inteqrasiya hələ hazırlanmayıb.

Barterune üçün dəqiqləşdirilmiş istifadəçi qərarı (3 noyabr 2026): hesab silinəndə həmin hesaba aid bütün lokal oyun məlumatları da silinir; lokal irəliləyiş qonaq kimi saxlanmır, anonim/qonaq sessiyası yaradılmır. Lokal save/backup, Room məlumatları, cache, sync outbox və billing journal/cache təmizliyi silmə axınına daxildir. Firebase Auth silindikdən sonra lokal təmizlik yarımçıq qalarsa növbəti açılışda həmin UID üçün tamamlanır; təmizlik bitənədək köhnə oyun məlumatları göstərilmir. Sonra məcburi Google giriş ekranı açılır. Bu qərar DT07 üzrə yeni UID-yə alış restore/transfer qadağasını dəyişmir. Arrowz-dan reauth, cloud-first/Auth-last və xəta/retry ardıcıllığı götürülür; onun guest davranışı götürülmür. Aşağıdakı protokol implementasiya olunmamış texniki layihədir.

Online reauthentication → `accountControl/{uid}.status=deleting` → bütün bulud yazılarını dayandır → sxemdəki şəxsi/public sənədləri sil → serverdən boşluğunu yoxla → Firebase Auth istifadəçisini sil → lokal UID məlumatlarını təmizlə. Rules `deleting` zamanı yalnız oxuma/silmə və silmə statusuna aid dar keçidlərə icazə verir. İdarə sənədini client silmir və `deleting → active` keçidini aça bilmir. Bu minimal UID/status baryeri köhnə tokenli cihazın məlumatı yenidən yazmasını bloklayır; saxlanma səbəbi və müddəti privacy qərarıdır. Auth silinməsi profil/subcollection-ları avtomatik silmir.

Silmə mərhələləri lokal və control statusunda izlənir, process death/retry eyni işi davam etdirir. Auth ən sonda silinir: aralıq xəta və kvota bitməsi uğur kimi göstərilmir. Auth silinib lokal təmizlik yarımçıq qalarsa növbəti açılış həmin UID-ni təmizləyir. Baryerin vaxtından əvvəl manual silinməsi köhnə token pəncərəsini yenidən aça bilər; operator proseduru bunu nəzərə alır. Avtomatik TTL/extension/job V1 asılılığı deyil.

GitHub Pages deletion səhifəsi: Firebase web SDK ilə eyni Google hesabına giriş/reauth və eyni silmə protokolunu işlədən statik səhifə layihəsi; OAuth authorized domain ayrıca yoxlanır. Tətbiqin quraşdırılması tələb olunmur. Girişə çıxışı itirilmiş şəxs üçün identity yoxlamalı support müraciəti və developer-in manual Console təmizliyi ayrıca prosedurdur; ictimai formadan təsdiqsiz hesab silinmir. URL, support ünvanı, cavab müddəti, minimal baryer/telemetriya saxlanması və PGS məlumatlarının əhatəsi M3/M7-dən əvvəl bağlanmalıdır. Bu işdə veb səhifə yaradılmayıb. Google hesabının özü və Play alış qeydləri silinmir; bunun kosmetika restore-a təsiri §12-də ayrılır.

## 7. Bulud yaddaşı və ziddiyyətlər

### 7.1. Mənbələr və məhdud sxem

Room aktiv oyunun lokal mənbəyidir; Firestore yalnız buluda qəbul edilmiş nüsxənin revision mənbəyidir. Bu qəbul gameplay doğrulaması deyil. Save + command log + outbox bir lokal tranzaksiyada yazılır. Tam jurnal lokal qalır; cloud snapshot səfər, RNG, pin olunmuş engine/content/schema versiyası, checkpoint və lazım olan bərpa məlumatını daşıyır. Checksum yalnız korlanma üçündür.

Sxem layihəsi: `accountControl/{uid}` (active/deleting), `accounts/{uid}` (private progress), `accounts/{uid}/slots/{1..3}`, `accounts/{uid}/runs/{runId}`, `accounts/{uid}/operations/{opId}`, `publicRecords/{uid}/entries/{categoryId}`. Attempt/grant və nailiyyət qəbzləri `operations` daxilində növü müəyyən edilmiş sənədlərdir; yalnız sxemdə tanınan əməliyyat növləri açılır. Arbitrary path və əlavə nested collection yaratmağa icazə yoxdur. Bütün private yollar yalnız həmin UID üçündür; public entry-də yalnız ləqəb, score, kateqoriya və tarix var. Token, e-poçt, cihaz ID-si, alış receipt-i public sənədə düşmür. Sxemdəki bütün yollar silmə inventarına daxildir.

Hər slot envelope-də `revision`, `generation`, `deleted`, `lastOpId`, `updatedAt`, `current` və əvvəlki sağlam `previous` snapshot var. Silinmə payload-ı təmizləyir, generation/revision tombstone-u saxlayır. Hər iki snapshot-un birlikdə ölçüsü Firestore-un 1 MiB sənəd limitindən aşağı olmalıdır; daxili byte həddi və worst-case fixture ölçüsü M0-da təyin edilir. Böyük save səssiz kəsilmir: lokal saxlanır, cloud üçün ölçü xətası göstərilir. Limitsiz tarixçə və tam journal upload yoxdur.

### 7.2. Revision, retry və konflikt

Online transaction slot-u və account control-u oxuyur: active hesab, gözlənən generation/revision və schema uyğundursa `revision+1`, snapshot, previous və sabit `opId` qəbzini atomik yazır. Rules dəyişən sahələri, ardıcıl revision-u və əməliyyatla slot arasındakı `getAfter()` əlaqəsini yoxlamalıdır. Transaction offline işləmir; Room outbox dəyişmir və retry-ni gözləyir. SDK cache/local event bulud uğuru sayılmır; yalnız server commit/receipt təsdiqi statusu dəyişir. Transaction callback-də UI, pul və reklam hüququ dəyişmir, çünki callback yenidən işləyə bilər.

Cavab itəndə eyni `opId` ilə retry əvvəl qəbzi yoxlayır; əməliyyatı yenidən tətbiq etmir. Qəbz eyni payload hash və nəticə revision-u ilə bağlıdır. Köhnə qəbzlərin təmizlənməsi belə köhnə base revision yazısına icazə vermir; saxlanma həddi və səhifəli təmizləmə M0 yük hesabına daxildir. Reward grant/attempt deduplikasiya qəbzləri və ranked run/completion qeydləri adi sync qəbzi kimi silinmir: slot/checkpoint silinməsi onları yenidən istifadə edilən etmir. Onların replay-i bloklayan retention/arxiv qaydası və artan saxlanma xərci M0-da hesablanır; silinmə yalnız hesab silmə inventarı və ya ayrıca təhlükəsiz protokolla olur. Bounded qayda yoxlamaları bütün jurnalı replay etmir.

A və B eyni base-dən fərqli oynayıbsa avtomatik last-write-wins yoxdur. Upload rədd ediləndə lokal branch və bulud branch itkisiz göstərilir; pul/yük/gün/borc ayrı merge edilmir. İstifadəçi seçdiyi nüsxəni ən son cloud revision-a qarşı yeni transaction ilə yayımlayır. İkinci konflikt təkrar seçim tələb edir. Qəbul olunmayan branch lokal ehtiyatda qalır; digər cihaza çatmamış lokal branch üçün cloud backup zəmanəti verilmir.

Slot silmə generation-u artırır; köhnə offline outbox onu diriltmir. Bərpa/yeni səfər yalnız cari tombstone-u oxuduqdan sonra ayrıca istifadəçi əməliyyatıdır, yeni run ID ilə bağlanır. Checkpoint yalnız gameplay-i qaytarır, hesab reklam qəbzlərini və Billing hüquqlarını geri çevirmir. Hesab progress merge-i kosmetik unlock/nailiyyət ID-lərinin idempotent birləşməsi və grant delta-ları ilə edilir; bütün hesab balansı köhnə save-dən overwrite edilmir. IAP aktivliyi ayrıca §12 mənbəyindən gəlir.

### DT08 — qəbul edilmiş backup bərpa siyasəti (3 noyabr 2026)

Ən son cloud save-dən adi davam geri dönüş sayılmır və mövcud rewind statusunu qoruyur. Köhnə backup və ya konflikt nüsxəsindən bərpa geri dönüş sayılır; lineage üzrə rewindUsed=true qalır və sonrakı bərpa ilə silinmir.

Mövcud vaxtında/gecikmiş × geri dönüşsüz/geri dönüşlü rekord kateqoriyaları saxlanır; ayrıca backup kateqoriyası yoxdur. Digər şərtlər ödənən nailiyyətlər mümkündür, lakin geri dönüşlü səfər “geri dönüşsüz bitir” nailiyyətini vermir; əvvəl açılmış hesab nailiyyətləri geri alınmır.

İlkin online-start və bir completion/lineage məhdudiyyəti dəyişmir. Bərpa üçün yeni run ID yaradılması lineage əlaqəsini və rewind işarəsini sıfırlamır, offline startı ranked etmir və ikinci online completion hüququ yaratmır. Hesab reklam/alış qəbzləri və hüquqları köhnə save ilə geri çevrilmir. DT02 retention parametrləri dəyişmir.

Qəbul yoxlamaları (hələ icra edilməyib): ən son cloud save ilə yeni cihazda davam rewind yaratmır, amma mövcud true bayrağı qoruyur; köhnə backup/konflikt bərpası true edir; təkrar bərpa bayrağı silmir; uyğun kateqoriya/nailiyyət seçilir; yeni run ID ilə duplicate completion və offline→ranked keçidi rədd edilir. Bu, məhsul siyasəti təsdiqidir; implementasiyaya başlama icazəsi deyil.

### DT02 — qəbul edilmiş retention parametrləri (3 noyabr 2026)

İstifadəçi 30 gün, slot başına 3 həll edilmiş ehtiyat və 50-lik təmizləmə parametrlərini qəbul edib. Həll edilmiş lokal konflikt ehtiyatı seçim server tərəfindən təsdiqlənəndən sonra 30 gün saxlanır; slot başına ən çox 3 nüsxə üçün dördüncü ehtiyat zamanı ən köhnənin silinməsinə ayrıca razılıq tələb olunur. Həll edilməmiş/nəticəsi naməlum branch avtomatik silinmir. `previous` bir əvvəlki sağlam snapshot olaraq qalır, 30 günlük arxiv deyil.

Adi sync qəbzinin təmizlənməsi üçün server `committedAt` tarixindən ən az 30 gün keçməli, köhnə base artıq qəbul edilməməli və qəbz cari `lastOpId` olmamalıdır. Bir keçid ən çox 50 namizəd oxuyur və 50 uyğun qəbzi silir; növbəti keçid uğurlu sync-dən sonra olur. Reward/attempt/grant/nailiyyət/start/completion qeydləri adi sweep-ə daxil deyil; qəbzi silinmiş köhnə əməliyyat yeni base-ə avtomatik bağlanmır. Ətraflı təhlükəsizlik və qəbul meyarları: `design/states/D5-system-spec.json → technicalAlignment.unresolved → DT02.clarification`.

Bu, parametr təsdiqidir: DT01 tutum/kvota hesabı və DT03 Rules/schema/retry sınaqları açıq qalır. Saxlanma sərt ümumi say həddi ilə məhdudlaşmış sayılmır. B01–B10 dəyişmir; implementasiya icazəsi verilmir.

### 7.3. Kvota və qoruma sərhədi

UI: lokal saxlanıb, gözləyir/offline, sinxronlaşır, buludda saxlanıb, konflikt, kvota/ölçü/icazə xətası. Təhlükəsiz sərhədlərdə outbox coalesce edilir; hər toxunuşda upload və davamlı leaderboard listener yoxdur. Leaderboard səhifəli, limitli və istifadəçi refresh-i ilə oxunur. Şəbəkə xətasına backoff+jitter, auth xətasına reauth, permission/schema xətasına avtomatik sonsuz retry yoxdur. Kvota bitəndə offline oyun davam edir; sync və ilk giriş/onlayn start/mağaza funksiyaları gözləyir və ya əlçatmaz status göstərir.

Spark free quota bütün layihə üçündür: 1 GiB saxlanma, gündə 50 000 read, 20 000 write, 20 000 delete, ayda 10 GiB outbound; bir free database. Rules əlavə oxumaları və retry-lər də hesablanır. TTL, managed backup/PITR pulsuz backup kimi planlaşdırılmır. M0-da aktiv hesab × sync/start/reward sayı, iki snapshot, indeks və qəbz saxlanması ilə tutum hesabı hazırlanır; saylar artdıqda Spark limitsiz xidmət vəd etmir. Console quota müşahidəsi manual əməliyyatdır, billing avtomatik açılmır.

Rules default-deny, UID, sahə allowlist/type/ölçü, enum, immutable ID, revision/generation, request.time və delete baryeri yoxlamaları tələb edir. Public list sorğuları Rules filter deyil prinsipinə uyğun məhdud query istifadə edir. Rules rate-limit xidməti deyil; bir hesabın abuse-u ümumi kvotanı tükədə bilər. App Check/Play Integrity uyğunluğu və enforcement sınağı buraxılışdan əvvəl ayrıca yoxlanır; dəyişdirilmiş client və score/reward saxtakarlığı tam bağlanmır. OS Auto Backup auth materialı və UID cache-ni başqa hesaba daşımamalıdır.

Mənbələr (3 noyabr 2026): [kvotalar](https://firebase.google.com/docs/firestore/quotas), [transaction/offline davranışı](https://firebase.google.com/docs/firestore/manage-data/transactions), [Rules və atomik yoxlamalar](https://firebase.google.com/docs/firestore/security/rules-conditions), [App Check sərhədi](https://firebase.google.com/docs/app-check), [silmə və subcollection-lar](https://firebase.google.com/docs/firestore/manage-data/delete-data), [Auth delete/reauth](https://firebase.google.com/docs/auth/android/manage-users).

### DT01 — ölçü və kvota modeli (3 noyabr 2026)

Status: sənəd hesabı hazırlanıb; daxili ölçü/sync parametrləri təklifdir, real sxem və yük ölçülməyib. DT02-nin qəbul edilmiş 30 gün / slot başına 3 ehtiyat / 50-lik təmizləməsi dəyişmir. Bu bölmə balans və implementasiya qərarı deyil. Maşınla oxunan tam model, fixture tələbləri və ssenarilər: `design/states/D5-system-spec.json → technicalAlignment.unresolved → DT01.clarification`.

**Rəsmi sərhəd.** Firestore Standard üçün layihənin bir pulsuz database-i: 1 GiB saxlanma, gündə 50 000 read / 20 000 write / 20 000 delete, ayda 10 GiB outbound; sənəd maksimum 1 048 576 byte-dır. Günlük reset Pacific vaxtına görədir, Bakı gecəyarısı kimi planlaşdırılmır. TTL/managed backup/PITR bu pulsuz tutuma daxil deyil. Mənbə: [rəsmi kvotalar](https://firebase.google.com/docs/firestore/quotas), 3 noyabr 2026 yoxlaması.

**Daxili byte büdcəsi təklifi.** Bir snapshot 96 KiB: aktiv state 32 KiB, checkpoint-in bütün state-i 32 KiB, versiya/seed/RNG/flag 8 KiB, migration/genişlənmə ehtiyatı 24 KiB. Cloud slot sənədi current+previous+envelope = 96+96+16 = 208 KiB; indekslərə 48 KiB ehtiyatla 256 KiB/slot. KiB=1024 byte. Bunlar ölçülmüş serializer nəticələri deyil. Partiya sayını azaltmaq və ya balansı dəyişmək üçün limit sayılmır: aşan save lokal bütöv qalır, cloud ölçü xətası göstərir, səssiz kəsilmir. Bir adi qəbz və ya saxlanan run/op sənədinə indeks daxil 1 KiB; digər account/control/public-best/nailiyyət/entitlement məlumatına ümumilikdə 16 KiB nümunə büdcəsi ayrılır. Kataloq/ID siyahısı böyüsə yenidən hesablanır.

JSON simvol sayı, UTF-8 fayl ölçüsü, sıxılmış payload və Firestore sənəd ölçüsü eyni deyil. Document name + field adları + typed value ölçüləri + 32 byte overhead rəsmi qayda ilə hesablanmalıdır; indeks entry-ləri ayrıca əlavə olunur. Snapshot current/previous və iri array/map sahələri üçün indeks istisnaları təklif edilir; yalnız lazım olan receipt type/time və rekord query indeksləri saxlanır. Bu konfiqurasiya hələ yaradılmayıb. [Ölçü qaydaları](https://firebase.google.com/docs/firestore/storage-size).

**Worst-case fixture tələbi.** Üç slotun current və previous-i birlikdə dolu olmalıdır. Snapshot-da bütün bazarlar, partiya maya dəyəri/keyfiyyətləri, borclar/xidmətlər, xəbərlər, aktiv səfər/hadisə/finalın yarımçıq vəziyyəti, RNG/versiyalar və checkpoint-in ayrıca tam state-i ölçülür. Maksimum UTF-8 mətn/path və migration overhead daxil edilir. 96 KiB−1 / 96 KiB / 96 KiB+1 snapshot və 208 KiB slot sərhədləri yoxlanmalıdır. Tam journal, şəkil və lokalizasiya mətnləri cloud payload-a əlavə edilmir. Sxem və icazəli maksimum kolleksiya sayları hazır olmadığından bu arifmetik yuxarı büdcədir; faktiki worst-case fixture yaradıldığı və ölçüldüyü iddia edilmir.

**DT02-nin ölçüyə təsiri.** 3 slot × 3 həll edilmiş lokal ehtiyat × 96 KiB = 864 KiB. Lokal current+previous də əlavə ediləndə 3×5×96 = 1440 KiB; Room/journal/outbox və həll edilməmiş branch-lər xaricdir, ümumi disk cap deyil. Bu 9 ehtiyat cloud-a upload edilmir. Adi sync qəbzləri təmizləmə gecikmədikdə təxminən son 30 günün sync sayıdır; cari lastOpId və offline hesab backlog-u bu pəncərədən uzun qala bilər. 50-lik səhifə nə qəbz sayına, nə layihə yaddaşına sərt hədd qoyur. Replay-i bloklayan qeydlər DT02 qaydasına görə ayrıca saxlanır.

**Sync/coalesce təklifi.** Lokal durable commit hər əməliyyatda qalır; adi slot-sync üçün minimum 60 saniyə interval və dirty-state coalesce təklif olunur. Bu gündəlik 12 sync cap-i deyil. CAS base/generation dəyişməsi, naməlum nəticə, konflikt branch-i, online-start, reward, completion və deletion sərhədi coalesce edilmir; oyun və callback hüquqları dəyişmir. OS background upload-u bitirməyə zəmanət vermir, pending outbox növbəti açılışa qalır. İstifadəçi davranışı və çox cihaz yükü ölçülmədən 60 saniyə kvotaya uyğunluq zəmanəti vermir.

**Təkrar hesablana bilən gündəlik model.** `s` aktiv hesab başına gündə qəbul edilmiş adi sync sayı, `c` dolu 50-lik təmizləmə keçidi, `t` hesabın eyni profillə aktiv olduğu gün sayıdır. Nümunə digər yük: gündə 1 online start, 1 completion, 2 reward reserve, 2 settle və 1 achievement publication. Bunlar gameplay/reklam limitləri deyil. Transaction oxularına 1,25 retry əmsalı tətbiq olunur. Sync/start/reserve/achievement üçün client3+Rules3 read; completion üçün client5+Rules5; settle üçün client4+Rules4 read nəzərdə tutulur. Writes müvafiq olaraq 2/2/2/2, completion4, settle3-dür. Completion-un account/run/public-best/op kimi dörd yazı yaratdığı yuxarı nümunə götürülür.

Bootstrap/account/Rules üçün 12 read və 2×20 leaderboard entry üçün 40 read/gün əlavə edilir. Leaderboard 20 burada yalnız hesablama fərziyyəsidir; DT05 konfiqurasiyasını təsdiqləmir. Bir dolu cleanup keçidi 50 namizəd + 50 uyğunluq recheck + delete başına 2 Rules read ehtiyatı = 200 read, üstəgəl query/index üçün 5 read ehtiyatı və 50 delete-dir. Rules cache qənaəti fərz edilmir; 50 delete-in hamısı bir request kimi layihələndirilmir, Rules access-call limitləri DT03-də yoxlanmalıdır. 5 index read sərt üst hədd deyil: committedAt+opId və `__name__` üzrə sıralama multi-range index-entry xərci yarada bilər, dəqiq query planı ölçülməlidir. Boş query də minimum 1 read yaradır.

- Read/aktiv hesab-gün: `R = 7,5s + 62,5 + 52 + 205c`.
- Write/aktiv hesab-gün: `W = 2s + 18`; delete: `D = 50c`.
- Outbound nümunə büdcəsi: `E = 1,25s × 0,25 + 0,5 MiB/gün`. Hər sync cəhdində tam 256 KiB slot read fərz edilir; digər transaction/leaderboard/bootstrap/cleanup cavabları üçün əlavə 0,5 MiB ayrılır. Bu real wire ölçüsü deyil, payload rezervidir; Rules dependent read client trafiki sayılmır.
- Cloud storage/hesab: `3×256 + 16 + NsyncReceipts×1 + NretainedDocs×1 KiB`. Nümunədə `784 + 30s + 8t KiB`: gündə run1 + start/completion op2 + attempt2 + settle2 + achievement op1 = 8 saxlanan sənəd. Nailiyyətin hər gün olması konservativ modeldir, trigger qaydası deyil. Aktivlik dayananda artım dayanır, amma məlumat özbaşına silinmir.

Retry eyni uğurlu qəbzi qaytarırsa yenidən write hesablanmır; həqiqətən yeni commit, əlavə konflikt, çox cihaz, schema böyüməsi və uğursuz sorğular ayrıca əlavə olunur. Rules əlavə oxuları, sənədlər və indekslər kvotaya daxildir; dedup cache və boş query pulsuz fərz edilmir. Cursor istifadə olunur, offset xərci modelə salınmır. [Oxu/Rules/indeks/trafik hesabı](https://firebase.google.com/docs/firestore/pricing).

**Üç şərti ssenari.** Hər resursun yalnız 80%-i planlaşdırılır; qalan 20% deletion/operator/test/əlavə retry və başqa yük üçün ehtiyatdır. Ssenarilər bərabər istifadə profilli, hər gün aktiv hesablar üçündür; təhlükəsiz release sayı deyil.

- Yüngül: s=6, c=1 → 364,5 read, 30 write, 50 delete, 2,375 MiB/gün. Read həddi 109 DAU; aylıq outbound 30 gündə 114, 31 gündə 111 DAU. Storage 30 aktiv gündə 1204 KiB/hesab → 696 saxlanan hesab; 365 gündə 3884 KiB → 215 hesab.
- İstinad: s=12, c=2 → 614,5 read, 42 write, 100 delete, 4,25 MiB/gün. Read 65, write 380, delete 160 DAU; outbound 30 gündə 64, 31 gündə 62 DAU. Storage 30 aktiv gündə 1384 KiB/hesab → 606 saxlanan hesab; 365 gündə 4064 KiB → 206 hesab.
- Ağır: s=30, c=4 → 1159,5 read, 78 write, 200 delete, 9,875 MiB/gün. Read 34 DAU; outbound 30 gündə 27, 31 gündə 26 DAU. Storage 30 aktiv gündə 1924 KiB/hesab → 435 saxlanan hesab; 365 gündə 4604 KiB → 182 hesab.

DAU limiti ilə ümumi saxlanan hesab limiti ayrıdır. Məsələn, istinad profilində 1000 hesabın 30 aktiv günlük storage-i 1 384 000 KiB-dir və 1 GiB-ni keçir; həmin gün cəmi 50 hesabın aktiv olması bu yaddaşı azaltmır. 31 günlük ay üçün istinad outbound-u `62×31×4,25 = 8168,5 MiB` ilə 8192 MiB plan büdcəsindədir; 63 hesab onu aşır. 20% ehtiyat ayrıca zəmanət deyil; deletion burst və ya həqiqi index scan onu keçə bilər.

**Backlog və açıq yoxlamalar.** Aktiv hesabda `50c > s` olduqda yaşlı adi qəbz backlog-u azala bilər; uyğun olmayan və replay-blocking qeydlər silinmir. İnaktiv hesabın qəbzləri təmizlənmədiyi üçün modeldə faktiki sənəd sayı saxlanır. Tutum çatmayanda lokal oyun və pending/error davranışı qorunur; billing avtomatik açılmır, təhlükəsizlik qəbzi kvotaya sığmaq üçün silinmir. Real gözlənən DAU/ümumi hesab, hesab yaşı, cihaz/sessiya/sync/reward sayları, serializer ölçüsü, indeks inventarı/Query Explain, Rules trace və serialized response ölçüləri məlum deyil. Bu məlumatlar və DT03 sınaqları olmadan DT01 capacity-validated və DT02 validation-complete statusuna keçirilmir. Yeni 96/208/256 KiB, 1 KiB/16 KiB və 60 saniyə parametrləri ayrıca qəbul gözləyir. Kod/Rules/fixture generatoru yaradılmayıb, runtime sınağı aparılmayıb.


**DT01 dəqiqləşdirməsi — parametr təsdiqi yoxdur (3 noyabr 2026).** İstifadəçi ölçməyədək bütün DT01 ölçü/sync parametrlərinin təklif qalmasını seçdi. 96/208/256 KiB, 1 KiB/16 KiB və 60 saniyə qəbul edilmiş siyasət deyil. 96 KiB snapshot typed value büdcəsi, 208 KiB ad/sahə/value/overhead daxil sənəd, 256 KiB isə sənəd+indeks storage rezervidir; 256 KiB faktiki wire ölçüsü deyil. Daxili 32/32/8/24 bölgüsü gameplay kolleksiya həddi yaratmır.

60 saniyənin dəqiqləşdirilmiş təklif əhatəsi UID+slot+cihaz üzrə ardıcıl adi upload başlanğıclarıdır; eyni slot üçün bir in-flight əməliyyat. İlk dirty upload dərhal başlaya bilər, sonrakı dirty state intervala uyğun birləşdirilir. Yalnız göndərilməmiş, eyni UID/slot/generation və məlum CAS bazalı snapshot-lar coalesce edilə bilər. Göndərilmiş/naməlum əməliyyatın opId/payload/base-i dəyişməzdir; retry backoff+jitter ilə eyni əməliyyatı izləyir. Lokal durable state/journal qorunur. Start/reward/completion/deletion/konflikt ayrıca sayılır; cihazlararası qlobal interval zəmanəti yoxdur.

`s` bütün cihaz/slotlar üzrə qəbul edilmiş adi commit cəmidir; 60 saniyə `s=12` yaratmır. Fasiləsiz dirty, online, konfliktsiz bir device-slot seqmentində m dəqiqə və I saniyə interval üçün təxminən `ceil(60m/I)` upload başlanğıcı fürsəti var (ilk dərhal, son sərhəd xaric); sessiya/slotlar üzrə toplanır. 60 dirty dəqiqə I=60 üçün təxminən 60, I=120 üçün 30 fürsətdir. Təmiz state upload yaratmır; offline backlog/retry/məcburi axınlar ayrıca hesablanır. Bu sərt cap və ya faktiki commit proqnozu deyil.

Dəyişən davranış üçün `a=start, b=completion, u=reserve, v=settle, h=achievement, f=bootstrap+leaderboard/başqa sabit read`, `k=transaction read retry faktoru`:

- `R = k(6s+6a+10b+6u+8v+6h)+f+C`; `W=2s+2a+4b+2u+3v+2h`; `D=d`.
- `C` faktiki cleanup query document/index read + recheck + Rules read, `d` faktiki uyğun silmədir. İmtina/naməlum nəticə, dedup lookup və əlavə konflikt oxuları ayrıca əlavə olunur; lazım gəlsə retry faktorları axın üzrə ayrılır.
- Əvvəlki `c=1/2/4` dolu səhifə xərc rezervidir, hər gün 50/100/200 uyğun silmə proqnozu deyil. DT02 trigger/paging qaydası dəyişmir; `c` sərbəst scheduler deyil. Sabit s=12 və backlog yoxdursa uzunmüddətli silmə yaranan uyğun qəbzlər qədərdir; 100/gün daimi deyil. Boş/qismən/uyğun olmayan səhifələr də read yaradır. `50c>s` yalnız potensialdır; backlog azalması üçün faktiki uyğun `d>s` lazımdır.
- `784+30s+8t` yetişmiş pəncərə və vaxtında cleanup fərziyyəsidir. Yeni fasiləsiz aktiv hesab üçün adi qəbz təxminən `s×min(t,30)`, üstəgəl qorunan lastOpId/gecikmə/backlog; ümumi storage faktiki hesab inventarlarının cəmidir. Gündə 8 ömürboyu sənəd ayrıca ehtiyat ssenarisidir.
- Əvvəlki outbound rəqəmləri payload rezervidir. İndekslər wire payload-a daxil deyil; bootstrap/restore-da üç böyük slotun oxunması təkbaşına 0,5 MiB əlavə rezervi aşa bilər. Buna görə əvvəlki DAU rəqəmləri tutum zəmanəti və konservativ yuxarı hədd sübutu deyil. Real cavab ölçüsü ilə yenidən hesablanmalıdır. [Firestore read/Rules/storage hesabı](https://firebase.google.com/docs/firestore/pricing).

Real yük inputları hələ məlum deyil: buraxılış/12 ay ümumi hesab və DAU/pik gün; cihaz/sessiya/online dirty dəqiqə/slot; start/completion/reward/achievement/leaderboard sıxlığı; aktiv gün payı, hesab yaşı, offline müddət və qayıdan backlog. Cavabsız input üçün rəqəm uydurulmur. Tam struktur `DT01.clarification.refinement` daxilindədir. DT02, balans və implementasiya sərhədi dəyişmir.

## 8. Onlayn rekord və nailiyyət

Şəxsi rekord offline dərhal görünür. Onlayn nəticə `pending_upload → published` keçir; `pending_verification/verified` yoxdur. Client engine nəticəni hesablayır; Firestore Rules yalnız qəbul müqaviləsini yoxlayır. UI bunu serverdə replay edilmiş nəticə kimi təqdim etmir. V1-də real pul mükafatlı yarış yoxdur.

Təsdiqlənmiş online-start qaydası saxlanır: internetlə start transaction-ı `runs/{runId}` qeydiyyatı yaradır; UID, run/lineage ID, qayda/content versiyası, seed və `request.time`-a bağlı start vaxtı dəyişməzdir. Yalnız server commit-dən sonra ranked başlanğıc göstərilir; cache və gözləyən offline write ticket deyil. Kvota/şəbəkə xətasında retry və ya açıq şəkildə şəxsi/offline səfər seçimi var; həmin səfər sonradan ranked-ə çevrilmir. Bu qeydiyyat etibarlı server seed-i və ya anti-cheat ticket deyil; startdan əvvəl client hesablamasını əngəlləmir.

Tam offline başlanmış səfər yalnız şəxsi rekord verir. Online qeydiyyatlı run offline bitə bilər; qayıdanda completion ID ilə run-ın finished keçidi, şəxsi cloud nəticəsi və uyğun public best entry bir transaction-da bağlanır. Eyni run/lineage üzrə ikinci completion rədd edilir; eyni əməliyyat retry-i əvvəlki nəticəni qaytarır. Rules UID, start mövcudluğu, versiya/kateqoriya, score tipi/həddi və bir dəfə finalize yoxlayır, düzgün bazar əmrləri ilə qazanıldığını sübut etmir. Eyni lineage fork-larında ilk qəbul olunan completion qalır; digər branch şəxsi saxlanır. Checkpoint flag-inin client tərəfindən gizlədilməsinə tam qoruma yoxdur.

V1 yalnız classic-dir; rewind/no-rewind və rulesetVersion kateqoriyaları ayrıdır. Public profil Google adı/e-poçtu avtomatik yayımlamır; ləqəb istifadəçi tərəfindən seçilir. Uzunluq/simvol qaydası Rules ilə, uyğun məzmun və şikayət/gizlətmə isə manual operator prosesi ilə layihələndirilir; söz filtri tam moderasiya deyil. Moderasiya blokları yalnız səlahiyyətli operator tərəfindən dəyişir; client öz blokunu qaldıra bilmir. İctimai indekslər və oxu səhifə limiti M4-də sınaqdan keçir.

İlkin nailiyyətlər: ilk uğurlu ticarət, dörd şəhəri görmək, ilk 20 günlük səfəri bitirmək, borcu tam ödəmək, geri dönüşsüz səfər bitirmək. Dəqiq trigger/ID kataloqu açıqdır. Client unlock-u sabit event ID ilə lokal və UID-yə bağlı cloud queue-da bir dəfə qeyd edir, PGS sessiyası varsa təkrar təhlükəsiz publication edir. PGS profilinin olmaması oyun/cloud-u bloklamır. Nailiyyətlər client-reported-dır; serverdə gameplay doğrulaması yoxdur.

## 9. PNG → ekran → komponent xəritəsi

Hazır PNG-lər production asset deyil. `design/choices/NN-variants.png` bir neçə variantlı seçim lövhəsidir; yalnız göstərilən seçim layout referansıdır. Oradakı rəqəmlər balans, yazılar lokalizasiya mənbəyi, seçilməyən variantlar isə tələblər sayılmır. İcrada hər lövhə üçün seçilmiş hissə və aid state ayrıca kanonikləşdirilir.

- `design/reference/selected-pixel-map.png`: pixel-art üslub referansı. Xəritə fonu mətn, HUD, düymə və sabit UI-siz yenidən hazırlanır. Şəhər adları, marşrutlar və hotspot-lar kod/data qatındadır; PNG-də bişirilmir. Şəkildəki şəhər adları ayrıca təsdiqlənməyib.
- `51-variants.png` B → `MarketScreen` panorama + geniş ticarət sahəsi; `52` C → `MarketViewToggle`, list/card; `53` B → yanaşı `TradeActions`; `54` C → `QuantityDialog`.
- `55` A → `EventDialog`; `56` A → `WorldMap` zoom/pan/fit; `57` A → `CargoScreen` mal/partiya/detail; `58` C → `NewsDialog` list/detail.
- `59` B → `WorkshopScreen`; `60` C → `CreditorScreen`; `61` B → `TravelServicesScreen`; `62` B → `ResultsScreen`.
- `63` A → `SaveSlotsScreen`; `64` A → `MainMenuScreen`; `65` A → `TutorialOverlay`; `66` B → `SettingsDialog`.
- `67` A → `PersonalRecordsScreen`; `68` B → `PauseDialog`; `69` B → `ArrivalScreen`; `70` A → `ContractExpiredDialog`.
- `71` A → `TradeLimitHint`; `72` B → `RoadBlockedDialog`; `73` A → `FinalDayRescueDialog`; `74` B → `RouteRiskDialog`.
- `75` B → `RecoveryWorkScreen`; `76` A → `BatchSelector`; `77` B → `SaveErrorCard`; `78` A → `WaitDayDialog`.
- `79` B → `FinalSaleLedgerScreen`; `80` A → `EmptyState`; `81` A → `SlotActionsMenu`; `82` A → `NewRunDialog`.
- `83` C → `LoanContractScreen`; `84` A → `CityServiceHotspots`; `85` B → `EventResultDialog`.

Yuxarıdakı NN qısa adlarının hamısının prefiksi `design/choices/`, suffiksi `-variants.png`-dir. Seçilmiş variantın reviewNotes-u da tətbiq olunur; `decisions.json` dəyişərsə bu xəritə yoxlanır.

`design/screens/market-selected-draft.png` və `design/states/D1-market-draft.png`: bazarın keçid eskizləri; coverage-dəki 52C/53B və hesab uyğunsuzluqları düzəlmədən kanonik deyil. `D1-quantity-input-v2.png`, `D1-quantity-limits-v2.png`, `D1-quantity-actions-v1.png`, `D1-quantity-invalid-v1.png`: miqdar state referansları; ümumi Max kimi köhnəlmiş detalların əvəzinə `decisions.json/designResolutions` işləyir. `D1-quantity-applied-v1.png`, input-v1 və limits-v1 tarixi referansdır. `D1-quantity-applied-v2.png` yekun fayl yoxlamasında mövcuddur; ayrıca davam edən dizayn işinin son vizual statusu coverage-dən götürülməlidir, bu plan həmin renderi yoxlamayıb.

Google giriş, cloud restore/conflict, profil, onlayn cədvəl, nailiyyət, hesab silmə, consent, privacy, shop, billing pending/error və reklam pending/inbox üçün hələ seçilmiş kanonik PNG yoxdur. Bunlar D5-ə əlavə dizayn coverage kimi hazırlanmalıdır; mövcud 51–85-lə örtülmüş sayılmır.

## 10. İstehsal qrafik asset-ləri

Aşağıdakı adlar planlaşdırılan fayllardır; mövcud PNG kimi təqdim edilmir. Son ölçülər D6-da viewport və yaddaş büdcəsinə görə təyin edilir.

- `map_world_base.png`: mətnsiz, UI-siz xəritə illüstrasiyası; `WorldMap`-də pan/zoom edilən fon. Şəhər koordinatları və yollar ayrıca `map.json`; toxunma hitbox-u görünən bayraqdan daha böyük ola bilər.
- `city_<cityId>_panorama.png` ×4: bazar, gəliş və şəhər xidmətləri fonları. Emalatxana/kreditor/xidmət nöqtələri ayrıca hotspot data-sı ilə uyğunlaşır.
- `menu_caravanserai.png`, `workshop_bg.png`, `creditor_bg.png`, `recovery_work_bg.png`, `results_return.png`: əsas menyu və aid xidmət/nəticə illüstrasiyaları.
- `good_grain.png`, `good_wood.png`, `good_cloth.png`, `good_spice.png`, `good_iron.png`, `good_salt.png`, `good_wool.png`, `good_herbs.png`, `good_mana_crystal.png`, `good_dragon_resin.png`: bazar list/card, cargo, borcu malla ödəmə. Keyfiyyət overlay/text ilə göstərilir, hər faiz üçün yeni PNG yoxdur.
- `guide_portrait.png`, `guard_portrait.png`, `creditor_portrait.png`, `tutorial_merchant.png`: xidmət kartları və təlim. `event_<eventId>.png`: hadisə kataloqunda ID ilə bağlanan illüstrasiyalar; təxminən 10 hadisənin dəqiq siyahısı hələ açıqdır.
- `cart_travel_sheet.png` + frame metadata: xəritədə qısa araba hərəkəti; `cosmetic_<id>_preview.png` və lazım olan cart sprite variantı: kosmetika önizləməsi və aktiv görünüş.
- `empty_cart.png`: boş inventar; başqa empty hallarında uyğun mətnlə. `parchment_panel.9.png` və ya ayrı künar/tekstura qatları: dartılan panellər; mətn və düymə daxil olmayan dekor. Dokulu panelin kontrastı overlay ilə sabitləşdirilir.
- Sadə gold/day/cargo, plus/minus, back, settings ikonları mövcud üsluba uyğun VectorDrawable və ya ayrıca pixel sprite olur. Google loqosu rəsmi brend asset-indən götürülür, əl ilə yenidən çəkilmir.
- Launcher üçün foreground/background və monochrome layer-lər ayrıca; store üçün `play_icon_512.png`, `feature_graphic_1024x500.png`; store screenshot-ları real tətbiq renderindən hazırlanır.

Rasterlər `core/designsystem/src/main/res/drawable-nodpi/` daxilində məqsədli decode ölçüsü ilə; launcher `mipmap-*`; content JSON `content/src/main/resources/` və ya Android assets adapteri ilə paketlənir. Tam ekran şəkli düymə kimi işlədilmir. Pixel-art üçün uyğun sampling və sabit aspect ratio; bütün mətni bitmap-dən çıxarmaq lazımdır. İstifadəçi mətni, qiymət, gün, risk və cədvəl kodla çəkilir.

Asset manifest-də hər fayl üçün ID, mənbə, lisenziya/hüquq, ölçü, alpha, anchor, safe crop, istifadə edən komponentlər, variant/state, locale və təsdiq statusu qeyd olunur. Bütün asset-lər eyni anda decode edilmir; decoded yaddaş width×height×4 əsasında ölçülür, map və böyük illüstrasiyalar profil edilir. Dizayn lövhələri release bundle-a daxil edilmir.

## 11. Vizual sistem və cihaz uyğunluğu

Hazırda kanonik token faylı yoxdur. D6-da `BarteruneColors`, `BarteruneSpacing`, `BarteruneTypography`, `BarteruneShapes`, motion və elevation tokenləri yaradılmalıdır; bu sənəd yeni rəng/ölçü icad etmir. Referansın rəngini kor-koranə mətn fonuna tətbiq etmək olmaz.

Paylaşılan komponentlər: `GameHud`, `ParchmentPanel`, `GameButton`, `TradePrice`, `QuantityField`, `GoodRow/Card`, `BatchRow`, `ReasonHint`, `IllustratedDialog`, `LedgerRow`, `SaveSlotCard`, `SyncStatus`, `AccountStatus`, `OfflineNotice`.

Telefon üfüqi ekranında minimum məzmun və scroll; planşetdə list/detail sahələri və mətn üçün daha çox yer. Pəncərə ölçüsü/resizing/foldable dəyişməsində state saxlanır, xəritə koordinatları ekran pikselinə bağlanmır. Android 16 edge-to-edge, cutout və system bar insets yoxlanır. Böyük ekran orientation istisnasına güvənərək layout yoxlaması buraxılmır; `appCategory=game` rəsmi istisnası ayrıca manifestdə nəzərə alınır.

Qəbul: bütün interaktiv hədəflər ən azı 48dp; normal mətn kontrastı 4.5:1 hədəfi; status yalnız rənglə göstərilmir. AZ/TR/RU/EN ən uzun sətirlər, böyük sistem şrifti, TalkBack semantikası və azaldılmış hərəkət yoxlanır. Pixel font yalnız oxunaqlı qısa dekor mətnində; əsas narrativdə dörd dilin qliflərini daşıyan oxunaqlı font. Hər vizual mərhələ emulator/device render → screenshot → şəkli açıb baxış ilə bağlanır. Bu plan vizual implementasiyanın yoxlanıldığı iddiası vermir.

## 12. Reklam, alış və hesab hüquqları

V1: ödənişli Play yükləmə + könüllü reklam + kosmetik IAP. Supported və iqtisadi reklam bonusları sonrakı mərhələdir. Monetizasiya sənədinin məhsul placement/limit təklifləri saxlanır; cari texniki müqavilə bu planın §12 bölməsidir: reklam client callback modeli, kosmetik IAP isə AppBackend server doğrulaması ilə işləyir. Reklam SSV-si billing adapterinin hazır olmasından nəticə kimi qəbul edilmir. Məhsul qiyməti və limitləri burada təsdiqlənmir.

### 12.1. Client rewarded axını

Uyğun offer → online transaction ilə sabit attempt ID və limit rezervasiyası → test/release ayrılmış SDK reklamı → `OnUserEarnedRewardListener` → lokal durable pending event → Firestore transaction ilə bir dəfə grant/counter/account delta → lokal tətbiq. Reklamın bağlanması reward deyil. Grant ID attempt/completion/placement ilə bağlıdır; təkrar callback, retry, checkpoint və ikinci cihaz eyni grant-ı çoxaltmır. Rezervasiya bitməsi və settle sərhədi request.time əsasında, gecikmiş callback qaydası isə ayrıca limit müqaviləsində təyin edilir. Qəbul edilməmiş attempt üçün reklam başlanmır; reklam ərzində əlaqə itərsə durable event sonra göndərilir.

Bu modeldə SSV yoxdur. Rules limit və atomikliyi yoxlayır, reklamın həqiqətən izlənməsini yoxlamır; lokal callback-i saxtalaşdırmaq mümkündür. Callback durable yazılmadan process ölərsə itmiş mükafatı avtomatik bərpa etmək mümkün olmaya bilər; buna server zəmanəti verilmir. No-fill/offline/consent imtinası oyunu bloklamır. UMP consent məlumatı reklamdan əvvəl yenilənir; privacy options, yaş/region və 13–17 auditoriyası ayrıca konfiqurasiya olunur. [Rewarded callback](https://developers.google.com/admob/android/rewarded).

### 12.2. AppBackend Billing və restore/refund

Kosmetik IAP üçün mövcud `android-billing` kitabxanası istifadə olunur; ayrıca client-managed hüquq sistemi qurulmur. Authenticated backend catalog məhsul allowlist-ini, Google Play isə lokal qiymət və cari offer-i verir. Checkout server account identity və eyni login epoch yoxlamasından sonra `setObfuscatedAccountId` ilə açılır. Barterune adapteri yalnız uyğun app/package və durable kosmetik məhsulları qəbul edir; dəqiq SKU kataloqu açıqdır.

`PENDING` hüquq vermir. `PURCHASED` callback-i kosmetikanı açmır: account identifier yoxlanır → token UID-yə bağlı Keystore/AES-GCM jurnala davamlı yazılır → AppBackend verify → server entitlement snapshot-ı cari hesabın cache-inə tətbiq edilir. Client acknowledge/consume çağırmır; server davamlı commit-dən sonra finalization edir. Şəbəkə xətasında queue saxlanır, foreground/process restart retry eyni tokenlə davam edir. Purchase token və Firebase ID token log/public sənədə yazılmır; Developer API credential yalnız backend-də qalır.

Uğurlu server refresh cache-i tam əvəz edir; köhnə save/cloud union hüquq yaratmır. Müvəqqəti şəbəkə xətası refund sayılmır, offline yalnız əvvəl serverdə yoxlanmış cari hesab cache-i göstərilə bilər. Refund/revoke provider və server reconcile inteqrasiyası ilə cihazda ayrıca yoxlanmalıdır; hazır adapter dərhal revoke zəmanəti vermir. Consumable valyuta və subscription Barterune scope-na əlavə edilmir.

Host auth işi billing inteqrasiyasını da əhatə edir: giriş/çıxış/hesab dəyişməsi `AccountSessions`-a bağlanır, eyni UID ilə yeni login epoch yenilənir, token aktiv Firebase sessiyasından alınır. Foreground lifecycle billing bağlantısı və refresh/retry ilə birləşdirilir. Gec verify/rədd/cache cavabı dəyişmiş sessiyaya tətbiq edilmir. Host backup exclude qaydalarını birləşdirir; hesab silmə server baryeri təsdiqlənəndən sonra `clearDeletedAccount(uid)` çağırır. Bu lokal metod server məlumatını silmir; tam DT04 coordinator-u hələ açıqdır.

DT07 — 3 noyabr 2026: istifadəçi variant 1-i seçib. Pulla alınmış daimi kosmetika alış zamanı daxil olunmuş ilk Firebase UID-yə daimi bağlanır. Eyni Play hesabı ilə başqa Firebase UID-yə keçmək alışları avtomatik açmır. Eyni UID üçün restore Play alışının uyğunluğu yoxlanaraq nəzərdə tutulur; cloud cache təkbaşına alış sübutu deyil. Hesab silindikdən sonra alış yeni Firebase UID-yə bərpa edilmir və köçürülmür; support istisnası yoxdur. Bu məhdudiyyət alışdan əvvəl və hesab silmə təsdiqində aydın bildirilməlidir. Bu siyasət Google Play sifarişinin silinməsi və ya avtomatik refund demək deyil.

Google Play ödəniş hesabı ilə Firebase oyun hesabı fərqli ola bilər. İlk UID/no-transfer siyasətinin texniki mənbəyi AppBackend alış reyestri və account identity yoxlamasıdır; Firestore client claim alış sübutu deyil. Hesab silindikdən sonra yeni UID-yə restore/transfer qadağasının icrası DT04 server baryeri, minimum reyestr məlumatı və retention müddəti ilə uzlaşdırılmalıdır. Qeyri-müəyyən müddətə məlumat saxlamaq təsdiqlənmir. SKU/kataloq/qiymət, host deletion inteqrasiyası və canlı Billing sınaqları açıqdır.

Qəbul sınaqları test reklam ID-ləri və license tester alışları ilədir. Hazır kitabxana testləri canlı Google Play/Firebase/Keystore cihaz davranışının sübutu deyil. Real SKU, credential, backend URL/konfiqurasiya, Console/upload/signing və deployment ayrıca göstərişədək təxirə salınıb; bu plan düzəlişi həmin işləri başlatmır. Reklam SSV və gameplay replay hazır billing adapterinə daxil deyil.

## 13. Play Store və Android release qapıları

Aşağıdakı qaydalar 2 noyabr 2026-da rəsmi mənbələrlə yoxlanıb; təqdimatdan əvvəl yenidən yoxlanmalıdır.

1. `targetSdk` buraxılış vaxtındakı Google Play tələbinə uyğun seçilir (hazırkı tələb: API36 və ya yuxarı); `compileSdk >= targetSdk`. `minSdk` üçün rəqəm təsdiqlənməyib: seçilən SDK-ların uyğunluğu və cihaz sınaqlarına əsasən sonra müəyyənləşdiriləcək. Google Play-in target tələbi minimum Android versiyası deyil. Android 16/API36 tələbi 31 avqust 2026-dan yeni tətbiq və yeniləmələrə aiddir; extension tarixi 1 noyabr 2026 idi. [Target API](https://support.google.com/googleplay/android-developer/answer/11926878).
2. API36-da edge-to-edge və dəyişən sistem davranışları test edilir. Böyük ekran orientation/resizing qaydalarında game istisnası mövcuddur; planşet dəstəyi yenə ayrıca QA tələb edir. [Android 16](https://developer.android.com/about/versions/16/behavior-changes-16).
3. 64-bit cihazlar üçün 16KB page-size uyğunluğu, xüsusən transitive SDK `.so` faylları yoxlanır. Saf Kotlin seçimi SDK-ların native kitabxana gətirmədiyini sübut etmir. Release AAB 16KB cihaz/emulatorda sınanır; hesab üzrə mümkün müddət uzadılmasına güvənilmir. [16KB](https://developer.android.com/guide/practices/page-sizes).
4. Rəqəmsal kosmetika üçün standart Play Billing axını; bu tarixdə yeni release üçün Billing 8+ planlaşdırılır, 7-nin extension müddəti bitib. [Versiya cədvəli](https://developer.android.com/google/play/billing/deprecation-faq).
5. İctimai işlək privacy policy URL-si, tətbiqdaxili keçid, faktiki SDK məlumatları ilə uyğun Data safety, təhlükəsiz ötürmə və saxlama açıqlaması. Google/Firebase/AdMob/Crashlytics/PGS məlumatları da inventara daxildir. [Data safety](https://support.google.com/googleplay/android-developer/answer/10787469), [User Data](https://support.google.com/googleplay/android-developer/answer/10144311).
6. Hesab yaradıldığı üçün tətbiqdaxili silmə yolu və tətbiq quraşdırılmadan işləyən veb silmə müraciəti lazımdır. Sadəcə Google access revoke və ya logout hesab silmə sayılmır. [Account deletion](https://support.google.com/googleplay/android-developer/answer/13327111).
7. App content: reklam var bəyannaməsi, real target audience, IARC sorğusu və login-gated məzmun üçün reviewer access təlimatı. Məcburi Google girişini reviewer problemsiz yoxlaya bilməlidir; test addımları və lazım olan təsdiqlənmiş giriş imkanları hazırlanır, şəxsi hesab parolu repoya yazılmır.
8. Şəxsi hesab 13 noyabr 2023-dən sonra yaradılıbsa ən azı 12 tester 14 gün fasiləsiz closed test-ə qoşulu olmalıdır, sonra production access üçün müraciət edilir. Bu şərt avtomatik təsdiq zəmanəti deyil; test nəticələri sənədləşir. Hesabın tarixi yoxlanmalıdır. [Testing](https://support.google.com/googleplay/android-developer/answer/14151465).
9. Mənalı və stabil oyun, crash/ANR və işləməyən axınların olmaması. Google konkret minimum funksiya saymır. [Functionality](https://support.google.com/googleplay/android-developer/answer/9898783?hl=en).
10. Signed AAB, Play App Signing, qorunan upload key, sabit applicationId, artan versionCode, release R8 mapping və native debug symbols varsa yüklənməsi. Release log-da token/receipt/PII yoxdur. İcazə inventarında yalnız tələb olunan internet/network və SDK manifest əlavələri saxlanır; kontakt, location və geniş storage icazələri bu məhsula lazım deyil.
11. Store icon 512×512, feature graphic 1024×500, real phone/tablet screenshot-ları, düzgün lokalizasiya və əlaqə məlumatı hazırlanır. Reklam və ya implementasiya olunmamış rejim gameplay screenshot-u kimi təqdim edilmir. [Preview assets](https://support.google.com/googleplay/android-developer/answer/9866151).
12. Developer identity/device verification və Play Console-un həmin hesab üçün göstərdiyi release bəyannamələri tamamlanır. Konsoldakı konkret əlavə şərtlər publish zamanı ayrıca checklist-ə daxil edilir.

## 14. Test və qəbul strategiyası

Engine testləri: alış/satış invariantları, miqdar və overflow, yük ölçüsü, keyfiyyət partiyası, qiymət sonrası təsir, gün 19/20, yol müddəti, borc/müqavilə, deterministik hadisə, checkpoint flag, atomik finalize. Eyni seed+əmrlər lokal engine testlərində eyni nəticə verməlidir; server replay V1 qəbul şərti deyil.

Data testləri: Room migration, mutasiya zamanı process death, disk yazma xətası, pozulmuş save və ehtiyatdan baxışlı restore; üç yuvanın izolyasiyası. Sync testləri: iki offline cihaz, CAS conflict, tombstone, account switch, köhnə schema, commit cavabının itməsi, ölçü həddi, quota exhaustion və təkrar outbox; server təsdiqi ilə cache statusunun fərqi.

Online/Rules testləri: başqa UID read/write, əlavə sahə/yol, revision/generation sıçrayışı, saxta transaction əlaqəsi, delete baryerindən sonra köhnə tokenli yazı və reactivation rədd edilir. Online start olmadan rekord, duplicate completion/grant və yanlış kateqoriya rədd edilir. Müqaviləyə uyğun uydurma score və saxta reward callback-inin tam aşkarlanmaması məlum model sərhədidir; “bütün saxtakarlıq rədd edilir” meyarı qoyulmur. Rules Emulator Suite ilə dummy hesablar üzərində yoxlanır.

Axın testləri: PGS unavailable, iki cihazlı reward settle, callback sıraları/process death, pending→purchased, canceled/already-owned, server finalization retry, duplicate verify/lost reply, server snapshot restore/refund reconcile, Play və Firebase hesab fərqi; logout, account switch, eyni UID ilə yeni login epoch-u və gec verify/rədd/cache cavabları. Silmə: app/web reauth, hər mərhələdə interruption/retry, quota xətası, public/private bütün yollar, Auth-last və köhnə cihazın resurrection cəhdi. Manual support proseduru və minimal baryerin retention qərarı release-dən əvvəl yoxlanır.

UI matrisi: SDK uyğunluğu və cihaz sınaqları ilə seçiləcək minimum Android, aralıq Android və buraxılışın target Android versiyası; kiçik landscape telefon, geniş telefon, Android planşet və resize; dörd dil, böyük font, offline launch, Google cancel/error, background/return, billing/reward qayıdışı. Maliyyə və gameplay düymələrinin təkrar basılması ayrıca yoxlanır.

CI: engine unit tests, Firestore Rules emulator tests, Android lint, compile/debug build, migration və instrumented kritik axınlar, version/content schema və manifest yoxlaması. Release öncəsi signed AAB internal track, Play pre-launch report, real cihaz smoke, crash/ANR müşahidəsi. Plan mərhələsində build/test işlədilməyib, çünki kod yoxdur.

## 15. Mərhələlər və çıxış meyarları

M0 — Qərar və dizaynın bağlanması. Açıq balans qaydaları, D1–D6 və yeni hesab/cloud/social ekranları, asset manifest, kanonik tokenlər tamamlanır. Çıxış: hər state-in mənbəsi, əmri və qəbul meyarı var; çatışmayan PNG hazır sayılmır.

M1 — Skeleton və engine. Gradle, content schema, pure engine, Room save və bir kiçik ticarət axını. Çıxış: bir al/sat əmri testdən keçir, process restart-dan sonra eyni state; UI tokenlərdən istifadə edir. Bu mərhələ lokal prototipdir, store release deyil.

M1.5 — Əsas oynanış sınağı. M1-dən sonra, geniş M2 implementasiyasından əvvəl iki şəhər, bir neçə mal və iki fərqli marşrutla kiçik lokal prototip hazırlanır. Bu məhdud sınaq yekun V1-in dörd şəhər və 20 günlük səfər sərhədini dəyişmir. Sınaq balansı ayrıca işarələnir; PNG nümunələri və sınaq rəqəmləri təsdiqlənmiş balans sayılmır.

Konkret protokol: [M1_5_PLAYTEST.az.md](M1_5_PLAYTEST.az.md). Əvvəl2 pilot, sonra4 janr təcrübəli +4 az-təcrübəli yeni iştirakçı; U1–U5 hədlərinin hamısı və texniki etibarlılıq şərti M2 üçün məcburidir. Bu protokol aşağıdakı ümumi qəbul meyarlarını konkretləşdirir.

- Qısa idarə olunan təlim: ilk alış → marşrut seçimi → səfər → ilk satış. Sonra oyunçu köməksiz növbəti ticarətini seçir; ilk satışdan sonra yeni, anlaşılan ticarət fürsəti görünür.
- Mal və yol seçimlərində ən azı iki məntiqli alternativ olmalıdır. Oyunçu qiymət məlumatının nə qədər aktual olduğunu, yolun vaxtını/xərcini/riskini və əməliyyatdan sonrakı xalis qazanc və ya zərərin səbəbini anlaya bilməlidir. Sınaq yolu/risk qaydaları ayrıca yazılır; nəticə yalnız təsadüfdən asılı olmamalıdır.
- Oyunçularla müşahidə edilir: köməksiz növbəti addımı seçirmi, mal və marşrut seçiminin səbəbini izah edə bilirmi, ilk satışdan sonra özü yeni fürsət axtarırmı, zərərdən sonra fərqli üsul sınamaq istəyirmi, təkrar oyunda strategiyasını dəyişirmi? Davam etməyə məcbur edilmir; təkcə “xoşuna gəldi?” cavabı qəbul sübutu deyil.
- Çıxış və M2-yə keçid şərti: sınağın quruluşu, iştirakçı sayı, verilən kömək və müşahidələr qısa hesabatda saxlanır; nəticələr oyunçuların qərarları anladığını və yönləndirmə olmadan yeni ticarətə başlamaq istədiyini göstərir. İştirakçı sayı və konkret uğur hədləri M1_5_PLAYTEST.az.md-də müəyyənləşdirilib; pilotdan sonra əsas turdan əvvəl versiya dondurulur, nəticəyə baxıb dəyişdirilmir. Bu meyarlar ödənmirsə, məlumatın təqdimatı, qiymətlər və yol seçimləri düzəldilib sınaq təkrarlanır; M2-yə keçilmir. Kiçik sınaq uzunmüddətli oyunçu saxlanmasının sübutu sayılmır.

M2 — Tam offline 20 günlük dövr. Yalnız M1.5 oynanış sınağının keçid şərti ödəndikdən sonra başlanır. Xəritə/səyahət, hadisə, borc, xidmət, təkmilləşdirmə, xəbər, checkpoint, nəticə və üç yuva. Çıxış: başlanğıcdan yekuna oynamaq, son-gün çıxılmaz vəziyyətindən çıxmaq və təkrarsız hesablaşma.

M3 — Hesab və Spark buludu. Məcburi Google gate, UID izolyasiyası, bounded snapshot, Rules/CAS, outbox, konflikt/tombstone və app/web deletion. Çıxış: A-da saxla → B-də davam; iki offline branch seçim zamanı itmir; cache uğur sayılmır; quota/ölçü xətasında lokal oyun qorunur; silmə yarımçıqdan davam edir, Auth ən sonda silinir, köhnə cihaz yazısı bloklanır. Sxem/indeks/qayda sınaqları və free-quota tutum hesabı hazırdır. Public testdə məcburi giriş işləyir.

M4 — Client-reported onlayn rekord və nailiyyət. Firestore online-start qeydiyyatı, bir completion/lineage, kateqoriyalar, public profil/moderasiya proseduru və PGS bridge. Çıxış: start-sız/duplicate/başqa UID nəticəsi rədd edilir, uyğun offline completion sonradan bir dəfə yayımlanır. UI nəticəni serverdə doğrulanmış adlandırmır; saxta, lakin sxemə uyğun score-a tam qoruma meyarı yoxdur.

M5 — Reklam və server doğrulamalı kosmetik IAP. Consent, client SDK reward callback və attempt/grant deduplikasiyası §12.1 üzrə; IAP mövcud AppBackend və Android billing adapteri ilə §12.2 üzrə inteqrasiya olunur. Çıxış: no-fill/pending oyunu bloklamır; durable reward callback/retry/checkpoint/iki cihaz eyni grant-ı çoxaltmır; callback-dən əvvəl process death məhdudiyyəti sənədləşir. Alış hüququ yalnız server snapshot-ından gəlir; client ack/consume etmir. Pending, duplicate verify, lost reply, process restart/retry, restore/refund reconcile və yanlış UID sınanır. Host auth/lifecycle/backup/deletion inteqrasiyası, ilk-UID/no-transfer siyasəti və DT04 retention bağlanmadan mərhələ tamamlanmır. Canlı provider/license-tester/cihaz yoxlaması ayrıca tələbdir. Reklam SSV, dərhal revoke və supported bu mərhələnin hazır olduğu iddiasına daxil deyil.

M6 — Telefon/planşet polish və lokallaşdırma. Dörd dil, font/kontrast/tap target, motion/audio, bütün loading/empty/error halları. Çıxış: seçilmiş cihaz matrisinin renderləri açılıb vizual yoxlanır; clipping və çatışmayan idarə qalmır.

M7 — Play hazırlığı. Privacy/Data safety/deletion, store assets, signing, API36/16KB, internal/closed test və production müraciəti. Çıxış: release checklist və test sübutu hazırdır; publish ayrıca istifadəçi tapşırığı ilə edilir.

## 16. Qərar statusları və exact next step

### 16.1. 2 noyabr 2026 cavabları ilə bağlananlar

- Ranked: internetlə Firestore start qeydiyyatı alınır (server anti-cheat ticket deyil); səfər sonra offline tamamlana bilər. Tam offline başlanğıc yalnız şəxsi rekord verir (§8).
- V1 yalnız classic-dir. Reklamla əlavə tutum kimi iqtisadi dəstək verən supported səfər sonrakı mərhələyə keçir. Classic üçün kosmetik reklam mükafatları bu qərarla ləğv edilmir; onların dəqiq şərtləri ayrıca monetizasiya qərarıdır.
- İlkin nailiyyətlər: ilk uğurlu ticarət, dörd şəhəri görmək, ilk 20 günlük səfəri bitirmək, borcu tam ödəmək, checkpoint-ə qayıtmadan səfəri bitirmək. ID, dəqiq trigger, yoxlama və təkrar açılmama meyarları ayrıca kataloqda bağlanmalıdır.
- İş ardıcıllığı: əvvəl balans təklifi hazırlanıb istifadəçiyə seçim üçün təqdim edilir; sonra D5 sistem ekranları hazırlanır. Təklif təsdiqlənmiş balans sayılmır.
- Privacy/deletion hosting: digər tətbiqdəki kimi GitHub Pages. Konkret səhifə URL-ləri və hesab silmə müraciətinin emalı açıqdır; statik səhifənin mövcudluğu təkbaşına işlək silmə axını sayılmır.

### 16.2. Texniki qərarlar və qalan yoxlamalar

- Yeni məcburi məhdudiyyət: Firebase Spark; Blaze/billing hesabı yoxdur. Ödənişli Play yükləmə + könüllü reklam + kosmetik IAP təsdiqlənib; oyun qiyməti açıqdır. §2.1 əvvəlki backend təklifinə üstün gəlir.
- İlkin Spark modeli save/sync və client-reported onlayn nəticələr üçün qalır; 3 noyabrda hazırlanmış AppBackend IAP adapteri billing üçün ayrıca server yoludur. Online + offline oyun saxlanır. Spark save/sync, qaydalar, deduplikasiya, client reklam və deletion layihəsi §6–8/12-də yazılıb; işləkliyi hələ test edilməyib. Snapshot byte həddi, quota tutum hesabı, qəbz retention-u, silmə/support müddətləri, App Check konfiqurasiyası və Play↔Firebase hüquq siyasəti M0/M3 qəbul işləridir. IAP server verification artıq §12.2-dəki mövcud adapterə əsaslanır; gameplay server replay və reklam SSV əlavə edilməyib. Cloud Run/Storage seçilməyib; backend deploy və canlı konfiqurasiya təxirə salınıb.

- DT08: ən son cloud save-dən davam geri dönüş sayılmır; köhnə backup/konflikt nüsxəsindən bərpa geri dönüş sayılır. Siyasət qəbul edilib; §7.2 implementasiya/sınaqları qalır.
- DT09 Android siyasəti: `targetSdk` buraxılış vaxtındakı Google Play tələbinə uyğun olacaq. `minSdk` seçilən SDK-ların uyğunluğu və cihaz sınaqlarına görə sonra müəyyənləşdiriləcək; API26 təsdiqlənmiş minimum və ya ilkin standart deyil. §13–14 cihaz matrisi yekun qərarla dəqiqləşdiriləcək.
- DT09 stack qərarı (3 noyabr 2026): Kotlin + Jetpack Compose təsdiqlənib; yüngül xəritə/at arabası hərəkətləri Compose Canvas və animasiya vasitələri ilə qurulacaq. Saf Kotlin engine, Room və digər §3–4 kitabxana/arxitektura detalları texniki tövsiyə olaraq qalır; PGS SDK seçimi ayrıca uyğunluq yoxlamasıdır. Firebase Spark backend sərhədi əvvəlki qərara uyğun saxlanır. Bu seçim implementasiyaya başlama icazəsi deyil.

### 16.3. Açıq oyun balansı və dizayn

B01–B10 istifadəçi tərəfindən qəbul edilib və `docs/decisions.json` → `balanceDecisions.confirmed` daxilində saxlanılıb. [BALANCE_PROPOSAL.az.md](BALANCE_PROPOSAL.az.md) qəbul edilmiş balans mətnidir; alternativlər qəbul edilməyib. B08 bütün şəhərlərdə gündəlik xəbərləri və yerli xəbər tarixçəsini, B09 son-gün yardım/gecikmə və dörd rekord kateqoriyasını, gün 20-də yalnız satış/mövcud borc ödənişi/bitirməni, B10 dəqiq nailiyyət trigger-lərini əhatə edir. Gecikmiş və yardımlı səfərlər uyğun nailiyyətləri verir. B06/B07-nin B08/B09-a bağlı qaydaları artıq açıq deyil. PNG rəqəmləri qəbul edilmiş balansı əvəz etmir. Sınaq meyarları yoxlama planıdır; real oynanış balans testi hələ aparılmayıb.

D1–D6 hələ tamamlanmayıb. Yeni hesab/cloud/social/consent/shop ekranları §9-dakı D5 coverage tələbidir; bu chatdə ekran dizaynı və render edilməyib.

### 16.4. Buraxılış inputları və yoxlama statusu

- İstifadəçinin məlumatına görə Play Console, AdMob və Unity başqa tətbiq üçün hazırdır. Bu, Barterune üçün tətbiq, reklam bloku, PGS və məhsul ID-lərinin mövcudluğunu təsdiqləmir; Unity inteqrasiyasının seçilməsi demək deyil.
- İstifadəçi göstərdiyi Google profili ilə açıq brauzerdə Play Console-a baxmağa icazə verib. 2 noyabr yoxlamasında qoşulu Chrome başqa hesabı göstərdi, istənilən hesab seçim siyahısında yox idi. Heç bir Console ayarı dəyişdirilmədi; hesabın yaradılma tarixi, developer adı və ictimai əlaqə e-poçtu yoxlanmayıb. Giriş üçün verilmiş e-poçt ictimai support ünvanı kimi qəbul edilmir.
- Sonrakı yoxlama aktiv Chrome-un native pəncərəsində uğurlu oldu: göstərilən Google profili və `AB Pixel Labs` developer hesabı açıqdır. `Barterune — Merchant Adventure` üçün Console tətbiq qeydi artıq mövcuddur. Console daxili tətbiq ID-si `4975590916599881823`-dür; bu Android `applicationId`/paket adı deyil. Dashboard qurulumda 13 tapşırıqdan 1-nin tamamlandığını göstərir.
- Bu tətbiqin Console dashboard-u production müraciətindən əvvəl ən azı 12 tester ilə fasiləsiz 14 günlük closed test tələbini birbaşa göstərir; hazırda 0 tester qeydiyyatlıdır. Hesabın dəqiq açılma tarixi görünməsə də, bu test qapısı artıq hesabın tarixindən şərti nəticə kimi deyil, tətbiq üçün müşahidə edilmiş tələb kimi plana daxil edilir. Heç bir ayar dəyişdirilməyib.
- Hələ lazım olanlar: şəxsi Play hesabının açılma tarixi, applicationId, ictimai əlaqə e-poçtu, konkret GitHub Pages privacy/deletion URL-ləri, Firestore regionu və Spark kvota/tutum hesabı (billing açılmadan), Barterune Play/PGS/AdMob ID-lərinin statusu. Secret-lər sənədə yazılmır.

### 16.5. Exact next step

Spark save/sync bölmələri texniki layihədir; oyun kodu və Rules implementasiyası yoxdur. Ayrı AppBackend billing nüvəsi və Android kitabxanası hazırlanıb; bu, hazır oyun və ya canlı deploy deyil. 3 noyabr plan düzəlişi billing bölmələrini həmin adapterlə uyğunlaşdırır. B01–B10 qəbul edilib və qərar mənbəyinə yazılıb. Növbəti kiçik sənəd/dizayn vahidi: qəbul edilmiş balansı D5-in xəbər, son-gün nəticə/rekord və nailiyyət axınlarının qəbul meyarlarına uyğunlaşdırmaq; bunun üçün ayrıca dizayn tapşırığı gözlənilir. D1–D6 tamamlanmış sayılmır. DT09-da Kotlin + Compose və Google Play-ə uyğun target siyasəti təsdiqlənib; minSdk SDK uyğunluğu və cihaz sınaqlarından sonra seçiləcək. M0-da §7 ölçü/kvota/retention hesabları, §6 deletion əməliyyat proseduru və §12 hesab-hüquq siyasəti bağlanmalıdır. M0 tamamlanana və implementasiya ayrıca istənənə qədər oyun kodu yazılmasın.
