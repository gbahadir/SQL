---------------------------------------------------------------------------------------------
----- WINDOW FUNCTIONS -----
---------------------------------------------------------------------------------------------

/* Nedir bu Windows Function ne iþe yarar?:
Analitik fonksiyonlar olarak da bilinirler .
Window fonksiyonlarý sql sorgusu ile elde edilen sonuç setini her fonksiyonun kendi karakterine göre parçalara ayýrarak 
yine bu parçalara kendi fonksiyonlarýna göre deðer üretirler.
Bu deðerler SELECT listesinde veya ORDER BY sýralama kriterleri içinde kullanýlabilirler.
Window fonksiyonlarý kullanýlýrken OVER anahtarý ile kayýt setinin parçalara bölünmesi saðlanýr. 

Window Functions,  SELECT girdi değerlerinin bir ifadenin sonuç kümesindeki bir veya daha fazla satırın "penceresinden" alındığı bir SQL işlevidir.

Window Functions, OVER bir yan tümcenin varlığıyla diğer SQL işlevlerinden ayrılır. 
Bir fonksiyonun bir OVER yan tümcesi varsa, o zaman bir Window Functions'dur. 
Bir OVER yan tümcesi yoksa, sıradan bir toplama veya skaler fonksiyondur.
Window Functions, function  ile OVER clause arasında bir FILTER yan tümceye de sahip olabilir.

Bir  window functions  , bir şekilde geçerli satırla ilgili olan bir dizi tablo satırında bir hesaplama gerçekleştirir. 
Bu, bir toplama işleviyle yapılabilecek hesaplama türüyle karşılaştırılabilir. 
Ancak normal toplama işlevlerinden farklı olarak, bir pencere işlevinin kullanılması, satırların tek bir çıktı satırında gruplanmasına neden olmaz 
- satırlar ayrı kimliklerini korur. Perde arkasında, pencere işlevi, sorgu sonucunun geçerli satırından daha fazlasına erişebilir.

Bir window function kullandığımızda, OVER()yan tümceyi kullanarak pencereyi basitçe tanımlarız. 
OVER() tümcesi, window function'i SQL'deki diğer işlevlerden ayırır. 
OVER(), işlevselliğini genişletmek için aşağıdaki maddeleri alabilir:
- PARTITION BY : Satır grupları oluşturmak için pencere bölümlerini tanımlar
- ORDER BY : Bir bölüm içindeki satırları sıralar
- ROW or RANGE: İşlevin kapsamını tanımlar

Pencere işlevlerini üç kategoride gruplayabiliriz:

1- Aggregate Window Functions
2- Ranking Window Functions
3- Value Window Functions

*/

---- 1) AGGREGATE WINDOW FUNCTIONS -----
/*
 Aggregate Window Functions, normal bir toplama işlevine benzer. 
Ancak aralarındaki temel fark, toplama penceresi işlevinin döndürülen satır sayısını değiştirmemesidir.

Window function sözdizimi dökümü:

	window_function: Bu AVG(), COUNT(), MAX(), MIN(), SUM() olabilen sıradan bir toplama işlevidir .
	column_name: İşlevin üzerinde çalıştığı sütun
	OVER:  Toplama işlevleri için pencere yan tümcelerini belirtir. 
		OVER yan tümcesi, pencere toplama işlevlerini sıradan toplama işlevlerinden ayırır.
	PARTITION BY expr_list : Isteğe bağlı. Pencere işlevi için pencereyi tanımlar.
	ORDER BY order_list : Opsiyonel. Her bölüm içindeki satırları sıralar.
	frame_clause: ORDER BY deyimi kullanılıyorsa, frame_clause gereklidir. Çerçeve yan tümcesi, sıralanan sonuç içindeki kümeler ve satırlar dahil 
		veya hariç tutularak bir işlevin penceresindeki satır kümesini iyileştirir.
*/

SELECT graduation, COUNT (id) OVER() as cnt_employee
FROM departments;

-- Aşağıdaki sorgu gibi bir DISTINCT anahtar kelime kullanırsanız , yinelenen satırlardan kurtulursunuz.

SELECT DISTINCT graduation, COUNT (id) OVER() as cnt_employee
FROM departmen

-- Fark ettiğiniz gibi, sonuç için herhangi bir bölümleme, sıralama veya çerçeve koşulu kullanmadık. 
-- OVER anahtar kelimesinin yanındaki parantezler boştu ve yukarıdaki sonuçları aldık. 
-- Aşağıdaki gibi bir anahtar kelime  PARTITION BY ile DISTINCT kullanırsak :

