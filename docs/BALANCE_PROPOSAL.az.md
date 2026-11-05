# Barterune classic balans təklifi

Tarix: 3 noyabr 2026. Status: B01–B10 istifadəçi tərəfindən qəbul edilib; B08–B10 aşağıdakı dəqiqləşdirmələrlə qüvvədədir. Oyun implementasiyası deyil. Məqsəd 20 günlük səfərdə mal, yol, vaxt və risk arasında anlaşılan seçim yaratmaqdır. Tövsiyə aşağıdakı B01–B10 paketidir; alternativlər yalnız seçim üçündür, əlavə rejim açmır.

## Qəbul edilmiş çərçivə

`decisions.json` əsas mənbədir. V1 yalnız classic-dir; supported və daimi inkişaf sonra gəlir. Dörd şəhər əvvəldən açıqdır, on malın adları qəbul edilib. Səfərlər eyni başlanğıc şərtlərinə malikdir. Ticarət gün sərf etmir; yol, iş, xüsusi seçim və pulsuz gözləmə vaxtı irəli aparır. Alış qiyməti satışdan yüksəkdir; böyük əməliyyat əvvəl göstərilən qiymətlə bitir, qiymət sonra dəyişir.

Yük miqdar × ölçü ilə hesablanır. Müddətdən xarab olma yoxdur; hadisə zədəsi və keyfiyyət partiyaları var. Bir təsadüfi hadisə bütün sərvəti silmir. Bələdçi/mühafizəçi ayrı və birlikdə, bir yol və müddətli müqavilə ilə tutulur; müddət yolda bitən anda təsir dayanır.

20-ci gün satış mümkündür, adi marşrut qalan vaxta sığmalıdır. İstisna son-gün çıxışında yardım borcu ilə vaxtında çatma və gecikərək tamamlama seçimləri saxlanır. Yekun yük yerli bazarda satılır, borc çıxılır, təkmilləşdirməyə qalıq dəyər verilmir. Checkpoint deterministikdir, geri dönüş bayrağı silinmir. Üç yuvanın pulu/yükü/günü ayrı, kosmetika və açılışları ortaqdır.

Bu çərçivə əsasən 2/4/6–40/43–49/73/79-cu qərarlara söykənir. Miqdarın OK düyməsi əməliyyat etmir; ayrıca Al/Sat və ayrı maksimumlar dəyişmir (53/54/71/76/86 və D1 quantity resolution). PNG nümunələrindəki 500 pul, 24 tutum və digər rəqəmlər buraya balans qərarı kimi köçürülmür. Qəbul edilmiş V10 footer və «Назад» həndəsəsinə toxunulmur.

B01–B10 üzrə aşağıdakı əsas qaydalar 3 noyabr 2026-da qəbul edilib. Alternativlər qəbul edilməyib; sınaq meyarları yoxlama işi kimi qalır.

## B01 Başlanğıc və vaxt

Tövsiyə: **300 qızıl, 30 yük tutumu, boş yük, borcsuz, təkmilləşdirməsiz; Sünbülovada başlanğıc.** Xəritədə digər üç şəhər dərhal açıqdır. Şəhər adları da yeni təklifdir; dörd şəhərin açıq olması başlanğıc şəhərini seçmək öhdəliyi yaratmır.

Gün 1-dən gün 20-yə qədər oynanır: bir günlük yol gün 1 → gün 2-dir, cəmi 19 təqvim keçidi var. Gün 20-də ticarət və nağd/malla borc ödənişi mümkündür; gözləmə, iş və yeni yol bağlıdır. Oyunçu satış dəftərindən bazara qayıda bilər; yalnız «satıb bitir» nəticəni atomik bağlayır. Həmin gün yenidən açmaq yeni bazar günü yaratmır.

Səbəb: ilk yükü seçmək üçün pul və tutum ayrı məhdudiyyət olur; borc məcburi deyil. Sabit start şəhəri rekordların müqayisəsini sadələşdirir.

Alternativ: 400 qızıl + 30 tutum daha rahat başlanğıcdır, lakin kredit və ucuz mal seçiminin əhəmiyyətini azalda bilər. Sınaq: köməksiz ilk alış və ilk gəlirli satış; eyni başlanğıc bütün yuvalarda və kosmetikalarda qorunmalıdır.

## B02 Şəhərlər və mallar

Tövsiyə olunan adlar və ixtisaslar:

- **Sünbülova:** taxıl, duz, yun istehsalı; parça və ədviyyata yüksək tələb.
- **Yaşıldərə:** odun, dərman otları, əjdaha qatranı istehsalı; dəmir və mana kristalına yüksək tələb.
- **Duzliman:** parça və ədviyyat istehsalı; odun, dərman otları və əjdaha qatranına yüksək tələb.
- **Daşqala:** dəmir və mana kristalı istehsalı; taxıl, duz və yuna yüksək tələb.

Hər mal üçün rəqəmlər ardıcıllıqla **baza qiyməti / bir vahidin yük ölçüsü / normal bazar ehtiyatı / gündəlik bərpa** şəklindədir:

