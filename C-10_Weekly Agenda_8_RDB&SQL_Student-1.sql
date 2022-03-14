---- C-10 WEEKLY AGENDA-8 RD&SQL STUDENT

---- 1. List all the cities in the Texas and the numbers of customers in each city.----
SELECT city, COUNT(customer_id) number_of_customers
FROM sale.customer
WHERE state = 'TX'
GROUP BY city;

---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---
SELECT city, COUNT(customer_id) AS number_of_customers
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 5
ORDER BY number_of_customers DESC;

---- 3. List the top 10 most expensive products----
SELECT TOP 10 product_name, list_price
FROM product.product
ORDER BY list_price DESC;


---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----
SELECT 
    S.store_id,
    P.product_name,
    P.list_price,
    S.quantity
FROM product.stock AS S
JOIN product.product AS P
ON S.product_id = P.product_id
WHERE store_id = 2 AND list_price > 25
ORDER BY list_price DESC;
--Alternative
SELECT B.store_id, A.product_name, A.list_price, B.quantity
FROM product.product AS A, product.stock AS B
WHERE A.product_id = B.product_id
      AND B.store_id = 2
      AND B.quantity > 25
ORDER BY A.product_name;

---- 5. Find the sales order of the customers who lives in Boulder order by order date ----
SELECT 
    O.order_id,
    C.first_name,
    C.last_name,
    O.order_date
FROM sale.customer C
JOIN sale.orders O
ON C.customer_id = O.customer_id
WHERE city = 'Boulder'
ORDER BY order_date;

---- 6. Get the sales by staffs and years using the AVG() aggregate function.
SELECT 
    S.first_name,
    S.last_name,
    YEAR(O.order_date) AS [Year],
    AVG(quantity*(list_price * (1-discount))) AS Avg_Orders
FROM sale.orders O
JOIN sale.staff S
ON O.staff_id = S.staff_id
JOIN sale.order_item I 
ON O.order_id = I.order_id
GROUP BY S.first_name, S.last_name,YEAR(O.order_date);


---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----
SELECT B.brand_name, SUM(I.quantity) Quantity
FROM sale.order_item I
JOIN product.product P
ON I.product_id = P.product_id
JOIN product.brand B
ON B.brand_id = P.brand_id 
GROUP BY B.brand_name
ORDER BY Quantity DESC;

---- 8. What are the categories that each brand has? ----
SELECT DISTINCT B.brand_name, C.category_name
FROM product.product P 
JOIN product.brand B 
ON P.brand_id = B.brand_id
JOIN product.category C 
ON P.category_id = C.category_id
ORDER BY B.brand_name;

---- 9. Select the avg prices according to brands and categories ----

SELECT B.brand_name, C.category_name, AVG(P.list_price) AVG_Prices
FROM product.product P
JOIN product.category C
ON P.category_id = C.category_id
JOIN product.brand B 
ON P.brand_id = B.brand_id
GROUP BY B.brand_name, C.category_name
ORDER BY B.brand_name;

---- 10. Select the annual amount of product produced according to brands----
SELECT 
    B.brand_name,
    P.model_year,
    SUM(S.quantity+I.quantity) Total_Production
FROM product.product P 
JOIN product.stock S
ON P.product_id = S.product_id
JOIN sale.order_item I 
ON P.product_id = S.product_id
JOIN product.brand B 
ON P.brand_id = B.brand_id
GROUP BY B.brand_name, P.model_year
ORDER BY B.brand_name, model_year;

---- 11. Select the store which has the most sales quantity in 2016.----
SELECT TOP  (1) A.store_name, SUM(C.quantity) AS [store most sales]
FROM sale.store A, sale.orders B, sale.order_item C
WHERE A.store_id = B.store_id
AND B.order_id = C.order_id
AND YEAR(B.order_date) = '2020'
GROUP BY A.store_name
ORDER BY SUM(C.quantity) DESC;

---- 12 Select the store which has the most sales amount in 2018.----
SELECT TOP(1) A.store_name, SUM(C.list_price) AS [store sales]
FROM sale.store A, sale.orders B, sale.order_item C
WHERE A.store_id = B.store_id
AND B.order_id = C.order_id
AND YEAR(B.order_date) = '2018'
GROUP BY A.store_name
ORDER BY SUM(C.quantity) DESC;

---- 13. Select the personnel which has the most sales amount in 2019.----
SELECT TOP(1) A.first_name, A.last_name, SUM(C.list_price) AS [staff sales]
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id
AND B.order_id = C.order_id
AND YEAR(B.order_date) = 2019
GROUP BY A.first_name, A.last_name
ORDER BY SUM(C.quantity) DESC;