SELECT DISTINCT graduation, COUNT (id) OVER(PARTITION BY graduation) as cnt_employee
FROM departments 

-- PARTITION BY Bir window function'in üzerinde çalıştığı bölümleri belirtir.
-- window function, her bölüme ayrı ayrı uygulanır ve her bölüm için hesaplama yeniden başlar. 
-- PARTITION BY Eklemezsek , window function tüm sütunda çalışır.

-- Ya sadece  ORDER BY parantez içinde kullanırsak? 

SELECT hire_date, COUNT (id) OVER(ORDER BY hire_date) cnt_employee
FROM department

----- 2) RANKING WINDOW FUNCTIONS -----
/*
Ranking Window Functions

CUME_DIST() : Sıralı bir değerler kümesindeki bir değerin kümülatif dağılımını hesaplayın.
			Su bir ornek olabilir: sinav siralamasi yapiyoruz. 1000 kisi girmis. sinavda 10. olan yuzdelik dagilimda nerede?
			Hani "OSS'de su kadarlik dilime girdi" diyoruz ya, onu bu CUM DIST'e dayanarak buluyoruz. 

DENSE_RANK()	: Sıra değerlerinde boşluk olmadan sıralı bir satır kümesindeki bir satırın sıralamasını hesaplayın.

NTILE(N)	: Bir sonuç kümesini mümkün olduğunca eşit sayıda bölmeye bölün ve her satıra bir bölüm numarası atayın.
			Ucuzdan pahaliya siralayip kumelere bolersek en ucuzdan en pahaliya urun kumeleri olusturabiliriz. 
			Parantez icine kume sayisini yaziyoruz.

PERCENT_RANK() : Sıralı bir satır kümesindeki her satırın yüzde sıralamasını hesaplayın.

RANK() : Sonuç kümesinin bölümündeki her satıra bir derece atayın.

ROW_NUMBER() : Assign a sequential integer starting from one to each row within the current partition.
*/

SELECT name,
	   RANK() OVER(ORDER BY hire_date DESC) AS rank_duration
FROM departments;

--
SELECT name,
	   DENSE_RANK() OVER(ORDER BY hire_date DESC) AS rank_duration
FROM departments;

--
SELECT name, seniority, hire_date,
	   ROW_NUMBER() OVER(PARTITION BY seniority ORDER BY hire_date DESC) AS row_number
FROM departments;

-- RANK()kiralama_tarihi değeri aynıysa işlev aynı sıra numarasını atar. 
-- Not: RANK()fonksiyon, sıralama kuralı tarafından oluşturulan listedeki değerlerin satır numaralarını atar. 
-- O deger degisirse RANK satir numarasi da degisir. 
-- Aynı değerler için en küçük satır numaralarını atar. Yani degerimiz 3 ise hepsine ilk 3'in aldigi sira numarasini verir.
-- Yani groupby, where vs kullanmadan aynı fiyatlı ürünleri bulabiliriz

-- Not: DENSE_RANK()sıralama kuralı tarafından oluşturulan listedeki değerlerin sıra numaralarını döndürür. 
-- Aynı değerler için en küçük sıralı tamsayıları atar. Ayni deger ler bir ortak sira numasi alir. Sonraki ayni degerler siradaki numarayi alir.

-- ROW_NUMBER()her satıra sıralı bir tamsayı atar. Satır numarası ilk satır için 1 ile başlar.
-- PARTITION BY, ROW_NUMBER() ile kullanılırsa bölüm içindeki her satıra sıralı bir tamsayı atar. 
-- Her bölümdeki ilk satır için satır numarası 1 ile başlar. 

-- Dense rank stokta kaç çeşit ürün var rank'ıde sectiğim ürünün stoktaki mevcutu için kullanabiliriz 

----- 3) VALUE WINDOW FUNCTIONS -----

-- Diğer satırlardan değerler eklemenize izin verirler.

/*
FIRST_VALUE :	Belirtilen pencere çerçevesindeki ilk satırın değerini alın.

LAG	: Geçerli satırdan önce gelen belirli bir fiziksel ofsette bir satıra erişim sağlayın.

LAST_VALUE	: Belirtilen pencere çerçevesindeki son satırın değerini alın.

LEAD : Geçerli satırı takip eden belirli bir fiziksel ofsette bir satıra erişim sağlayın.
*/