- Taxıl: **20 / 2 / 60 / 12**.
- Odun: **28 / 3 / 45 / 9**.
- Parça: **60 / 1 / 24 / 5**.
- Ədviyyat: **100 / 1 / 16 / 3**.
- Dəmir: **75 / 3 / 20 / 4**.
- Duz: **30 / 2 / 45 / 9**.
- Yun: **40 / 2 / 30 / 6**.
- Dərman otları: **55 / 1 / 24 / 5**.
- Mana kristalı: **140 / 2 / 12 / 2**.
- Əjdaha qatranı: **90 / 2 / 16 / 3**.

Bütün şəhərlərdə bütün mallar siyahıdadır; ehtiyat 0 ola bilər. Gün 1-də istehsalçı şəhərdə ehtiyat normalın 100%-i, yüksək tələbdə 50%-i, digərlərində 75%-idir; kəsr aşağı yuvarlaqlaşır. Gündəlik bərpa siyahıdakı miqdardır, normal ehtiyata qədər artır; normaldan yuxarı ehtiyat varsa artmır. Alış miqdarı azaldır, satış eyni malın ehtiyatını artırır. Ehtiyat tavanı normalın iki qatıdır; artıq satış yenə qəbul edilir, tavanı aşan mal oyunçuya geri qaytarılmır. Satışın maksimumu bazar ehtiyatı ilə məhdudlaşdırılmır.

Səbəb: ucuz yük başlanğıca, bahalı və yüngül yük kapital artdıqdan sonrakı seçimə uyğundur; az ehtiyat bütün tutumu həmişə ən bahalı mala doldurmağı məhdudlaşdırır. Bunların taraz olması oynanış sınağında yoxlanmalıdır.

Alternativ: ilk balansda bütün ehtiyatları 25% artırmaq qiymət fərqlərini öyrənməyi asanlaşdırar, amma qarışıq yük seçimini zəiflədə bilər. Sınaq: taxıl/odun ilk bir neçə dövrdən sonra tam mənasız olmamalı, bir mal bütün şəhər/gün şərtlərində üstün gəlməməlidir.

## B03 Qiymət və bazar təsiri

Tövsiyə: istehsalçı əmsalı **0,75**, yüksək tələb **1,25**, digər şəhər **1,00**. Günlük yerli dalğalanma **−5%, 0%, +5%**, hərəsi bərabər ehtimalla; gün 1-də 0%-dir. Bu dalğalanma və gələcək hadisə cədvəli deterministik saxlanır; açıb-bağlama yenisini yaratmır.

Günlük baza `P = malın baza qiyməti × şəhər əmsalı × günlük dalğalanma əmsalı × aktiv xəbər effekti` olur. Aralıq hesab dəqiq kəsr/tam əmsallarla saxlanır; yalnız yekun vahid qiymət yuvarlaqlaşır:

- Vahid alış: `ceil(P × (1 + bazar təsiri) × 1,10)`.
- Keyfiyyətli vahid satış: `floor(P × (1 + bazar təsiri) × 0,90 × keyfiyyət/100)`.
- Satış qiyməti ən azı 1 qızıldır. Bu mal/əmsal hədlərində alış həmişə satışdan böyükdür.
- Cəm = göstərilən tam vahid qiymət × miqdar. Ümumi məbləğə ayrıca gizli vergi əlavə edilmir.

Günün xalis alış miqdarı `x = oyunçunun aldığı − satdığı` vahiddir. Böyük əməliyyat pilləsi `T = max(1, ceil(normal ehtiyat/4))`. Qiymət təsiri `işarə(x) × min(8, 5 × floor(abs(x)/T))` faizdir: 0%, ±5%, ±8%. Buna görə böyük alış sonrakı qiyməti artırır, böyük satış azaldır. Hissə-hissə əməliyyat da günün eyni xalis sayğacını dəyişir; hədd hər toxunuşda sıfırlanmır. Yeni gün sayğac 0 olur; ehtiyat isə davam edir.

Təsir yalnız əməliyyat bitəndən sonra qüvvəyə minir. Yekun avtomatik satış bütün partiyalar üçün bir dondurulmuş quote ilə edilir; partiyaların sırası satış gəlirini dəyişmir. Sonrakı bazar təsiri nəticəyə geri tətbiq edilmir. Xəbər effekti də al/satla deyil, gün sərhədində dəyişir.

Səbəb: eyni şəhərdə yüksəldib dərhal satmaq qazanc yaratmamalıdır. Sabit günlük P üçün ən yüksək mümkün sağlam satış `floor(0,90 × 1,08 × P)`, ən ucuz alış `ceil(1,10 × 0,92 × P)`-dir; 0,972P < 1,012P olduğuna görə hətta əks təsir hədlərində dövr zərərlidir. Pulsuz gözləmə günü sərf edir və qiymət artımı zəmanəti vermir.

