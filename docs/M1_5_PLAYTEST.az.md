# M1.5 — Əsas oynanış sınağı protokolu

Tarix: 3 noyabr 2026. Status: istifadəçinin istədiyi konkret sınaq layihəsi; sınaq keçirilməyib, implementasiya başlamayıb. §15-dəki M1.5 üçün icra protokoludur. Aşağıdakı qiymətlər yalnız sabit sınaq fixture-idir, V1 balans qərarı deyil.

## Məqsəd və sərhəd

Yoxlanan fərziyyə: oyunçu ilk alış–səfər–satışı başa düşür və kömək/çağırış olmadan növbəti ticarət planını qurub icra etməyə başlayır. Bu, uzunmüddətli retention, ödənişli oyuna tələbat, Google girişinin rahatlığı və ya bütün 20 günlük oyunun balans sınağı deyil.

M1 bitdikdən sonra iki şəhər, üç mal, iki yol və bir risk hadisəsi olan lokal test build-i hazırlanır. İstehsal girişini dəyişmədən, yalnız daxili test build-ində hesabsız sabit başlanğıc fixture-i açılır. Cloud, reklam, mağaza, nailiyyət, borc və təkmilləşdirmə bu sınağa daxil deyil. Oyun üfüqi Android cihazında yoxlanır. Kliklənməyən PNG oynanış sübutu sayılmır. Mövcud dizayn müqavilələri bu protokolla dəyişdirilmir.

## İştirakçılar və təşkilat

- Əvvəl 2 pilot iştirakçı: təlimatın, logların, vaxtın və fixture-in işləməsini yoxlamaq üçün. Əsas 8 nəfərin nəticələrinə daxil edilmir.
- Sonra oyunu əvvəllər görməmiş 8 yetkin iştirakçı: 4 nəfər mobil strategiya/ticarət/resurs oyunlarını müntəzəm oynayır, 4 nəfər mobil oyun oynayır, amma bu janrda təcrübəsi azdır. Hamısı test dilini başa düşür; ilkin tur AZ dilindədir. Bu seçim bütün auditoriyanın təmsili sayılmır.
- Layihə müəllifi, komanda üzvü və dizaynı əvvəlcədən bilən adam əsas qrupa daxil edilmir. Mümkün qədər fərqli əlaqə dairələrindən cəlb edilir. Təşviq verilirsə, davam etməkdən və cavablardan asılı olmayan sabit təşviqdir.
- Hər seans 25–30 dəqiqə, təkbətək, eyni cihaz/build/balansla. Bir moderator, mümkün olduqda ayrıca qeyd aparan. İşə qəbul mesajı və nəticə protokolu neytraldır; iştirakçıya oyunu bəyənməsinin gözlənildiyi deyilmir.
- Əsas 8 nəfər başlayandan sonra build və hədlər dondurulur. Məzmun və ya oynanış düzəlişi edilirsə, yeni versiya və yeni 8 nəfərlə ayrıca tur açılır; versiyalar qarışdırılmır.

8 nəfər erkən məhsul qərarı üçün seçilmiş praktik həddir; statistik etibarlılıq və bazar uğuru zəmanəti deyil. Nəticələr faizlə yanaşı mütləq sayla, məsələn 6/8, verilir.

## Sabit sınaq dünyası

Başlanğıc: A şəhəri, 1-ci gün, 100 qızıl, boş yük, tutum 10. Hər mal 1 tutum tutur. Hər şəhərdə hər malın başlanğıc ehtiyatı 20-dir; alışda azalır, satışda artır. Bu qısa sınaqda qiymət və gündəlik ehtiyat bərpası yoxdur; böyük əməliyyatın qiymət təsiri ayrıca V1 sınağına qalır. Eyni şəhərdə dərhal alıb-satmaq zərərlidir.

Qiymətlər oyunçunun baxışındandır: “Al” oyunçunun ödədiyi, “Sat” oyunçunun aldığı vahid qiymətdir.

