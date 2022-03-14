/*
--CREATING TABLES FOR IN-CLASS

--CREATE DATABASE departments
--USE departments

CREATE TABLE employees_A
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);



INSERT employees_A VALUES
 (17679,  'Robert'    , 'Gilmore'       ,   110000 ,  'Operations Director', 'Male')
,(26650,  'Elvis'    , 'Ritter'        ,   86000 ,  'Sales Manager', 'Male')
,(30840,  'David'   , 'Barrow'        ,   85000 ,  'Data Scientist', 'Male')
,(49714,  'Hugo'    , 'Forester'    ,   55000 ,  'IT Support Specialist', 'Male')
,(51821,  'Linda'    , 'Foster'     ,   95000 ,  'Data Scientist', 'Female')
,(67323,  'Lisa'    , 'Wiener'      ,   75000 ,  'Business Analyst', 'Female')





CREATE TABLE employees_B
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);


INSERT employees_B VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')

CREATE TABLE employees_C
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job VARCHAR (30),
gender VARCHAR(10),
);


INSERT employees_C VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')
*/

--SET OPERATORS
--GİRİŞ
/*  
	•	Both SELECT statements must contain the same number of columns.
	•	Her iki SELECT ifadesi de aynı sayıda sütun içermelidir.
	•	In the SELECT statements, the corresponding columns must have the same data type.
	•	SELECT ifadelerinde, karşılık gelen sütunlar aynı veri tipine sahip olmalıdır.
	•	Performans açısından, UNION ALL, UNION'a kıyasla daha iyi performans gösterir, çünkü kaynaklar yinelenenleri filtrelemek ve sonuç kümesini sıralamak için boşa harcanmaz.
	•	Set operatörleri alt sorguların bir parçası olabilir.
*/
SELECT * FROM employees_A --Sütun sayıları eşit ve aynı data tipine sahipler
SELECT * FROM employees_B -- B VE C TABLOLARI AYNIDIR
SELECT * FROM employees_C --job_title sütunun ismini job olarak değiştirdim

--1. UNION
/* The UNION set operator returns the combined results of the two SELECT statements. 
Essentially, It removes duplicates from the results i.e. only one row will be listed for each duplicated result.
	UNION set operatörü, iki SELECT ifadesinin birleştirilmiş sonuçlarını döndürür. 
Esasen, sonuçlardan yinelenenleri kaldırır, yani yinelenen her sonuç için yalnızca bir satır listelenir.*/ 

--EXAMPLE 1:
SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job
  FROM employees_C
  -- sonuçta gelen sütun ismi job_title, ilk yazılan tabloya ait sütun isimlerini aldı.
  -- sütun ismi farklı olsa da birleştirdi, çünkü sütun sayıları ve sütun veri tipleri aynı
  -- Hepsini alt alta sıraladı
  -- A da 6 satır  B de 6 satır varken tekrar eden (duplicated) satırları sildiği için UNION da 10 satır sonuç geldi
  --YİNELENEN(duplicated) satırlar emp_id 49714 and emp_id 67323 satırları BİR KEZ geldi

--EXAMPLE 2:
 SELECT emp_id, first_name, last_name, job--sonuçta gelen sütun ismi job, ilk yazılan TABLOYA göre birleştirildi
  FROM employees_C --Üçüncü bir tablo oluşturdum
  UNION
 SELECT emp_id, first_name, last_name, job_title
  FROM employees_A

  --EXAMPLE 3:
SELECT *  --İKİ YILDIZ OLURSA KABUL EDİYOR
  FROM employees_A
UNION
SELECT *
  FROM employees_C

  --EXAMPLE 4:
SELECT *  --TEK YILDIZ KULLANILIRSA HATA VERİYOR. EŞİT SAYIDA SÜTUN YOK DİYE
  FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job
  FROM employees_C
   
--EXAMPLE 5:  
SELECT first_name, last_name --İSTEDİĞİMİZ SÜTUN İSİMLERİNİ ÇAĞIRABİLİRİZ
  FROM employees_A
UNION
SELECT first_name, last_name --İSTEDİĞİMİZ SÜTUN İSİMLERİNİ ÇAĞIRABİLİRİZ
  FROM employees_B

--EXAMPLE 6:  
SELECT emp_id, first_name --İSTEDİĞİMİZ SÜTUN İSİMLERİNİ ÇAĞIRABİLİRİZ AMA DATA TİPLERİ AYNI OLMALI
  FROM employees_A
UNION
SELECT first_name, last_name ----İSTEDİĞİMİZ SÜTUN İSİMLERİNİ ÇAĞIRABİLİRİZ AMA DATA TİPLERİ AYNI OLMALI
  FROM employees_B

  --EXAMPLE 7:
SELECT emp_id, first_name, last_name  --JOB TITLE SİLDİM --EŞİT SAYIDA SÜTUN OLMALI YOKSA HATA VERİYOR
  FROM employees_B
UNION
SELECT emp_id, first_name, last_name, job_title
  FROM employees_A

-- Difference from JOIN 
SELECT *
  FROM employees_A 
LEFT JOIN employees_C
  ON employees_A.emp_id = employees_C.emp_id

SELECT * 
  FROM employees_A 
INNER JOIN employees_C
  ON employees_A.emp_id = employees_C.emp_id

  --2 UNION ALL
  /*The UNION ALL clause is used to print all the records including duplicate records when combining the two tables.
  UNION ALL yan tümcesi, iki tabloyu birleştirirken yinelenen kayıtlar dahil tüm kayıtları yazdırmak için kullanılır.*/
  
SELECT 'Employees A' AS [Type], emp_id, first_name, last_name, job_title 
--maviden kurtarmak için Type köşeli paranteze aldım
FROM employees_A
UNION ALL
SELECT 'Employees B' AS Type2, emp_id, first_name, last_name, job_title 
FROM employees_B; --farklı sütun ismi versem de data tipleri aynı olduğu için
					--ilk tablondaki sütun ismi ile birleştirdi 

  --UNION DA 10 SATIR VARKEN BURADA 12 SATIR VAR. 
  --YİNELENEN(duplicated) satırlar emp_id 49714 and emp_id 67323 HER TABLO İÇİN AYRI AYRI geldi

  -- 3.INTERSECT
  /*INTERSECT lists only records that are common to both the SELECT queries; 
INTERSECT, yalnızca her iki SELECT sorgusu için ortak olan kayıtları listeler;
 !!! YANİ HER İKİ TABLODAKİ ORTAK SATIRLARI GETİRİR*/

SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
INTERSECT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B
 ORDER BY emp_id;

 -- HER İKİ TABLODAKİ ORTAK emp_id 49714 and emp_id 67323 GELDİ SADECE

 /*--4 EXCEPT
EXCEPT operator compares the result sets of the two queries and 
returns the rows of the previous query that differ from the next query.
EXCEPT operatörü, iki sorgunun sonuç kümelerini karşılaştırır ve 
önceki sorgunun sonraki sorgudan farklı olan satırlarını döndürür.*/

-- EXAMPLE 1
SELECT emp_id, first_name, last_name, job_title --A TABLOSUNUN, B TABLOSUNDAN FARKLI OLAN SATIRLARI GELDİ
  FROM employees_A
EXCEPT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B;

-- EXAMPLE 2 -- B'NİN A'DAN FARKLI OLAN SATIRLARI GELDİ
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B
EXCEPT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_A;

--İKİDEN FAZLA TABLO BİRLEŞTİRME MÜMKÜN
--EXAMPLE 1: TEKRAR EDEN SATIRLARI SİLEREK UNİONLA BİRLEŞTİRDİ
SELECT *
  FROM employees_A
UNION
SELECT *
  FROM employees_B
UNION
SELECT *
  FROM employees_C

--EXAMPLE 2: ÜÇ SÜTUNU BİRLEŞTİRDİ. UNIONALL TEKRAR EDEN SATIRLARI DA GETİRDİĞİ İÇİN 18 SATIR GELDİ
SELECT *
  FROM employees_A
UNION ALL
SELECT *
  FROM employees_B
UNION ALL
SELECT *
FROM employees_C

--EXAMPLE 1: --A B VE C SÜTUNLARINDA ORTAK OLAN SATIRLARI GETİRDİ
SELECT *
  FROM employees_A  
INTERSECT	
SELECT *
  FROM employees_B
INTERSECT
SELECT *
  FROM employees_C

--EXAMPLE 1: --A'NIN B VE C SÜTUNLARINDAN FARKLI OLAN SATIRLARI GELDİ
SELECT *
  FROM employees_A  
EXCEPT
SELECT *
  FROM employees_B
EXCEPT
SELECT *
  FROM employees_C

  --EXAMPLE 1:
  --B'NİN A VE C SÜTUNLARINDAN FARKLI OLAN SATIRLARINI İSTEDİK. 
  --B'NİN A'DAN FARKLI SATIRLARI VAR FAKAT C TABLOSU İLE AYNI SATIRLARI İÇERDİĞİ İÇİN VERİ GETİRMEDİ
SELECT *
  FROM employees_B
EXCEPT
SELECT *
  FROM employees_A
EXCEPT
SELECT *
  FROM employees_C;