Alternativ: təsir tavanını ±5%-ə endirmək böyük əməliyyatları yumşaldır; alış/satış aralığını daraltmaq bu mərhələdə tövsiyə edilmir. Sınaq: eyni gün al/sat, əməliyyatı hissələrə bölmə, ehtiyat tavanında satış və final partiya sırası arbitraj yaratmamalıdır.

## B04 Yol şəbəkəsi və risk

Şəhər halqası **Sünbülova ↔ Daşqala ↔ Yaşıldərə ↔ Duzliman ↔ Sünbülova** olsun. Halqanın qonşu şəhərləri üçün məsafə vahidi 1, iki diaqonal üçün 2-dir. Hər cüt şəhər birbaşa bağlıdır; hər bağlantıda üç marşrut növü görünür.

Bir məsafə vahidi üçün seçimlər:

- **Karvan yolu:** 2 gün, 8 qızıl; quldur 8%, yük hadisəsi 6%, gecikmə hadisəsi 6% — ümumi təhlükəli hadisə 20%.
- **Kəsə yol:** 1 gün, 14 qızıl; quldur 15%, yük hadisəsi 8%, gecikmə hadisəsi 7% — ümumi 30%.
- **Mühafizəli dolama:** 3 gün, 18 qızıl; quldur 2%, yük hadisəsi 4%, gecikmə hadisəsi 4% — ümumi 10%.

Gün və pul məsafə vahidinə vurulur. Faiz **bütün seçilmiş səfərə** aiddir, günə görə təkrar vurulmur; diaqonalın qiymət/gün fərqi görünür, ayrıca gizli gündəlik risk əlavə edilmir. Bir səfərdə ən çox bir təsadüfi yol hadisəsi olur. Ayrı 15% ehtimalla təhlükə əvəzinə H08 xəbər qarşılaşması olur; qalan ehtimal hadisəsiz keçiddir. Bunlar bir-birini istisna edən nəticələrdir. Müqavilə bitməsi H03 və son-gün çıxışı H04 təsadüfi hadisə sayılmır.

Risk yoxlama sərhədi planlaşdırılan yolun gün keçidlərindən bərabər ehtimalla seçilir və saxlanır. Həmin sərhəddə qüvvədə olan xidmətlə ehtimal hesablanır; xidmətin azaltdığı ehtimal «hadisəsiz» hissəyə keçir. Müddətli xidmətin yalnız ilk günləri əhatə etdiyi yolda başlanğıc detalı sərhədlər üzrə orta ehtimalı göstərir və uzadılma daxil edilmədiyini bildirir. Uzatma gələcək riski yeniləyir; keçilmiş sərhəd yenidən yoxlanmır. Hadisə seçiləndən sonra tətbiqi açmaq və retry nəticəni dəyişmir.

Gün keçidinin sırası: yeni gün və iqtisadiyyat/borc yenilənməsi → bitən müddətli xidmətin dayandırılması və təklif → risk sərhədi/hadisə → yol davamı/gəliş. Xidmət eyni anda bitirsə, avtomatik köhnə təsir verilmir. Adi yola çıxışda `cari gün + yol müddəti ≤20` tələb olunur. Hər hadisədən yaranan əlavə vaxt ayrıca göstərilir.

Səbəb: sürətli yol daha çox ticarət dövrü verir, təhlükəsiz yol sərvəti qoruyur, karvan yolu pul qənaətidir. Məsafəyə görə riskin ayrıca artması ilk versiyada izahı çətinləşdirər.

Alternativ: təhlükəsiz yolun qiyməti 12 qızıl ola bilər; bunu yalnız sınaqda onun heç seçilmədiyi görünərsə yoxlamaq lazımdır. Sınaq: başlanğıcda pul, gec oyunda yük dəyəri, son günlərdə vaxt səbəbi ilə seçim dəyişməlidir; bir yol bütün bu hallarda üstün olmamalıdır.

## B05 Xidmət və təkmilləşdirmə

Bələdçi gecikmə hadisəsi ehtimalını **50%**, mühafizəçi quldur ehtimalını **50%** azaltsın. Birinin təsiri digər hadisə kateqoriyasına keçmir. İkisi birlikdə mümkündür. Mühafizəçi quldurla qarşılaşma yenə yaranarsa «mühafizəçi ilə keç» seçimini itkisiz açır; ayrıca döyüş yoxdur.

Bir yol üçün bələdçi **4 × məsafə**, mühafizəçi **10 × məsafə** qızıl; müddətli müqavilə **4 gün**, bələdçi **12**, mühafizəçi **28** qızıl. Müddətli müqavilə gün d-də alınanda `d+4` gününün başlanğıcında bitir; gözləmə və iş də müddəti sərf edir. Bir-yol xidməti təsdiqlənmiş çıxışda başlayır, seçilmiş səfərin təyinatına və ya geri qayıdış şəhərinə çatanda bitir; eyni səfərin yan yolu və məcburi dayanması əhatədədir. Yeni səfərə daşınmır.

