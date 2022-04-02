---------------------------------------------------------------------------------------------------------

-----  SET OPERATORS -----

----------------------------------------------------------------------------------------------------------

/* Küme işlemleri, birden çok sorgunun sonuçlarının tek bir sonuç kümesinde birleştirilmesine olanak tanır. 
Küme operatörleri UNION , INTERSECT ve EXCEPT'i içerir .

UNION set operatörü , iki SELECT ifadesinin birleştirilmiş sonuçlarını döndürür . 
Secilen Tablolari alt alta ekler. Sutun sayisi ve data tipleri ayni olmalidir
Esasen, sonuçlardan yinelenenleri kaldırır, yani yinelenen her sonuç için yalnızca bir satır listelenir. 
Bu davranışa karşı koymak için , nihai sonuçta kopyaları tutan UNION ALL set operatörünü kullanın. 
UNION ALL, birlesimde ayni olan satirlari silmeden ekler ve duplike satir olusur.

INTERSECT , yalnızca her iki SELECT sorgusu için ortak olan kayıtları listeler; EXCEPT set operatörü , 
ilk sorgunun sonuçlarında da bulunurlarsa, ikinci sorgunun sonuçlarını çıktıdan kaldırır. 
INTERSECT ve EXCEPT küme işlemleri yinelenmemiş sonuçlar üretir. 

Önemli: 
Her iki SELECT ifadesi de aynı sayıda sütun içermelidir.
SELECT ifadelerinde, karşılık gelen sütunlar aynı veri tipine sahip olmalıdır.
Sonuç kümesini sıralamak için konumsal sıralama kullanılmalıdır. Set operatörlerinde bireysel sonuç seti sıralamasına izin verilmez. ORDER BY, sorgunun sonunda bir kez görünebilir.
UNION ve INTERSECT operatörleri değişmelidir, yani sorguların sırası önemli değildir; nihai sonucu değiştirmez.
Performans açısından, UNION ALL, UNION'a kıyasla daha iyi performans gösterir, çünkü kaynaklar yinelenenleri filtrelemek ve sonuç kümesini sıralamak için boşa harcanmaz.
Set operatörleri alt sorguların bir parçası olabilir .*/

---- UNION & UNION ALL -----------------------------------------------------------------------------------

---- UNION ----

/* Bazı durumlarda, iki veya daha fazla tablodaki verileri bir sonuç kümesinde birleştirmeniz gerekebilir. 
Bu işlemi gerçekleştirmek için Union deyimi kullanılır. Birleştirmeniz gereken tablolar, aynı veri tabanında 
veya farklı veritabanlarında benzer veriler içeren tablolar olabilir.

UNION operatörünü, iki veya daha fazla sorgudan gelen satırları tek bir sonuç kümesinde birleştirmek için kullanacaksınız . 
UNION operatörü için temel sözdizimi şöyledir:

SELECT column1, column2, ...
  FROM table_A
UNION
SELECT column1, column2, ...
  FROM table_B 
  */

-- Preclass data employees_A table daki altı satır ve employees_B table tablosundaki altı satır UNION operatörü kullanılarak birleştirilir 
-- ve on satırlık bir tablo elde edilir. 
-- Ancak bazı kayıtlar yinelenen kayıtlar oldukları için çıktı tablosunda tekrarlanmaz.

SELECT emp_id, first_name, last_name, job_title
	FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job_title
	FROM employees_B;

-- List Customer's last names in Charlotte and Aurora

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION ALL 
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';


SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION 
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';


-------------- UNION yerine kullanabiliriz

SELECT DISTINCT last_name
FROM sale.customer
WHERE city='Charlotte' OR city='Aurora'  --- UNION ALL GIBI BUTUN VERILER GELIR

--------------

SELECT DISTINCT last_name
FROM sale.customer
WHERE city IN ('Charlotte', 'Aurora');

---- UNION ALL ----
-- UNION ALL yan tümcesi , iki tabloyu birleştirirken yinelenen kayıtlar dahil tüm kayıtları yazdırmak için kullanılır.

-- UNION ALL operatörünün temel sözdizimi şöyledir:

/*
SELECT column1, column2, ...
  FROM table_A
UNION ALL
SELECT column1, column2, ...
  FROM table_B
  */

-- employees_A tablosundaki altı satır ve employees_B tablosundaki altı satır, 
-- UNION ALL operatörü kullanılarak birleştirilir ve on iki satırlık bir tablo elde edilir. 
-- Ancak, emp_id 49714 ve emp_id 67323'ün çalışan kayıtları mükerrer kayıtlardır.

  SELECT 'Employees A' AS Type, emp_id, first_name, last_name, job_title
  FROM employees_A
