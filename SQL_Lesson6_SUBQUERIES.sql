-------------------------------------
-- DS 10/22 EU -- DAwSQL Session 8 --
----------- 10.03.2022 --------------
------------------------------------- 

----- SUBQUERIES -----

/*	1. Soru benden ne istiyor? 
	2. İstenen veri hangi tablolarda yer alıyor (join etmem gerekiyor mu)? 
	3. Soruda bir şart/filtreleme var mı(WHERE clause)? 
	4. Gruplama var mı(GROUP BY)?  
	5. Sıralamam gerekiyor mu (ORDER BY) 
	6. Subquery kullanacak mıyım?
Acele etmeden adım adım gidiyor. Önce subquery'i yazıyor. Ordan sonucu alıp o sonucu nerde kullanacaksa oraya yapıştırıyor.  
Sonra üst sorguyu tamamlıyor. */

/* Subquery, başka bir SELECT ifadenin içine yerleştirilmiş bir ifadedir. Subquery'e inner query veya nested query de denir.
Bir subquery şu durumlarda kullanılabilir:

- SELECT yan tümcesi
- FROM yan tümcesi
- WHERE yan tümcesi
Subquery kullanırken bazı kurallar vardır:

Bir subquery parantez içine alınmalıdır.
Bir  ORDER BY yan tümcenin bir subquery'de kullanılmasına izin verilmez.
BETWEEN Operatör bir subquery ile kullanılamaz . BETWEEN'i Ancak subquery içinde kullanabilirsiniz  .
Subquery'i hangi deyimi kullanırsanız kullanın, bu kurallar geçerlidir ve subquery çoğunlukla aynı şekilde yazılır. 

Üç ana subqery türü vardır:
1- Single-row subqueries
2- Multiple-row subqueries
3- Correlated subqueries

*/

SELECT dept_name, 
       ( SELECT MAX(salary) FROM departments ) as max_salary
FROM departments;

---
SELECT *
FROM 
(
SELECT name, seniority, salary 
FROM departments
WHERE seniority = 'Senior'
AND salary > 80000
) as sub_table;

---
SELECT name, salary
FROM departments
WHERE salary > 
    (SELECT salary 
     FROM departments
     WHERE name = 'Jane');


----- SINGLE ROW SUBQERIES -----

-- Tek satırlı alt sorgular, yalnızca bir sütunlu bir satır döndürür ve aşağıdakiler gibi tek satırlı operatörlerle kullanılır: 
-- =, >, >=, <=, <>, !=  

SELECT name, salary
FROM departments
WHERE salary > 
    (SELECT AVG(salary) 
     FROM departments)
ORDER BY salary;


-- Yukarıdaki sorguyu analiz edelim:
-- We've used > operator with WHERE clause.
-- inner query 73923 olan ortalama maaşı döndürür ve bu tek değeri dış sorguya iletir.
-- Outer query, bu çalışanları filtreler ve maaşı 73923'ten fazla olanları döndürür.
---

---- MULTIPLE ROW SUBQERIES

-- Multiple-row subquer'ler, IN, NOT IN, ANY, ALL gibi çok satırlı operatörlerle birlikte kullanılır  vesatır kümelerini döndürür . 

SELECT name, dept_name
FROM departments
WHERE dept_name IN
   (SELECT dept_name 
    FROM departments
    GROUP BY dept_name
    HAVING AVG(salary) > 60000);


-- Davis Thomas'nın çalıştığı mağazadaki tüm personelleri listeleyin.

SELECT *
FROM sale.staff
WHERE store_id = (
    SELECT store_id
    FROM sale.staff
    WHERE first_name = 'Davis' AND last_name = 'Thomas'
	);

-- Charles Cussona'nin manageri oldugu staff listesini getirin

SELECT *
FROM sale.staff
WHERE manager_id  = (
	SELECT staff_id
	FROM  sale.staff
	WHERE first_name='Charles' and last_name='Cussona'
	);

-- The BFLO Store magazasinin oldugu sehirdeki musterileri listeleyin

