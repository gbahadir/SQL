-- BUILT-IN FUNCTIONS
-- March 3, 2022

-- GETDATE : SQL örneğini çalıştıran bilgisayarın geçerli tarih ve saatini belirlemek için. O anki zaman ve tarihi getirir

-- DATENAME(datepart, date): tarihin belirli bir bölümünün adını veya değerini nvarchar biçiminde döndürür.

-- DATEPART(datepart, date): tarihin belirli bir bölümünün değerini INT biçiminde döndürür.

-- DAY(date) : tarihin gününü INT biçiminde döndürür.

-- MONTH(date): tarihin ayını INT biçiminde döndürür.

-- YEAR(date): tarihin yılını INT biçiminde döndürür.

-- DATEDIFF(datepart, startdate, enddate): ki tarih arasındaki farkı INT biçiminde döndürür.

--DATEADD(datepart, number, date):  belirli bir tarihin bir bölümüne bir aralık eklemenizi sağlar.

-- EOMONTH(startdate [, month to add]): isteğe bağlı bir mahsup ile belirtilen bir tarihi içeren ayın son gününü döndürür.

-- ISDATE(expression) : geçerli bir tarih saat değeriyse 1 döndürür; aksi halde 0.

--------------------------------------------------------------------------------------------------------------------

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);

SELECT * FROM t_date_time;

SELECT GETDATE()

INSERT t_date_time VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

SELECT * FROM t_date_time;

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' );

SELECT * FROM t_date_time;

SELECT CONVERT(VARCHAR, GETDATE(), 7);

SELECT CONVERT(DATE, '25 OCT 21', 6);

SELECT A_date,
		DATENAME (DW, A_date) [DAYS]
FROM t_date_time;


SELECT A_date,
		DATENAME (DW, A_date) [DAYS],
		DAY (A_date) [days2]
FROM t_date_time;

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time;

---- DATEDIFF

SELECT	A_date,	
		A_datetime
FROM	t_date_time


SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day
FROM	t_date_time


SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day,
		DATEDIFF (MONTH, A_date, A_datetime) Diff_month,
		DATEDIFF (YEAR, A_date, A_datetime) Diff_month,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_Hour
FROM	t_date_time


---- SALE.ORDERS TABLOSUNDAKI ORDER DATE ILE SHIPPED DATE ARASINDAKI FARKI GUN OLARAK BULALIM

SELECT order_date, shipped_date,
	DATEDIFF(DAY, order_date, shipped_date) diff_day  -- Eski tarih  once yazilir
FROM sale.orders;

---- DATEADD & EOMONTH

SELECT *
FROM [sale].[orders];

SELECT order_date,
	DATEADD (YEAR, 3, order_date) new_year,  -- order_date'e 3 yil ekledik
	DATEADD (DAY, -5, order_date) new_day  -- order_date'e -5 gun ekledik
FROM [sale].[orders];

SELECT order_date,
        DATEADD (YEAR, 3, (DATEADD (DAY, -5, order_date))) [new_date]  -- ayni anda gun yil ekledik
FROM [sale].[orders]

SELECT EOMONTH(order_date) LAST_DAY, order_date  -- o ayin son gununu getirir
FROM [sale].[orders];

SELECT EOMONTH(order_date) LAST_DAY, order_date, EOMONTH(order_date, 2) after_2  -- o aydan 2 ay sonranin son gununu getirir
FROM [sale].[orders];  

----  ISDATE: Tarih mi diye sorgular. 0	yada 1 sonuc verir

SELECT ISDATE ('123456');

SELECT ISDATE ('2022-03-03');


---- STRING FUNCTIONS

-- LEN / CHARINDEX / PATHINDEX

-- LEN(), bir dizenin karakter sayısını döndürür (metnin sonundaki boşluklar hariç). Dize NULL değer ise, uzunluk işlevi NULL döndürür .

SELECT LEN (123456);

SELECT LEN ('welcome');

SELECT LEN (welcome);  -- tirnaksiz error verir. Sutun ismi arar

