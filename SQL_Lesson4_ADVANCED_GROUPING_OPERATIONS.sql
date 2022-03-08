---- ADVANCED GROUPING OPERATIONS ----

/* 
Yazim Sirasi:

  SELECT			|
  FROM + JOIN		|
  WHERE				|
  GROUP BY			|
  HAVING			|
  ORDER BY			|
  LIMIT			   \|/

Calisma sirasi :

  FROM + JOIN		|
  WHERE				|
  GROUP BY			|
  HAVING			|
  SELECT			|
  ORDER BY			|
  LIMIT			   \|/
  
 */

---- HAVING ----
-- HAVING yan tümcesi, gruplama ve toplama işlemi sonucunda oluşturulacak yeni sütun üzerinde filtreleme yapmak için kullanılır.
-- Kullanım amacına çok benzer WHERE. Her ikisi de sonuçları filtrelemek için kullanılır. 
-- Ancak kullanım HAVING ve WHERE kullanım nedenleri açısından birbirinden farklılık gösterir.
-- WHEREtablolardan okunan satırları filtreleyerek, sorgu yürütmesinin daha önceki bir aşamasında dikkate alınır. 
-- WHERE kullanılarak filtrelenen satırlar üzerinden gruplanacak alanlar belirlenir ve toplama işlemi ile yeni bir alan oluşturulur. 
-- Ardından HAVING, aynı sorgu içinde yeni oluşturulan alanı filtrelemek istiyorsanız kullanılır.
-- HAVING ve WHERE yan tümceler aynı sorguda olabilir.

-- HAVING toplu veriler içindir,  WHERE ise toplu olmayan veriler içindir. 
-- WHERE Cümle, birleştirmeden önceki veriler üzerinde, HAVING ise birleştirmeden sonraki veriler üzerinde çalışır.

-- HAVING yan tümcesi, grupları belirli bir koşula göre filtreler. 
-- HAVING Cümlesini GROUP BY ile kullanmanız gerekir . Aksi takdirde hata alırsınız. 
-- HAVING cumlesi GROUP BY dan sonra uygulanır . 
-- Ayrıca, çıktıyı sıralamak istiyorsanız, HAVING yan tümceden sonra ORDER BY yan tümceyi kullanmalısınız. 


-- Syntax:

SELECT column_1, aggregate_function(column_2)  -- aggregate_functions: sum, min, max, avg, count
FROM table_name
GROUP BY column_1
HAVING search_condition;

---- GROUP BY ----
-- GROUP BY yan tümcesi, satırları özet satırlar veya gruplar halinde gruplandırır. 


SELECT dept_name, AVG(salary) AS avg_salary
FROM department
GROUP BY dept_name;

SELECT dept_name, AVG(salary) AS avg_salary
FROM department
GROUP BY dept_name
HAVING avg_salary > 50000;

-----------------------------------------------------------------------------------------------------
-- Write a query that checks if any product id is repeated in more than one row in the product table.

SELECT *
FROM product.product;

SELECT product_id, COUNT(product_id) num_of_rows
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1;

-- Write aquery that returns category ids with max list price above 4000 or a min list price below 500. 


SELECT category_id, list_price
FROM product.product
ORDER BY category_id, list_price;

SELECT
    category_id, 
    MAX(list_price) max_price,
    MIN(list_price) min_price
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500;


--Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.
--Markalara ait ortalama ürün fiyatlarını bulunuz.
--ortalama fiyatlara göre azalan sırayla gösteriniz.

SELECT B.brand_name, B.brand_id, A.list_price
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
ORDER BY B.brand_name


SELECT B.brand_name,B.brand_id,AVG(list_price) avg_list_price
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
GROUP BY B.brand_name, B.brand_id
ORDER BY avg_list_price DESC

---
SELECT B.brand_name, AVG(A.list_price) avg_list_price
FROM product.product A
JOIN product.brand B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
ORDER BY avg_list_price DESC;


--Write a query that returns BRANDS with an average product price of more than 1000.

SELECT B.brand_name, AVG(A.list_price) avg_list_price
FROM product.product A
JOIN product.brand B
ON A.brand_id = B.brand_id
GROUP BY B.brand_name
HAVING AVG(list_price) > 1000
ORDER BY avg_list_price;


----- HOMEWORK

--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)

--Bir siparişin toplam net tutarını getiriniz. (müşterinin sipariş için ödediği tutar)
--discount'ı ve quantity' yi ihmal etmeyiniz.
-- quantity * list_price * (1-discount)  ---NET PRICE