SELECT *
FROM sale.customer
WHERE city = (
    SELECT city
    FROM sale.store
    WHERE store_name = 'The BFLO Store'
);

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'  TV'den daha pahali urunlerin listesini getir

SELECT *
FROM product.product
WHERE list_price > (
	SELECT list_price
	FROM product.product
	WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
	);

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'  TV'den daha pahali TV'lerin listesini getir

SELECT *
FROM product.product
WHERE list_price > (
	SELECT list_price
	FROM product.product
	WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
	)
	AND 
	category_id =
	(SELECT category_id
	FROM product.product
	WHERE product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
	);


-- Laurel Goldammer isimli müşterinin alışveriş yaptığı tarihte/tarihlerde alışveriş yapan tüm müşterileri listeleyin.

SELECT C.first_name, C.last_name, N.order_date
FROM sale.customer C
JOIN 
(SELECT *
FROM sale.orders
WHERE order_date IN (
SELECT O.order_date
FROM sale.customer C 
JOIN sale.orders O 
ON C.customer_id = O.customer_id
WHERE first_name = 'Laurel' AND last_name = 'Goldammer') ) N
ON C.customer_id = N.customer_id;

-- 2021 yilinda uretilen ve kategorisi Game, gps ve Home Theatre olmayanlari listeyin

SELECT *
FROM product.category
WHERE category_name in ('Game', 'gps', 'Home Theater');

SELECT *
FROM product.product
WHERE model_year = '2021';

SELECT *
FROM product.product
WHERE model_year = '2021'
	AND category_id NOT IN (
	SELECT category_id
	FROM product.category
	WHERE category_name in ('Game', 'gps', 'Home Theater')
	);

----- ANY & ALL -----



/* ANY operator:
Boolean değer döndürür.
Eğer subquery'nin değerlerinden herhangi biri koşulu karşılıyorsa TRUE döndürür. 
Yani aralıktaki değerlerden herhangi biri TRUE ise koşulun TRUE olacağı anlamına gelir.
ALL operator:
Boolean değer döndürür.
Ancak tüm subquery değerleri koşulu sağlıyorsa TRUE döndürür. Yani aralıktaki tüm değerler için işlem TRUE ise şart o zaman TRUE olacaktır.
SELECT, WHERE ve HAVING statement'ları ile birlikte kullanılır. */

-- 2020 model olup Receivers Amplifiers kategorisindeki en pahalı üründen daha pahalı ürünleri listeleyin.
-- Ürün adı, model_yılı ve fiyat bilgilerini yüksek fiyattan düşük fiyata doğru sıralayınız.

SELECT	product_name, model_year, list_price
FROM	product.product
WHERE	model_year = 2020 AND
		list_price > ALL (
			SELECT	b.list_price
			FROM	product.category a, product.product b
			WHERE	a.category_name = 'Receivers Amplifiers' and
					a.category_id = b.category_id
		)
ORDER BY list_price DESC;


-- Receivers Amplifiers kategorisindeki ürünlerin herhangi birinden yüksek fiyatlı ürünleri listeleyin.
-- Ürün adı, model_yılı ve fiyat bilgilerini yüksek fiyattan düşük fiyata doğru sıralayınız.

SELECT list_price --1. kosul
FROM product.product b, product.category a
WHERE b.category_id=a.category_id
AND category_name = 'Receivers Amplifiers';

SELECT product_name, model_year, list_price -- 2. kosul
FROM product.product 
WHERE model_year=2020;

SELECT product_name, model_year, list_price -- kosullarin bir arada kullanilmasi
FROM product.product  
WHERE model_year=2020
AND list_price > ALL (  --buyuktur yapinca birden fazla satir ciktigi icin calismaz ALL dememiz lazim 
    SELECT list_price
    FROM product.product b, product.category a
    WHERE b.category_id=a.category_id
    AND category_name = 'Receivers Amplifiers'
    )
ORDER BY list_price DESC;


SELECT product_name, model_year, list_price
FROM product.product
WHERE model_year = 2020 
    AND list_price > (
        SELECT MAX(B.list_price)
        FROM product.category A
        JOIN product.product B
        ON A.category_id = B.category_id
        WHERE A.category_name = 'Receivers Amplifiers'
    );

