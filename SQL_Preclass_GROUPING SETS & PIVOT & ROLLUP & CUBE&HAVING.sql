--CREATING AN EXAMPLE_TABLE

CREATE VIEW EXAMPLE_TABLE
AS
SELECT sale.order_item.order_id,
		sale.order_item.item_id,
		sale.order_item.product_id,
		product.brand.brand_name,
		product.product.product_name,
		product.product.model_year,
		sale.order_item.quantity,
		sale.order_item.list_price,
		sale.order_item.discount
FROM sale.order_item
INNER JOIN product.product
ON sale.order_item.product_id = product.product.product_id
INNER JOIN product.brand
ON product.product.brand_id = product.brand.brand_id ;

SELECT * FROM EXAMPLE_TABLE

--Advanced Grouping Operations
/* 1. HAVING CLAUSE
-- HAVING clause is used to filter on the new column that will create as a result of the aggregate operation.
-- Its intended use is very similar to WHERE. Both are used for filtering results 
-- A query can contain both a WHERE clause and a HAVING clause
-- The HAVING clause is applied after the GROUP BY
-- You have to use the HAVING clause with the GROUP BY. Otherwise, you will get an error. 
-- If you want to sort the output, you should use the ORDER BY clause after the HAVING clause.
Important: HAVING is for aggregate data and WHERE is for non-aggregate data. 
	The WHERE clause operates on the data before the aggregation and the HAVING clause operates on the data after the aggregation
*/
 
-- EXAMPLE 1
SELECT brand_name, --GRUPLAYACAĞIMIZ SÜTUNU SEÇTİK
	AVG (list_price) AS avg_list_price --YAPACAĞIMIZ FONKSİYONU BELİRLEDİK
FROM EXAMPLE_TABLE
GROUP BY brand_name
HAVING AVG (list_price) > 1000 --ÇIKAN SONUÇ ÜZERİNDE İSTEDİĞİMİZ KOŞULU BELİRLEDİK
ORDER BY avg_list_price DESC;

-- EXAMPLE 2

SELECT brand_name, 
	AVG (list_price) AS avg_list_price
FROM EXAMPLE_TABLE
WHERE order_id >= 100
GROUP BY brand_name
HAVING AVG (list_price) > 500 --BOSE ORTALAMA FİYAT 528
ORDER BY avg_list_price DESC;

SELECT brand_name, 
	AVG (list_price) AS avg_list_price
FROM EXAMPLE_TABLE
WHERE order_id >= 200 --ORDER ID 200 E ÇIKARDIK
GROUP BY brand_name
HAVING AVG (list_price) > 500 --BOSE ORTALAMA FİYAT 516 A DÜŞTÜ.
ORDER BY avg_list_price DESC;

-- 2.GROUPING SETS
-- EXAMPLE 1

SELECT brand_name, --GRUPLAYACAĞIMIZ SÜTUNU SEÇTİK 
		model_year, --GRUPLAYACAĞIMIZ SÜTUNU SEÇTİK 
		SUM(quantity) as SumOfQuantity --FONKSİYONU BELİRLEDİK
FROM EXAMPLE_TABLE
GROUP BY 
	GROUPING SETS ((brand_name, model_year), --1  --SEÇENEK BELİRLEDİK
					(brand_name), --2 --SEÇENEK BELİRLEDİK
					(model_year)) --3 --SEÇENEK BELİRLEDİK
ORDER BY brand_name;

-- EXAMPLE 2

SELECT brand_name, 
		model_year, 
		AVG(list_price) as AVG_list_price
FROM EXAMPLE_TABLE
GROUP BY 
	GROUPING SETS ((brand_name, model_year),
					(brand_name),
					(model_year)) 
ORDER BY brand_name;

--GROUPBY VS GROUPING SET

SELECT brand_name, AVG(list_price) as AVG_list_price
FROM EXAMPLE_TABLE
GROUP BY brand_name;

SELECT brand_name, model_year, AVG(list_price) as AVG_list_price
FROM EXAMPLE_TABLE
GROUP BY brand_name, model_year
ORDER BY brand_name

