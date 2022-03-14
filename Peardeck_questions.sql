
-- RDB&SQL3, Slide40, how many yahoo mails in customer's email column 
SELECT COUNT(email)
FROM sale.customer
WHERE CHARINDEX('yahoo',email) != 0;


-- Slide41, Write a quary return the characters before the '@' in the email column 
SELECT  email, SUBSTRING(  email,0, PATINDEX('%@%', email))
FROM [sale].[customer]

-- Slide42, ADD new column to customers table that contains customers' contact information 
-- if phone is not null, phone will be printed. if null, email will be prinnted 
ALTER TABLE [sale].[customer]
ADD info TEXT

UPDATE [sale].[customer]
SET [info]=phone
WHERE PHONE is not null 

UPDATE [sale].[customer]
SET [info]=email
WHERE PHONE is null 

SELECT  customer_id,
first_name,
last_name,
phone,
email,
info
FROM [sale].[customer]

-- Slide43, write a quary return streets.
-- the 3.char of the street is numerical. 
SELECT [street], SUBSTRING([street],3,1)
FROM [sale].[customer]
WHERE ISNUMERIC (SUBSTRING([street],3,1))=1

-- Slide44, split the values in the column into 2 parts with '@'
SELECT email,
SUBSTRING (email,0, PATINDEX('%@%',email) )  [left_part],
SUBSTRING (email, (PATINDEX('%@%',email)+1) , len(email) )  [right_part]
FROM [sale].[customer]

-- Slide45,
SELECT street, 
SUBSTRING (street,1,1) + SUBSTRING (street,3,len(street)) [new_street]
FROM [sale].[customer]
WHERE SUBSTRING (street,2,1) ='C'

/* CHECK YOURSELF 
List the product names in ascending order 
where the part from the beginning to the first space character is "Samsung" in the product_name column.*/ 

SELECT product_name
FROM product.product
WHERE SUBSTRING (product_name,1, len('Samsung'))='samsung'
ORDER BY product_name ASC


/* CHECK YOURSELF 
Write a query that returns streets in ascending order. 
 The streets have an integer character lower than 5 after the "#" character end of the street. 
 (use sale.customer table) (Use SampleRetail Database and paste your result in the box below.) */
SELECT street 
FROM sale.customer 
WHERE CHARINDEX( '#', street ) =len(street)-1  AND 
RIGHT(street,1) <'5'  
ORDER BY street ASC


/*CHECK YOURSELF 
 Write a query that returns orders of the products branded "Seagate". 
It should be listed Product names and order IDs of all the products ordered or not ordered. 
 (order_id in ascending order)*/
SELECT 
[product].[product].[product_name],
[sale].[order_item].[order_id]
FROM [product].[brand]
LEFT JOIN  [product].[product] on [product].[brand].[brand_id] = [product].[product].[brand_id]
LEFT JOIN [sale].[order_item] on [product].[product].[product_id] = [sale].[order_item].[product_id]
WHERE PATINDEX('%Seagate%', [product].[product].[product_name]) != 0 OR 
PATINDEX('%Seagate%', [product].[brand].[brand_name]) != 0 
ORDER BY order_id ASC

/* CHECK YOURSELF 
Write a query that returns the order date of the product named
"Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black".
(Use SampleRetail Database and paste your result in the box below.) */
SELECT [sale].[orders].[order_date]
FROM [sale].[orders]
LEFT JOIN [sale].[order_item] ON  [sale].[order_item].[order_id] = [sale].[orders].[order_id]
LEFT JOIN [product].[product] on [product].[product].[product_id]= [sale].[order_item].[product_id]
WHERE PATINDEX('Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black',[product_name]) != 0

select A.first_name, 
A.last_name,
B.store_name
FROM sale.staff A 
INNER JOIN sale.store B
on A.store_id = B.store_id


--- ODEV 5 Mart 
-- In the stock table, there all  not all product held on the product table 
-- and you want to insert these product into the stock table 
-- you have to insert all these product for every theree stores with '0' quantity 

/* CHECK YOURSELF 
Write a query that returns the count of orders of each day 
between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.
 Note: The column names should be day names (Sun, Mon, etc.).  */ 