--LAG()ve LEAD()fonksiyonları ile başlayalım . Bu işlevler, satırları önceki veya sonraki satırlarla karşılaştırmak için kullanışlıdır. 
-- LAG önceki satırlardaki verileri ve LEAD sonraki satırlardaki verileri döndürür. Deger verilmezse defeultu 1 dir. Negatif sayi kabul etmez.

SELECT id, name,
		LAG(name) OVER(ORDER BY id) AS previous_name
FROM departments;

---

SELECT id, name,
		LEAD(name) OVER(ORDER BY id) AS next_name
FROM departments;

---
SELECT id, name,
		LAG(name, 2) OVER(ORDER BY id) AS previous_name
FROM departments;

---
SELECT id, name,
		FIRST_VALUE(name) OVER(ORDER BY id) AS first_name
FROM departments;

---
SELECT id, name,
		LAST_VALUE(name) OVER(ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_name
FROM departments;

---


-----------------------------------------------------------------
-- Her urunun toplam miktarini ogrenmek istersek

-- Group by ile 

select	product_id, sum(quantity) total_stock
from	product.stock
group by product_id
order by product_id

-- Window function ile

SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) total_stock  -- Partition da yazilan sutun adina gore gruplama yaparak hesaplar
FROM product.stock;

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.

select	brand_id, avg(list_price) avg_price
from	product.product
group by brand_id
;

-- WF ile

SELECT brand_id, AVG(list_price) OVER(PARTITION BY brand_id) avg_price  -- Distinc yazmazsak ortalamayi her ID karsisina yazar
FROM product.product;


SELECT DISTINCT brand_id, AVG(list_price) OVER(PARTITION BY brand_id) avg_price
FROM product.product;

-- Windows frame i anlamak için birkaç örnek:
-- Herbir satýrda iþlem yapýlacak olan frame in büyüklüðünü (satýr sayýsýný) tespit edip window frame in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.


SELECT	category_id, product_id,
	COUNT(*) OVER() NOTHING,                      --Tablonun tum satirlarini saydi
	COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,  -- Her kategorideki satir sayisini, o kategorideki her urune yazdi
	COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,  -- Partition icinde daraltma yapilmadi, Her kategorideki satir sayisini, o kategorideki her urune yazdi 
	COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,   -- Order by yapip tanimlama yapmazsak kategorinin icindeki bulundugu sira sayisini getirir.  DEFAULT: rows between unbounded preceeding and current row
	COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,  -- Her frame'de icindeki bulundugu sira sayisini getirir. Bastan bulundudu satira kadar sinirlama yok.
	COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,  -- Bulundudu satirdan frame sonuna kadar satirlari getirir.
	COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1, -- Ayni frame'de Herbir satirin 1 oncesini ve 1 sonrasini alir
	COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2  -- Her frame'de bulundugu satirdan 2 geriye 3 ileriye toplam 6 satir alarak islem yapar
FROM	product.product
ORDER BY category_id, product_id;


-- En ucuz urunu bulalim

select	top 1 list_price
from	product.product
order by list_price;

-- Window function ile

SELECT DISTINCT Min (list_price) OVER ()
FROM product.product

-- Her bir kategorideki en ucuz urunu getirelim

SELECT DISTINCT Min (list_price) OVER (PARTITION BY category_id) cheapest_product
FROM product.product

---

select	product_id, product_name, list_price, min(list_price) over() cheapest
		from	product.product

-- 
select	*
from	(
		select	product_id, product_name, list_price, min(list_price) over() cheapest
		from	product.product
		) A
where	A.list_price = A.cheapest
;

-- Product tablosunda toplam kaç faklý product bulunduðu

SELECT COUNT(product_id)
FROM product.product;

-- WF ile

select	distinct count(*) over()
from	product.product


-- Order_item tablosunda kaç farklý ürün bulunmaktadýr?

select	count(distinct product_id)
from	sale.order_item
;

-- Ayný sorguyu Window Functions ile yaptýðýnýz hata alýrsýnýz.
-- Çünkü windows functions içinde count(distinct ...) kullanamazsýnýz

select	count(distinct product_id) over ()
from	sale.order_item
;

select	distinct order_id, count(item_id) over(partition by order_id) cnt_product
from	sale.order_item

-- Herbir kategorideki herbir markada kaç farklý ürünün bulunduðu

