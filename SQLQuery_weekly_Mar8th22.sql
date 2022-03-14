/* ====================================================================================================
									WEEKLY AGENDA 8
  =====================================================================================================*/


  /*									DÝKKAT! 
     QUERY YAZMAYA BASLAMADAN ÖNCE DATABASE ÇALISILMALI. DATABASE "ER DIAGRAM" IYICE INCELENMELI
     HANGI TABLOLARIM VAR, TABLOLARIMDA HANGI ALANLARIM (SÜTUNLARIM) VAR, TABLOLARIM HANGI FOREIGN KEYLER
	 ILE BIRBIRINE BAGLANMIS (RELATION KURULMUS) BUNLAR ÖNEMLI! 
	 ÇÜNKÜ SQL DE BIZ RELATIONAL DATABASE'LER ÜZERINDE ÇALISIYORUZ VE ARALARINDAKS ILISKIYI BILMEK
	 SORULARIN ÇÖZÜM YOLUNU BELIRLEMEDE ÇOK ÖNEMLIDIR.*/



/*1. List all the cities in the Texas and the numbers of customers in each city.
	Teksas'taki tüm sehirleri ve her sehirdeki müsteri sayisini listeleyin */

SELECT COUNT(first_name) AS müsteri_sayisi
FROM sale.customer;

SELECT City, COUNT(customer_id) AS müsteri_sayisi  -- alan isimleri, allias isimleri vs. arasinda asla bosluk birakmiyoruz!
FROM sale.customer								
WHERE state = 'TX'  -- tirnak içinde olan ifadeler her zaman case sensitive! onun disindakiler case insensitive
GROUP BY city;     -- GROUP BY yaptigim sütun(lar) SELECT statement'da aynen yer almali!!

/* Alan isimleri, allias isimleri vs. arasinda asla boþluk birakmiyoruz!
SQL derleyici bosluga farkli bir anlam yüklüyor. örnegin bosluktan sonra baska bir keyword bekliyor.
veya alan adi ile allias (AS) yi ayirmak için bosluk kullaniliyor. gibi...

Tirnak içinde olan ifadeler (stringler) her zaman case sensitive! onun disindakiler case insensitive

GROUP BY yaptigim sütun(lar) SELECT statement'da aynen yer almali!! */



SELECT City, COUNT(customer_id) AS müsteri_sayisi
FROM sale.customer
WHERE state = 'TX'
GROUP BY city
ORDER BY müSteri_sayisi DESC;

/* ORDER BY için COUNT(customer_id) kullanabilecegimiz gibi, 
bunun alliasini da kullanabiliriz
veya asagida gösterildigi gibi o sütunun SELECT teki sira numarasini da kullanabiliriz.
  ---> ORDER BY 2 DESC; <-----    */


/* 2. List all the cities in the California which has more than 5 customer, 
	by showing the cities which have more customers first.---
	 Kaliforniya'da 40'tan fazla müsterisi olan tüm sehirleri önce daha fazla müsterisi olan sehirleri göstererek listeleyin.*/

SELECT city, COUNT(customer_id) AS müsteri_sayisi
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 40
ORDER BY müsteri_sayisi;

/* HAVING; GROUP BY ile birlikte kullandýðýmýz AGGREGATE fonksiyonundan gelen sonucu filtreler!! 
Yukaridaki örnekte her sehrin customer sayisi 5'ten büyük olanlari getirir.*/

/* 3. List the top 10 most expensive products
	    En pahali 10 ürünü listeleyin */

SELECT TOP 10 product_name, list_price
FROM product.product
ORDER BY list_price desc;

-- TOP keywordü ile select ten gelecek sonucun ilk kaç recordunu getirecegimizi belirliyoruz.


/* 4. List store_id, product name and list price and the quantity of the products 
	which are located in the store id 2 and the quantity is greater than 25----

	Store_id 2 de bulunan ve sayisi 25 ten fazla olan ürünlerin store_id sini, product_name'ini, list_price'ini 
	ve sayisini listeleyiniz.*/

SELECT S.store_id, P.product_name, P.list_price, S.quantity 
FROM product.product AS P, product.stock AS S
WHERE P.product_id = S.product_id 
	  AND S.store_id = 2
	  AND S.quantity > 25
ORDER BY P.product_name;

/* önce benden istenenlere baktim. Bir takim ürünlerin ismi istenmis. Demek ki product tablosuna gitmeliyim
 sonra store_id ler istenmis. bunun için aklima ilk store tablosu geldi. baktim evet orada store_id var,
 bu tabloyu kullanabilirim dedim. yani product tablosuna bu tabloyu join ederim dedim. 
 Sonra baktim quantity (maðazalardaki ürünlerin sayisi) istenmis. 
 O zaman stock tablosuna da gitmem gerektiðini anladim. Baktim evet orada quantity sütunu var. Bu tabloyu da
 join edecegim dedim. Fakat bir de gördüm ki bu tabloda da store tablosunda da bulunan store_id sütunu varmis. 
 O zaman store tablosundan baþka bir veri getirmeyecegim için, fazla tablo join etmeme adina store tablosundan
 vazgeçtim. 
 Buraya dikkat!! --> Soru benden store_id'si üzerinden cevap istemis. store_id si 2 olan maðaza demis. Magaza ismini de 
 isteseydi o zaman store_name'in yer aldigi store tablosundan vazgeçemeyecek, onu da join etmek zorunda kalacaktim.

*/

