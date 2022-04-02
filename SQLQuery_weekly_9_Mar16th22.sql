-- 1. By using view get the average sales by staffs and years using the AVG() aggregate function.

CREATE VIEW staff_AVG_sales AS
SELECT first_name, last_name, year, avg_amount
FROM	(
		select  A.first_name, A.last_name, YEAR(B.order_date) as year, AVG (C.list_price*C.quantity) as avg_amount
		from sale.staff A, sale.orders B, sale.order_item C
		where A.staff_id = B.staff_id AND
			B.order_id = C.order_id
		group by A.first_name, A.last_name, YEAR(B.order_date)
		) A
;

select *
from staff_AVG_sales
order by first_name, last_name


-- 2. Select the annual amount of product produced according to brands (use window functions)

select *
from product.product

select distinct b.brand_name, p.model_year,  
	COUNT (p.product_id) over (partition by b.brand_name, p.model_year order by p.model_year) as annual_countOfProduct
from product.product p, product.brand b
where p.brand_id=b.brand_id


-- 3. Select the least 3 products in stock according to stores

select *
from product.stock

select *
from (
		select s.store_name, p.product_name, 
				SUM(st.quantity) product_quantity,
				ROW_NUMBER() OVER ( PARTITION BY s.store_name ORDER BY SUM(st.quantity) ASC ) least_3
		from sale.store s, product.stock st, product.product p
		where s.store_id=st.store_id 
			and st.product_id = p.product_id
		group by s.store_name, p.product_name
		having SUM(st.quantity) > 0
		) A
WHERE A.least_3 < 4



/* 5. Assign a rank to each product by list price in each brand 
and get products with rank less than or equal to three.*/

select *
from product.product

SELECT *
FROM (
		select  product_id, 
				product_name, 
				brand_id, 
				list_price,
				RANK () OVER ( PARTITION BY brand_id
								ORDER BY list_price DESC
								) product_price_rank
		from product.product
		) A
WHERE product_price_rank <= 3






