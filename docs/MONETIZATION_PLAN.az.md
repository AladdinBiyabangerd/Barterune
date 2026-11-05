# Barterune mükafatlı reklam və mağaza implementasiya planı

Tarix: 2 noyabr 2026. Status: implementasiya üçün təklif olunan spesifikasiya. İstifadəçinin təsdiqlədiyi monetizasiya çərçivəsi: yalnız könüllü mükafatlı reklam və real pulla alış; banner, avtomatik interstitial və rewarded interstitial yoxdur. Aşağıdakı balans rəqəmləri və yeni məhsullar sınaq başlanğıcıdır, təsdiqlənmiş oyun qaydaları deyil.


## Son qərar əlavəsi — 2 noyabr 2026

İstifadəçi oyunun Google Play-də ödənişli yüklənməsini seçib; qiymət hələ açıqdır. Könüllü rewarded reklam və kosmetik alışlar da qalır. Bu, aşağıdakı əvvəlki monetizasiya çərçivəsini genişləndirir. V1 yalnız classic-dir; supported və iqtisadi reklam dəstəyi sonraya saxlanır.

Firebase ilkin mərhələdə pulsuz Spark planında olacaq; əlavə yoxlama serveri qurulmur. İstifadəçi online + offline oyun, client yoxlamaları və Firebase Security Rules ilə mümkün qorumanı seçib. Aşağıdakı server SSV, server grant ledger və purchase verification axınları ilkin versiya tələbi deyil, gələcək mərhələdir. Client callback server təsdiqi sayılmır; lokal deduplikasiya və Firestore atomik qeydləri hadisənin həqiqiliyini sübut etmir. 3 noyabr 2026: V1 client rewarded, Firestore attempt/grant deduplikasiyası, client Billing acknowledgment və Play query restore/refund layihəsi `IMPLEMENTATION_PLAN.az.md` §12-də yazılıb; aşağıdakı köhnə server müqavilələrinə texniki üstünlük verir. Play↔Firebase hesab bağlanması, silinmədən sonra restore siyasəti və dəqiq limitlər açıqdır. Gəlir yarandıqda Blaze nəzərdən keçirilə bilər; hazırda billing/deploy təsdiqi yoxdur. Əsas qərar: `docs/IMPLEMENTATION_PLAN.az.md` §2.1 və §16.


Məqsəd reklam düyməsini menyuda gözlətmək deyil: oyunçunun məqsədini və həmin andakı ehtiyacını müəyyən edib, ölçülə bilən faydanı həmin yerdə təklif etməkdir. Reklamdan mağazaya keçid faydanı sınamaq → nəticəni görmək → daimi məhsulu nəzərdən keçirmək ardıcıllığı ilə qurulur. Optimallaşdırma hədəfi tək reklam sayı deyil, oyunçu başına ümumi xalis gəlir və oyunda qalmanın birlikdə yaxşılaşmasıdır.

## 1. Real məlumat və onun tətbiq sərhədləri

### 1.1 Kontekstual təklif üçün sənaye məlumatı

