----- CLUSTRED INDEX -----

/*
Clustred index , veriyi sql’de fiziksel olarak sıraya sokan yapıdır. 
Aslında hepimiz clustred index’i tablolarımızda kullanıyoruz. 
Tablolarımıza tanımladığımız her bir Primary key aslında otomatik olarak bir Clustred index yapısıdır. 
Çünkü tablolarımız bu pk’ya göre fiziksel olarak sıralanır.

Primary Keyde otomatik olarak Clustred index olusuyor.

Clustered index ile ilgili önemli noktalar

Her tabloda yalnızca 1 adet clustered index olabilir.
Sql query sonucu sıralı dataları dönerken de clustered indexe göre aynı sırada döner.
Tablodaki bir clustered index pk olabileceği gibi aynı zamanda birden fazla kolonun 
birleşiminden oluşan bir yapı da olabilir. Buna composite clustered index denir.

Primary key – Clustered Index farkı nedir?

Primary key dediğimiz, tablodaki kaydın uniqueliğini garantileyen bir alandır ve kaydın kimliğidir. 
Tanımlandığı gibi de clustered index özelliği taşır.
Clustered index, bir veri yapısı, dataya daha hızlı ulaşmak için oluşturulmuş bir indexleme şeklidir.
Genel olarak datanın fiziksel sıralamasını düzenleyerek dataya ulaşma süresini optimize etmeyi amaçlarken, 
keyler ise datanın uniqueliğini sağlar.

----- NON-CLUSTRED INDEX -----

 Kitapların başında içerik kısmı vardır. Bu içerik kısmında her bir konu başlığının hangi sayfa numarasında 
 veya sayfa numaraları aralığında olduğunu gösterir. Siz kitabı açtığınızda önce içerik sayfasına bakarsınız. 
 Daha sonra aradığınız içeriğin sayfasını ya da sayfa aralığını öğrenip direkt olarak bu sayfalara geçersiniz. 
 Non-cluster index de tam olarak bunu yapmakta.

Bir kolonu Non-clustered index olarak indexlediğinizde, arka tarafta yeni bir tablo oluşur 
ve bu tablo sizin indexlediğiniz kolona karşılık kolon adresini tutar. Yani bir nevi pointer yapısı gibi düşünebilirsiniz.
Non-clustered indekste verilere direkt erişilemez. 
Elde edilen indeksleme yapısına erişmek için kümelenmiş indeks yapısı kullanılmış olur.
Verileri herhangi bir alana göre sıralandığında erişim kümelenmiş indeks üzerinden anahtar değer referans alınarak yapılır.

----- COMPOSITE CLUSTERED INDEX -----

Tablodaki bir clustered index PK olabileceği gibi aynı zamanda birden fazla kolonun birleşiminden oluşan bir yapı da olabilir. Buna composite clustered index denir.
Aşağıdaki query ile 2 kolona bağlı clustered index yaratmış olduk.
Bu query’nin bize söylediği şey, tablomdaki kayıtları Gender’a göre diz , genderi aynı olanları da artan sırada salary’e göre diz. Siz insertlerinizi ne şekilde atarsanız atın, dizilim bu yönde olacaktır.
create clustered index myClusteredIndex On tblEmployee (Gender Desc, Salary Asc)

*/



--Bu tablo için ayrı bir database oluşturmanız daha uygun olacaktır.
--Index' in faydalarının daha belirgin olarak görülmesi için bu şekilde bir tablo oluşturulmuştur.

--önce tablonun çatısını oluşturuyoruz.


create table website_visitor 
(
visitor_id int,
ad varchar(50),
soyad varchar(50),
phone_number bigint,
city varchar(50)
);


--Tabloya rastgele veri atıyoruz konumuz haricindedir, şimdilik varlığını bilmeniz yeterli.


DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;



--Tabloyu kontrol ediniz.

SELECT top 10*
FROM
website_visitor



--İstatistikleri (Process ve time) açıyoruz, bunu açmak zorunda değilsiniz sadece yapılan işlemlerin detayını görmek için açtık.
SET STATISTICS IO on
SET STATISTICS TIME on



--herhangi bir index olmadan visitor_id' ye şart verip tüm tabloyu çağırıyoruz


