---- CREATE ----
-- veritabanı ve tablo yapılarını oluşturmak için kullanılır.

CREATE TABLE departments
(
	id BIGINT NOT NULL,
	name VARCHAR(20) NULL,
	dept_name VARCHAR(20) NULL,
	seniority VARCHAR(20) NULL,
	graduation VARCHAR(20) NULL,
	salary BIGINT NULL,
	hire_date DATE NULL,
        CONSTRAINT pk_1 PRIMARY KEY (id)
 ) ;

 ---- ALTER TABLE ----
 -- ALTER TABLE Kısıtlamaları eklemek ve kaldirmak  için  kullanilir .Sütunların kaldırılmasını sağlar.
-- Bir kısıtlama eklendiğinde, mevcut tüm veriler ihlaller için doğrulanır.

-- SELECT – to query data in the database
-- INSERT – to insert data into a table
-- UPDATE – to update data in a table
-- DELETE – to delete data from a table

/* Bir ifadedeki her madde yeni bir satırda başlamalıdır.
Her bir tümcenin başlangıcı, diğer tümcelerin başlangıcı ile aynı hizada olmalıdır.
Bir tümcenin birkaç bölümü varsa, bunlar ayrı satırlarda görünmeli ve ilişkiyi göstermek için tümcenin başlangıcının altına girintili olmalıdır.
Ayrılmış kelimeleri temsil etmek için büyük harfler kullanılır.
Kullanıcı tanımlı kelimeleri temsil etmek için küçük harfler kullanılır.*/
 --------------------------------------------------

CREATE DATABASE LibDatabase;

USE LibDatabase;


CREATE SCHEMA Book;
CREATE SCHEMA Person;
--create Book.Book table
CREATE TABLE [Book].[Book](
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL
	);

	--create Book.Author table
CREATE TABLE [Book].[Author](
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);

	--create Publisher Table
CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar](100) NULL
	);

	CREATE TABLE [Person].[Person](
	[SSN] [bigint] PRIMARY KEY NOT NULL,
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);

	--create Person.Loan table
CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])
	);

	--cretae Person.Person_Phone table
CREATE TABLE [Person].[Person_Phone](
	[Phone_Number] [bigint] PRIMARY KEY NOT NULL,
	[SSN] [bigint] NOT NULL	
	);

--cretae Person.Person_Mail table
CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL	
	);


---------------------------------------------------------------------------------------------
---- INSERT ----
-- bir tabloya satır ekler.
--INSERT verilerin ekleneceği tabloyu veya görünümü belirtir.

/* İfadeyle satır eklerken INSERTşu kurallar geçerlidir:

Bir varchar veya metin sütununa boş bir dize (' ') eklemek, tek bir boşluk ekler.
Tüm karakter sütunları, tanımlanan uzunluğa göre soldan sağa doldurulur.
Yalnızca boşluk içeren dizeler dışında, varchar sütunlarına eklenen verilerden tüm sondaki boşluklar kaldırılır. 
Bu dizeler tek bir boşluk için kesilir.
Bir INSERT ifade bir kısıtlamayı, varsayılanı veya kuralı ihlal ederse veya yanlış veri türüyse, ifade başarısız olur 
ve SQL Server bir hata mesajı görüntüler.

Sütun_listesindeki sütunlardan yalnızca bazıları için değerler belirttiğinizde, değeri olmayan sütunlarda üç şeyden biri olabilir:

1- DEFAULT : Sütunun bir kısıtlaması varsa, sütuna bir varsayılan bağlıysa veya temel alınan kullanıcı tanımlı veri türüne 
bir varsayılan bağlıysa, varsayılan bir değer girilir .
2- NULLNULL : sütun izin veriyorsa ve sütun için varsayılan bir değer yoksa girilir .
3- Bir hata mesajı görüntülenir ve sütun şu şekilde tanımlanırsa NOT NULLve varsayılan yoksa satır reddedilir. */

---- SELECT ----
-- kullanıcının belirli kriterlere göre tablolardan veri çıkarmasına olanak tanır. 

INSERT INTO Person.Person (SSN, Person_FirstName, Person_LastName)
	VALUES (75056659595,'Zehra', 'Tekin')