SELECT product_name, model_year, list_price
FROM product.product
WHERE model_year = 2020 
    AND list_price > ALL (
        SELECT B.list_price
        FROM product.category A, product.product B
        WHERE A.category_id = B.category_id
        AND A.category_name = 'Receivers Amplifiers'
    );


-- ANY

SELECT product_name, model_year, list_price
FROM  product.product
WHERE  model_year=2020 
	AND  list_price > ANY
		(
		SELECT list_price
		FROM product.product
		WHERE category_id = (
		SELECT category_id
		FROM product.category
		WHERE  category_name='Receivers Amplifiers')
		)
ORDER BY list_price 

--- 

SELECT product_name, model_year, list_price
FROM product.product
WHERE model_year = 2020 
	AND list_price > ANY 
		(
		SELECT	b.list_price
		FROM	product.category a, product.product b
		WHERE	a.category_name = 'Receivers Amplifiers' 
		AND	a.category_id = b.category_id
		)
order by list_price DESC;

----- CORRELATED SUBQURIES -----

-- Bir alt sorgu, dış sorgudaki sütunlara başvuruyorsa veya başka bir deyişle, bir alt sorgu dış sorgudaki değerleri kullanıyorsa, 
-- bu alt sorguya ilişkili alt sorgu denir. 
-- İlişkili bir alt sorguda, alt sorgudaki her satır, dış sorgunun her satırı için bir kez yürütülür. 
-- Bu nedenle, yinelenen bir alt sorgu olarak da bilinir.

-- SQL correlated subquery ile simple subquery arasındaki temel fark, SQL correlated subquery'nin dış sorgunun tablosundaki sütunlara başvurmasıdır .

-- Aşağıda, ilişkili bir alt sorgu sorgusu örneği gösterilmektedir. 
-- Bu örnekte, ortalama maaşları 80000'in üzerinde olan departmanlarda çalışan çalışanları listelemeye çalışıyoruz.

SELECT id, name, graduation, seniority
FROM departments AS A
WHERE dept_name IN 
            (
             SELECT dept_name
             FROM  departments AS B
             WHERE A.id= B.id
             GROUP BY dept_name
             HAVING AVG(salary) > 80000
             )


----- EXIST & NOT EXIST -----

---- EXISTS ----

/* EXIST ve NOT EXIST ne yapar? arasındaki fark nedir?

EXISTS Operatöru, SELECT ifade tarafından döndürülen satır sayısını kısıtlamak için kullanılır .
EXISTS operatörü, bir alt sorgudaki kayıtların varlığını test eder, eğer alt sorgudan kayıt dönüyorsa 
TRUE değerini döndürür. kayıt yoksa FALSE yada NULL döndürür.
Alt sorgu boş bir satır döndürse bile, EXIST operatör bunu bir kayıt olarak değerlendirir ve sonucu TRUE olarak kabul eder.

NOT EXISTS operatörü de alt sorgudaki kayıtların varlığını test eder, 
eğer alt sorgudan kayıt dönmüyorsa TRUE döndürür. Kayıt varsa FALSE döndürür. 

EXISTS ve NOT EXISTS operatörlerini kullanmanın avantajı, eşleşen bir kayıt bulunduğu sürece iç alt sorgu yürütmesinin durdurulabilmesidir.

Alt sorgu büyük hacimli kayıtları taramayı gerektiriyorsa, tek bir kayıt eşleştirilir eşleşmez alt sorgu yürütmesini durdurmak,  
genel sorgu yanıt süresini büyük ölçüde hızlandırabilir.
*/