UNION ALL
SELECT 'Employees B' AS Type, emp_id, first_name, last_name, job_title
  FROM employees_B;


-- Write a query that returns customers who name is ‘Thomas’ or surname is ‘Thomas’. (Don't use 'OR')

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas';


--------------------
-- UNION, select ile getirdiğimi sonuçtaki aynı değerleri tekrarsız getirdiği için, eğer querymizi bu şekilde;

select brand_id
from product.brand
union
select category_id
from product.category

-- bazı satırları aynı değerler olacak şekilde brand_id ve category_id leri getirecek olursak bakın burda 40 satır değer döndürecek.
-- fakat output ta farklı değerler gelecek şekilde

select brand_name
from product.brand
union
select category_name
from product.category

-- brand_name ve category_name i seçersek, o zaman 56 sonuç geldiğini göreceksiniz. 


------ --Even if the contents of to be unified columns are different, the data type must be the same.

SELECT *
FROM product.brand 
UNION 
SELECT *
FROM product.category

SELECT *
FROM product.brand 
UNION ALL
SELECT *
FROM product.category


--- COLUMN SAYISI FARKLI OLMA DURUMU 


SELECT city, 'CLEAN' AS STREET
FROM sale.store
UNION ALL
SELECT city
FROM sale.store


-----  INTERSECT --------------------------------------------------------------------------------------------------
-- INTERSECT  operatörü, iki sorgunun sonuç kümelerini karşılaştırır ve her iki sorgunun çıktısı olan farklı satırları döndürür.
-- Iki tablonun kesisim kumesini verir.

-- NTERSECT  operatörü için temel sözdizimi şöyledir:

/*SELECT column1, column2, ...
  FROM table_A
INTERSECT
SELECT column1, column2, ...
  FROM table_B
  */

  -- Gördüğünüz gibi sonuç setinde sadece iki çalışanın her iki tablo için ortak olan bilgileri döndürüldü.

  SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
INTERSECT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B
  ORDER BY emp_id;

-- Write a query that returns brands that have products for both 2018 and 2019.
-- Hem 2018 hem de 2019 model ürünleri olan markaları döndüren bir sorgu yazın.

SELECT *
FROM product.brand
WHERE brand_id IN
(
SELECT brand_id
FROM product.product
WHERE model_year = 2018
INTERSECT
SELECT brand_id
FROM product.product
WHERE model_year = 2019
);

-- WHERE clause da hangi alana (column'a) condition getiriyorsak SUBQUERY(ler)in SELECT'inde de aynı alanı getirmek zorundayız. 
-- (elmalarla elmaları kıyaslamak için)

---------

-- Write a query that returns customers who have orders for both 2018, 2019, and 2020

SELECT first_name, last_name
FROM sale.customer
WHERE customer_id IN
(
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31'
)

----- EXCEPT ----------------------------------------------------------------------------------------------------

-- EXCEPT operatörü, iki sorgunun sonuç kümelerini karşılaştırır ve önceki sorgunun sonraki sorgudan farklı olan satırlarını döndürür.
-- A tablosunun B tablosundan farkli olan satirlari getirir

-- EXCEPT operatörü için temel sözdizimi şöyledir:

/*
SELECT column1, column2, ...
  FROM table_A
EXCEPT
SELECT column1, column2, ...
  FROM table_B
  */

  -- Görüldüğü gibi sonuç kümesinde sadece çalışanlar_A tablosunda olan ancak çalışanlar_B tablosunda olmayan çalışanlar döndürüldü.

  SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
EXCEPT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B;

-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.
SELECT *
FROM product.brand
WHERE brand_id IN
(
SELECT brand_id
FROM product.product
WHERE model_year = 2018
EXCEPT
SELECT brand_id
FROM product.product
WHERE model_year = 2019
)

-- Write a query that returns only products ordered in 2019 (not ordered in other years).
-- HOMEWORK

----------------------------------------------------------------------------------------------------------

----- CASE EXPRESSION ------------------------------------------------------------------------------------

-- CASE İfadesi  , bir koşullar listesini değerlendirir ve ilk koşul karşılandığında bir değer döndürür.  
-- CASE İfadesi, diğer programlama dillerindeki IF-THEN-ELSE ifadelerine benzer. 
-- CASE ifadesi, SQL'in if/then mantığını işleme şeklidir. Her  CASE ifade END anahtar kelimesi ile bitmelidir.

-- ELSE kısmı isteğe bağlıdır. ELSE kısmı yoksa ve hiçbir koşul doğru değilse  NULL dondurur. 
-- İki tür  CASE ifade vardır: 

-- Simple CASE expression:
-- Simple CASE expression, sonucu belirlemek için bir ifadeyi bir dizi basit ifadeyle karşılaştırır.

-- Searched CASE expression:
-- Searched CASE expression, sonucu belirlemek için bir dizi Boolean ifadesini değerlendirir.

-- CASE herhangi bir ifade veya cümlede kullanılabilir. Örneğin, CASE'i , SELECT, UPDATE, DELETE ve SET gibi ifadelerde,
-- ve IN, WHERE, ORDER BY ve HAVING gibi tümcelerde kullanabilirsiniz .

-- Simple CASE ifade sözdizimi:
/*
CASE case_expression
  WHEN when_expression_1 THEN result_expression_1
  WHEN when_expression_1 THEN result_expression_1
  ...
  [ ELSE else_result_expression ]
END
*/

-- Basit CASE ifade, case_expression WHEN yan tümcelerdeki ifadelerle karşılaştırır. 
-- Ardından, birden çok olası sonuç ifadesinden birini döndürür. 
-- Hiçbir case_expression while ifadesi ile eşleşmezse, CASE ifadesi  else_result_expression dondurulur.
-- ELSE kısmı dahil edilmemişse, CASE ifadesi  NULL dondurur.

-- ELSE isteğe bağlıdır. Köşeli parantezler arasında gösterilmesinin nedeni budur. Köşeli parantez "isteğe bağlı" anlamına gelir.
-- ELSE'i CASE ifadelerimize  dahil etmek zorunda değiliz .

SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
        ELSE 'others'
    END AS category
FROM departments;


----- SIMPLE CASE EXPRESSION------------------------------------------------------------------------------

-- Generate a new column containing what the mean of the values in the Order_Status column.
-- Order_Status isimli alandaki değerlerin ne anlama geldiğini içeren yeni bir alan oluşturun.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END ORDER_STATUS_DESC
FROM sale.orders



-- Add a column to the sales.staffs table containing the store names of the employees.

SELECT first_name, last_name, store_id,
	CASE store_id
		WHEN 1 THEN 'Davi techno Retail'
		WHEN 2 THEN 'The BFLO Store'
		ELSE 'Burkes Outlet'
	END STORE_NAME  
FROM sale.staff

----- SEARCHED CASE EXPRESSION--------------------------------------------------------------------------

-- The searched CASE expression, sonucu belirlemek için bir dizi ifadeyi değerlendirir. 
-- Simple CASE expression de, yalnızca denklik için karşılaştırılır, oysa aranan  CASE ifade herhangi bir karşılaştırma türünü içerebilir. 
-- Bu tür bir CASE ifadede, anahtar kelimeden hemen sonra herhangi bir CASE ifade belirtmiyoruz.

/*
CASE
  WHEN condition_1 THEN result_1
  WHEN condition_2 THEN result_2
  WHEN condition_N THEN result_N
  [ ELSE result ]
END
*/

SELECT first_name, salary
FROM employees_A 
WHERE 
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END = 'High'
;


-- CASE İfadeyi toplama işlevleriyle kullanmak çoğu zaman sizi uzun sorgulardan kurtarır.

SELECT first_name,
       SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) AS Seniority,
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) AS Graduation
FROM departments
GROUP BY first_name
HAVING SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) > 0
	     AND
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) > 0  
;



