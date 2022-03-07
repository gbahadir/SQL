--------------------------------------------------------------------------------------------------------
------ JOINS --------------

---- INNER JOIN ----
/* INNER JOIN JOIN'lerin en yaygın türüdür. İki veya daha fazla tablodan ortak sütunlardaki değerlere dayalı olarak yeni bir sonuç tablosu oluşturur. 
INNER JOIN yalnızca belirtilen birleştirme koşullarını karşılayan birleştirilmiş satırları içeren bir tablo döndürür. */

-- Bir birleştirme koşulu genellikle aşağıdaki biçimi alır:  table_A.column = table_B.column. 
-- Bu ifadedeki operatör genellikle eşittir işaretidir (=), ancak herhangi bir karşılaştırma operatörü de kullanılabilir.


SELECT columns
  FROM table_A
  INNER JOIN table_B ON join_conditions;


-- INNER JOIN Ayrıca, yan tümce kullanılarak üç veya daha fazla tablo birleştirilebilir. 
-- Üç veya daha fazla tabloyu birleştirmek için kullanılan sözdizimi aşağıdaki gibidir:


SELECT columns
  FROM table_A
  INNER JOIN table_B 
    ON join_conditions1 AND join_conditions2
  INNER JOIN table_C
    ON join_conditions3 OR join_conditions4

-- List products with category names
-- Select product ID, product name, category ID and category names

SELECT 
    A.product_id,
    A.product_name,
    B.category_id,
    B.category_name
FROM product.product A
INNER JOIN product.category B
ON A.category_id = B.category_id;


SELECT 
	A.first_name, 
	A.last_name,
	B.store_name
FROM sale.staff A
INNER JOIN sale.store B ON A.store_id = B.store_id;

--Write a query that returns count of orders of the states by months.

SELECT A.[state], YEAR(B.order_date) YEAR1, MONTH(B.order_date) MONTH1, COUNT (DISTINCT order_id) NUM_COUNT
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
GROUP BY A.[state], YEAR(B.order_date), MONTH(B.order_date);

----
SELECT A.[state], YEAR(B.order_date) YEAR1, MONTH(B.order_date) MONTH1, COUNT (DISTINCT B.order_id) NUM_COUNT
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
GROUP BY A.[state], YEAR(B.order_date), MONTH(B.order_date);

---- 
SELECT c.[state], YEAR(o.order_date) AS my_years, MONTH(o.order_date) AS my_month, COUNT(distinct order_id) my_order_id
FROM  sale.customer AS c
JOIN  sale.orders AS o 
ON c.customer_id = o.customer_id
GROUP BY c.[state], YEAR(o.order_date), MONTH(o.order_date);



---- LEFT JOIN ----

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Use Left Join)

SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B 
ON A.product_id = B.product_id
WHERE order_id IS NULL;

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM product.product A
LEFT JOIN product.stock B 
ON A.product_id = B.product_id
WHERE A.product_id > 310 ;


---- RIGHT JOIN ----

-- Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

SELECT B.product_id, B.product_name, A.*
FROM product.stock A
RIGHT JOIN product.product B 
ON A.product_id = B.product_id
WHERE B.product_id >310;


-- Report the orders information made by all staffs.
-- Expected columns: Staff_id, first_name, last_name, all the information about orders

SELECT 
	B.staff_id, 
	B.first_name, 
	B.last_name, 
	A.*
FROM sale.orders A
RIGHT JOIN sale.staff B 
ON A.staff_id = B.staff_id;


---- FULL OUTER JOIN ----

--Write a query that returns stock and order information together for all products . (TOP 100)
--Expected columns: Product_id, store_id, quantity, order_id, list_price

SELECT  TOP 100 
	A.product_id, 
	B.store_id, 
	B.quantity, 
	C.order_id, 
	C.list_price
FROM product.product A
FULL OUTER JOIN product.stock B 
ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C 
ON A.product_id=C.product_id

--- 

SELECT  TOP 5 
	A.product_id, 
	B.store_id, 
	B.quantity, 
	C.order_id, 
	C.list_price
FROM product.product A
FULL OUTER JOIN product.stock B 
ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C 
ON A.product_id=C.product_id
ORDER BY B.store_id


---- CROSS JOIN ----

/*
In the stocks table, there are not all products held on the product table and you 
want to insert these products into the stock table.

You have to insert all these products for every three stores with "0" quantity.

Write a query to prepare this data.
*/

SELECT product_id, quantity
FROM product.stock;

SELECT B.store_id, A.product_id, 0 QUATITY
FROM product.product A
CROSS JOIN sale.store B
WHERE A.product_id NOT IN (
	SELECT product_id
	FROM product.stock
	)
ORDER BY A.product_id, B.store_id;


---- SELF JOIN ----

--Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name

SELECT *
FROM sale.staff;


SELECT A.first_name, B.first_name MANAGER_NAME
FROM sale.staff A
JOIN sale.staff B 
ON A.manager_id = B.staff_id;

---

SELECT 
	A.first_name AS Staff_Name, 
	A.last_name AS Staff_Last, 
	B.first_name AS Manager
FROM sale.staff A, sale.staff B
WHERE  A.manager_id = B.staff_id;

---

-- Write a query that returns the 1st and 2nd degree managers of all staff


SELECT A.first_name STAFF_NAME, B.first_name MANAGER1_NAME, C.first_name MANAGER2_NAME
FROM sale.staff A
JOIN sale.staff B ON A.manager_id = B.staff_id
JOIN sale.staff C ON B.manager_id = C.staff_id
ORDER BY C.first_name, B.first_name;

/* ALTER TABLE [sale].[staff]  WITH CHECK ADD FOREIGN KEY([manager_id])
REFERENCES [sale].[staff] ([staff_id])
manager_id staff_id ye a refere ediyormus */ 

------------------------------------------------------------------------------------------------------------
---- VIEWS ---- 

-- VIEW Olusturma :

CREATE VIEW CUSTOMER_PRODUCT
AS
SELECT	distinct D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';

SELECT * FROM [dbo].[CUSTOMER_PRODUCT];