- A şəhəri: taxıl Al10/Sat8; parça Al20/Sat16; duz Al15/Sat12.
- B şəhəri: taxıl Al16/Sat14; parça Al10/Sat8; duz Al15/Sat12.
- Təhlükəsiz yol, hər iki istiqamətdə: 2 gün, 4 qızıl; hadisə yoxdur.
- Qısa riskli yol, hər iki istiqamətdə: 1 gün, 2 qızıl; göstərilən hadisə ehtimalı 50%. Hadisə çıxanda seçim: əlavə 6 qızıl ödəmək və ya 1 vahid yük itirmək. İtiriləcək mal, miqdar və təsir təsdiqdən əvvəl göstərilir. Yük yoxdursa itki seçimi yoxdur; pul yoxdursa ödəniş seçimi yoxdur. Heç biri mümkün deyilsə əlavə itki olmadan keçid var; çıxılmaz vəziyyət yaradılmır. Qarışıq yükdə vahid alış qiyməti ən yüksək maldan 1 vahid götürülür; bərabərlikdə sabit mal ID sırası işləyir.
- Hər müstəqil seansda eyni əvvəlcədən sabitlənmiş RNG ardıcıllığı: riskli yolun ilk istifadəsində hadisə var, ikincidə yoxdur, sonra təkrarlanır. Bu ardıcıllıq oyunçuya əvvəlcədən deyilmir; ehtimal/risk məlumatı isə seçimdən əvvəl görünür. Statistik risk balansı bu turda ölçülmür.
- Başqa şəhərin qiyməti “son görülmüş qiymət — gün N” kimi göstərilir. Təlim üçün B-nin gün1 məlumatı əvvəlcədən verilir; cari qiymət zəmanəti deyil. Fixture-də qiymətlərin sabitliyi bu etiketin başa düşülməsini yoxlamağa mane olmamalıdır: moderator son sualda bunu ayrıca soruşur.
- Mini-səfər 6-cı gün bitir. 6-cı günə çatmaq olar, onu aşan yol seçilmir; yol xərcinə pulu çatmayan keçid bağlanır. Son gün satış mümkündür, sonra qalan yük həmin şəhərin Sat qiyməti ilə bir dəfə hesablanır. Nəticə pul + yükün satış dəyəridir; bu fixture-də borc yoxdur. Daha tez bitirmək və istənilən vaxt çıxmaq mümkündür.

Təlimin sabit hesabı: A-da 5 taxıl almaq 50 qızıl; təhlükəsiz yol 4; B-də 70-ə satmaq; son pul116, xalis qazanc16, gün3, yük0. B-də geri yol üçün parça fürsəti var: 5 parça50, təhlükəsiz yol4, A-da satış80; əlavə qazanc26, son pul142, gün5. İkinci hesab moderator üçündür, iştirakçıya həll kimi verilmir. Riskli yol vaxt qazandırır, təhlükəsiz yol isə nəticənin müəyyənliyini qoruyur; “düzgün cavab” tək marşrut deyil.

## Seans ssenarisi