Eyni xidmətin birdən çox müqaviləsi yığılmır. Mövcud əhatə göstərilir, alınacaq yol xidməti müddətli müqaviləni səssiz əvəz etmir. Müddətli yenilənmə eyni qiymətə yeni 4 gündür. Yolda nağd çatmırsa seçilmiş mallar B06 qəbul qiyməti ilə verilə bilər, yaxud B06 xidmət borcu nəzərdən keçirilər; hər ikisi uyğun deyilsə xidmət bitir və yeni risk göstərilər. Xidmətsiz davam həmişə ayrıca seçimdir.

Cari səfər üçün hər kateqoriyada bir səviyyə:

- **Çanta:** 60 qızıl, +10 tutum.
- **Araba:** 140 qızıl, +20 tutum.
- **Qoruyucu örtük:** 70 qızıl, hadisənin keyfiyyət zədəsi faizini 50% azaldır; aşağı yuvarlaqlaşır. Quldur ödənişini və borcu azaltmır.

Çanta və araba birlikdə maksimum 60 tutum verir; ayrı alınır, ilkin şərt yoxdur. Şəhərdə tətbiq dərhal olur, gün sərf etmir; geri satılmır və yekun dəyəri 0-dır. Kosmetika bu rəqəmlərə təsir etmir.

Alternativ: ilk sınaqda təkmilləşdirmə qiymətlərini 20% yüksəltmək olar, əgər hamısını ilk günlərdə almaq avtomatik optimal çıxarsa. Sınaq: tutum genişlənməsi öz qiymətini çıxarmaq üçün bir neçə faydalı yük dövrü tələb etməli; son gün alınması gəlir artırmamalıdır.

## B06 Borc və bərpa işi

Adi kredit: **20–200 qızıl**, 10 qızıl addımla; **5 gün**, bir dəfə **10% sabit haqq**, yuxarı yuvarlaqlaşır. Mövcud adi və xidmət borclarının tam ödənməmiş cəmi yeni kreditdən sonra **220 qızılı** keçməməlidir. Tarix gün 20-ni aşırsa yeni adi kredit verilmir. Faiz gündəlik mürəkkəb faiz deyil; xərc müqavilədə əvvəldən görünür.

Nağd qismən ödəniş əvvəl haqqı, sonra əsası azaldır; sabit haqq geri hesablanmır. Son tarix gününün axırına qədər gecikmə yoxdur; növbəti günə keçiddə qalıq borca **5% bir dəfə** gecikmə haqqı əlavə edilir. Sonrakı hər gün yenidən artmır. Müqavilədə bir dəfə **+2 gün möhlət**, qalıq borcun **10%-i, minimum 5 qızıl** haqqla, borca əlavə olunaraq mümkündür; yeni tarix `max(cari gün, əvvəlki son tarix)+2` olur və ≤20 olmalıdır. Artıq gecikmiş müqavilə də bir dəfə möhlət ala bilər, əvvəlki gecikmə haqqı silinmir və yenidən gecikmədə ikinci 5% tutulmur. Haqq borcu limitdən yuxarı çıxararsa yeni borc bağlanır; ödəniş bağlanmır.

Malla ödəniş bütün on mal üçün açıqdır. Vahid qəbul qiyməti cari keyfiyyətli yerli satış qiymətinin **80%-i**, aşağı yuvarlaq, minimum 1 qızıldır. Bir və ya bir neçə partiya seçilir. Kreditora təhvil bazar ehtiyatını/qiymətini dəyişmir. Qalıq borcdan artıq dəyər nağd qaytarılmır: artığı təsdiqdən əvvəl göstərilir, miqdarı azaltmaq və imtina mümkündür. Şəhərdə bazarda satıb nağd ödəmək adətən daha sərfəlidir; malla ödənişin xüsusi faydası yolda xidmət yenilənməsidir.

Bərpa işi yalnız **pul <20 qızıl və satış dəyəri müsbət yük yoxdur** halında açılır (qərar 9). Müddət **1 gün**, qazanc **30 qızıl**; gün+1 ≤20 tələb olunur. İş borc tarixini keçirə bilər, əlavə haqq əvvəl göstərilir. Kreditorun «işləyərək azalt» seçimi də eyni uyğunluq həddini saxlayır; qazanc yerinə seçilmiş borcu **30 qızıladək** birbaşa azaldır, qalıqdan artıq hissə pula çevrilmir. Bu iki əməliyyat birlikdə mükafat vermir. Uyğun olmayan oyunçu üçün səbəb görünür; yükü gizlicə yox sayıb pulsuz borc azaltmaq olmur.

Yolda xidmət borcu: yalnız çatışmayan haqq qədər, **10% sabit haqq**, ən çox **3 gün**, son tarix `min(cari gün+3,20)`; ümumi 220 limitinə daxildir. Pul oyunçunun əlinə verilmədən xidmət haqqı və borc birlikdə tətbiq olunur. Həmin gün son tarix mümkündür; gecikmə qaydası yenə ertəsi gün işləyir. Borc/mal seçimi əlçatmazdırsa xidmətsiz davam qalır.