select	distinct category_id, brand_id, count(*) over(partition by brand_id, category_id) num_of_prod
from	product.product
order by brand_id, category_id
;

----- FIRST VALUE

-- Müþterilerin sipariþ tarihini ve ayrýca tüm sipariþler içinde en eski sipariþ tarihini getiriniz

select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date, b.order_id) min_order_date
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

/* order by içinde yalnýzca order_date yazdýðýmýzda tarihe göre sýralar.
order by içinde order_date'in yanýna bir alan daha yazmýþ olsak ayný tarihler arasýnda sýralamayý o alana göre yapar.
Eðer yalnýzca order_date yazarsak ve kayýtta iki ayný tarih olursa tablo oluþturulurken sýra nasýlsa o sýraya göre sýralar. */

----- LAST VALUE
-- Order by da bulundugu satiri son satir kabul eder
-- DEFAULT: rows between unbounded preceeding and current row

-- Müþterilerin sipariþ tarihini ve ayrýca tüm sipariþler içinde en yeni sipariþ tarihini getiriniz

select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- Bu sorguyu LAST_VALUE ile yaptýðýmýzda window frame i belirlememiz gerekiyor.
-- Aksi taktirde order by kullandýðýmýzda default window frame UNBOUNDED PRECEDING AND CURRENT ROW oluyor.

-- Ters cevirerek calistirabiliriz

select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date DESC) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- Ya da son satiri kendimiz belirleriz

