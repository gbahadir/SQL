--List the products ordered the last 10 orders in Buffalo city.
-- Buffalo şehrinde son 10 siparişte sipariş verilen ürünleri listeleyin.

SELECT	B.product_id, B.product_name, A.order_id
FROM	sale.order_item A, product.product B
WHERE	A.product_id = B.product_id
AND		A.order_id IN (
						SELECT	TOP 10 order_id
						FROM	sale.customer A, sale.orders B
						WHERE	A.customer_id = B.customer_id
						AND		A.city = 'Buffalo'
						ORDER BY order_id desc
						)
order by 3
----
SELECT TOP 10 *
FROM sale.customer, sale.orders, sale.order_item, product.product
WHERE sale.customer.customer_id = sale.orders.customer_id
AND sale.orders.order_id = sale.order_item.order_id
AND sale.order_item.product_id= product.product.product_id
AND city = 'Buffalo'
ORDER BY order_date DESC

----
SELECT A.product_id,B.product_name
FROM product.product B,sale.order_item A
WHERE A.product_id=B.product_id
		AND A.order_id in(
							SELECT TOP 10 B.order_id
							FROM sale.customer A,sale.orders B
							WHERE A.customer_id=B.customer_id AND A.city='Buffalo'
							order by order_date DESC)

--Müşterilerin sipariş sayılarını, sipariş ettikleri ürün sayılarını ve ürünlere ödedikleri toplam net miktarı raporlayınız.

SELECT	A.customer_id, A.first_name, A.last_name, c.*, b.product_id, B.quantity, b.list_price, b.discount, quantity*list_price*(1-discount)
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
AND A.customer_id = 1


SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  A.customer_id, A.first_name, A.last_name

----
SELECT A.customer_id, A.first_name, A.last_name,
COUNT(DISTINCT B.order_id) Order_Quant, --- BURADA DISTINCT ONEMLI. TEKRAR EDEN ORDER ID OLUYOR ITEM ID NEDENIYLE.
SUM(C.quantity) Total_Quant,
SUM(C.quantity*C.list_price*(1-C.discount)) Net_Paid
FROM sale.customer A
LEFT JOIN sale.orders B
ON A.customer_id = B.customer_id
LEFT JOIN sale.order_item C
ON C.order_id = B.order_id
GROUP BY A.customer_id, A.first_name, A.last_name
ORDER BY A.customer_id

-- Hic siparis vermemis musterilerde rapora dahil olsun

SELECT 
    C.customer_id,
    C.first_name,
    C.last_name, 
    COUNT(DISTINCT O.order_id) orders,
    SUM(I.quantity) total_products,
    SUM(I.quantity*list_price*(1-discount)) net_amount
FROM sale.customer C
LEFT JOIN sale.orders O
ON O.customer_id = C.customer_id
LEFT JOIN sale.order_item I
ON O.order_id = I.order_id
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY 1;