SELECT *
FROM (
    SELECT order_id, DATENAME(WEEKDAY, order_date) date_names
    FROM sale.orders
    WHERE order_date between '2020-01-19' and '2020-01-25'
) as source_table
PIVOT(
    count(order_id)
    FOR    date_names  IN (
         [sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[saturday]
 )
) AS pivot_table;




-- Please write a query to return only the order ids that have an average amount of more than $2000. 
-- Your result set should include order_id. Sort the order_id in ascending order.
SELECT order_id, AVG(quantity * list_price ) Average
FROM sale.order_item
Group by order_id
HAVING AVG (quantity * list_price ) > 2000
ORDER by order_id ASC



/* CHECK YOURSELF 
Detect the store that does not have a product named "Samsung Galaxy Tab S3 Keyboard Cover" in its stock.
(Paste the store name in the box below.) */ 
SELECT store_name
FROM sale.store
where store_id NOT IN ( 
        SELECT store_id 
        FROM product.stock
        WHERE product_id = ( 
            SELECT product_id
            FROM product.product 
            WHERE product_name= 'Samsung Galaxy Tab S3 Keyboard Cover'
        )
)

/* CHECK YOURSELF 
List in ascending order the stores where both "Samsung Galaxy Tab S3 Keyboard Cover"
 and "Apple - Pre-Owned iPad 3 - 64GB - Black" are stocked.*/ 

SELECT store_name
from sale.store
where store_id in (
    SELECT store_id
    FROM product.stock
    where product_id in (
        SELECT product_id
        FROM  product.product 
        WHERE product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
        )
    INTERSECT
    SELECT store_id
    FROM product.stock
    where product_id in (
        SELECT product_id
        FROM  product.product 
        WHERE product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black'
        )
)
ORDER BY store_name asc

/*  CHECK YOURSELF - CASE expression
Classify staff according to the count of orders they receive as follows:

a) 'High-Performance Employee' if the number of orders is greater than 400
b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
c) 'Low-Performance Employee' if the number of orders is between 1 and 100
d) 'No Order' if the number of orders is 0
Then, list the staff's first name, last name, employee class, and count of orders.  
(Count of orders and first names in ascending order) */ 

SELECT first_name, last_name,  
    CASE 
        WHEN count (order_id) >= 400 THEN 'High-Performance Employee'
        WHEN count(order_id) >100 THEN 'Normal-Performance Employee'
        WHEN count(order_id)=0 THEN 'No Order'
        ELSE 'Low-Performance Employee'
    END AS employee_class,
    COUNT(order_id) as order_num

FROM sale.staff s
LEFT JOIN sale.orders o ON s.staff_id = o.staff_id
GROUP BY first_name, last_name
ORDER BY  count(order_id) asc, first_name asc

/* List counts of orders on the weekend and weekdays. 
Submit your answer in a single row with two columns. 
For example: 164 161. First value is for weekend. */ 

SELECT *
FROM (
    SELECT  order_id, 
    CASE 
    WHEN datename(weekday, order_date) in ( 'saturday', 'sunday') THEN  'weekend'
    ELSE 'weekdays' 
    END AS weekday1
    FROM sale.orders
    ) as source_table 

PIVOT (
    COUNT(order_id)
    FOR weekday1 IN  (
        [weekend], [weekdays]
    )
)as p;

/*  CHECK YOURSELF - Subqueries and CTE's
List the store names in ascending order that did not have an order between "2018-07-22" and "2018-07-28".*/

SELECT store_name
FROM sale.store
WHERE store_id NOT IN (
    SELECT store_id
    FROM sale.orders
    WHERE order_date between '2018-07-22' and '2018-07-28'
)

/*List customers with each order over 500$ and reside in the city of Charleston. 
List customers' first name and last name ( both of the last name and first name in ascending order). */


WITH t1 AS (
    SELECT s.customer_id, s.order_id, SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) as total
    FROM sale.order_item i, sale.orders s
    WHERE i.order_id=s.order_id
    GROUP BY s.customer_id, s.order_id
    HAVING SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) >500
),
t2 AS (    
    SELECT s.customer_id, s.order_id, SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) as total
    FROM sale.order_item i, sale.orders s
    WHERE i.order_id=s.order_id
    GROUP BY s.customer_id, s.order_id
    HAVING SUM((i.list_price - (i.list_price * i.discount)) * i.quantity) <500
),
t3 AS ( 
    SELECT customer_id, first_name, last_name, city
    FROM sale.customer
    WHERE city = 'Charleston'
)
SELECT Distinct t3.first_name, t3.last_name
FROM t3 
LEFT JOIN t1 ON t3.customer_id=t1.customer_id
LEFT JOIN t2 ON t3.customer_id=t2.customer_id
WHERE t3.customer_id in (
    SELECT t1.customer_id FROM t1 
    EXCEPT 
    SELECT t2.customer_id FROM t2 
)
ORDER BY 2 ASC, 1 ASC


----------alternative solution ------- 
WITH t1 AS (
    SELECT order_id, SUM((list_price - (list_price * discount)) * quantity) as total
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