/*
Bu örnekte (bir önceki alt konuda gördüğünüz), ortalama maaşları 80000'in üzerinde olan departmanlarda çalışan çalışanları listelemeye çalışıyoruz.

Sorguda neler oluyor?

İç sorguda ortalama maaşı 8000'in üzerinde olan departmanları bulun.
Bu kurala uyan bir veya daha fazla departman varsa, bu departmanlarda çalışan çalışanlar dış sorguda departman tablosu (A) ile eşleştirilir. 
Sonuç olarak, bu çalışanlarla ilgili bilgiler listelenir.
EXISTS veya NOT EXISTS kullanan ilişkili alt sorgular için, alt sorgudan ne dönerse dönsün, önemli olan eşleşen değerlerdir. 
select deyiminde çağrılan sütunlar değil.

NOT EXISTS operatörü, temel alınan alt sorgu hiçbir kayıt döndürmezse true değerini döndürür. Ancak, iç alt sorgu tarafından tek bir kayıt eşleştirilirse,
NOT EXISTS operatörü false döndürür ve alt sorgu yürütmesi durdurulabilir.
*/
SELECT id, name, graduation, seniority
FROM departments AS A
WHERE EXISTS
            (
             SELECT 1
             FROM  departments AS B
             WHERE A.id= B.id
             GROUP BY dept_name
             HAVING AVG(salary) > 80000
             );
---

SELECT id, name, graduation, seniority 
FROM departments AS A
WHERE NOT EXISTS 
            (
             SELECT 1
             FROM  departments AS B
             WHERE A.id= B.id
             GROUP BY dept_name
             HAVING AVG(salary) > 80000
             );

-- 'Apple - Pre-Owned iPad 3 - 32GB - White' isimli ürünün hiç sipariş edilmediği eyaletleri listeleyiniz.
-- Not: Eyalet olarak müşterinin adres bilgisini baz alınız.

select	distinct [state]
from	sale.customer d
where	not exists (
			select	*
			from	sale.orders a, sale.order_item b, product.product c, sale.customer e
			where	a.order_id = b.order_id and
					b.product_id = c.product_id and
					c.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
					a.customer_id = e.customer_id and
					d.state = e.state
					);

-- 2020-01-01 tarihinden önce sipariş vermeyen müşterileri döndüren bir sorgu yazın. 
-- Bu sorguda 2020-01-01 tarihinden önce sipariş vermiş bir müşteri varsa sorgu herhangi bir sonuç döndürmemelidir.

SELECT DISTINCT B.customer_id, B.first_name, B.last_name, A.order_date
FROM sale.orders A, sale.customer B 
WHERE A.customer_id = B.customer_id
    AND NOT EXISTS 
	(
	SELECT *
	FROM sale.orders C
	WHERE C.order_date < '2020-01-01' 
	AND A.customer_id = C.customer_id
	);

select	distinct b.customer_id, b.first_name, b.last_name
from	sale.orders a, sale.customer b
where	a.customer_id = b.customer_id and
		NOT EXISTS (
			select	*
			from	sale.orders c
			where	c.order_date < '2020-01-01' and
					b.customer_id = c.customer_id);

-- Jerald Berray isimli müşterinin son siparişinden önce sipariş vermiş 
-- ve Austin şehrinde ikamet eden müşterileri listeleyin.


----- COMMON TABLE EXPRESSIONS (CTE)-----

/*
CTE, başka bir SELECT, INSERT, DELETE, veya UPDATE deyimlerinde başvurabileceğiniz veya kullanabileceğiniz geçici bir sonuç kümesidir . 
Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir. 
CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar. 

CTE, yalnızca tek bir SQL ifadesinin süresi boyunca mevcuttur. 
Bu, bunların "ifade kapsamlı görünümler " oldukları ve veritabanı şemasında depolanmadıkları anlamına gelir. 
Yalnızca oluşturulduğu sorguda geçerlidirler. Bir alt sorgu gibi. Satırları ve veri sütunlarını içeren bir sonuç üretir.

İki tür CTE vardır:
1- Ordinary
2- Recursive

CTE'ler, SELECT, INSERT, DELETE, veya UPDATE deyimlerinin önüne bir WITH yan tümce eklenerek oluşturulur .
WITH ayrıca CTE olarak da bilinir. Bazı kaynaklarda CTE'leri WITH cümle veya WITH sorgu olarak görebilirsiniz. Çünkü WITH anahtar sözcüğünü kullanır.
*/

---- Ordinary Common Table Expressions ----