----
SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(C.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A
		LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
		LEFT JOIN sale.order_item C ON B.order_id = C.order_id
GROUP BY  A.customer_id, A.first_name, A.last_name
ORDER BY 1 DESC

--- Null'lari 0 ile dolduralim
SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		ISNULL(SUM(C.quantity),0) cnt_product,
		ISNULL(SUM(quantity*list_price*(1-discount)),0) net_amount
FROM	sale.customer A
		LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
		LEFT JOIN sale.order_item C ON B.order_id = C.order_id
GROUP BY  A.customer_id, A.first_name, A.last_name
ORDER BY 1 DESC

-- Şehirlerde verilen sipariş sayılarını, sipariş edilen ürün sayılarını 
-- ve ürünlere ödenen toplam net miktarları raporlayınız.

SELECT 
    C.city,
    COUNT(DISTINCT O.order_id) orders,
    SUM(I.quantity) total_products,
    SUM(I.quantity*list_price*(1-discount)) net_amount
FROM sale.customer C
JOIN sale.orders O
ON O.customer_id = C.customer_id
JOIN sale.order_item I
ON O.order_id = I.order_id
GROUP BY C.city
ORDER BY 1;

SELECT	A.city,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  A.city
ORDER BY 1;

--Eyaletlerde verilen sipariş sayılarını, sipariş edilen ürün sayılarını ve ürünlere ödenen toplam net miktarları raporlayınız.

SELECT	a.state,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  a.state
order by 1

-- State ortalamasının altında ortalama ciroya sahip şehirleri listeleyin.

WITH T1 AS
(
SELECT	DISTINCT A.state, A.city,
		AVG(quantity*list_price*(1-discount)) OVER (PARTITION BY A.state) avg_turnover_ofstate,
		AVG(quantity*list_price*(1-discount)) OVER (PARTITION BY A.state, A.city) avg_turnover_ofcity
FROM	sale.customer A, sale.orders B, sale.order_item C
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
)
SELECT *
FROM T1
WHERE	avg_turnover_ofcity < avg_turnover_ofstate

--Create a report shows daywise turnovers of the BFLO Store.
--BFLO Store Mağazasının haftanın günlerine göre elde ettiği ciro miktarını gösteren bir rapor hazırlayınız.

WITH bflo
AS (
SELECT S.store_name, DATENAME(WEEKDAY,O.order_date) week_day, I.list_price, I.quantity, I.discount
FROM sale.store S, sale.orders O, sale.order_item I 
WHERE O.store_id = S.store_id
AND O.order_id = I.order_id
AND S.store_name = 'The BFLO Store')

SELECT week_day, SUM(list_price*quantity*(1-discount)) net_amount
FROM bflo
GROUP BY week_day
ORDER BY 2 DESC;

----

SELECT DATENAME(weekday, order_date) [days] ,SUM(quantity*list_price*(1-discount)) net_amount
		FROM sale.store A,sale.order_item B, sale.orders C
		WHERE  A.store_id = C.store_id
		AND     B.order_id = C.order_id and store_name='The BFLO Store'
		GROUP BY DATENAME(weekday, order_date);

----

SELECT *
FROM (
		SELECT DATENAME(weekday, order_date) [days] ,SUM(quantity*list_price*(1-discount)) net_amount
		FROM sale.store A,sale.order_item B, sale.orders C
		WHERE  A.store_id = C.store_id
		AND     B.order_id = C.order_id and store_name='The BFLO Store'
		GROUP BY DATENAME(weekday, order_date)
) BFL
PIVOT
(SUM(net_amount)
for  [days] in 
([Friday],[Monday],[Saturday],[Sunday],[Thursday],[Tuesday],[Wednesday]) 
)as pivottable

----

SELECT *
FROM
(
SELECT	DATENAME(WEEKDAY, order_date) dayofweek_, quantity*list_price*(1-discount) net_amount, datepart(ISOWW, order_date) WEEKOFYEAR
FROM	sale.store A, sale.orders B, sale.order_item C
WHERE	A.store_name = 'The BFLO Store'
AND		A.store_id = B.store_id
AND		B.order_id = C.order_id
AND		YEAR(B.order_date) = 2018
) A
PIVOT
(
SUM (net_amount)
FOR dayofweek_
IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday] )
) AS PIVOT_TABLE

--Write a query that returns how many days are between the third and fourth order dates of each staff.
--Her bir personelin üçüncü ve dördüncü siparişleri arasındaki gün farkını bulunuz.

WITH T1 AS
(
SELECT staff_id, order_date, order_id,
		LEAD(order_date) OVER (PARTITION BY staff_id ORDER BY order_id) next_ord_date,
		ROW_NUMBER () OVER (PARTITION BY staff_id ORDER BY order_id) row_num
FROM sale.orders
)
SELECT *, DATEDIFF(DAY, order_date, next_ord_date) DIFF_OFDATE
FROM T1
WHERE row_num = 3


--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasında satılan ürün sayısının 7 günlük hareketli ortalamasını hesaplayın.