Son-gün **yardım borcu** adi limitdən istisnadır; B09-dakı çıxış əməliyyatına bağlıdır, yeni ticarət kapitalı vermir və təkrar götürülmür. Son hesablaşma bütün ödənməmiş borcu çıxır; pul çatmırsa nəticə mənfi ola bilər. Borc səssiz silinmir və növbəti bərabər başlanğıclı səfərə daşınmır. Gün 20-də pul/yük yoxdursa yeni iş və borc dövrü əvəzinə mənfi yekunla bitirmək mümkündür.

Alternativ: adi kredit haqqı 5% olsun; daha rahatdır, amma borcun hər startda avtomatik üstünlük olma riskini artırır. Sınaq: 100 kredit → 110 borc; 40 ödəniş → 70; tarix keçəndə +4 → 74. Borcsuz tam səfər mümkün qalmalıdır.

## B07 Hadisələr və zədə

H01–H10 adları D4 eskiz kataloqu ilə uyğun saxlanır; aşağıdakı rəqəmlər və H05–H10 məhsul məzmunu yeni təklifdir. Yük hadisəsi H05/H07, gecikmə hadisəsi H02/H06 arasında bərabər bölünür.

Hər təsadüfi təhlükə üçün ümumi bir itki büdcəsi olsun: **L = floor(hadisədən əvvəlki ümumi aktivlərin 15%-i)**. Aktivlər = pul + yükün yol çıxışında yadda saxlanmış sağlam/keyfiyyətli satış dəyəri; borc çıxılmır, mənfi sərvət limitini pozmur. İtki hesabı eyni dondurulmuş qiymətlə aparılır; zədədən sonra yeni limit hesablanmır. Pul itkisi + yükün dəyər itkisi + hadisənin yaratdığı yardım/əlavə borc birlikdə L-ni aşmır. Adi əvvəlcədən seçilmiş yol haqqı/kredit haqqı bu təsadüfi itki büdcəsi deyil. Məcburi əlavə gözləmə/təmir itkisi ən çox +1 gündür; oyunçunun ayrıca seçdiyi geri dönüşün görünən yol müddəti buna daxil deyil; qazanılmamış mənfəət «itki» kimi hesablanmır.

Bir səfərdə bir təsadüfi təhlükə; təhlükəli yol hadisəsindən sonrakı səfər təsadüfi təhlükə vermir, amma vaxt/xərc əvvəlki kimidir. Bu qoruyucu sərhəd və hadisəsiz növbəti yol statusu görünür; müqavilə bitməsi/son-gün həlli yenə işləyir. İtki ardıcıl iki yolda yığılmır.

- **H01 Quldurlar:** ödəniş `min(20,L)` qızıl, yalnız pul çatırsa; qaçış 70% itkisiz, 30% yükdə ən çox 25 faiz-bənd keyfiyyət itkisi; aktiv mühafizəçi ilə itkisiz keç; danışıq üçün 1 ədviyyat və ya 1 yun təhvil, yaxud son 2 gündə əldə edilmiş doğru/yalan fərq etmədən cari quldur xəbərinin mənbəsini bölüşmək. Mal dəyəri L-ni aşırsa həmin təhvil passivdir; mənbə bir qarşılaşmada işlənmiş sayılır. Xəbər «doğru fakt»a çevrilmir. Qaçış heç bir resurs olmadan da açıqdır; itiriləcək yük yoxdursa pul borcu gizlicə yaradılmır.
- **H02 Bağlı yol:** +1 gün gözlə; `min(12 × məsafə,L)` pul ödəyib əlavə günsüz yan yol; başlanğıc şəhərinə geri dön. Geri dönüş artıq keçilmiş yol günləri qədər vaxt alır, ən az 1 gün; pul xərci 0, ilkin yol haqqı qaytarılmır. Adi sığmayan seçim yerinə B09 çıxışı tətbiq edilir. Eyni bağlanma yenidən roll edilmir.
- **H03 Müqavilə bitdi:** təsadüfi deyil; B05/B06 yenilənməsi və ya xidmətsiz davam.
- **H04 Son gün çıxılmazlığı:** təsadüfi deyil; B09 vaxtında yardım/gecikmiş çatma.
- **H05 Yağış:** taxıl, parça, yun, dərman otlarında ən çox 20 faiz-bənd zədə ilə davam et və ya +1 gün sığın. Metal, duz, ədviyyat, kristal və qatran bu hadisədə zədələnmir. Uyğun yük yoxdursa dəyişikliksiz davam mümkündür.
- **H06 Təkər:** `min(12,L)` pul ilə təmir et və ya +1 gün təmir işi. Araba təkmilləşdirməsi bu hadisəni avtomatik silmir; onun faydası tutumdur.
- **H07 Tökülən yük:** bir partiyada ən çox 15 faiz-bənd zədə ilə davam et və ya +1 gün yığışdırıb itkisiz bərpa et. Tavan səbəbi ilə ayrıca vahid itirmək tələb olunmur.
- **H08 Yol tacirinin xəbəri:** pulsuz dinlə və ya imtina et; yeni şayiə, pul/yük/gün dəyişikliyi yoxdur. Şayiə almaq cari şəhər qiymətini yeniləmir.
- **H09 Məhsul bolluğu:** B08 üzrə bir şəhər/mal üçün 3 gün qiymət −20%, gündəlik ehtiyat bərpası ×2.
- **H10 Bayram tələbi:** B08 üzrə bir şəhər/mal üçün 3 gün qiymət +20%; avtomatik satış yoxdur.