;
select *
from Person.Person;

INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (889623212466,'Kerem');

select *
from Person.Person;

INSERT Person.Person VALUES (15078893526,'Mert','Yetiş');

select *
from Person.Person;

INSERT Person.Person VALUES (55556698752, 'Esra', Null);

select *
from Person.Person;

INSERT Person.Person VALUES (35532888963,'Ali','Tekin');-- Toplu veri girisi 1 :Tüm tablolara değer atanacağı varsayılmıştır.
INSERT Person.Person VALUES (88232556264,'Metin','Sakin');

INSERT INTO Person.Person_Mail (Mail, SSN) -- Toplu veri girisi yontemi 2
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

select *
from Person.Person_Mail;

select @@IDENTITY  -- Son calisan rowun ID numarasini gosterir

SELECT @@ROWCOUNT  -- -- Son calisan rowda toplam row sayisini gosterir

select *
into Person.Person2  -- yeni kopya tablo olusturur(PK, FK'lar haric)
from Person.Person;


select *
from Person.Person2;

select *
from Person.Person
where Person_FirstName like 'M%';  --Adi M ile baslayanlari getirir


insert into Person.Person2
select *
from Person.Person
where Person_FirstName like 'M%';  --Adi M ile baslayanlari Person2 ye ekler

select *
from Person.Person2;

insert into Book.Publisher
default values;

select *
from Book.Publisher;

---- UPDATE ----
-- yeni veriler ekleyerek veya mevcut verileri değiştirerek mevcut satırlardaki verileri değiştirir.

UPDATE Person.Person2 
SET Person_FirstName = 'Default_Name'; -- Bir sutunda mevcut verilerin tamamini degistirmek icin kullanilir

select *
from Person.Person2;

UPDATE Person.Person2
SET Person_FirstName = 'Can'   -- Belirli bir satirda degisiklik yapar
WHERE SSN = 75056659595;

select *
from Person.Person2;


select *
from Person.Person2;

SELECT *
FROM Person.Person2 AS A
Inner Join Person.Person as B
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595;


UPDATE Person.Person2
SET Person_FirstName = B.Person_FirstName
FROM Person.Person2 AS A
Inner Join Person.Person as B   -- Person.Person2 tablosunda secilen satirdaki isimi B tablosundan gelen isimle degistirir
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595


---- DELETE ---- 
-- bir kayıt kümesinden satırları kaldırır.

select *
from Person.Person2;
Delete from Book.Publisher;  -- Publisher tablosundaki tum satirlar silindi

select *
from Book.Publisher;


insert Book.Publisher values ('İLETİŞİM');  -- 1 satir ekledik
insert Book.Publisher values ('BİLİŞİM');

DELETE FROM BOOK.Publisher
WHERE Publisher_Name = 'BILISIM'; -- Secilen satir silinir

select *
from Book.Publisher;

TRUNCATE table book.publisher; -- DELETE'den farki ID sayaci sifirlar.

DROP TABLE Person.Person2;  -- Veritabanından bir tabloyu kaldırır .

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;
TRUNCATE TABLE Book.Publisher;

ALTER TABLE Book.Author
ALTER COLUMN Author_ID  -- Primary key olsturmak icin sutunu once not null yaptik
INT NOT NULL;  


ALTER TABLE Book.Author
ADD CONSTRAINT pk_author
PRIMARY KEY (Author_ID); sutunu 

ALTER TABLE Book.Book
ADD CONSTRAINT FK_Author
FOREIGN KEY (Author_ID)  -- Author_ID'yi Book tablosunda Foreign Key yaptik
REFERENCES Book.Author (Author_ID); 

ALTER TABLE Person.Loan
ADD CONSTRAINT FK_PERSON
FOREIGN KEY (SSN)
REFERENCES Person.Person (SSN);

ALTER TABLE Person.Loan 
ADD CONSTRAINT FK_book 
FOREIGN KEY (Book_ID) 
REFERENCES Book.Book (Book_ID);


Alter table Person.Person_Mail 
add constraint FK_Person4 
Foreign key (SSN) 
References Person.Person(SSN);