----- CHARINDEX(substring, string [, start location]) ----

--CHARINDEX()işlev, bağımsız değişken olarak bir dize ve bunun bir alt dizesini alır 
-- ve alt dizenin ilk karakteri olan alt dizenin konumunu gösteren bir tamsayı döndürür. 
-- CHARINDEX()işlev, alt dizenin ilk oluşumunu bulur ve tamsayı türünde bir değer döndürür.
-- CHARINDEX()işlevi büyük/küçük harfe duyarlı olarak çalışır. 


SELECT CHARINDEX('C', 'CHARACTER');  -- C'nin ilk indexini geirir

SELECT CHARINDEX('C', 'CHARACTER', 2);  -- C'nin 2. karakterden sonraki ilk indexini geirir


SELECT CHARINDEX('CT', 'CHARACTER');  -- CT'nin ilk indexini geirir

------ PATINDEX(%pattern%, input string) -----

-- PATINDEX(), belirtilen bir ifadede bir kalıbın ilk oluşumunun başlangıç ​​konumunu 
-- veya kalıp bulunamazsa tüm geçerli metin ve karakter veri türlerinde sıfırları döndürür.
-- Desen veya ifadeden biri ise NULL, PATINDEX()NULL döndürür.
-- PATINDEX() Başlangıç ​​pozisyonu 1'dir.
-- PATINDEX aynı LIKE şekilde çalışır , böylece herhangi bir joker karakter kullanabilirsiniz. 
-- Deseni  % (yüzde) ler arasına almak zorunda değilsiniz. 
-- PATINDEX(), LIKE'dan farklı olarak, CHARINDEX()'in yaptığına benzer bir konum döndürür.

SELECT PATINDEX ('%R','CHARACTER');  -- Sondaki R den onceki karakterleri al

SELECT PATINDEX ('R%','CHARACTER');   -- R den sonraki karakterleri getir

SELECT PATINDEX ('___R%','CHARACTER');  


----- LEFT / RIGHT / SUBSTRING

-- SUBSTRING(string, start_postion, [length])işlevi, bir dizeden bir alt dize çıkarmanızı sağlar. Dönüş değeri metindir.

-- LEFT(string, number of characters): Belirtilen sayıda karaktere sahip bir karakter dizesinin sol kısmını döndürür.

-- RIGHT(string, number of characters): Belirtilen sayıda karaktere sahip bir karakter dizisinin sağ kısmını döndürür. 


SELECT LEFT ('CHARACTER', 3);  -- Soldan 3 karakter alir

SELECT LEFT (' CHARACTER', 3);

SELECT RIGHT ('CHARACTER', 3);  -- Sagdan 3 karakter alir

SELECT RIGHT ('CHARACTER ', 3);  -- Sagdan 3 karakter alir

---
SELECT SUBSTRING ('CHARACTER', 3, 5);  -- 3. karakterden baslayip 5 karakter alir

SELECT SUBSTRING ('CHARACTER', -1, 5);  -- -1' den itibaren 5 karakter getiriyor -1 0 1 2 3 : CHA dondurur. Pythondaki gibi tersten saymaz.

SELECT UPPER (SUBSTRING('clarusway.com', 0 , CHARINDEX('.','clarusway.com'))); 

---- LOWER / UPPER / SPRING_SPLIT

-- UPPER()işlevi, tüm küçük harfli ASCII karakterlerinin büyük harf eşdeğerine dönüştürüldüğü bir dizenin bir kopyasını döndürür. 

-- LOWER()işlevi, tüm büyük harfli ASCII karakterlerinin küçük harf eşdeğerine dönüştürüldüğü bir dizenin bir kopyasını döndürür. 

-- UPPER()ve LOWER()işlevler, boş bir değer iletirseniz boş değerler döndürür. 
-- UPPER() veya LOWER() öğesine sayısal değerler iletirseniz, her ikisi de tam sayısal değeri döndürür.

SELECT LOWER ('CHARACTER');  -- tum karakterleri kucuk yapar