Zədə keyfiyyətin faiz-bənd azalmasıdır: 100 → 80, ikinci eyni zədə 80 → 60; keyfiyyət minimum **25%** olur. Qoruyucu örtük azalma faiz-bəndini yarıya endirir. Tam partiya zədəsi L-ni aşırsa yalnız uyğun miqdarda vahid ayrılır və/və ya azalma kiçildilir; seçilmiş alt-partiya və nəticə əvvəl göstərilir. 1 faiz-bənd/1 vahid addım belə büdcəni aşırsa həmin vahidə zədə tətbiq edilmir. Qüsursuz yükün öz-özünə zamanla keyfiyyət itirməsi yoxdur.

Partiyalar yalnız eyni mal + keyfiyyət + alış günü + eyni vahid alış dəyərində birləşir; müxtəlif maya dəyəri qorunur. Alınma dəyəri tam cəm kimi saxlanır. Zədə ilə k vahid ayrılarkən maya dəyəri `floor(cəm × k/n)`, qalıq köhnə partiyada qalır; son hissə bütün qalıq dəyəri götürür. Satış və zədədə ümumi maya dəyəri itmir/çoxalmır, əvvəlki ortalama üzrə səssiz yenidən qiymətləmə yoxdur.

Alternativ: itki büdcəsi 10% daha rahatdır; qoruyucu örtük və mühafizəçinin faydasını zəiflədə bilər. Sınaq: borclu və pulsuz/yüksək dəyərli yüklü vəziyyətlər, kiçik partiya və təkrar zədə; tətbiqi açmaqla qaçışın nəticəsini yeniləmək olmamalıdır.

## B08 Xəbər və şayiə

Oyunçu orada olmasa da bütün şəhərlərdə hər oyun günü üzrə, hər şəhər üçün **10%** ehtimalla bir yeni H09/H10 bazar xəbəri yaransın; növ bərabər seçilsin, şəhərin təsadüfi bir malına aid olsun. Bir şəhərdə eyni anda ən çox iki aktiv xəbər, bir malda isə bir effekt var. Eyni malda mövcud xəbər bitmədən əvəzlənmir və effektlər üst-üstə vurulmur; yer yoxdursa o gün yeni xəbər yaranmır. Gün d-də başlayan təsir d, d+1, d+2 günlərində qüvvədədir, d+3-də bitir.

Fakt yerli şəhərin xəbər lövhəsindən pulsuz alınır: mal, şəhər, effekt və bitmə günü görünür. Uzaq şəhər barədə şayiə H08-dən gəlir. Uyğun aktiv və ya növbəti 2 gündə başlayacaq real bazar hadisəsi olduqda H08 məlumatının 2/3 hissəsi bazar şayiəsi, 1/3 hissəsi cari yolda quldurlarla bağlı danışıq məlumatıdır; uyğun real hadisə yoxdursa yol məlumatı verilir. Yol məlumatı 2 gün etibarlıdır, yalnız həmin yolun H01 danışıq şərtini açır; göstərilən risk faizini və bazar qiymətini dəyişmir. Bazar şayiəsi əsas hadisə cədvəli ilə bağlıdır: daxili modeldə 70% həqiqi yaxınlaşan/aktiv hadisəyə, 30% mövcud olmayan hadisəyə aid olsun. Bu rəqəm oyunçuya dəqiq etibarlılıq faizi kimi göstərilmir; «Şayiə — yol taciri, yoxlanmayıb» işarəsi qalır. Yalan bazar şayiəsi üçün həmin pəncərədə baş verməyən hadisə seçilir; reallıq cədvəli şayiəyə görə dəyişmir. 70% yalnız bazar şayiəsi verilən bu şərtli seçimə aiddir, bütün xəbərlərin ümumi dəqiqlik göstəricisi deyil.

Şayiə iki gün sonra köhnəlir; şəhərdə uyğun faktı görmək onu təsdiqlənmiş və ya yanlış çıxmış kimi yeniləyir. Şəhərə çatmamış onun doğru/yalan olduğu UI-də uzaqdan açılmır. Gəlişədək hadisə bitibsə, şayiənin aid olduğu tarixdə doğru olub-olmadığı yerli xəbər tarixçəsindən yoxlanır. Son görülmüş qiymət və günü ayrıca qalır; xəbər oxumaq bu qiymət tarixini dəyişmir. Doğru xəbər də yol vaxtı, ehtiyat və qiymət aralığı səbəbi ilə qazanc zəmanəti deyil.