/*
Common Table Expression tek bir ifadenin süresi boyunca mevcuttur. Bu, yalnızca ait oldukları sorgunun içinde kullanılabilir oldukları anlamına gelir.
VIEW'lere benzer . Bu şekilde "statement scoped views" olarak tanımlanır. 

Tüm CTE'ler (sıradan ve özyinelemeli) bir SELECT, INSERT, DELETE, veya UPDATE ifadesinin önünde bir WITH yan tümce ile başlar.

WITH query_name [(column_name1, ...)] AS
    (SELECT ...) -- CTE Definition
SELECT * FROM query_name; -- SQL_Statement

İlk olarak, WITH anahtar sözcüğünu, daha sonra bir sorguda başvurabileceğiniz query_name izler.
Ardından, query_name'dan sonra virgülle ayrılmış sütunların bir listesini belirtin. Sütun sayısı, CTE_definition'da tanımlanan sütun sayısıyla aynı olmalıdır. Bu kısım isteğe bağlıdır.
Ardından, Query_name veya sütun listesinden sonra AS anahtar sözcüğü kullanın (sütun listesi belirtilmişse).
AS Anahtar kelimeden sonra CTE'nizi SELECT deyimle tanımlayın. CTE tanımına parantez eklemeniz gerekir. Bu, bir sonuç kümesini dolduracaktır.
Son olarak, SELECT, INSERT, DELETE veya UPDATE deyimlerini kullanarak bir sorguda (SQL_statement) ortak tablo ifadesine bakın .
*/

WITH temp_table (avg_salary) AS
	(
  SELECT AVG(salary)
	FROM departments
  )
	SELECT name, salary
	FROM departments INNER JOIN temp_table
	ON departments.salary > temp_table.avg_salary;

---


WITH table_name AS (
		SELECT	MAX(B.order_date) last_order_date
		FROM	sale.customer A, sale.orders B
		WHERE	A.first_name = 'Jerald' 
				AND	A.last_name = 'Berray' 
				AND A.customer_id = B.customer_id
				)
SELECT	*
FROM	table_name;


------------------

---- Recursive Common Table Expressions ----

/*
Alt sorgusu kendi adına başvuruyorsa, ortak bir tablo ifadesi özyinelemelidir. 
İlk CTE, tam sonuç döndürülene kadar verilerin alt kümelerini döndürerek tekrar tekrar yürütülür. 
Yinelemeli bir ortak tablo ifadesi, sıradan bir ortak tablo ifadesi ile aynı temel sözdizimine sahiptir, ancak aşağıdaki ek özelliklere sahiptir:

SELECT İfadesi, en sağdaki bileşik operatörün UNION ya da UNION ALL olduğu yerde bir bileşik seçim olmalıdır.
AS anahtar sözcüğünün sol tarafında belirtilen tablo, bileşik seçimin FROM en sağdaki ifadesinin yan tümcesinde  tam olarak bir kez görünmelidir 
ve SELECT başka hiçbir yerde yer almamalıdır.
Bileşik seçimin en sağında  SELECT yer alan, aggregate yada window functions kullanmamalıdır .
*/

WITH table_name (column_list)
AS (
    -- Anchor member
    initial_query  
    UNION ALL
    -- Recursive member that references table_name.
    recursive_query  
)
-- references table_name
SELECT *
FROM table_name

/*
Bir recursive CTE'nin üç bölümü vardır:

1- Recursive CTE'nin temel sonuç kümesini döndüren bir ilk sorgu. İlk sorguya çapa üyesi denir.
2- Ortak tablo ifadesine (tablo_adı) başvuran recursive query, bu nedenle özyinelemeli üye olarak adlandırılır.
Recursive üye,  UNION ALL  operatör kullanılarak çapa üye ile birleştirilir.
3- Recursive üyenin yürütülmesini sonlandıran recursive üyede belirtilen bir sonlandırma koşulu.

Recursive CTE, bir çalışanın bir yöneticiye rapor verdiği organizasyon çizelgeleri veya bir ürün birçok bileşenden oluştuğunda 
çok seviyeli malzeme listesi gibi hiyerarşik verileri sorgulamada yararlıdır ve her bir bileşenin kendisi de başka birçok bileşenden oluşur.
*/