1. **Giriş, 2 dəqiqə.** “Səni yox, oyunu yoxlayırıq. İstənilən vaxt dayandıra bilərsən. İlk qısa hissə idarələri öyrədəcək, sonra özün qərar verəcəksən.” Səs/ekran yazısı üçün ayrıca razılıq alınır; razılıq yoxdursa anonim əl qeydi aparılır. Şəxsi hesab məlumatı yığılmır.
2. **Təlim, maksimum5 dəqiqə.** Oyun daxilində məqsəd göstərilir: “6 gün ərzində ticarətlə sərvətini artır.” İşıqlandırılmış addımlarla 5 taxıl al, təhlükəsiz yolu seç, B-yə get, 5 taxılı sat. Pul/yük/gün və xalis16 qazanc görünür. Bu mərhələdə proqramın verdiyi kömək normaldır; moderatorun əlavə köməyi ayrıca qeyd olunur. Təlimin bitmə vaxtı ilk satış nəticəsinin görünməsidir.
3. **Sərbəst davam, maksimum8 dəqiqə.** Təlim bağlanır. Moderator yalnız “Bu nöqtədən necə davam edəcəyinə özün qərar ver; istəsən dayandıra bilərsən” deyir. “Parça al”, “geri qayıt”, “bir dəfə də oyna” deyilmir. İlk90 saniyədə moderator susur; davam etmə niyyətini soruşmur. Oyunçunun təlimdən sonra özü başladığı ilk alışın, marşrutun və tamamladığı satışın vaxtı yazılır. Yalnız ekranlara baxmaq davam əməliyyatı sayılmır. Müşahidə pəncərəsi təlimin bitməsindən hesablanır. Altı gün bitəndə nəticə və adi yeni-səfər düyməsi görünür; vurğulanan çağırış verilmir.
4. **Təkrar seçim, maksimum3 dəqiqə.** Sərbəst hissənin sonunda əlavə yönləndirmə verilmir. Nəticəyə çatan oyunçunun60 saniyə ərzində özü yeni səfər açıb ilk alış etməsi ayrıca yazılır. Sadəcə “yenə oynayardım” deməsi davranış sübutu deyil. Bu göstərici diaqnostikdir; əsas könüllü davam göstəricisi ilə qarışdırılmır.
5. **Risk və zərər tapşırığı, 4 dəqiqə.** Əsas könüllü davranış ölçüləndən sonra hamıya eyni ayrı checkpoint açılır: A, gün4, pul50, əvvəlki100 qızıldan50-yə alınmış5 taxıl, riskli yolla B-yə keçid. “Bu yükü B-yə apar, hadisədə seçimini et, sonra sat.” Hadisə məcburi sabit fixture-dir, əsas RNG-dən ayrıdır. Əlavə6 ödəsə son pul112 və əvvəlki100 xalis sərvətə görə qazanc12; 1 taxıl versə son pul104 və qazanc4. Ardınca ayrıca nəticə nümunəsi göstərilir: başlanğıc100, alış60, yol8, satış62, son pul94, xalis zərər6. “Niyə azaldı və növbəti dəfə nəyi dəyişərdin?” soruşulur. Bu tapşırıqda davam etmə davranışı əsas könüllü metrikaya daxil edilmir.
6. **Son suallar, 3 dəqiqə.** “Oyunun məqsədi nədir?”, “Son ticarətində niyə o malı/yolu seçdin?”, “Başqa şəhərin göstərilən qiyməti çatanda mütləq eyni qalacaqmı?”, “Ən anlaşılmaz məqam nə oldu?” Bəyənmə və təkrar oynamaq istəyi yalnız əlavə keyfiyyət qeydi kimi saxlanır.

Moderator kömək istənəndə əvvəl “Nə etmək istəyirdin?” deyə bilər; hara basmağı və hansı qərarı verməyi göstərən istənilən ipucu “əlavə kömək” sayılır. İştirakçı90 saniyə çıxılmaz qalıb kömək istəyərsə kömək göstərilir, amma müvafiq müstəqillik meyarı keçmir. Texniki nasazlığa görə saat ayrıca dayandırılır; qərarsızlıq vaxtı dayandırılmır. Sərbəst hissədə fasiləsiz ucadan düşünmək tələb edilmir; səbəblər qərardan sonra soruşulur.

## Əvvəlcədən dondurulan uğur meyarları

M2-yə keçid üçün aşağıdakı beş meyarın hamısı ödənməlidir:

- **U1 — İlk dövrün anlaşılması:** ən azı7/8 nəfər proqram təlimini5 dəqiqədə moderatorun əlavə köməyi olmadan bitirir; sonradan məqsədi öz sözləri ilə ticarətlə xalis sərvəti artırmaq kimi izah edir. Təkcə istiqamətləndirilmiş düymələri basmaq kifayət deyil.
- **U2 — Könüllü növbəti ticarət:** ən azı6/8 nəfər ilk satışdan sonra90 saniyə ərzində moderator ipucusuz yeni ticarət üçün alış edir və8 dəqiqəlik sərbəst pəncərədə başqa şəhərə gedib satışını bitirir. Oyunçunun seçdiyi malın gəlirli olması məcburi deyil; məqsədli alış–daşınma–satış ardıcıllığı olmalıdır.
- **U3 — Qərarın səbəbi:** ən azı6/8 nəfər sərbəst hissədəki mal və yol seçimlərini həm qiymət fərqi, həm yolun ən azı bir amili (xərc/vaxt/risk) ilə izah edir və son görülmüş qiymətin cari qiymət zəmanəti olmadığını anlayır. İki eyni yolu “fərqli strategiya” kimi saymaq olmaz.
- **U4 — Nəticədən öyrənmək:** ən azı6/8 nəfər zərər nümunəsində yol xərcindən sonra6 qızıl itirildiyini anlayır və qiyməti/yol xərcini yoxlamaq, başqa mal/miqdar/yol seçmək və ya əməliyyatdan imtina etmək kimi səbəblə bağlı bir dəyişiklik deyir. Əzbər arifmetik sürət yoxlanmır; göstərilən hesabdan istifadə edə bilər. Risk checkpoint-ində seçimin yük/pul təsirini də izah etməlidir.
- **U5 — Təcrübəsiz qrupun davamı:** janr təcrübəsi az olan4 nəfərdən ən azı3-ü U2-ni keçir. Ümumi6/8 nəticənin yalnız təcrübəli qrup hesabına alınması kifayət deyil.

Texniki etibarlılıq ayrıca şərtdir: yanlış pul/yük/gün hesabı, təkrar satış, seçimsiz çıxılmaz vəziyyət, kritik crash varsa həmin build üzrə “keçdi” verilmir. Səbəb düzəldilir və yeni versiyada tur təkrarlanır. İştirakçının anlamaması, darıxması və çıxması nəticədən silinmir, meyarı keçməmək sayılır. Əlaqəsiz xarici müdaxilə və ya cihazın sıradan çıxması ilə seans yarımçıq qalarsa “yararsız seans” kimi səbəbi yazılır; yalnız bu halda eyni profildə yeni iştirakçı ilə əvəz edilir. Texniki yararsız seanslar da hesabatdan gizlədilmir.

Pilotdan sonra, əsas turdan əvvəl meyarların son mətni, build ID/hash, fixture versiyası və test tarixi dondurulur. Əsas tur başlayandan sonra hədləri aşağı salmaq, uğursuz iştirakçını əvəz etmək və ya uğur çıxana qədər iştirakçı artırmaq olmaz. Eyni iştirakçı düzəliş yoxlamasına kömək edə bilər, amma yeni ilk-istifadə turunun8 nəfərinə daxil edilmir.

## Qeyd forması və qərar

Hər iştirakçı üçün P01–P08 anonim kodu; təcrübə qrupu; build/fixture/cihaz; təlim vaxtı və kömək; ilk sərbəst alışa qədər saniyə; mal/miqdar/yol və səbəb; ikinci ticarətin tamamlanması; pul/yük/gün nəticəsi; dayandığı yer və səbəb; risk/zərər cavabı; U1–U4 üzrə keçdi/keçmədi və sübut; təkrar səfər/strategiya dəyişikliyi; nasazlıq qeyd edilir. U5 az-təcrübəli qrupun U2 nəticəsindən hesablanır. Ekran yazısı könüllüdür; anonim loglar kifayətdir.

Yekun hesabatda bütün8 nəticə, hər U üzrə say, az-təcrübəli qrup nəticəsi, ən ciddi3 maneə və qərar yazılır. Bütün meyarlar + texniki şərt keçirsə M2-yə keçmək olar; nəticə gələcək retention və satış uğuru iddiasına çevrilmir. Anlaşılma zəifdirsə məlumat/təlim, U2 zəifdirsə yeni fürsətin görünməsi və ticarət qərarları, U3/U4 zəifdirsə qiymət/xərc/risk əlaqəsi düzəldilir. Sonra yeni8 nəfərlə eyni hədlərlə təkrar tur keçirilir. Planı dəyişmək lazımdırsa, ayrıca versiya və səbəb yazılır; əvvəlki tur geriyə dönük uğurlu sayılmır.