Səbəb: etibarlı müşahidə ilə uzaq məlumat ayrı dəyər daşıyır, bir-birinə zidd bir neçə effektin hesabı yığılmır. Alternativ: şayiə modelində 50% doğruluq; sınaqda oyunçular bütün şayiələri görməzdən gələrsə bu alternativ seçilməməlidir. Sınaq: oyunçu faktı, şayiəni və köhnə müşahidəni köməksiz ayırd edə bilməlidir.

## B09 Son gün və yekun nəticə

Gün 20-də adi və ya yardımla gəlişdən sonra yalnız satış, mövcud borcun nağd/malla ödənməsi və səfəri bitirmə açıqdır. Yeni alış, borc, xidmət, təkmilləşdirmə, iş, gözləmə və yol bağlıdır. Bu dəqiqləşdirmə B01-dəki ümumi «ticarət» ifadəsini məhdudlaşdırır.

Adi yol gün 20-yə sığır; əlavə gecikmə normal sərhədi aşırsa əvvəl mümkün əlavə günsüz pul/yük seçimi göstərilir. Hamısı əlçatmazdırsa H04 açılır. İki seçim:

- **Yardım borcu ilə vaxtında çat:** çatışmayan əlavə günü xilasetmə həll edir; gün 20-də seçilmiş son şəhərə gəliş. Yeni yardım borcu `min(40, həmin hadisənin qalan L büdcəsi)` qızıldır, adi 220 limitindən istisnadır; ayrıca faiz/gecikmə haqqı yoxdur. Aktiv 0-dırsa yardımın borcu da 0 ola bilər. Yardım oyunçuya nağd pul vermir, bir məcburi çıxışa bağlıdır. Gəlişdən sonra gün 20 qaydaları ilə satış mümkündür.
- **Gecikərək tamamla:** yalnız çıxılmazlığı həll etmək üçün +1 istisna gün, pul borcu yoxdur; gəlişdən sonra yeni alış/yol/iş yoxdur, yalnız yekun satış dəftəri açılır. `late=true` qalır. H02 geri dönüş bir neçə gün aşırsa bu seçim həmin budağı yox, artıq seçilmiş təyinat şəhərinə +1 gün gecikmiş tamamlanmanı əvəz edir; sonsuz gecikmə dövrü açılmır.

L artıq xərclənibsə yardım ikinci itki büdcəsi yaratmır. Xidmətin müddəti əlavə gündə də bitir, amma yeni təsadüfi təhlükə çəkilmir. Yardım və gecikmə eyni hadisədə alternativdir; birlikdə avtomatik tətbiq edilmir (39/45-in açıq dəqiqləşdirməsi).

Yekun **xalis sərvət = pul + qalan yükün göstərilmiş yerli satış cəmi − bütün borc**. Təkmilləşdirmə, işlənməmiş xidmət müddəti və kosmetikanın qalıq dəyəri 0-dır. Satış B03-ün dondurulmuş quote-u ilə atomikdir; borc qədər çıxılır, mənfi nəticə mümkündür. Yekun satışa bazar alış ehtiyatı limiti qoyulmur.

Qəbul edilmiş rekord ayrımı: classic-də **vaxtında/gecikmiş × geri dönüşsüz/geri dönüşlü**, hər balans versiyası ayrıca. Bu ayrım mövcud rewind ayrımına late ölçüsünü əlavə edir. Yardım borcu nəticədən çıxdığı üçün vaxtında kateqoriyada qalır və dəftərdə ayrıca görünür. Eyni xalis sərvət eyni sıralama dəyəri olsun; serverin dəqiq completion vaxtı gameplay üstünlüyü yaratmasın. Online start şərti, client-reported rekord modeli və Spark qoruma məhdudiyyətləri dəyişmir.

Alternativ: gecikmiş səfərlər yalnız şəxsi tarixçəyə yazılsın, online cədvəli olmasın; daha sadədir, lakin gecikmiş nəticəni müqayisə etmək imkanı azalır. Sınaq: gün 20 pul=0/yük=0, borc limitində yardım, müqavilənin eyni sərhəddə bitməsi və final retry heç bir çıxılmazlıq/ikiqat satış yaratmamalıdır.

## B10 Nailiyyətlər və sınaq meyarları

Qəbul edilmiş beş nailiyyət üçün dəqiq trigger-lər:

- İlk uğurlu ticarət: təlimdən kənar səfərdə ilk commit edilmiş, miqdarı >0 olan alış və ya satış. Qazanc şərti yoxdur; «ticarət» gəlir zəmanəti deyil.
- Dörd şəhər: bir classic səfərdə dörd fərqli şəhərdə olmaq; başlanğıc şəhəri sayılır. Sadəcə xəritəni açmaq sayılmır.
- İlk 20 günlük səfər: gün 20-də və ya son-gün istisnasından sonra yekunlaşmış bir classic səfər; erkən çıxış/silmə sayılmır.
- Borcu tam ödə: faktiki götürülmüş borcu oyun zamanı nağd/mal/işlə 0-a endir; başlanğıcda borcsuz olmaq sayılmır, final avtomatik çıxma nailiyyət vermir.
- Geri dönüşsüz bitir: yuxarıdakı müddət tamamlanıb, lineage üzrə rewind heç işlənməyib. Tətbiqi açıb-bağlama geri dönüş sayılmır.

Gecikmiş və yardımla bitən səfərlər də şərtləri ödənən nailiyyətləri verir.

Nailiyyətlər kosmetik/hesab açılışıdır; növbəti classic start pul/tutumunu artırmır. Təlim ayrıca fixture-dir, bu balans üzrə reklam/rekord/nailiyyət farm-ı yaratmır. Təlimdən sonra yeni normal səfər eyni B01 şərtləri ilə başlayır; bu keçid də qəbul edilib və D5 dizaynında əhatə olunmalıdır.

Sınağın əsas protokolu `M1_5_PLAYTEST.az.md`-dir: 2 pilot, sonra 4 janr təcrübəli + 4 az-təcrübəli iştirakçı və mövcud U1–U5 hədləri dəyişmir. Aşağıdakılar balans üçün əlavə əvvəlcədən təyin edilən yoxlamalardır, istifadəçi nəticələri deyil:

- İki şəhərli prototip Sünbülova–Daşqala, taxıl/yun/dəmir və ən azı iki yol ilə qurula bilər. İki fərqli yük planı və iki yol ən azı bir aydın şərtdə faydalı olmalıdır; əks halda B02/B04 yenidən tənzimlənir.
- Nəzarət nümunəsi: gün 1, dalğalanma/xəbər/bazar təsiri 0; 15 taxıl ×17 alış, 30 tutum. Karvanla 8 yol haqqı, gün 3-də 15×22 satış: **367 qızıl**, xalis **+67**. Bu nümunə optimal strategiya iddiası deyil.
- Eyni yük kəsə yolla hadisəsiz gün 2-də **361 qızıl**, xalis **+61** verir. Daha az pul artımını bir günə qazanmaqla daha çox risk arasındakı fərq görünür.
- Daşqaladan 5 dəmir ×62 alış, karvanla Yaşıldərəyə 8 xərc, 5×84 satış: 367 → **469 qızıl**. Bu nümunə də sabit qiymətli nəzarət hesabıdır; tam iqtisadiyyat simulyasiyası deyil.
- 10 000 müsbət tam günlük baza üçün eyni-gün qiymət tavan/dib arbitraj bərabərsizliyi ayrıca hesabla yoxlanıb. Borc nümunəsi, ilk ticarət hesabları və risk bölgülərinin cəmi də hesablanıb. Oyun kodu, stochastic simulyasiya və oyunçulu balans testi aparılmayıb.
- Tam dörd şəhərli balans mərhələsində eyni əvvəlcədən seçilmiş seed siyahısında qarışıq yük, bahalı yük, gözləmə, borclu/borcsuz və hər yol strategiyası müqayisə edilməlidir. Bir sabit strategiya həm orta xalis sərvət, həm ən pis 10%-lik nəticədə bütün alternativləri üstələyirsə rəqəmlər yenidən baxılır. Sınaq seed-ləri nəticəni gördükdən sonra seçilmir.
- B05 tutum təkmilləşdirməsi üçün sonrakı əlavə yükün xalis gəliri alış qiymətini çıxarmalıdır; bunun ilk alışda həmişə baş verdiyi rəqəmlər qəbul edilmir. Təhlükəsiz yol/xidmət heç bir sərvət-risk şəraitində faydalı deyilsə qiyməti və ya riski düzəldilir.

## Qəbul və tətbiq sərhədi

B01–B10 əsas qaydaları 3 noyabr 2026-da istifadəçi tərəfindən qəbul edilib və `decisions.json` → `balanceDecisions.confirmed` daxilində saxlanılıb. B08 bütün şəhərlərdə gündəlik xəbər yaranması və yerli xəbər tarixçəsini; B09 gün 20 əməliyyat məhdudiyyətini; B10 gecikmiş/yardımlı səfərlərin uyğun nailiyyətlərini də əhatə edir. Alternativlər qəbul edilməyib. Sınaq meyarları yoxlama planıdır; balansın sınaqdan keçməsi iddiası deyil.

B06/B07-nin B08/B09-a istinad etdiyi qaydalar artıq bağlanıb. Qəbul edilmiş qaydalar D1–D5-də köhnə açıq balans qeydlərinə üstün gəlir; ekranların uyğunlaşdırılması və D1–D6 yekun dizaynı hələ tamamlanmayıb. Stack/minSdk, Spark kvota/snapshot/retention və Play hesab-hüquq siyasəti açıq qalır. Ayrıca implementasiya tapşırığı olmadan oyun kodu yazılmır.