-- 1'den 10'a kadar herbir rakam bir satırda olacak şekide bir tablo oluşturun.


WITH cte
    AS (SELECT 1 AS n -- anchor member
        UNION ALL
        SELECT n + 1 -- recursive member
        FROM   cte
        WHERE  n < 10) -- terminator
SELECT n
FROM cte;

--- 

with tablorakam as (
		select	1 rakam
		
		union all
		select	rakam + 1
		from	tablorakam
		where	rakam < 10
)
select	*
from	tablorakam;

/* CTE'ler (Common Table Expressions) nedir ?
CTE (Common Table Expression), geçici olarak var olan ve genelde yinelemeli(recursive) 
ve büyük sorgu ifadelerinde kullanım için olan bir sorgunun sonuç kümesi olarak düşünebiliriz.
Veritabanı görünümleri(views) ne benzetebiliriz, ancak hiç bir şekilde alanların (field&column) deklare edilmesi gerekmez. 
CTE’lerin sonuçları depolanmaz ve yalnızca işlem süresince var olur. */

/* CTE’leri nasıl oluştururuz ?
“WITH” keyword’ü ile başlatın.
Tablo olarak kullanacağımız, geçici bir “isim” ataması yapın.
İsim ataması yaptıktan sonra, “AS” ile devam edin.
İsteğe bağlı olarak, field’ların isimlerini yazabilirsiniz (field1,field2)
Sonuç için bir sorgu yazın.
Birden fazla CTE’yi bir araya getirmek için, her CTE’den sonra “,” ekleyerek 2–4. adımları tekrarlayın.
“CTE” dizilimi bittikten sonra, CTE’den referans alacak şekilde sorgunuzu yazın. */


----- CTE vs. Subquery -----

/*
CTE ve Subqueries çoğunlukla aynı amaç için kullanılır. 
Ancak CTE'nin ana avantajı (recursive queries için kullanmadığınızda) kapsüllemedir, 
kullanmak istediğiniz her yerde Subqueries bildirmek yerine, onu bir kez tanımlayabilirsiniz, ancak buna birden fazla referans yapabilirsiniz.

Ayrıca, CTE'ler pratikte daha yaygındır, çünkü birinin (sorguyu yazmayan) mantığı izlemesi için daha temiz olma eğilimindedirler. 
Bu bağlamda CTE'lerin daha okunaklı olduğunu söyleyebiliriz. 

Her ikisi de sorgu iyileştiriciye aynı bilgiyi sağladığından, CTE'lerin ve Subqueries performansı teorik olarak aynı olmalıdır. 
Bir fark, birden fazla kez kullanılan bir CTE'nin bir kez kolayca tanımlanıp hesaplanabilmesidir. 
Sonuçlar daha sonra saklanabilir ve birden çok kez okunabilir.

Aynı sonuca sahip iki farklı sorguyu karşılaştıralım, biri CTE kullanılarak ve diğeri Subqueries kullanılarak yazılmıştır:
*/

-- CTE ile:

WITH t1 AS 
(
SELECT *
FROM departments
WHERE dept_name = 'Computer Science'
),
t2 as
(
SELECT *
FROM departments
WHERE dept_name = 'Physics'
)
SELECT d.name, t1.graduation AS graduation_CS, t2.graduation AS graduation_PHY
FROM departments as d
LEFT JOIN t1
ON d.id = t1.id
LEFT JOIN t2
ON d.id = t2.id
WHERE t1.graduation IS NOT NULL 
OR    t2.graduation IS NOT NULL
ORDER BY 2 DESC, 3 DESC;


-- Subquery ile:

WITH t1 AS 
(
SELECT *
FROM departments
WHERE dept_name = 'Computer Science'
),
t2 as
(
SELECT *
FROM departments
WHERE dept_name = 'Physics'
)
SELECT d.name, t1.graduation AS graduation_CS, t2.graduation AS graduation_PHY
FROM departments as d
LEFT JOIN t1
ON d.id = t1.id
LEFT JOIN t2
ON d.id = t2.id
WHERE t1.graduation IS NOT NULL 
OR    t2.graduation IS NOT NULL
ORDER BY 2 DESC, 3 DESC;