---- GROUPING SETS & PIVOT & ROLLUP & CUBE ----

-- Bir kac kolon uzerinden grup  yapmaya yararlar
-- Bu yöntemler daha çok periyodik raporlamada kullanılmaktadır. 
-- Tek bir sorgu sonucunda verilerin farklı kırılımlarının elde edilmesini sağlarlar. 
-- Tek bir sorguda farklı gruplama seçenekleri döndürülerek zaman ve kaynak tasarrufu sağlanır.
-- Ayrıca karar vericilerin rapor edilen analizleri farklı yönlerden tek bakışta değerlendirmesini sağlar.

-- GROUPING SETS operatörü, toplama işlemlerinde gruplandırılmış sütun gruplarını ifade eder.

SELECT
    column1,
    column2,
    aggregate_function (column3)
FROM
    table_name
GROUP BY
    GROUPING SETS (
        (column1, column2),  -- 1 ve 2 ye gore grupla
        (column1),			 -- 1 e gore grupla
        (column2),			 -- 2 ye gore grupla
        ()					 -- butun tabloya gore islem yap
);

SELECT
    seniority,
    graduation,
    AVG(Salary)
FROM
    departments
GROUP BY
    GROUPING SETS (
        (seniority, graduation),
        (graduation)

--------------------------------------------------
-- Yeni tablo olusturalim

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


--- GROUPING SETS

--- GROUPING SETS

SELECT * 
FROM sale.sales_summary


-- 1. Calculate the total sales price.

SELECT SUM(total_sales_price)
FROM sale.sales_summary


-- 2. Calculate the total sales price of the brands

SELECT Brand, SUM(total_sales_price) total
FROM sale.sales_summary
GROUP BY Brand

-- 3. Calculate the total sales price of the categories

SELECT * 
FROM sale.sales_summary


SELECT Category, SUM(total_sales_price) total
FROM sale.sales_summary
GROUP BY Category



-- 4. Calculate the total sales price by brands and categories.

SELECT  Brand, Category ,SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY Brand, Category


-- GROUPING SET ile yukardaki 4 kodu birlestirme

SELECT Brand, Category, SUM(total_sales_price) TOTAL
FROM sale.sales_summary
GROUP BY 
	GROUPING SETS(
	
	(Brand),
	(Category),
	(Brand, Category),
	()
)
ORDER BY Brand, Category



-- PIVOToperatör, raporlama işlemlerinde pivot tablodaki satırların alanlara dönüştürülmesine izin verir. 
-- Gruplandırmaya dahil edilen her sütun için toplama işlemi tekrarlanır ve ayrı bir alan oluşturulur.

SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM 
table_name
PIVOT 
(
 aggregate_function(aggregate_column)
 FOR pivot_column
 IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;

SELECT [seniority], [BSc], [MSc], [PhD]
FROM 
(
SELECT seniority, graduation, salary
FROM   departments
) AS SourceTable
PIVOT 
(
 avg(salary)
 FOR graduation
 IN ([BSc], [MSc], [PhD])
) AS pivot_table;


---------- ROLLUP ---------

-- ROLLUP operatörü, her sütun ifadesi kombinasyonu için bir grup oluşturur. 
-- Sağdan sola sıralı olarak parantez içinde yazılan sütun adlarından birer birer çıkararak gruplama kombinasyonları yapar. 
-- Bu nedenle, sütunların yazıldığı sıra önemlidir.
-- Her sutunun gruplarini kartezyen carpimi yapip sonuclarina aggregasyonu uyguluyor  

SELECT
    d1,
    d2,
    d3,
    aggregate_function(c4)
FROM
    table_name
GROUP BY
    ROLLUP (d1, d2, d3);

-------------------------------------------

----- HOMEWORK

--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
-- Calculate sum total_sales_price
--brand, category, model_year sütunları için Rollup kullanarak total sales hesaplaması yapın.
--üç sütun için 4 farklı gruplama varyasyonu üretiyor




-- CUBE operatörü, seçme operatöründe belirtilen tüm alanlar için tüm olası gruplama kombinasyonlarını yapar. 
-- Sütunların yazıldığı sıra önemli değildir.

SELECT
    d1,
    d2,
    d3,
    aggregate_function (c4)
FROM
    table_name
GROUP BY
    CUBE (d1, d2, d3);