SELECT UPPER ('character');   -- tum karakterleri buyuk yapar

SELECT  UPPER (LEFT('character', 1)) + LOWER (RIGHT('character', 8));  -- Ilk harfi buyuk yaptik

SELECT replace('clarusway','c','C');

SELECT UPPER(LEFT('character',1)) + LOWER(RIGHT('character',LEN ('character')-1));

SELECT UPPER(Substring('character',1,1))+Substring('character',2,8);

------ STRING_SPLIT(string, seperator)

-- STRING_SPLIT(), belirtilen bir ayırıcı karaktere dayalı olarak bir dizeyi alt dizelerin satırlarına bölen tablo değerli bir işlevdir.

SELECT * FROM STRING_SPLIT ('John, Jeremy, Jack, George', ',');


----- TRIM(), LTRIM(), RTRIM()----

-- TRIM()işlevi, belirtilen karakterleri dizenin her iki ucundan kaldırır.

/*Trim ile iki uctan istemedigimiz karakterleri atariz. Defaultu bosluktur.
Ortadaki karakterleri yoketmek için replace kullanmamız lazim. 
Trim'i başında ve sonundakiler için kullanabiliyoruz */

--TRIM()işlevi, belirtilen baştaki ve sondaki karakterler kaldırılmış olarak yeni bir dize döndürür. Orijinal dizeyi değiştirmez.


SELECT TRIM(' CHARACTER');

SELECT TRIM(' CHARACTER ');

SELECT TRIM(' CHAR ACTER ');

SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString; 

SELECT RTRIM(' CHARACTER ');  -- Sagdaki boslugu atti

SELECT LTRIM(' CHARACTER ');  -- Soldaki boslugu atti

----  REPLACE & STR ----

-- REPLACE(string expression, string pattern, string replacement) , belirtilen bir dizenin tüm oluşumlarını başka bir dizeyle değiştirmenize olanak tanır. 

-- REPLACE()işlevi, bir tablodaki karakter verilerini güncellemek için kullanışlıdır, 
-- örneğin, ölü bağlantıları ve yazım hatalarını güncellemek icin.

SELECT REPLACE('CHARACTER STRING', ' ', '/');  -- Boslugu / ile degistirdi

SELECT STR(5454);  -- 10dan kucuk karakter girersek, boslukla 10 tamamlar

SELECT STR(5454, 10, 6); 

SELECT STR(133215.654645, 11, 3);  -- Noktanin saginda 3 karakter kalacak sekilde 11 karakter alir. 11 karakter yoksa basini boslikla doldurur.

---- CAST/ CONVERT/ COALESCE/ NULLIF/ ROUND

-- CAST() ve CONVERT() İşlevleri, bir veri türünün ifadesini diğerine dönüştürür.

-- CAST Syntax:  
-- CAST ( expression AS data_type [ ( length ) ] )  
  
-- CONVERT Syntax:  
-- CONVERT ( data_type [ ( length ) ] , expression [ , style ] )​
​
SELECT CAST (456123 AS CHAR)  -- Int'i str yaptik
​
SELECT CAST (456.123 AS INT)  -- Float'i INT yaptik

SELECT 'customer' + '_' + CAST(1 AS VARCHAR(1)) AS col

SELECT CAST(4599.999999 AS numeric(5,1)) AS col


-- Convert' te değiştireceğiniz formatı/style' ı belirtebiliyorsunuz. tarihte olduğu gibi.​
​
SELECT CONVERT (INT , 30.60)  -- Floati INT yaptik
​
SELECT CONVERT (VARCHAR(10), '2020-10-10')  -- Date'i Str yaptik
​
SELECT GETDATE() AS current_time, CONVERT(DATE, GETDATE()) AS current_date​

SELECT GETDATE() AS current_time, CONVERT(NVARCHAR, GETDATE(), 11)AS current_date


---- COALESCE(expression [, ...n]) ---- 