/*
CTE sorgusunda, derleyici aynı veri kümesini (geçici de olsa) temp_table olarak kaydettiğinden beri sorguladığınızı bilir . 
İkinci sorguda, SQL tamamen aynı olsa da, derleyici onları çalıştırana kadar onların aynı sorgu olduklarını anlamaz. 
Aynı sorguyu iki farklı takma adla çağırmamız gerektiğine dikkat edin: t1 ve t2 . 
Bu sorgu yalnızca daha fazla işlem yapmak ve fazlalık içermekle kalmaz, aynı zamanda bizi aynı sorguyu iki farklı adla çağırmaya da zorlar. 
Bu yanıltıcı.

Bir tavsiye olarak, sonuçlara hızlı bir şekilde ihtiyacınız olduğunda Adhoc sorgularında yalnızca alt sorguları kullanmak olacaktır. 
Sorgu başkaları tarafından okunacaksa, her gün çalıştırılacaksa veya yeniden kullanılacaksa, 
okunabilirlik ve performans için bir CTE kullanmayı deneyin.
*/

WITH t1 AS (
    SELECT order_id, SUM((list_price - (list_price * discount)) * quantity) as total -- her siparişin toplam fiyatı
    FROM sale.order_item
    GROUP BY order_id
	HAVING SUM((list_price - (list_price * discount)) * quantity) > 500
),
t2 AS (
    SELECT customer_id, first_name, last_name, city
    FROM sale.customer
    WHERE city = 'Charleston'
)
SELECT t4.first_name, t4.last_name
FROM (
		SELECT t2.customer_id, t2.first_name, t2.last_name, t2.city, SUM(t1.total) AS total
		FROM sale.orders t3
		JOIN t1 ON t1.order_id = t3.order_id
		JOIN t2 ON t2.customer_id =  t3.customer_id
		GROUP BY t2.customer_id, t2.first_name, t2.last_name, t2.city
		) AS t4
WHERE t4.customer_id IN
					(select c.customer_id
					from sale.customer c
					WHERE NOT EXISTS (
									SELECT i.order_id, SUM((i.list_price - (i.list_price * i.discount)) * i.quantity)
									FROM sale.order_item i, sale.orders o, sale.customer r
									where i.order_id = o.order_id
									and r.customer_id = o.customer_id
									and r.customer_id = c.customer_id
									group by i.order_id
									having SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) <= 500
									)
						)
ORDER BY t4.last_name ASC, t4.first_name ASC;



WITH t1 AS (
    SELECT order_id, SUM((list_price - (list_price * discount)) * quantity) as total -- her siparişin toplam fiyatı
    FROM sale.order_item
    GROUP BY order_id
	HAVING SUM((list_price - (list_price * discount)) * quantity) > 500
),
t2 AS (
    SELECT customer_id, first_name, last_name, city
    FROM sale.customer
    WHERE city = 'Charleston'
)
SELECT t4.first_name, t4.last_name
FROM (
		SELECT t2.customer_id, t2.first_name, t2.last_name, t2.city, SUM(t1.total) AS total
		FROM sale.orders t3
		JOIN t1 ON t1.order_id = t3.order_id
		JOIN t2 ON t2.customer_id =  t3.customer_id
		GROUP BY t2.customer_id, t2.first_name, t2.last_name, t2.city
		) AS t4
WHERE t4.customer_id NOT IN
					(select c.customer_id
					from sale.customer c
					WHERE EXISTS (
									SELECT i.order_id, SUM((i.list_price - (i.list_price * i.discount)) * i.quantity)
									FROM sale.order_item i, sale.orders o, sale.customer r
									where i.order_id = o.order_id
									and r.customer_id = o.customer_id
									and r.customer_id = c.customer_id
									group by i.order_id
									having SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) <= 500
									)
						)
ORDER BY t4.last_name ASC, t4.first_name ASC;

--------------------------

