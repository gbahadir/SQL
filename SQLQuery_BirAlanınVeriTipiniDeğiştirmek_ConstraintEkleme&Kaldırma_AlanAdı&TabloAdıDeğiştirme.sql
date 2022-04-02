
/* ==================================================================
				1. BÝR ALANIN VERÝ TÝPÝNÝ DEÐÝÞTÝRMEK 
=====================================================================*/

/* E-Commerce database'indeki orders_dimen tablosunun Order_Date alanýnýn "date" olan veri tipini 
	 "varchar" olarak deðiþtirmek istiyorum.
	
	Öncelikle bu alanýn orjinal hali üzerinde deðiþiklik yapmak istemediðim için 
	sonradan silmek üzere orders_dimen2 isminde yeni bir tablo oluþturayým 
	ve bu tablonun içeriðini orders_dimen tablosundan alsýn.*/

/*Aþaðýdaki kod ile orders_dimen tablosuna git ve içindeki tüm alanlarý 
orders_dimen2 adlý tabloya gir demiþ oluyorum.(select into --> eðer hedef tablosu yoksa oluþturur)*/

select *
into orders_dimen2
from orders_dimen


/* Aþaðýdaki iki fonksiyon(CAST ve CONVERT); 
SELECT ile birlikte kullanýlýr ve FROM ile ilgili alana gidip ordaki verinin tipini 
istediðiniz veri tipiyle deðiþtirir ve yeni haliyle bize getirir. 

Ancak pek tabi ki SELECT keyword'ü verinin tipi deðiþtirilmiþ yeni halini 
bize SORGU SONUCU OLARAK GETÝRÝR. YANÝ TABLODA YAPISAL BÝR DEÐÝÞÝKLÝKÝ YAPMAZ.*/

select CAST(Order_date as date) from orders_dimen2

select CONVERT(datetime, Order_Date, 101) from orders_dimen2

/* Tablo üzerindeki alanlarda (ve diðer tüm database objectlerde) yapýsal bir deðiþiklik yapmak için 
ALTER TABLE komutunu kullanýyoruz. Syntax'i þu þekildedir:*/

ALTER TABLE tablo_adi ALTER COLUMN  sutun_adi veri_turu


/*Aþaðýdaki kod ile diyoruz ki; orders_dimen2 tablosunda bir deðiþiklik yap ve bu deðiþiklik, 
Order_Date alanýnýn veri tipini date yapmak olsun.*/

ALTER TABLE orders_dimen2
ALTER COLUMN Order_Date varchar
-- Þimdi Object Explorer'dan bakarsak veri tipinin deðiþtiðini görebiliriz.

-- Tekrar varchar dan date tipine çevirelim:
ALTER TABLE orders_dimen2
ALTER COLUMN Order_Date date



/* ==================================================================
	  2. BÝR ALANA BÝR KISIT (CONSTRAINT) EKLEMEK veya KALDIRMAK
=====================================================================*/

/* Bir SQL tablosundaki bir alana NOT NULL ya da NULL constrainti eklemek istersek 
Syntax'i þu þekildedir:*/

ALTER TABLE tablo_adi 
ALTER COLUMN  sutun_adi veri_turu [NOT NULL | NULL ]

-- örneðimizdeki alana NOT NULL kýsýtý ekleyelim:

ALTER TABLE orders_dimen2
ALTER COLUMN Order_Date varchar NOT NULL


/* Bir SQL tablosundaki bir alana UNIQUE constrainti eklemek istersek 
Syntax'i þu þekildedir:
(Not: hata mesajý almamak için alandaki verilerin eþsiz olmasý yada tablonun boþ olmasý gerekiyor.)*/

ALTER TABLE tablo_adi 
ADD CONSTRAINT kisit_adi UNIQUE(sutun_adi)

-- örneðimizdeki alana UNIQUE kýsýtý ekleyelim:

ALTER TABLE order_dimen2
ADD CONSTRAINT order_date_kýsýt UNIQUE (Order_Date)


/* Bir SQL tablosundaki bir alana PRIMARY KEY constrainti eklemek istersek 
Syntax'i þu þekildedir:
(Not: Kýsýt isimleri önemlidir. Kaldýrma iþlemleri bu kýsýt isimleri üzerinde yapýlacaktýr.*/

ALTER TABLE tablo_Adi 
ADD CONSTRAINT kisit_adi PRIMARY KEY (sutun_adi)


/* örneðimizde bir alaný önce NOT NULL sonra da PRIMARY KEY yapalým:

(PRIMARY KEY için temel kurallardan biri boþ geçilemez olmasýdýr. 
Bu yüzden pek tabi ki öncelikle bu alanýn NOT NULL olmasý gerekmektedir.)*/

ALTER TABLE order_dimens2 ALTER COLUMN Ord_id INT NOT NULL
ALTER TABLE order_dimens2 ADD CONSTRAINT PK_ord_id PRIMARY KEY (Ord_id)


/* Bir SQL tablosundaki bir alanýn PRIMARY KEY constraintini kaldýrmak istersek
Syntax'i þu þekildedir:

(Alanlardaki kýsýtlarý kaldýrma iþlemi kýsýt adlarý ile yapýlmaktadýr. 
Diðer kýsýtlamalarý da kýsýtlama adý ile kaldýrabilirsiniz. 
Olmayan bir kýsýtlamayý yada daha önce silinmiþ olan bir kýsýtlamayý silmeye çalýþýyorsanýz. 
“Could not drop constraint. See previous errors.” hatasý ile karþýlaþýrsýnýz.*/

ALTER TABLE tablo_adi DROP CONSTRAINT kisit_adi

-- örneðimizdeki Ord_id alanýndan UNIQUE kýsýtýný kaldýralým:
--(Ord_id için UNIQUE kýsýtlamasýný "order_date_kýsýt" olarak eklemiþtik)

ALTER TABLE Ord_id DROP CONSTRAINT order_date_kýsýt

/* ==================================================================
					3. BÝR TABLONUN ADINI DEÐÝÞTÝRMEK
=====================================================================*/

/*ALTER komutu ile tablo adýný deðiþtirmek mümkün deðildir.
Fakat bu iþlem için sp_rename saklý yordamý kullanýlabilir. 
Ýliþki baðýmlýlýðý yüzünden SQL Server tabloyunu yeniden oluþturmayý öneriyor.*/

-- orders_dimen2 tablo adýný orders_dimen3 olarak deðiþtirelim:

sp_rename 'orders_dimen2' , 'orders_dimen3'


/* ==================================================================
					4. BÝR ALANIN ADINI DEÐÝÞTÝRMEK
=====================================================================*/

/*ALTER Komutu ile sütun isimlerini deðiþtirmek mümkün deðildir. 
Bu iþlem için sp_rename saklý yordamý ile yapmak mümkündür. 
Ancak SQL Server tabloyu yeniden oluþturmanýzý önerir.*/

--örneðimizde Order_Date alan adýný Date_Order olarak deðiþtirelim:

sp_rename 'order_dimen2.Order_Date', 'Date_Order', 'COLUMN'







