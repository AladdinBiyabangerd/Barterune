# Barterune Android billing inteqrasiyası

Ayrıca Kotlin kitabxanasıdır; hazır oyun tətbiqi/APK deyil. Barterune-da əvvəl Android source olmadığı üçün UI və gameplay yaratmadan hazırlanıb. AppBackend-in Google alış nüvəsinə qoşulur. Real `applicationId`, Firebase layihəsi, backend HTTPS ünvanı və Play SKU-ları olmadan canlı alış başlatmaq hazır sayılmır.

## Çoxoyunlu backend sərhədi

Backend 2–3 oyuna xidmət edir; hər oyun öz adapterini və sabit `app` identifikatorunu istifadə edir. Eyni istifadəçi bütün oyunları oynaya bilər. Hesabın oyun daxilindəki açarı `(app, uid)`-dir; yalnız `uid` ilə oyun məlumatı seçilmir.

- Barterune adapteri `/v1/apps/barterune/…` yolunu çağırır. Digər oyunlar öz adapteri və app yolu ilə işləyir; tanınmayan app üçün başqa oyuna fallback olmamalıdır.
- Save/progress, balans, inventar, rekord, nailiyyət, alış hüquqları, pending əməliyyatlar və cache oyun üzrə ayrılır. Ortaq login oyun məlumatlarını birləşdirmir.
- Server seçilmiş app üçün auth konfiqurasiyasını, paket adını və SKU kataloqunu yoxlamalıdır; client-in app seçməsi təkbaşına icazə deyil.
- Retry/deduplikasiya, fon işləri və hesab silmə də app sərhədini saxlamalıdır. Bir oyundakı silmə digər oyunlardakı məlumatları silməməlidir; bütün oyunlar üzrə hesab silmə ayrıca açıq əməliyyatdır.
- Qəbul yoxlaması: eyni UID ilə iki app-də eyni məhsul/əməliyyat adları istifadə olunur; birində alış, retry, progress dəyişikliyi və silmə digərində dəyişiklik yaratmamalıdır. Yanlış app/paket/token kombinasiyası rədd edilməlidir.

Bu bölmə arxitektura tələbidir; bütün backend yollarının və gələcək oyun adapterlərinin izolyasiya sınağından keçdiyi iddiası deyil.

## Modul quruluşu

- `core`: hesab sessiyası, checkout uyğunluğu, davamlı pending queue müqaviləsi, server təsdiqi və hesab üzrə cache. Android-dən asılı olmayan 13 ssenari testi.
- `android`: Billing Library 9.1.0 bridge, HTTPS backend adapteri, Android Keystore/AES-GCM ilə şifrələnmiş jurnal.
- SDK qiyməti və uyğun offer-lər Play-dən gəlir. SKU allowlist-i backend-in authenticated `billing/catalog` endpoint-indən gəlir.

Go backend üçün Redis/başqa runtime əlavə edilmir. Mobil modulda Firebase SDK, Room və WorkManager-in ikinci nüsxəsi yoxdur; hostun Firebase girişi `AccountSessions` vasitəsilə qoşulur.

## Host tətbiqinə qoşulma

Mövcud host Gradle layihəsi yaradıldıqda `:core` və `:android` modullarını daxil et və tətbiqə `implementation(project(":android"))` əlavə et. Namespace `appbackend.barterune.billing` kitabxananın kod namespace-idir; oyunun mağaza `applicationId` seçimi deyil.

```kotlin
val sessions = AccountSessions { expectedUid ->
    val user = firebaseAuth.currentUser ?: throw AccountChanged()
    if (user.uid != expectedUid || user.isAnonymous) throw AccountChanged()
    // Hostun artıq istifadə etdiyi Task-to-coroutine adapteri ilə:
    user.getIdToken(false).await().token ?: throw AccountChanged()
}
val journal = SecurePurchaseJournal(applicationContext)
val backend = AppBackendClient(realBackendHttpsOrigin, sessions)
val coordinator = BillingCoordinator(sessions, backend, journal, applicationContext.packageName)
val play = PlayBillingBridge(applicationContext, coordinator)
```

Firebase Auth listener-i hər giriş/çıxış keçidində `sessions.onAuthChanged(user?.uid)` çağırmalıdır. Eyni UID ilə yenidən login də yeni epoch yaradır. Listener-də anonim istifadəçini `null` kimi ötür. Hər foreground/Google Play-dən qayıdışda, hesab listener-i yeniləndikdən sonra `play.onForeground()` çağır. `play.notices`-i UI-dən topla; istifadəçiyə pending, cancel, wrong-account və retry vəziyyətlərini lokallaşdırılmış göstər.