SELECT *
FROM
website_visitor
where
visitor_id = 100

--execution plan' a baktığınızda Table Scan yani tüm tabloyu teker teker tüm değerlere bakarak aradığını göreceksiniz.



--Visitor_id üzerinde bir index oluşturuyoruz

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);


--visitor_id' ye şart verip sadece visitor_id' yi çağırıyoruz



SELECT visitor_id
FROM
website_visitor
where
visitor_id = 100


--execution plan' a baktığınızda Clustered index seek
--yani sadece clustered index' te aranılan değeri B-Tree yöntemiyle bulup getirdiğini görüyoruz.



--visitor_id' ye şart verip tüm tabloyu çağırıyoruz

SELECT *
FROM
website_visitor
where
visitor_id = 100

--execution plan' a baktığınızda Clustered index seek yaptığını görüyoruz.
--Clustered index tablodaki tüm bilgileri leaf node'larda sakladığı için ayrıca bir yere gitmek ihtiyacı olmadan
--primary key bilgisiyle (clustered index) tüm bilgileri getiriyor.
------------------------------


--Peki farklı bir sütuna şart verirsek;


SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'


--Execution Plan' da Görüleceği üzere Clustered Index Scan yapıyor.
--Dikkat edin Seek değil Scan. Aradığımız sütuna ait değeri clustered index' in leaf page' lerinde tutulan bilgilerde arıyor
--Tabloda arar gibi, index yokmuşçasına.


--Yukarıdaki gibi devamlı sorgu atılan non-key bir attribute söz konusu ise;
--Bu şekildeki sütunlara clustered index tanımlayamayacağımız için NONCLUSTERED INDEX tanımlamamız gerekiyor.

--Non clustered index tanımlayalım ad sütununa
CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (ad);


--Ad sütununa şart verip kendisini çağıralım:

SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'


--Execution Plan' da Görüleceği üzere üzere aynı yukarıda visitor id'de olduğu gibi index seek yöntemiyle verileri getirdi.
--Tek fark NonClustered indexi kullandı.


--Peki ad sütunundan başka bir sütun daha çağırırsak ne olur?
--Günlük hayatta da ad ile genellikle soyadı birlikte sorgulanır.


SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'


--Execution Plan' da Görüleceği üzere burada ad ismine verdiğimiz şart için NonClustered index seek kullandı,
--Sonrasında soyad bilgisini de getirebilmek için Clustered index e Key lookup yaptı.
--Yani clustered index' e gidip sorgulanan ad' a ait primary key' e başvurdu
--Sonrasında farklı yerlerden getirilen bu iki bilgiyi Nested Loops ile birleştirdi.


--Bir sorgunun en performanslı hali idealde Sorgu costunun %100 Index Seek yöntemi ile getiriliyor olmasıdır!


--Şu demek oluyor ki, bu da tam olarak performans isteğimizi karşılamadı, daha performanslı bir index oluşturabilirim.

--Burada yapabileceğim, ad sütunu ile devamlı olarak birlikte sorgulama yaptığım sütunlara INCLUDE INDEX oluşturma işlemidir.
--Bunun çalışma mantığı;
--NonClustered index' te leaf page lerde sadece nonclustered index oluşturulan sütunun ve primary keyinin bilgisi tutulmaktaydı.
--Include index oluşturulduğunda verilen sütun bilgileri bu leaf page lere eklenmesi ve ad ile birlikte kolayca getirilmesi amaçlanmıştır.


--Include indexi oluşturalım:
Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (ad) include (soyad)


--ad ve soyadı ad sütununa şart vererek birlikte çağıralım
SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'

--Execution Plan' da Görüleceği üzere sadece Index Seek ile sonucu getirmiş oldu.


--soyad sütununa şart verip sadece kendisini çağırdığımızda 
--Kendisine tanımlı özel bir index olmadığı için Index seek yapamadı, ad sütunun indexinde tüm değerlere teker teker bakarak
--Yani Scan yöntemiyle sonucu getirdi.

SELECT soyad
FROM
website_visitor
where
soyad = 'visitor_name17'

--Execution Plan' da Görüleceği üzere bize bir index tavsiyesi veriyor.