-- Argümanları sırayla değerlendirir ve başlangıçta NULL olarak değerlendirilmeyen ilk ifadenin geçerli değerini döndürür.
​
SELECT COALESCE (NULL, NULL ,'Hi', 'Hello', NULL) result;  -- Ilk non null degeri getirir

-- CASE ifadesi , COALESCE için sözdizimsel bir kısayoldur .

CASE
WHEN (expression1 IS NOT NULL) then expression1
WHEN (expression2 IS NOT NULL) then expression2
...
ELSE expressionN
END

SELECT COALESCE(Null, Null, 1, 3) AS col;

SELECT COALESCE(Null, Null, 'William', Null) AS col;
​
---- ISNULL, NULLIF ----

-- ISNULL(check expression, replacement value)​: Belirtilen DEGERI,  NULLdeğeriyle değiştirir.

-- Boş değerleri belirli bir değerle doldurmak istiyorsanız ISNULL()işlevi kullanabilirsiniz.

SELECT ISNULL(NULL, 'Not null yet.') AS col;

SELECT ISNULL(1, 2) AS col;  -- Tablo değerleri üzerinde çalışıyorsanız, yukarıdaki sorguda "1" ve "2" yerine sütun adları yazabilirsiniz.


-- NULLIF(expression, expression) : Belirtilen iki ifade eşitse boş bir değer döndürür.

SELECT NULLIF (10,10)  -- Belirtilen iki ifade eşitse boş bir değer döndürür.

SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different;

SELECT NULLIF('2021-01-01', '2021-01-01') AS col
​
SELECT NULLIF('Hello', 'Hi') result;  -- Degilse ilk degeri dondurur

---- ROUND (0: yakin oalna yuvarlar, 1: alta yovarlar. Defaultu 0 dir)

-- İşlev atlandığında veya 0 (varsayılan) değerine sahip olduğunda, sayısal_ifade yuvarlanır.
-- 0 dışında bir değer belirtildiğinde, sayısal_ifade kesilir.

SELECT ROUND (432.368, 2, 0)  -- Noktadan sonra 2 rakam al yakina yuvarla (Noktadan sonraki rakam sayisi ayni kalir)
​
SELECT ROUND (432.368, 1, 0)  
​
SELECT ROUND (432.368, 2, 1)
​
SELECT ROUND (432.368, 2)

SELECT ROUND(565.49, -1) AS col;

SELECT ROUND(565.49, 0) AS col;

SELECT ROUND(565.49, -2) AS col;

SELECT ROUND(123.9994, 3) AS col1, ROUND(123.9995, 3) AS col2;

SELECT ROUND(123.4545, 2) col1, ROUND(123.45, -2) AS col2;

SELECT ROUND(150.75, 0) AS col1, ROUND(150.75, 0, 1) AS col2;

---- CONCAT() ----

-- CONCAT() iki dizeyi tek bir dizede birleştirme işlevini sağlar. 
-- Ayrıca, bitiştirme operatörü (+) iki dizgiyi tek bir dizgede birleştirmek için kullanılır. 
-- (+) operatörünü birden çok kez kullanarak ikiden fazla dizgiyi birleştirmek de mümkündür .

SELECT 'Way' + ' to ' + 'Reinvent ' + 'Yourself' AS motto;

SELECT CONCAT ('Robert' , ' ', 'Gilmore') AS full_name


---- ISNUMERIC(expression) ----
-- Bir ifadenin geçerli bir sayısal tür olup olmadığını belirler.

-- Girdi ifadesi geçerli bir sayısal veri türü olarak değerlendirildiğinde 1 döndürür ; 
--aksi halde 0 döndürür . Geçerli sayısal veri türleri şunlardır: bigint, int, smallint, tinyint, bit, decimal, numeric, 
-- float, real, money, smallmoney .


---------------------------------------------------------

SELECT UPPER (SUBSTRING('clarusway.com', 0 , CHARINDEX('.','clarusway.com')));

SELECT TRIM(' 789Sun is shining789');

SELECT COALESCE(NULLIF(ISNUMERIC(STR(12255.212, 7)), 1), 9999);