Alışdan əvvəl `play.offers(realSku)` ilə Play-in yerli qiymətini/offer tokenini al. İstifadəçinin seçdiyi cari offer üçün `play.buy(activity, realSku, selectedOfferToken)` çağır. Qiyməti backend və ya hardcoded mətnlə əvəz etmə. Offers və buy suspend API-lərdir; UI onları lifecycle coroutine scope-dan çağırmalıdır.

`coordinator.activeEntitlements()` cari hesabın yalnız əvvəl serverdən yoxlanmış cache-ni verir. UI bu dəyərləri `Updated` bildirişində və auth dəyişməsində yenidən oxumalıdır. Checkout-un açılması və `PURCHASED` callback-i təkbaşına kosmetikanı açmır.

## Nasazlıq və hesab dəyişməsi

- Purchase callback-də `PENDING` hüquq vermir; növbəti foreground Play sorğusu tamamlanan alışları yenidən tapır.
- PURCHASED tokeni əvvəl şifrələnmiş jurnala commit edilir, sonra serverə göndərilir. Disk xətasında server çağırışı başlanmır.
- Şəbəkə xətasında token eyni UID-nin queue-sunda qalır; yeni proses onu foreground-da retry edir. Müştəri acknowledge/consume çağırmır; bu işi server davamlı commit-dən sonra edir.
- Server cavabı gələnədək hesab və ya login epoch dəyişibsə yeni hesabın cache-i yenilənmir.
- Hesab dəyişdikdə başqa UID-nin queue/cache-i ona açılmır. Account identifier olmayan və ya uyğun gəlməyən köhnə alışlar rədd edilir; səssiz transfer yoxdur.
- Onlayn uğurlu entitlement refresh cache-i tam əvəz edir; köhnə save-dən union edilmir. Müvəqqəti şəbəkə xətası refund hesab edilmir.
- Hesab silmə server baryeri təsdiqlənəndən sonra `clearDeletedAccount(uid)` çağırmalıdır. Bu metod server məlumatını silmir; DT04 coordinator-u ayrıca işdir.

## Yaddaş və backup

Jurnal `barterune_billing.xml` SharedPreferences faylında, AES-GCM ciphertext şəklindədir. AAD hər UID-yə bağlıdır, açar Android Keystore-dadır; purchase token və Firebase ID tokeni log edilmir. Firebase ID tokeni jurnala yazılmır. KeyStore və ya ciphertext xətası zamanı məlumat səssiz təmizlənmir.

Host manifestində mövcud backup qaydalarına `barterune_billing_backup_rules.xml` və API31+ `barterune_billing_data_extraction_rules.xml`-dəki exclude-ları birləşdir. Kitabxana hostun başqa save/auth backup istisnalarını overwrite etmir. OS backup-dan billing cache bərpasına arxalanma; yeni cihazda Play/backend restore tələb olunur. Billing kitabxanası yalnız bir tətbiq prosesində istifadə edilməlidir.

## Versiyalar və DT09

Kotlin 2.1.10, AGP 8.13.0, Gradle 8.13, compileSdk 36, Play Billing 9.1.0. Kitabxananın texniki `minSdk=23` aşağı həddi istifadə edilən Billing/Keystore SDK-ları üçündür; Barterune-un məhsul minimum Android versiyası hələ seçilməyib. Hostun targetSdk-si buraxılış vaxtındakı Google Play tələbinə uyğun seçiləcək. Burada oyun app modulu və targetSdk qərarı yaradılmır.

## Yoxlama

JDK21 və Android SDK36 ilə:

```sh
./gradlew :core:test :android:assembleDebug :android:lintDebug --no-daemon
```

Core testləri server xəta/retry, process restart, yanlış hesab, pending, package/SKU allowlist, logout və login epoch halları üçündür. Keystore/Play UI/real cihaz və real backend TLS çağırışları bu JVM testlərinin sübutu deyil; license tester/device yoxlaması ayrıca qalır.

## Cari əhatə

İstifadəçinin son göstərişi ilə SKU, credential, upload, deployment və real konfiqurasiya doldurulması sonraya saxlanılıb. Aktiv Gradle layihəsi yalnız `:core` və `:android` kitabxanalarıdır. Başlanmış Play bootstrap işi `.local/deferred-play-bootstrap` daxilinə ayrılıb; aktiv build-ə daxil deyil və Play-ə yüklənməyib. Backend URL, Firebase sessiyası və SKU kataloqu sonradan xaricdən veriləcək.