-- Generate a new column containing what the mean of the values in the Order_Status column.
-- Order_Status isimli alandaki değerlerin ne anlama geldiğini içeren yeni bir alan oluşturun.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status,
	CASE
		WHEN order_status = 1 THEN 'Pending'
		WHEN order_status = 2 THEN 'Processing'
		WHEN order_status = 3 THEN 'Rejected'
		WHEN order_status = 4 THEN 'Completed'
	END ORDER_STATUS_NEW
FROM sale.orders

-----

SELECT order_id, order_status,
	CASE
		WHEN order_status = 1 THEN 'Pending'
		WHEN order_status = 2 THEN 'Processing'
		WHEN order_status = 3 THEN 'Rejected'
		ELSE 'Completed'
	END ORDER_STATUS_NEW
FROM sale.orders


-- Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT first_name, last_name, email
FROM sale.customer



SELECT first_name, last_name, email,
	CASE
		WHEN email LIKE '%@gmail.%' THEN 'GMAIL'
		WHEN email LIKE '%@hotmail.%' THEN 'HOTMAIL'
		WHEN email LIKE '%@yahoo.%' THEN 'YAHOO'
		WHEN email IS NOT NULL THEN 'OTHER'
		ELSE NULL 
	END EMAIL_SERVICE_PROVIDER
FROM sale.customer;