Unity 2024 Mobile Growth and Monetization Report-da resurs bitəndəki rewarded yerləşdirməsində ad-watcher göstəricisi 38,1%, səviyyələr arasında 23,8%, mağazada və lobby/map/pre-level yerləşdirmələrində 25,2% göstərilir. Resurs konteksti ilə səviyyələrarası göstəricinin fərqi 14,3 faiz bəndidir. Hesabat bu yerləşdirmə müqayisəsi üçün 5 000-dən çox DAU və gündəlik 50 ABŞ dollarından çox mediated rewarded-video gəliri olan oyunları əhatə edir. Bu, yeni indie oyun üçün proqnoz və ya təsadüfi bölünmüş eksperiment deyil. Hesabatdakı 1,83% lifetime IAP çevrilməsi də ayrıca 2023 quraşdırmaları və gəlir şərtləri olan seçmədir; gündəlik alıcı faizi sayılmamalıdır. [Unity 2024 hesabatı](https://legacy-activation-v2.unity3d.com/resources/mobile-growth-monetization-report-2024).

Barterune üçün hipotez: yük tutumu çatışmazlığı və səfərsonu növbəti açılışa yaxınlıq, kontekstsiz mağaza reklamından daha faydalı yerləşdirmələr ola bilər. Ehtiyacı süni yaratmaq bu məlumatdan çıxan nəticə deyil.

### 1.2 Reklamdan alışa keçid üçün məlumat

Unity/ironSource-un 24 avqust 2022 tarixli, səkkiz yüksək DAU tətbiqini təhlil edən yazısında ən azı bir rewarded reklamla qarşılıqlı əlaqəyə girən yeni istifadəçilərin alış çevrilməsi orta hesabla 4,5 dəfə yüksək olub. Qruplar reklamı özləri seçiblər: daha bağlı oyunçular həm reklama baxa, həm pul xərcləyə bilər. Bu korrelyasiyadır; “reklam göstərsək alış 4,5 dəfə artacaq” iddiası üçün əsas deyil. [İlkin təhlil](https://unity.com/blog/understanding-the-impact-of-rewarded-ads-on-iap-retention-and-engagement).

Barterune üçün hipotez: müvəqqəti faydanı həqiqətən istifadə edən oyunçuya onun daimi versiyasını göstərmək. Alış artımını ayrıca randomizə edilmiş testlə ölçmək lazımdır.

### 1.3 Məqsədə yaxınlaşma psixologiyası

Kivetz, Urminsky və Zheng-in 2006-cı il tədqiqatı kafe loyallıq proqramında və başqa tapşırıqlarda mükafata yaxınlaşdıqca səyin artmasını araşdırır. Bu, mobil oyun reklam çevrilməsi üzrə faiz vermir. [Müəllifin universitet səhifəsində orijinal məqalə](https://home.uchicago.edu/ourminsky/Goal-Gradient_Illusionary_Goal_Progress.pdf).

Tətbiq hipotezi: “160 / 200 nişan; bu reklam +40 nişan verir” kimi real və düzgün irəliləyiş göstərmək. Saxta başlanğıc irəliləyişi, gizli bahalaşma və sıfırlanan sayğac tətbiq edilmir.

### 1.4 Reklam keyfiyyəti gəlirə təsir edən amildir

Deloitte və Google AdMob-un 10 iyun 2025 açıqlaması 7 000 oyunçulu sorğu və beş ölkədə 50 iştirakçılı gündəlik araşdırmasına əsaslanır. Sorğuda hər beş oyunçudan biri keyfiyyətsiz reklam təcrübəsinə görə sevdiyi oyunu tərk edəcəyini bildirib. Bu özünüifadə məlumatıdır, Barterune üçün ölçülmüş churn deyil. [Araşdırmanın açıqlaması](https://www.deloitte.com/us/en/about/press-room/deloitte-improve-mobile-game-advertising.html).

Tətbiq: reklam şəbəkəsi seçimində eCPM ilə yanaşı səhv bağlanma, məcburi yönləndirmə, şikayət və oyuna qayıtma göstəriciləri də izlənir.

## 2. Məhsul çərçivəsi və mövcud qərarlarla uyğunluq

Mənbə: `docs/decisions.json`. Mövcud qaydalar saxlanır: üç yuva, ortaq kosmetikalar, səfərə aid pul/yük/gün, 20 günlük səfərdə bərabər başlanğıc, deterministik hadisələr, şəhər yaddaş nöqtəsi və geri dönüşlü rekordların ayrılması.

Reklam və IAP hesab səviyyəsində idarə edilir; yuva dəyişmək, səfəri silmək və ya checkpoint yükləmək reklam limitini və istifadə edilmiş hüququ bərpa etmir.

### 2.1 İki səfər qaydası

1. Klassik səfər: 20 gün, dəyişməyən iqtisadi şərtlər. Reklam yalnız səfərdənkənar kosmetik nişan və görünüş verir. Pul, bazar məlumatı, yük tutumu, qoruma və geri dönüş reklamla satılmır.
2. Dəstəkli səfər: ayrıca təklif olunan qayda dəsti. Başlanğıc iqtisadi vəziyyət eynidir; sonradan limitli reklam dəstəyi ala bilər. Başlamazdan əvvəl “Bu səfərdə reklam dəstəyi mümkündür. Rekordlar ayrıca saxlanır” izahı verilir. Oyunçu hazırkı klassik səfərin ortasında bu rejimə keçirilmir.

`ruleset = classic | supported`, `rewind_used = boolean`, `mode` və `ruleset_version` nəticədə saxlanır. Mövcud iki geri dönüş tabını çoxaltmaq əvəzinə əvvəl qayda/rejim filtri, sonra əvvəlki tablar tətbiq edilir. Dəstək almayan supported səfər də supported qalır; geri çevirmək və qarışıq rekord yaratmaq olmaz.

Dəstəkli səfər yeni məhsul qərarıdır: ayrıca feature flag arxasında hazırlanır. Açılana qədər klassik səfər və kosmetik monetizasiya müstəqil işləyir. Daimi inkişaf rejimi mövcud olmadığı üçün onun gəlirini ilk buraxılışın təmin olunmuş hissəsi saymaq olmaz.

### 2.2 Başlanğıc iqtisadiyyat

- Qızıl: yalnız səfər iqtisadiyyatı; V1-də real pulla satılmır.
- Tacir nişanı: hesab üzrə ortaq, yalnız kosmetika üçün; alınan məhsul kimi pul vahidi deyil, gameplay və reklamla qazanılır. Başqa oyunçuya ötürülmür, nağda çevrilmir.
- Dəstək hüququ: konkret səfərə aid, ayrıca ledger qeydi olan bir bonus. V1-də real pulla alınmır.
- Kosmetika: daimi IAP məhsulu və ya nişanla açılan kataloq əşyası. Hər məhsulun əldəetmə yolu əvvəlcədən açıq göstərilir.

Bu ayrım bazar balansını pullu valyuta ilə qarışdırmır və nəticədə hesablaşmanı dəyişmir.

## 3. Motivasiya mexanizmləri və təklif ardıcıllığı

### 3.1 Ehtiyac anı

Oyunçu konkret malı almağa çalışıb tutuma ilişir → mövcud pulsuz alternativlər görünür → uyğun supported səfərdə əlavə yerin dəqiq təsiri təklif edilir. Reklam ümumi “hədiyyə” deyil, konkret planı rahatlaşdıran seçim olur.

Şərt: təklifdən əvvəl oyunçu öz niyyətini alış miqdarı və ya açılış hədəfi ilə göstərməlidir. Təkcə ekranın açılması ehtiyac sayılmır. Tək pul çatışmazlığında tutum reklamı göstərilmir.

### 3.2 Real irəliləyiş

Oyunçu kataloqdan bir kosmetikanı “Hədəf seç” edə bilir. Səfərsonu nişan mükafatı yanında həmin hədəf göstərilir. Reklam mükafatı çatışmayan miqdarı tamamlayırsa “Bu bonusla açılır” faktı göstərilə bilər. Çatmırsa qalan miqdar dürüst göstərilir. Reklamdan əvvəl də, sonra da kataloq qiyməti eyni qalır.

### 3.3 Sınaq və daimi sahiblik

Oyunçu kosmetikanı əvvəl pulsuz önizləyir, reklamla bir səfər geyinir. Nəticədə öz karvanını həmin görünüşdə görür. Səfər bitdikdən sonra kosmetika detalında onun daimi versiyasına keçid görünür. Məcburi mağaza modalı açılmır və sınaq avtomatik pullu alışa çevrilmir.

Bu, Barterune üçün sınaq hipotezidir; mənbələr konkret kosmetika çevrilmə faizi vermir.

### 3.4 Alışın dəyərini aydınlaşdırmaq

Mağaza ilkin olaraq üç konkret məhsul göstərir. Hər məhsulun görünüşü, daimi və ya birdəfəlik olması, nəyi dəyişdirdiyi və yerli qiyməti görünür. “Ən populyar” yalnız həqiqi alış məlumatı bunu dəstəkləyirsə göstərilə bilər. Saxta endirim, saxta rəylər, uydurma məhdud say və təkrar başlayan timer yoxdur.

### 3.5 Təklif yorğunluğu

Reklam təklifinin təsirini artırmaq onu hər yerdə təkrarlamaq demək deyil. Bir oyunçu eyni kontekstual təklifi rədd edəndə həmin vəziyyətdə yenidən təklif edilmir. Ardıcıl iki rədd sonrası proactive vurğulama 24 saat dayanır; oyunçunun özü açdığı kataloqda könüllü imkan qalır.

Yaşa həssas qruplar və uşaqlar üçün davranış əsasında xərcləmə təzyiqi, fərdiləşdirilmiş alış təqibi və bu eksperimentlər açılmır. Auditoriya təsnifatı məlum olmayana qədər bunlar yetkin auditoriya üçün belə ümumi, sabit qaydalarla işləyən təkliflərdir; uşaq auditoriyasında monetizasiya ayrıca platforma yoxlamasından keçməlidir.

## 4. Reklam yerləşdirmələrinin dəqiq spesifikasiyası

Bu bölmədəki bütün limitlər balans hipotezidir. Hər reklam başlanmazdan əvvəl mükafat və tələb olunan reklam hərəkəti açıq deyilir. Müddət şəbəkədən asılıdır; təmin edə bilmədiyimiz “30 saniyə” vədi verilmir.

### R1 Səfərsonu nişan bonusu

- Ekran: seçilmiş 62B nəticə ekranı; 79B yekun satış atomik bitdikdən sonra, xalis sərvət və rekorddan ayrı “Kosmetik açılışlar” sahəsi.
- Trigger: tamamlanmış, təlim olmayan, ən azı 3 fərqli şəhərə çatmış 20 günlük səfər. Tərk edilmiş səfər uyğun deyil. Bu şərtlər səfərsonu pulsuz nişana da eyni tətbiq edilir.
- Pulsuz baza: 40 nişan; nəticə yarananda bir dəfə verilir. Reklam əlavə 40 nişan verir; səfər sərvəti ikiqat olmur.
- Mətn: “40 nişan qazandın. Reklamı tamamla, əlavə 40 nişan al.” Düymə: “Reklam izlə · +40 nişan”. Adi “Davam et” həmişə aktivdir.
- Hədəf: seçilmiş əşya varsa cari balans / qiymət göstərilir; hədəf yoxdursa bonus yenə mövcuddur.
- Limit: hər run üçün 1; hesab üzrə UTC günündə ən çox 2. Bonus növbəsi 7 gün saxlanır; bu müddət reklam başlamazdan əvvəl görünür. Başlanmış və tamamlanmış reklamın haqqı müddət bitdikdə də itmir.
- No-fill/offline: “Hazırda reklam yoxdur. Bonusu sonra nəticələrdən ala bilərsən.” Pulsuz 40 nişan və oyuna davam toxunulmazdır.
- Farm qoruması: run completion ID və baza mükafat ID-si checkpoint ilə dəyişmir; eyni run üçün nəticə təkrar açılmır.
- Qəbul: reklamı bağlamaq bazanı silmir; iki reward callback əlavə 80 vermir; başqa yuvadan bonus almaq eyni gündəki qlobal sayğaca daxildir.

### R2 Tutum çatışmazlığında səfərlik əlavə yer

- Ekran: 71A bazar məhdudiyyətinin inline sahəsi; 53B yanaşı Al/Sat düymələrini örtmür. Avtomatik popup yoxdur.
- Uyğunluq: `ruleset=supported`, təlim bitib, istifadəçi miqdar daxil edib, həmin miqdar pul baxımından alına bilir, amma yük ölçüsü tutuma sığmır; bu səfərdə R2 verilməyib; gün 19 və 20 deyil.
- Mükafat: `bonus_capacity = max(1, floor(base_run_capacity * 0.20))`. Məsələn, baza 20-dirsə +4 yer. Təkmilləşdirmə ediləndə bonus yenidən hesablanmır və artırılmır. Bütün səfər boyu qalır, səfər bitəndə sıfırlanır. Buna görə səyahət ortasında “artıq yük” problemi yaranmır.
- Əlavə filter: bonus bu əməliyyatda ən azı 1 əlavə mal vahidi almağa imkan verirsə göstərilir. Mövcud bazar ehtiyatı da hesablanır.
- Mətn: “Bu alış üçün yük yeri çatmır. Reklamı tamamla: bu səfər üçün +4 yük yeri.” Dəqiq bonus snapshot-dan gəlir.
- Pulsuz seçimlər: miqdarı uyğunlaşdır, yük sat, oyundaxili qızılla təkmilləşdir. Bunların yanında reklama xüsusi bloklama verilmir.
- Limit: hər səfərdə 1; hesab üzrə UTC günündə 1; qlobal rewarded cap-a daxildir.
- Qayıdış: tutum artırılır, miqdar forması yenilənir; mal avtomatik alınmır. Qiymət/ehtiyat köhnəlibsə əməliyyat yenidən hesablanır.
- Klassikdə görünmür. R2 xərclənməmiş olsa belə bu səfər classic rekorduna daxil olmur.
- Gecikmiş təsdiq: səfər bitibsə iqtisadi fayda tətbiq edilmir; hesabın dəstək inbox-una eyni R2 hüququ verilir. Növbəti supported run-da yalnız həmin run-un R2 limitini istifadə etməklə aktivləşdirilir; yeni reklam bonusu ilə yığılmır. Bu əvəzləmə şərti reklamdan əvvəl detallarda görünür.

### R3 Kosmetikanı bir səfər sına

- Ekran: yeni “Karvan görünüşü” detalı; 64A əsas menyuda kosmetika/mağaza keçidindən açılır. Bazar alt naviqasiyasına dördüncü tab əlavə edilmir.
- Trigger: oyunçu sahib olmadığı uyğun kosmetikanı açır. Pulsuz vizual önizləmə həmişə var; reklam yalnız istifadə hüququ üçündür.
- Mükafat: seçilmiş əşya üçün bir səfərlik trial token. Token öz-özünə vaxtla bitmir. İstifadəçi yeni səfər başlatma ekranında seçəndə run ID-yə atomik bağlanır; ləğv edilən start tokeni yemir. Trial səfər boyu qalır; həmin səfəri silmək tokeni qaytarmır.
- Mətn: “Bu görünüşü bir səfər istifadə et — reklamı tamamla.” Daimi qiymət ayrıca: “Daimi aç · {store_price}”.
- Limit: hesab üzrə UTC günündə 1 reklam; hər əşya üçün ən çox 1 trial; bir anda ən çox 1 xərclənməmiş trial token.
- Oyunçu almaq istəsə native store təsdiqi açılır. Reklamdan qayıdan kimi alış pəncərəsi açılmır.
- Əşyanı reklam gedərkən başqa cihazda alıbsa trial əvəzinə 40 kosmetik nişan verilir. Əvəzləmə reklamdan əvvəl detal mətnində göstərilir.
- Trial vizualdır, nə classic, nə supported rekord qaydasını dəyişmir.

### R4 Daimi inkişaf rejimində istehsal və xidmət sınağı

V1-də bağlıdır. Daimi inkişaf iqtisadiyyatı hazırlanandan sonra ayrıca balans işi tələb edir. Ehtimal edilən kontekst: emalatxanada oyunçunun özünün seçdiyi təkmilləşdirməyə az resurs çatmaması. Mükafat adi gameplay ilə əldə edilən, bir istehsal dövrünə bərabər sabit resurs paketi ola bilər. Dövrün uzunluğu, qiyməti, gündəlik resurs büdcəsi və sink-lər ölçülmədən rəqəm və ya gəlir proqnozu verilmir.

### R5 Hadisədən sonra itki bərpası

V1-də bağlıdır. Əvvəlki söhbətdə təklif edilsə də ilkin buraxılışa daxil edilmir: itki modeli hələ açıqdır, qoruma xidmətləri ilə qarşılıqlı təsir və checkpoint-dən farm riski var. Gələcəkdə yalnız supported/daimi rejimdə, əvvəlcədən elan edilmiş sığorta qaydası və hadisə ID-si üzrə birdəfəlik ödənişlə qiymətləndirilə bilər. Quldur hadisəsinin ehtimalı və zərəri monetizasiya profilinə görə dəyişməməlidir.

## 5. Qlobal təklif qaydaları

İlkin konfiqurasiya:

- İlk 5 aktiv dəqiqədə və təlim boyu proactive monetizasiya vurğusu yoxdur. Oyunçunun özü açdığı mağazada kataloq görünə bilər.
- Rewarded başlanğıcları arasında 180 saniyə; növbəti video avtomatik başlamır.
- Gündə ən çox 4 uğurlu rewarded mükafat; hesab və UTC günü üzrə. Hər placement-in daha aşağı limiti ayrıca qüvvədədir.
- Sayğac uğurlu grant-da artır; davam edən attempt müvəqqəti rezervasiya tutur ki, iki cihaz limiti paralel keçməsin.
- Reklam başlamadan açılmış rezervasiya 120 saniyədə boşala bilər. Başlamış attempt provider nəticəsi və reconciliation bitmədən yenidən istifadə edilə bilməz; gecikmiş etibarlı completion həmişə ödənir, yalnız texniki gecikməyə görə mükafat rədd edilmir.
- Hər ekran səfərində ən çox 1 proactive vurğu; eyni shortage ID rədd edildikdən sonra tutum yenə çatmasa belə vurğu təkrarlanmır. Oyunçu placement-i özü aça bilər.
- Ardıcıl iki explicit rədd → 24 saat proactive vurğu susur. Rədd `Davam et`, dismiss və ya explicit “İndi yox” ilə qeyd edilir; no-fill və SDK xəta rədd sayılmır.
- Reklamdan sonrakı ilk 180 saniyədə proactive mağaza təklifi yoxdur. Daimi məhsulun adi kataloq düyməsi gizlədilmir.
- Eyni anda ad və purchase axını işləyə bilməz. Aktiv hadisə, yaddaş bərpası və yekun satış tranzaksiyası zamanı monetizasiya açılmır.
- Privacy vəziyyəti sorğuya icazə vermirsə SDK reklam istəmir. Offline oyun davam edir; mağaza və reklam üçün internet ehtiyacı ayrıca yazılır.

Offer sırası: istifadəçinin özü açdığı konkret detal → mövcud ekrandakı uyğun R2 → səfər nəticəsində R1. Ekran dəyişən kimi əvvəlki təklifin avtomatik modalı növbəyə yığılmır.

“Gündə 4” optimallaşdırma faktı deyil; başlanğıc yük limitidir. Caps remote config ilə dəyişə bilər, amma aktiv attempt-in mükafatı dəyişdirilə bilməz.

## 6. Mağaza və pullu məhsullar

### P1 Daimi araba görünüşü

`barterune.skin.crimson_caravan`, non-consumable. Bir araba görünüşü və uyğun bayraq; statistik üstünlük yoxdur. İlkin qiymət hipotezi 2,99 ABŞ dolları ekvivalentidir. UI həmişə platformanın qaytardığı lokal qiymət mətnini göstərir, dollar rəqəmini hardcode etmir. R3 sınağı bu məhsula bağlanır.

### P2 Karvan kolleksiyası

`barterune.collection.merchants`, non-consumable. P1-dən ayrı üç kosmetik əşya; ilkin qiymət hipotezi 6,99 ABŞ dolları ekvivalenti. P1 ilə eyni əşyalar daxil edilmir ki, əvvəlki alıcı eyni görünüş üçün ikinci dəfə ödəniş etməsin. Paketin məzmunu tam görünür; təsadüfi qutu deyil.

### P3 Reklamsız kosmetik bonuslar

`barterune.cosmetic_bonus_pass`, non-consumable; ilkin qiymət hipotezi 7,99 ABŞ dolları ekvivalenti. Adı “Reklamları sil” deyil, çünki məcburi reklam onsuz da yoxdur.

- R1 üçün eyni run/gün şərtləri daxilində əlavə +40 nişan videoya baxmadan iddia edilir.
- R3 üçün eyni gündəlik və əşya limitləri daxilində trial reklamsız alınır.
- R2 yük bonusunu daxil etmir; oyun iqtisadiyyatı və rekord qaydalarını dəyişmir.
- Bonus avtomatik fonda verilmir; “Bonusu al” əməliyyatı eyni grant ledger-dən keçir.
- Rewarded izləmə limiti ilə pass claim limiti ayrıca sayılır, amma R1 və R3 placement limitləri mənbədən asılı olmayaraq ortaqdır. Alış gün ərzində əvvəl alınmış bonusu ikinci dəfə açmır.
- Pass sahibi üçün R1/R3 reklam CTA-sı çıxarılır. R2 varsa ayrıca könüllü reklam olaraq qalır; bu istisna məhsul səhifəsində alışdan əvvəl aydın göstərilir.
- Yeni reklam placement-ləri gələcəkdə bu məhsula avtomatik daxil sayılmır. Vəd məhz R1/R3 üçündür.

V1-də subscription, qızıl paketləri, ödənişli can, loot box, itki anında təcili alış pəncərəsi və checkpoint haqqı yoxdur. P3 gəlir riskidir: reklama ən çox baxanlar onu alıb gələcək reklam gəlirini azalda bilər; ayrıca eksperiment tələb edir.

### 6.1 Mağazaya yönəltmənin şərtləri

1. Kosmetik trial faktiki bir səfərdə istifadə edilib → səfərsonu görünüş detalında “Daimi aç” keçidi. Sadəcə token almaq istifadə sayılmır.
2. Son 7 gündə ən azı 3 R1/R3 mükafatı alınıb → əsas menyudakı mağaza keçidində P3-ün “Kosmetik bonusları reklamsız al” izahı. Eyni istifadəçiyə proactive vurğu ən çox 7 gündə 1 dəfə.
3. İstifadəçi kolleksiya detalını özü açıb → artıq sahib olmadığı P2 əşyaları önizlənir; mağaza bağlananda təqib popup-ı açılmır.
4. İlk alışdan sonra eyni sessiyada əlavə satış təklifi yoxdur. Mağaza normal qalır.

Bunlar davranışa görə məhsul uyğunlaşdırmasıdır; ödəmə qabiliyyəti, borc, şəxsi maliyyə, emosional həssaslıq və uşaqlıq kimi məlumatlar üzrə seqmentasiya aparılmır. İlkin mərhələdə hər region/storefront üçün eyni təsdiqlənmiş qiymət kataloqu istifadə edilir.

## 7. İqtisadi balans və nişan büdcəsi

İlkin nişan kataloqu: sadə bayraq 200, araba rəngi 600, premium olmayan xüsusi görünüş 1 200 nişan. Bunlar yalnız nişanla açılan əşyalardır; IAP-exclusive məhsullar ayrıca işarələnir.

Uyğun səfər üçün 40 baza + 40 reklam bonusu:

- 200 nişan: reklamsız 5, hər dəfə bonusla 3 uyğun səfər.
- 600 nişan: reklamsız 15, hər dəfə bonusla 8 uyğun səfər.
- 1 200 nişan: reklamsız 30, hər dəfə bonusla 15 uyğun səfər.

Bu “neçə günə açılır” deyil, səfər sayıdır. Faktiki səfər uzunluğu telemetriyada ölçülmədən gündəlik açılış tempi və gəlir fərziyyəsi qurulmur. R1 gündə ən çox 2 olduğu üçün daha çox səfər edənlərin bütün səfərləri ikiqatlaşmır.

Nişan yalnız alış zamanı sink olur. P3-ün uzunmüddətli supply artımını izləmək üçün hesab üzrə həftəlik qazanılan/xərclənən nişan, açılmamış kataloq qiymətinin cəmi və ilk açılışa qədər səfər sayı saxlanır. Kataloq bitəndə “faydasız nişan üçün reklam” vurğulanmır; R1 proactive təklif bağlanır, mövcud haqq saxlanır. Kataloq genişlənmədən supply artırılmır.

R2-nin iqtisadi təsiri əlavə yer × marşrut üzrə marja ilə ölçülür. Bu bonusun supported səfər sərvətini nə qədər artırması, dəstəkdən istifadə etməyənlərin oyun bitirmə faizi və pulsuz təkmilləşdirməyə tələbi ayrıca izlənir. Bonus almaq üçün baza tutumu və qiymətlər pisləşdirilmir.

## 8. Ekran və vəziyyət axınları

### 8.1 R2 bazar axını

Miqdar daxil edilir → stock/pul/tutum ayrıca yoxlanır → pulsuz alternativlər göstərilir → uyğun R2 inline görünür → istifadəçi seçir → dəqiq mükafat və səfər müddəti təsdiqi → reklam → grant təsdiqi → tutum yenilənir → istifadəçi alış düyməsini özü basır.

Əsas Al/Sat idarələri, miqdar klaviaturası, xəbər zolağı və Bazar/Xəritə/İnventar naviqasiyası reklama görə dəyişmir. Reklam CTA-sı bazar xəbər zolağına yerləşdirilmir; xəbər ilə reklam məzmunu qarışmır.

### 8.2 R1 nəticə axını

Yekun satış → atomik nəticə və baza 40 nişan → sərvət/rekord göstərilir → ayrıca kosmetik bonus sahəsi → reklam və ya pass claim → nişan ledger-i yenilənir → hədəf açılırsa “Görünüşə bax” keçidi. Yeni səfər başlanması bonus üçün məcburi deyil.

### 8.3 R3 və alış axını

Önizləmə → reklamla trial və ya daimi məhsul detalı → trial token → növbəti səfər başlananda istifadə → səfərsonu kosmetik detal → lokal qiymət → native purchase sheet → verification → entitlement → istifadəçiyə uğur bildirişi.

### 8.4 Bütün placement-lərin vəziyyətləri

- `ineligible`: CTA yoxdur; oyun hərəkəti normaldır.
- `loading`: qısa yüklənmə statusu; geri/davam bloklanmır.
- `ready`: mükafat, mənbə və limit görünür.
- `showing`: oyun pauzada; tətbiqin öz reklam bağlama idarəsi SDK üzərinə çəkilmir.
- `pending_verification`: “Mükafat yoxlanır”; eyni bonus ikinci dəfə başladılmır. Oyundan çıxıb qayıtmaqla inbox-dan alınır.
- `granted`: balans və hüquq yalnız bir dəfə dəyişir.
- `dismissed_without_reward`: mükafat yoxdur; oyuna qayıdır. Dərhal yenidən popup yoxdur.
- `unavailable` / `failed_to_show`: səbəb uyğun qısa mətnlə; sayğac xərclənmir, “almalısan” mağaza yönləndirməsi yoxdur.
- `limit_reached`: növbəti uyğun vaxt yerli saatla göstərilə bilər; müddət server UTC qaydasından hesablanır.

Vizual implementasiyadan əvvəl `ui-craft` tətbiq edilməlidir. Repo hazırda PNG eskizləri və JSON qərarlarından ibarətdir; kodlaşdırılmış rəng/spacing/type token faylı tapılmayıb. Bu sənəd piksel ölçüsü və rəng təyin etmir. Token sistemi qurulmalı, mövcud panel ailəsi istifadə edilməli, AZ/EN/TR/RU uzun mətnləri və üfüqi ekran screenshot-ları render edilərək yoxlanmalıdır. Bu plan vizual prototipin yoxlanması iddiası deyil.

## 9. Texniki arxitektura

Texnologiya hələ seçilmədiyi üçün aşağıdakılar dil və oyun mühərrikindən asılı olmayan müqavilələrdir. SDK seçimi Android/iOS və mühərrik qərarından sonra edilir. İlkin provider adapter-i AdMob rewarded və SSV kimi hazırlana bilər; mediation yalnız real fill/revenue məlumatından sonra əlavə edilir.

### 9.1 Modullar

- `OfferEligibilityService`: oyun vəziyyəti + hesab limitləri + remote config → səbəb kodu və uyğun offer.
- `RewardedAdAdapter`: consent-aware load/show və provider callback-ləri; iqtisadiyyatı birbaşa dəyişmir.
- `MonetizationBackend`: attempt rezervasiyası, SSV verification, reward ledger, receipt verification, limitlər.
- `EntitlementService`: kosmetika, P3 və trial hüquqlarının yoxlanmış vəziyyəti.
- `RunRewardApplier`: server grant-ını uyğun run-a bir dəfə tətbiq edir; köhnə save-yə görə haqqı silmir.
- `AnalyticsOutbox`: event ID ilə lokal növbə, internet gələndə deduplikasiyalı göndərmə.
- `RemoteConfig`: placement kill switch, caps, variant; aktiv offer snapshot-ı dəyişmir.

Core oyun offline işləməyə davam edə bilər; maliyyə hüquqlarının ilk verilməsi online verification tələb edir. Offline yeni reklam hüququ və alış uydurulmur. Daha əvvəl yoxlanmış daimi kosmetika lokal cache-dən işləyə bilər. R2 üçün backend olmadan sadəcə client callback-ə güvənən buraxılış tövsiyə edilmir.

### 9.2 Saxlanılan obyektlər

`AccountMonetization`: account_id, config_version, consent_state, UTC-day counters, cooldown_until, prompt_suppressed_until, entitlement_version. Qonaq hesaba sabit server ID-si verilir; platforma alışını bərpa etmək üçün məcburi ayrıca qeydiyyat ekranı qoyulmur. Cihazlararası birləşmə ayrıca təhlükəsiz hesab axını ilə olur.

`Run`: run_id, lineage_id, slot_id, mode, ruleset, ruleset_version, rewind_used, base_capacity, permanent_upgrades, capacity_bonus, applied_grant_ids, completion_id. `lineage_id` checkpoint və save nüsxəsi ilə dəyişmir.

`RewardAttempt`: attempt_id, account_id, placement_id, run_id/lineage_id, offer_snapshot, reward_spec_version, config_version, created_at, started_at, consent_snapshot, provider, status, provider_transaction_id, grant_id. Client mükafat məbləğini sərbəst seçmir.

`RewardGrant`: grant_id, account_id, attempt_id, reward_type, amount/item_id, target_run_id, source, created_at, application_status. Unique açarlar: provider + transaction_id; placement + account + run completion/lineage kimi biznes açarı. Provider transaction ID-si fərqli gələn iki attempt də eyni run bonusunu iki dəfə verə bilməz.

`Entitlement`: account_id, product_id/item_id, source, original_transaction_ref, acquired_at, revoked_at. Store token və receipt-lər analitikaya və ümumi loglara yazılmır.

### 9.3 API müqaviləsi

1. `POST /reward-attempts`: placement, run/completion reference, client idempotency key. Backend uyğunluğu və limiti yoxlayır, offer snapshot, attempt_id və opaque SSV token qaytarır. Snapshot qəbul edilmədən reklam göstərilmir.
2. `POST /reward-attempts/{id}/started`: reklam açılışı qeyd olunur; təkrar sorğu təhlükəsizdir. Provider callback-dən sonra gəlməsi də qəbul edilir.
3. `GET /reward-attempts/{id}`: pending/granted/failed vəziyyəti və grant. Client sorğunu dayandırsa backend verification davam edir.
4. `GET /reward-inbox`: istifadə edilməmiş və tətbiqi gözləyən hüquqlar. Yeni sesiyada və yuva açıldıqda reconciliation.
5. `POST /reward-grants/{id}/applied`: save revision ilə tətbiq təsdiqi; eyni grant üçün təkrar tətbiq edilmir. Server ledger həqiqət mənbəyidir.
6. `GET /catalog`: məhsul ID-ləri və məzmun; qiymət üçün store SDK-nın lokal product detail-ləri tələb olunur.
7. `POST /purchases/verify`: store token/signed transaction → server yoxlaması → entitlement. Eyni transaction təkrar entitlement vermir.
8. `GET /webhooks/admob-ssv`: provider-in imzalı URL query parametrlərini orijinal qaydada doğrulayan ayrıca callback endpoint-i. Reverse proxy parametrlərin imza üçün lazım olan təqdimatını pozmamalıdır; yoxlama provider-in rəsmi alqoritminə əsaslanır.

### 9.4 Reklamın mükafat tranzaksiyası

`eligible → reserved → showing → pending_verification → granted → applied`.

SSV imzası, key_id, timestamp, ad unit və opaque attempt əlaqəsi serverdə doğrulanır. Provider amount/type kataloqla uyğunlaşdırılır. Google SSV sənədi transaction_id və custom_data daxil olmaqla callback məlumatlarını və imza yoxlamasını izah edir. [Google SSV](https://developers.google.com/admob/android/ssv).

Bir DB tranzaksiyasında: valid attempt yoxlanır → biznes açarı və provider transaction üzrə grant insert → gündəlik limit rezervasiyası settle → ledger balansı/entitlement dəyişir. Duplicate callback əvvəlki uğurlu cavabı qaytarır, ikinci grant yaratmır. Etibarlı başlanmış attempt üçün gecikmiş completion yeni günə düşsə də haqq ödənir; limit aidiyyəti rezervasiya gününə bağlı qalır.

`onAdDismissed` tamamlanma sayılmır. Client reward callback yalnız pending UI yaradır; server təsdiqi grant verir. Mediation callback sırası dəyişə bildiyi üçün close → reward və reward → close sıraları eyni nəticəyə gəlməlidir. [Google rewarded SDK davranışı](https://developers.google.com/admob/android/rewarded).

30 saniyə pending qalandan sonra gözləmə modalı əvəzinə inbox statusu göstərilir; təsdiqlənmiş haqq üçün son tarix qoyulmur. 15 dəqiqədən uzun pending attempt əməliyyat alert-i yaradır. R2 run bitəndə §4-dəki inbox əvəzləməsinə çevrilir. Ads SDK-da timeout mükafatın qazanıldığını təkbaşına sübut etmir.

### 9.5 Checkpoint və üç yuva

Nişan, alınmış kosmetika, trial tarixi, reklam sayğacı və grant ledger checkpoint-in hissəsi deyil. Checkpoint yalnız run snapshot-ını qaytarır. Run yüklənəndə server/account ledger-in həmin lineage üçün təsdiqlənmiş bonusları birləşdirilir. Əvvəl tətbiq edilmiş R2 bonusu save köhnə olsa da maksimum bir dəfə görünür.

Səfər nəticəsinin baza və reklam nişanları `completion_id` ilə verilir. Save-ni silib yeni run açmaq yeni lineage yaradır, amma qlobal gündəlik limit saxlanır. Silinmiş run-a gələn etibarlı mükafat üçün inbox əvəzləməsi tətbiq edilir. İkinci cihazda eyni anda başlanmış cəhdlər server rezervasiyası ilə seriallaşdırılır.

### 9.6 Alışın emalı

Store purchase nəticəsi → backend verification → PURCHASED/verified təsdiqi → atomik entitlement → platformaya tələb olunan acknowledge/finish → UI yenilənməsi. Pending və user-cancelled alışda entitlement yoxdur. Google purchaseToken unikallığı ilə deduplikasiya edilir; orderId əsas açar sayılmır. Google sənədi alınmış hüquqdan sonra acknowledgment və emal edilməyən alışın üç gün ərzində avtomatik refund riskini izah edir. [Play Billing təhlükəsizliyi](https://developer.android.com/google/play/billing/security).

iOS-da verified transaction və cari hüquqlar StoreKit ilə reconcile edilir; app açılışında, purchase updates-da və restore əməliyyatında hüquqlar yenilənir. [StoreKit Transaction](https://developer.apple.com/documentation/storekit/transaction).

Refund/revoke təsdiqi gələndə gələcək P3 claim və IAP kosmetikasına giriş dayanır. Daha əvvəl sərf edilmiş bonus üçün oyunçuya qızıl borcu yazılmır və bitmiş səfərin rekordu dəyişdirilmir. Platforma callback-ləri təkrar və sıra xaricində gələ bilər; cari store vəziyyəti ilə reconcile edilməlidir.

### 9.7 Platforma tələbləri

Google rewarded qaydaları opt-in, əvvəlcədən aydın mükafat təsviri, normal istifadəyə mane olmayan rədd və vəd edilmiş haqqın çatdırılmasını tələb edir. Birbaşa real pul və ötürülə bilən pul ekvivalenti rewarded mükafatı verilmir. [Google rewarded qaydaları](https://support.google.com/admob/answer/7313578?hl=en).

Apple üçün standart tətbiqdaxili rəqəmsal məhsul axını IAP ilə hazırlanır; regiona aid alternativ ödəniş istisnaları bu V1 planına daxil deyil. Bərpa olunan alış üçün restore mexanizmi olmalıdır; alınmış oyun valyutasını müddətlə silmək olmaz. V1-də satılan valyuta və random pullu qutu yoxdur. [Apple App Review Guidelines 3.1.1](https://developer.apple.com/app-store/review/guidelines/).

Consent hər launch-da yenilənir, reklam sorğusundan əvvəl `canRequestAds` kimi platforma yoxlaması işləyir; uyğun privacy options girişi ayarlarda saxlanır. “Fərdiləşdirilməyə razılıq vermədi” avtomatik “bütün reklamlar qadağandır” kimi kodlaşdırılmır; faktiki SDK və region nəticəsi əsas götürülür. [Google UMP](https://developers.google.com/admob/android/privacy).

## 10. Analitika müqaviləsi

Hər event: event_id, timestamp_utc, pseudonymous_account_id, session_id, run_id varsa, mode, ruleset, placement_id, experiment_id/variant, config_version, platform, app_version, coarse storefront/region və locale. Raw receipt, reklam identifikatoru, dəqiq məkan və şəxsi maliyyə məlumatı bu event-lərdə yoxdur.

Event-lər:

- `offer_eligible`: səbəb və mövcud ehtiyac; reklam yüklənməsə də ölçülür.
- `offer_visible`: həqiqətən görünən təklif; impression qaydası ən azı 50% sahə/1 saniyə olaraq məhsul tərəfindən müəyyənləşdirilir. Bu tətbiqdaxili offer impression-dır, provider reklam impression-ı deyil.
- `offer_accept`, `offer_decline`: istifadəçinin qərarı və səbəb/kontekst.
- `ad_load_result`, `ad_show_start`, `ad_impression`, `ad_reward_client`, `ad_dismiss`, `ad_failed_to_show`.
- `reward_verified`, `reward_granted`, `reward_applied`, `reward_pending_age`.
- `cosmetic_target_set`, `trial_activated`, `trial_run_completed`.
- `store_product_view`, `purchase_started`, `purchase_pending`, `purchase_verified`, `purchase_cancelled`, `purchase_failed`, `purchase_refunded`.
- `run_started`, `city_arrived`, `run_completed`, `run_abandoned`, `checkpoint_loaded`.
- `ad_paid_event`: provider revenue, currency və precision. Mövcud deyilsə dashboard aggregate ilə ölçülür, uydurma user gəliri yazılmır.

Ölçülər və məxrəclər:

1. Reach = offer görən unikal DAU / bütün DAU.
2. Qəbul = qəbul edilən offer sayı / görünən offer sayı; placement üzrə və unique-user ölçüsü ayrıca.
3. Show rate = ad_show_start / qəbul edilmiş reklam attempt-i.
4. Grant rate = rewarded grant / show_start; ad_impression ilə eyni ölçü deyil.
5. Rewarded engagement = ən azı bir rewarded impression görmüş DAU / bütün DAU; eligible-DAU variantı ayrıca göstərilir.
6. Reklam dərinliyi = rewarded impression / həmin gün reklam görmüş oyunçu.
7. Ad ARPDAU = reklam gəliri / bütün DAU; IAP ARPDAU ayrıca və cəm.
8. D7/D30 payer conversion = həmin install cohort-da müvafiq günə qədər ilk verified alış edənlər / cohort quraşdırmaları.
9. Retention = install cohort-un D1/D7/D30 günündə core gameplay edən payı. Tək reklam callback və fon event-i “qayıtdı” sayılmır.
10. D30 net revenue per install = həmin cohort-un 30 günlük reklam + store-net IAP gəliri − refund və seçilmiş dəyişən xərclər / installs. Reklam provider payout-u artıq netdirsə komissiya ikinci dəfə çıxılmır.

Əsas dashboard platforma, storefront, placement və variant üzrə bölünür. AZ/TR auditoriyasının eCPM və alışını ABŞ benchmark-ı ilə əvəz etmək olmaz.

## 11. Eksperiment planı və qərar qaydaları

İstifadəçi hesabına görə sabit randomizasiya; üç yuva eyni variantdadır. Analiz bütün təyin edilmiş istifadəçilərlə intention-to-treat aparılır. Yalnız reklam izləyənləri müqayisə etmək seçim qərəzi yaradır. Variant, qiymət və balans eyni testdə birlikdə dəyişdirilmir.

### E1 Kontekstual R2 görünürlüğü

A: supported bazarda əlavə yer təklifi yalnız istifadəçinin özü açdığı dəstək detalında. B: eyni mükafat və limitlə uyğun çatışmazlıq yanında inline görünür. Primary: uyğun istifadəçi başına 7 günlük rewarded gəliri; guardrails: supported run tamamlama, D7 retention və alış forması səhvləri. Klassik istifadəçi bu testə daxil deyil.

### E2 Nəticədə real hədəf

A: R1-də yalnız +40 nişan. B: eyni +40 yanında oyunçunun seçdiyi kosmetikanın real progress-i. Primary: visible offer başına qəbul; secondary: 7 günlük nişan xərcləmə, reklamdan sonra çıxış və D7 retention. Hədəf seçməyən istifadəçilər ayrıca əvvəlcədən müəyyən edilmiş strata olur; saxta hədəf təyin edilmir.

### E3 Trial-dan alışa keçid

A: pulsuz önizləmə + daimi alış. B: eyni ekran + könüllü R3 trial. Primary: randomizasiya anından 30 günə store-net kosmetik gəlir / təyin edilmiş istifadəçi. Reklam gəliri və trial completion secondary. Yalnız trial tamamlayanların alışına baxıb qalib elan etmək olmaz.

### E4 P3-un cəmi gəlirə təsiri

A: P1/P2 mağazası. B: eyni mağaza + uyğun şərtdə P3. Primary: D30 cəmi net gəlir/install; secondary: ad gəlirinin itirilməsi, refund, gələcək entitlement yükü. Daha çox IAP olması təkbaşına qələbə deyil. Daimi məhsul satıldıqdan sonra test bitsə də alıcının hüququ saxlanır.

### Test müddəti və kifayət qədər məlumat

- Minimum iki tam həftəlik trafik dövrü; D30 nəticələri üçün cohort tam 30 gün yetişir. Təqvim minimumu statistik kifayət demək deyil.
- Məsələn, sadə müstəqil iki proporsiya hesabında qəbulun 35%-dən 42%-ə artımını 5% iki tərəfli alpha və 80% power ilə yoxlamaq üçün təxminən 760 unikal istifadəçi/qrup lazım olur. Bu planlama nümunəsidir; gerçek baseline və istifadəçi klasteri ilə hesab yenilənir. Offer sayını istifadəçi sayı kimi götürmək olmaz.
- Gəlir paylanması qeyri-bərabər olduğundan revenue sample size real pilot dispersiyası ilə simulyasiya edilir. İki həftəlik az trafikdə “qalib” çıxarılmır.
- Primary metric, sample size, maksimum müddət və analysis date əvvəlcədən qeyd edilir. Hər gün baxıb təsadüfi p<0.05 görünəndə test dayandırılmır.
- İlkin biznes qərarı: cəmi net gəlirdə ən azı +5% hədəf; retention üçün −2 faiz bəndi non-inferiority margin. Bunlar sübut olunmuş standart deyil. CI genişdirsə nəticə qeyri-müəyyəndir, “zərər yoxdur” deyil.
- Təhlükəsizlik stop-u: duplicate grant, səhv alış və ya klassik rekorda iqtisadi bonus qarışması aşkar edilərsə placement dərhal bağlanır. Yetərli nümunədə D7 retention-un 2 faiz bəndindən çox düşməsi və refund/şikayətin artması rollback araşdırması yaradır.

Az trafikdə ardıcıllıq E2 → E3 → E1 → E4-dür; eyni istifadəçidə qarşılıqlı təsir edən testlər paralel açılmır. E1 supported flag açıldıqdan sonra mümkündür.

## 12. Gəlir hesabı və qiymət həssaslığı

Bu bölmədəki rəqəmlər real bazar benchmark-ı deyil, hesablama ssenarisidir. Barterune üçün eCPM, retention, trafik və conversion hələ ölçülməyib; sabit gəlir vədi vermək mümkün deyil.

`Gündəlik reklam gəliri = DAU × həmin gün reklam attempt-i başlayan istifadəçi payı × bu istifadəçi başına attempt × impression/attempt × realized eCPM / 1000`.

Nümunə: 1 000 DAU × 0,35 × 2 × 0,90 = 630 impression/gün. Fərz edilən 3 dollar eCPM → 1,89 dollar/gün; 8 dollar → 5,04 dollar/gün; 15 dollar → 9,45 dollar/gün. Completion faizi reward üçün ayrıca ölçülür; artıq impression ilə hesablanmış gəlirə yenidən vurulmur. Ay üçün sadə 30× hesabı DAU və eCPM-in sabit qalması fərziyyəsidir.

IAP nümunəsi: 10 000 yeni quraşdırmanın 30 gündə 2%-i orta 4,99 dollar gross alış edərsə, cohort gross gəliri 998 dollardır. Buradakı 2% hipotetik D30 göstəricidir, Unity lifetime faizindən götürülməyib. Store komissiyası, vergi, refund və valyuta fərqləri faktiki settlement-dən çıxılır; vahid komissiya dərəcəsi fərz edilmir.

P3 qiymət testi: satışdan gələn net məbləğ − həmin alıcıların counterfactual gələcək reklam gəliri − xidmət xərci. Counterfactual randomizə control-dan ölçülür. Ən çox reklam izləyənlər pass alacağı üçün bütün oyunçuların orta reklam gəliri ilə hesab düzgün olmaya bilər. D30 ilkin siqnaldır; daimi pass üçün D90/180 izləmə saxlanır.

Paid user acquisition yalnız cohort LTV və dəyişən xərc ölçüləndən sonra planlanır. Yüksək reklam opt-in təkbaşına gəlirli oyun demək deyil.

## 13. İcra mərhələləri və asılılıqlar

### M0 Məhsul müqavilələri

İşlər: bu planın R1/R2/R3, nişan kataloqu və P1/P2/P3 qərarlarını ayrıca qərar ID-ləri ilə qeyd etmək; mode/ruleset modelini dondurmaq; mobile platforma, oyun mühərriki və backend seçmək; auditoriya/storefront təsnifatı. Mövcud `confirmed` qərarlar səssizcə dəyişdirilmir. Çıxış: versioned configuration və yeni qərarlar üçün açıq status.

### M1 Oyun və telemetriya bazası

İşlər: ilk oynanıla bilən 20 günlük run, deterministik save, üç yuva, run lineage/completion ID, baza nişan ledger-i və events. Reklam SDK-sız normal run-u bitirmək mümkün olmalıdır. Çıxış: gameplay baseline, real səfər müddəti və completion ölçümü.

### M2 Rewarded infrastrukturu

İşlər: consent, adapter, test reklam ID-ləri, reservation/SSV, ledger, inbox, remote kill switch. Əvvəl R1 inteqrasiyası. QA prod reklamı izləyərək və klikləyərək gəlir yaratmır; yalnız test konfiqurasiyası. Çıxış: crash/retry/duplicate/no-fill sınaqlarından keçən R1.

### M3 Kosmetika və IAP

İşlər: token sistemi və ekran axını, P1/P2 kataloqu, R3, verified purchase, restore, refund/revoke, dörd dil. Çıxış: sandbox alışları və üç yuva üzrə hüquq yoxlaması. P3 ayrıca bağlı qala bilər.

### M4 Supported qayda dəsti və R2

İşlər: səfər başlanğıcında ruleset seçimi, nəticə/rekord filtri, tutum bonusu və gecikmiş mükafat bərpası. Çıxış: klassik iqtisadiyyata sızma olmadan R2. Bu mərhələ açılmadan M2/M3 işləyə bilər.

### M5 Ölçülən soft launch

R1/R3 əvvəl 5%, sonra 25%, sonra 100% uyğun trafikdə texniki mərhələlərlə açılır; hər artım ən azı 48 saatlıq texniki müşahidədən və grant reconciliation-dan sonra. Bu 48 saat revenue eksperimentinin nəticəsi deyil. Rollout zamanı ayrıca holdout qrupu qorunur. E2/E3 ilk testlərdir. R2 uyğun cohort-da ayrıca açılır. P3 yalnız E4 və cannibalization ölçüsü hazır olduqda satılır.

Müddət təxmini mühərrik, backend və mövcud gameplay kodu olmadan verilməyib. Hazırkı repo dizayn/discovery vəziyyətindədir; bu plan hazır oyuna bir neçə reklam düyməsi əlavə etmək həcmində deyil.

## 14. Buraxılış qəbul meyarları

- Banner, avtomatik interstitial və rewarded interstitial adapter-i aktiv build-də yoxdur.
- Hər reklam istifadəçinin açıq seçimi ilə başlayır; gameplay tamamlamaq üçün reklam və ya alış tələb edilmir.
- Qəbuldan əvvəl dəqiq mükafat, müddət və tətbiq qaydası görünür. İmtina normal oyuna mane olmur.
- R1 bazası reklamdan asılı deyil; nəticə və rekord reklamdan sonra dəyişmir.
- R2 yalnız supported run-da, tutuma görə uyğun ehtiyacda və manual alışla işləyir; pul/stock çatışmazlığı bonusla gizlədilmir.
- R3 token start ləğvində xərclənmir, run start-da bir dəfə xərclənir və load/rewind ilə çoxalmır.
- Üç yuva və iki cihazla limitləri keçmək mümkün deyil; parallel reservation sınağı var.
- Duplicate SSV, close/reward callback sırası, delayed SSV, crash-before-save, crash-after-save-before-ack, restart və checkpoint ssenarilərində bir haqq ən çox bir dəfə tətbiq edilir və təsdiqlənmiş haqq itmir.
- No-fill, consent-denied, offline və provider xətası core oyunu bloklamır; həmin xəta mağaza alışını məcburi etmir.
- Alış cancel/pending/failed-də məhsul verilmir; verified alış, restore və refund/revoke sandbox-da yoxlanır.
- P3 satınalmasından sonra R1/R3 CTA dəyişir; eyni gün bonus yenidən verilmir; R2 istisnası alışdan əvvəl görünür.
- Rewarded və IAP event-ləri deduplikasiya edilir; paid impression gəliri provider hesabatı ilə gündəlik reconciliation olunur.
- Kill switch yeni attempt-i saxlayır, artıq başlanmış və təsdiqlənmiş mükafatları ödəməyə davam edir. Alınmış hüquqları silmir.
- AZ/EN/TR/RU, minimum dəstəklənən üfüqi ekran və uzun yerli qiymətlər render edilir; screenshot-a baxış və token kontrast yoxlaması tamamlanmadan vizual hissə hazır sayılmır.

## 15. Növbəti implementasiya üçün veriləcək tapşırıq

Əvvəl M0 və M1 sərhədini həll et: `docs/decisions.json` ilə bu planı tutuşdur, yeni monetizasiya qərarlarını təklif statusunda saxla, mühərrik/platforma/backend qərarını müəyyənləşdir. Sonra tək R1 üçün texniki dizayn hazırla: hesab və run ID-ləri, grant ledger, eligibility, SSV endpoint, pending inbox və qəbul ssenariləri. Oyun bazası olmayan repoya birbaşa production SDK əlavə etmə. R2, P3 və daimi inkişaf mükafatlarını birinci inteqrasiyaya yığma.