/* 5. Find the sales order of the customers who lives in Boulder order by order date
	Boulder'da yasayan müsterilerin sales order'ini, siparis tarihine göre bulun. */

SELECT C.city, A.order_id, A.order_date, C.customer_id, C.first_name, C.last_name
FROM sale.orders AS A, sale.customer AS C
WHERE A.customer_id = C.customer_id 
	AND city = 'Boulder'
ORDER BY A.order_date DESC;


/* 6. Get the sales by staffs and years using the AVG() aggregate function.
	   AVG() fonksiyonunu kullanarak personele (staff) ve yillara göre satislari alin. */

select *
from sale.order_item;


SELECT s.first_name, s.last_name, YEAR(o.order_date), AVG((i.list_price-i.list_price*i.discount)*quantity)
FROM sale.staff s 
INNER JOIN sale.orders o 
	ON s.staff_id = o.staff_id
INNER JOIN sale.order_item i
		ON o.order_id = i.order_id
GROUP BY s.first_name, s.last_name, YEAR(o.order_date)
ORDER BY 1, 2, 3;


/* 7. What is the sales quantity of product according to the brands and sort them highest-lowest
	Markalara göre satilan ürünlerin miktari nedir ve bunlari en yüksekten en düsüge dogru siralayiniz.*/

SELECT B.brand_name, P.product_name, COUNT(i.quantity) AS Sales_quantity_of_Product
FROM product.brand B, product.product P, sale.order_item i
WHERE B.brand_id = P.brand_id
AND P.product_id = i.product_id
GROUP BY B.brand_name, P.product_name
ORDER BY Sales_quantity_of_Product DESC;


---- 8. What are the categories that each brand has?----
--		Her markanin kategorileri nelerdir?

SELECT B.brand_name, C.category_name
FROM product.brand B, product.product P, product.category C 
WHERE B.brand_id = P.brand_id
	AND C.category_id = P.category_id
GROUP BY B.brand_name, C.category_name;


---- 9. Select the avg prices according to brands and categories----
--	Markalara ve kategorilere göre ortalama fiyatlari seçin

SELECT B.brand_name, C.category_name, AVG(P.list_price) AS MEAN
FROM product.brand B, product.product P, product.category C 
WHERE B.brand_id = P.brand_id
	AND C.category_id = P.category_id
GROUP BY B.brand_name, C.category_name;

---- 10. Select the annual amount of product produced according to brands----
--	Markalara göre  yillik ürün miktarini getirin

SELECT B.brand_name, P.model_year, COUNT(P.product_id)
FROM product.brand B, product.product P
WHERE B.brand_id = P.brand_id
GROUP BY B.brand_name, P.model_year
ORDER BY P.model_year;

---- 11. Select the store which has the most sales quantity in 2016.----
--	2016 yilinda en çok satis yapan magazayi seçin (2016 da satis yok bu yuzden 2019'i sectim)

SELECT TOP 1 S.store_name, SUM(I.quantity) BEST_STORE
FROM sale.store S, sale.orders O, sale.order_item I
WHERE S.store_id = O.store_id
	AND I.order_id = O.order_id
	AND YEAR(O.order_date) = 2019
GROUP BY S.store_name
ORDER BY BEST_STORE DESC;

-- şöyle bir kullanım da var --> WHERE  DATENAME(YEAR, O.order_date) = '2019'


---- 12. Select the store which has the most sales amount in 2018.----
--	 2018 yilinda en çok satis miktarina ulasan magazayi seçin

SELECT TOP 1 S.store_name,  SUM((I.list_price - (I.list_price * I.discount)) * I.quantity) BEST_STORE
FROM sale.store S, sale.orders O, sale.order_item I
WHERE S.store_id = O.store_id
	AND I.order_id = O.order_id
	AND YEAR(O.order_date) = 2018
GROUP BY S.store_name
ORDER BY BEST_STORE DESC;

---- 13. Select the personnel which has the most sales amount in 2019.----
--	2019 yilinda en çok satis yapan personeli seçin

SELECT TOP 1 S.staff_id, S.first_name, S.last_name, SUM((I.list_price - (I.list_price * I.discount)) * I.quantity) AS BEST_SALER
FROM sale.staff S, sale.orders O, sale.order_item I
WHERE S.staff_id = O.staff_id
	AND I.order_id = O.order_id
	AND YEAR(O.order_date) = 2019
GROUP BY S.staff_id,  S.staff_id, S.first_name, S.last_name
ORDER BY BEST_SALER DESC;