select	a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(b.order_date) over(order by b.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- En ucuz urunumuzun adi nedir (First_value ile)

select	distinct first_value(product_name) over (order by list_price) cheapest_product
from	product.product

-- En ucuz urunumuzun adi nedir (First_value ile), bunlarin icinde en yeni olani gelsin

select	distinct first_value(product_name) over (order by list_price, model_year DESC) cheapest_product_name
from	product.product
;
---

select	distinct
		first_value(product_name) over (order by list_price, model_year DESC) cheapest_product_name,
		first_value(list_price) over (order by list_price, model_year DESC) cheapest_product_price
from	product.product
;


----- LAG() FUNCTION

/* LAG, current row'dan belirtilen argümandaki rakam kadar önceki deðeri getiriyor.
LEAD, current row'dan belirtilen argümandaki rakam kadar sonraki deðeri getiriyor.
Genellikle LEAD VE LAG fonksiyonlarý SIRALANMIÞ BÝR LÝSTEYE UYGULANIR !  O yüzden ORDER BY KULLANILMALIDIR!! */

-- Çalýþanlarýn satýþ yaptýklarý tarihleri listeleyin ve ayrýca bir önceki satýþ tarihlerini de yanýna yazdýrýnýz.

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date;

-- WF ile bir onceki satisini ekleyelim

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date

-- Her sipasin ten sonraki sipariside getirelim

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		LEAD (b.order_date) over(partition by a.staff_id order by b.order_id) post_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date

--Her sipasin ten 2 onceki sipariside getirelim

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date, 2) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- Lead ve lag fonksiyonlarý ile yapabileceðiniz baþka örnekler:
-- Çalýþanlarýn 2 önceki satýþ tarihi, bir önceki satýþ tarihi, bir sonraki satýþ tarihi ve 2 sonraki satýþ tarihi

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lag2,
		lag(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lag1,
		lead(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lead1,
		lead(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lead2
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

----- WINDOW FRAMES -----
/*
Varsayılan olarak, bölümdeki ilk satırdan geçerli satıra kadar tüm satırları kapsayacak şekilde her satır için bir pencere ayarlanır. 
Ancak, window frame yan tümcesi varsayılandır.
Window frame yan tümcesini kullanan Window Functions sorgusu aşağıdaki gibi görünür:

---
SELECT {columns},
{window_func} OVER (PARTITION BY {partition_key} ORDER BY {order_key} {rangeorrows} 
BETWEEN {frame_start} AND {frame_end})FROM {table1};


{columns} sorgu için tablolardan alınacak sütunlar, 
{window_func} kullanmak istediğiniz pencere işlevi, 
{partition_key} bölümlemek istediğiniz sütun veya sütunlar (bundan sonra daha fazlası),  
{order_key} sıralamak istediğiniz sütun veya sütunlar,  
{rangeorrows} ya  RANGE anahtar sözcük ya da  ROWS anahtar 
{frame_start} pencere çerçevesinin nerede başlatılacağını belirten bir anahtar sözcüktür,
{frame_end} pencere çerçevesinin nerede biteceğini belirten bir anahtar sözcüktür 

Commonly Used Framing Syntax
Frame												Meaning

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW	: Bölümün 1. satırından başlayın ve geçerli satıra kadar olan satırları ekleyin.

ROWS UNBOUNDED PRECEDING							: Bölümün 1. satırından başlayın ve geçerli satıra kadar olan satırları ekleyin.

ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING	: Geçerli satırdan başlayın ve bölümün sonuna kadar olan satırları ekleyin.

ROWS BETWEEN N PRECEDING AND CURRENT ROW.			: Geçerli satırdan önce belirtilen sayıda satırdan başlayın ve geçerli satıra kadar olan satırları ekleyin.

ROWS BETWEEN CURRENT ROW AND N FOLLOWING			: Geçerli satırdan başlayın ve geçerli satırı takip eden belirli sayıda satıra kadar satır ekleyin.

ROWS BETWEEN N PRECEDING AND N FOLLOWING			: Geçerli satırdan önce belirli sayıda satırdan başlayın ve geçerli satırı takip eden belirli sayıda satır ekleyin. 
													Evet, mevcut satır da dahildir!
*/

---------------

-- Herbir kategori içinde ürünlerin fiyat sıralamasını yapınız (artan fiyata göre 1'den başlayıp birer birer artacak)

SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num
FROM	product.product
;

select	category_id, list_price,
		ROW_NUMBER() OVER(partition by category_id order by list_price ASC) Row_num
from	product.product
order by category_id, list_price
;

-- Aynı soruyu aynı fiyatlı ürünler aynı sıra numarasını alacak şekilde yapınız (RANK fonksiyonunu kullanınız)

select	category_id, list_price,
		ROW_NUMBER() OVER(partition by category_id order by list_price ASC) Row_num,
		RANK() OVER(partition by category_id order by list_price ASC) Rank_num
from	product.product
order by category_id, list_price
;

select	category_id, list_price,
		ROW_NUMBER() OVER(partition by category_id order by list_price ASC) Row_num,
		RANK() OVER(partition by category_id order by list_price ASC) Rank_num,
		DENSE_RANK() OVER(partition by category_id order by list_price ASC) Dense_rank_num
from	product.product
order by category_id, list_price
;

------

select	brand_id, list_price,
		ROUND(CUME_DIST() OVER(partition by brand_id order by list_price),3) AS Cum_dist
from	product.product;

---
SELECT	brand_id, list_price,
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK
FROM	product.product
;

-- Herbir markanin icinde 4 kume olusturalim
-- tam bölünmüyorsa ilk kümelere fazla eleman veriyor

SELECT	brand_id, list_price,
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK,
		NTILE(4) OVER (PARTITION BY brand_id ORDER BY list_price) AS NTILE_NUM,
		count(*) OVER (PARTITION BY brand_id) AS Urun_sayisi
FROM	product.product;

-- Aşağıdakilerin her ikisini de döndüren bir sorgu yazın:
-- 1- Herbir siparişin toplam fiyatı
-- 2- Ürünler liste fiyatı üzerinden satılmış olsaydı siparişlerin toplam fiyatı ne olurdur?

select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount
from sale.orders a, sale.order_item b
where a.order_id = b.order_id
order by a.order_id, b.item_id;

select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
		(b.list_price * (1 - b.discount)) * b.quantity
from sale.orders a, sale.order_item b
where a.order_id = b.order_id
order by a.order_id, b.item_id;

-- 1- Herbir siparişin toplam fiyatı

with tbl as (
select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
		(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
		sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
		sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
		count(*) over(partition by a.order_id) urun_adedi
from	sale.orders a, sale.order_item b
where	a.order_id = b.order_id
)
select	distinct order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi,
		siparis_toplami / siparis_toplami_liste_fiyati
from	tbl
order by siparis_toplami / siparis_toplami_liste_fiyati desc
;

---

with tbl as (
	select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
			(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
			sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
			sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
			sum(quantity) over(partition by a.order_id) urun_adedi
	from	sale.orders a, sale.order_item b
	where	a.order_id = b.order_id
)
select	distinct order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi,
		1 - (siparis_toplami / siparis_toplami_liste_fiyati) discount_ratio_order
from	tbl
order by 1 - (siparis_toplami / siparis_toplami_liste_fiyati) desc
;

---

with tbl as (
	select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
			(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
			sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
			sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
			sum(quantity) over(partition by a.order_id) urun_adedi
	from	sale.orders a, sale.order_item b
	where	a.order_id = b.order_id
)
select	distinct order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi,
		1 - (siparis_toplami / siparis_toplami_liste_fiyati) discount_ratio_order,
		cast( 100 * (1 - (siparis_toplami / siparis_toplami_liste_fiyati))
			as INT)
		discount_ratio_order_INT
from	tbl
order by 1 - (siparis_toplami / siparis_toplami_liste_fiyati) desc
;


-- SORU:
-- Herbir ay için şu alanları hesaplayınız:
--  O aydaki toplam sipariş sayısı
--  Bir önceki aydaki toplam sipariş sayısı
--  Bir sonraki aydaki toplam sipariş sayısı
--  Aylara göre yıl içindeki kümülatif sipariş yüzdesi

/*
Burada yer alan 4 soruyu hesaplamak için ilk olarak tarih verisinden herbir ay için unique bir id oluşturmalıyız.
Format olarak 'YYYYMM' kullanalım.
Bu formatı elde etmek için SQL Server de tanımlı olan stilleri kullanabiliriz.
Bu stiller CONVERT fonksiyonu ile çalışmaktadır.
Detaylı bilgi için: https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15

İlk 3 sorunun cevabı aşağıdaki SQL scriptinde yer almaktadır.
Aşağıda yer alan 4. sorunun cevabı ise doğru değildir.
Çünkü CUM_DIST() fonksiyonu satır sayısını esas alıp kümülatif yüzdeyi hesaplamaktadır.
Yani ocak ayına ait 1 satır var ve içinde bulunduğu yılda 12 ay var ve bu ay için CUM_DIST() fonksiyonu 1/12 değerini döndürecektir.
Aynı şekilde şubat ayı için 2/12 değerini döndürecektir. Yılları birbiriyle karşılaştırdığınızda bu durumu rahat görebilirsiniz.
Peki 4. soruda istenen değerleri nasıl hesaplayabiliriz?
Bunun için aşağıdaki ikinci SQL sorgusuna bakabilirsiniz :)
*/

select	convert(NVARCHAR(6), getdate(), 112) ay

-- 1. Çözüm

with tbl as (
		select	distinct
				year(order_date) yil,
				convert(nvarchar(6), order_date, 112) ay,
				count(*) over(partition by convert(nvarchar(6), order_date, 112)) toplam_siparis
		from	sale.orders
)

select	*,
		lag(toplam_siparis) over(order by ay) onceki_toplam_siparis,
		lead(toplam_siparis) over(order by ay) sonraki_toplam_siparis,
		CUME_DIST() over(partition by yil order by ay) kumulatif_yuzde
from	tbl
;



-- 2. Çözüm

with tbl as (
		select	year(order_date) yil,
				convert(nvarchar(6), order_date, 112) ay,
				count(*) toplam_siparis
		from	sale.orders
		group by year(order_date),
				convert(nvarchar(6), order_date, 112)
)

select	yil, ay, toplam_siparis,
		lag(toplam_siparis) over(order by ay) onceki_ay_toplam_siparis,
		lead(toplam_siparis) over(order by ay) sonraki_ay_toplam_siparis,
		sum(toplam_siparis) over(partition by yil order by ay rows between unbounded preceding and current row) kumulatif_toplam_siparis,
		sum(toplam_siparis + 0.0) over(partition by yil order by ay rows between unbounded preceding and current row)
			/ sum(toplam_siparis) over(partition by yil) kumulatif_siparis_yuzdesi
from	tbl

/*
Bu sorguda kümülatif sipariş yüzdesini CUM_DIST fonksiyonu ile değil de manuel olarak hesaplamış olduk.
Çünkü CUM_DIST fonksiyonu satır sayısına göre bir hesaplama yapıyor. Fakat biz zaten with clause içinde hesapladığımız aylık sipariş sayısı üzerinden hesaplama yapmak istiyoruz.
Dolayısıyla ilk olarak mevcut aya kadar toplam sipariş sayısını hesapladık (rows between kuralına dikkat edin, bir yıl içinde söz konusu aya gelene kadar tüm ayların toplamı)
Daha sonra bu değeri o yıldaki toplam sipariş sayısına oranladık.
Son kod içinde toplam_siparis değerini 0.0 ile topladık. Bunun sebebini Sizlere bırakıyorum :)
*/