SELECT model_year, AVG(list_price) as AVG_list_price
FROM EXAMPLE_TABLE
GROUP BY model_year;

-- 3.PIVOT TABLE

--EXAMPLE 1 :
SELECT brand_name, [2018],[2019],[2021]  -- pivot tablomuzun sütun isimlerini belirledik
FROM 
(SELECT brand_name, model_year, quantity FROM EXAMPLE_TABLE) AS temp_table -- hangi sütunlar lazımsa bu kısımda onu seçtik
PIVOT
(
SUM(quantity) --aggregate fonksiyonu belirledik
FOR model_year 
IN ([2018],[2019],[2021]) --yukarıda belirlediğimiz fonksiyonu FOR ile belirttiğimiz model_year sütunu içindeki
							--IN ile tespit ettiğimiz değerlere uyguladık
) AS pivot_table -- pivot_table olarak gelen tabloyu adlandırdık
ORDER BY brand_name; --brand_name e göre sıraladık

--The result is converted to pivot table format, making it easier to read. 

--EXAMPLE 2 :
SELECT brand_name, [2018],[2019],[2021] 
FROM 
(SELECT brand_name, model_year, list_price FROM EXAMPLE_TABLE) AS temp_table
PIVOT
(AVG(list_price)
FOR model_year 
IN ([2018],[2019],[2021])) AS pivot_table
ORDER BY brand_name;

-- 4. ROLLUP
-- SÜTUN SIRASI ÖNEMLİDİR.
-- GİRDİĞİMİZ SÜTUN SIRASINA GÖRE SADECE AŞAĞIDAKİ ÖRNEK GİBİ LİSTE ÇIKARIR
	--Groups for ROLLUP:
	--S1, S2, S3
	--S1, S2, NULL
	--S1, NULL, NULL
	--NULL, NULL, NULL

-- İLK GİRİLEN SÜTUN TEMELİNDE BİR DEĞERLENDİRME YAPIYOR DİYEBİLİRİZ
--KENDİ SIRALAMASI MEVCUT OLDUĞU İÇİN AYRICA ORDER BY KULLANMADIM

--EXAMPLE 1
SELECT brand_name, --kullanacığımız sütunları seçtik --S1
	model_year, --kullanacığımız sütunları seçtik --S2
	discount,--kullanacığımız sütunları seçtik --S3
	SUM(quantity) --kullanacağımız fonskiyonu seçtik
FROM EXAMPLE_TABLE
GROUP BY
	ROLLUP (brand_name,model_year,discount)

--EXAMPLE 2
SELECT brand_name,
	model_year,
	AVG(list_price)
FROM EXAMPLE_TABLE
GROUP BY
	ROLLUP (brand_name,model_year)

-- 5. CUBE
---- SÜTUN SIRASI ÖNEMLİ DEĞİLDİR
-- GİRDİĞİMİZ SÜTUNLARA GÖRE TÜM KOMBİNASYONLARI SIRALAR.
	--Groups for CUBE:
	--S1, S2, S3
	--S1, S2, NULL
	--S1, S3, NULL
	--S2, S3, NULL
	--S1, NULL, NULL
	--S2, NULL, NULL
	--S3, NULL, NULL
	--NULL, NULL, NULL

--KENDİ SIRALAMASI MEVCUT OLDUĞU İÇİN AYRICA ORDER BY KULLANMADIM

SELECT brand_name, --kullanacığımız sütunları seçtik --S1
	model_year, --kullanacığımız sütunları seçtik --S2
	AVG(list_price) --kullanacağımız fonskiyonu seçtik
FROM EXAMPLE_TABLE
GROUP BY
	CUBE (brand_name,model_year)

--Example 2
SELECT brand_name, --S1
	model_year, --S2
	discount, --S3
	SUM(quantity) 
FROM EXAMPLE_TABLE
GROUP BY
	CUBE (brand_name,model_year,discount)



-- EXAMPLE 3
SELECT order_id, 
	COUNT (quantity) AS samsung_list
FROM EXAMPLE_TABLE
WHERE product_name like 'Samsung%'
GROUP BY order_id
HAVING COUNT (quantity) > 1