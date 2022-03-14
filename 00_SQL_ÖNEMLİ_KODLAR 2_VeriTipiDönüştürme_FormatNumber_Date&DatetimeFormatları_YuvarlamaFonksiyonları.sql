/*=================================================
					INDEX
===================================================
1.		VERÝ TÝPÝNÝ DÖNÜÞÜRME
2.		FORMAT NUMBER
3.		DATE FORMAT with CULTURE
4.		DATE FORMATLARI
  4.a.	SADECE DATE FORMATI OLARAK
  4.b.	SADECE TIME FORMATI OLARAK
  4.c.	DATE&TIME FORMATI OLARAK
  4.d.	Tüm geçerli tarih ve saat biçimlerinin bir listesini almak için kod.
5.		DATE and TIME FONKSIYONLARI
  5.a	SYSDATETIME, SYSDATETIMEOFFSET and SYSUTCDATETIME Fonksiyonlarý
  5.b.  CURRENT_TIMESTAMP, GETDATE() and GETUTCDATE() Fonksiyonlarý
  5.c.	DATENAME Fonksiyonu
  5.d	DATEPART Fonksiyonu
  5.e	DAY, MONTH and YEAR Fonksiyonlarý
  5.f.	DATEFROMPARTS, DATETIME2FROMPARTS, DATETIMEFROMPARTS, 
		DATETIMEOFFSETFROMPARTS, SMALLDATETIMEFROMPARTS, TIMEFROMPARTS Fonksiyonlarý
  5.g.	DATEDIFF and DATEDIFF_BIG Fonksiyonlarý
  5.h	DATEADD, EOMONTH, SWITCHOFFSET and TODATETIMEOFFSET Fonksiyonlarý 
  5.i.	ISDATE Fonksiyonu (to Validate Date and Time Values)
6.		SAYI YUVARLAMA Fonksiyonlarý
  6.a.	ROUND, CEILING and FLOOR Examples for Decimal, Numeric and Float Data Types
  6.b.	ROUND, CEILING and FLOOR Examples for Integer Data Types
 */




/*================================================== 
1.				VERÝ TÝPÝNÝ DÖNÜÞÜRME
====================================================*/

SELECT CONVERT(varchar, '2017-08-25', 101);
SELECT CAST('2017-08-25' AS varchar);
-- date formatýndaki bir veriyi char'a çevirdi.

SELECT CONVERT(datetime, '2017-08-25');
SELECT CAST('2017-08-25' AS datetime);
-- char formatýndaki bir veriyi datetime'a çevirdi.

SELECT CONVERT(int, 25.65);
SELECT CAST(25.65 AS int);
-- decimal bir veriyi, integer'a (tam sayýya) çevirdi.

SELECT CONVERT(DECIMAL(5,2), 12) AS decimal_value;
SELECT CAST(12 AS DECIMAL(5,2) ) AS decimal_value;
-- integer bir veriyi 5 rakamdan oluþan ve bunun virgülden sonrasý 2 rakam olan decimal'e çevirdi.

SELECT CONVERT(DECIMAL(7,2), ' 5800.79 ') AS decimal_value;
SELECT CAST(' 5800.79 ' AS DECIMAL (7,2)) AS decimal_value;
-- char (string) olan ama rakamdan oluþan veriyi decimal'e çevirdi.


/*==========================================================
2.					FORMAT NUMBER 
============================================================*/

-- Currency-English-USA
SELECT FORMAT(200.36, 'C', 'en-us') AS 'Currency Format'

-- Currency-Germany
SELECT FORMAT(200.36, 'C', 'de-DE') AS 'Currency Format'

-- General Format
SELECT FORMAT(200.3625, 'G', 'en-us') AS 'Format'

-- Numeric Format
SELECT FORMAT(200.3625, 'N', 'en-us') AS 'Format'

-- Numeric 3 decimals
SELECT FORMAT(11.0, 'N3', 'EN-US') AS 'Format'

-- Decimal
SELECT FORMAT(12, 'D', 'en-us') AS 'Format'

-- Decimal 4	
SELECT FORMAT(12, 'D4', 'en-us') AS 'Format'

-- Exponential	
SELECT FORMAT(120, 'E', 'EN-US') AS 'Format'

-- Percent	
SELECT FORMAT(0.25, 'P', 'EN-US') AS 'Format'

-- Hexadecimal	
SELECT FORMAT(11, 'X', 'EN-US') AS 'Format'



/*===========================================================
3.					DATE FORMAT with CULTURE
=============================================================*/

--For example in the USA, the format would be like:
SELECT FORMAT (getdate(), 'd', 'en-us') as date

-- example in France
SELECT FORMAT (getdate(), 'd', 'fr-FR') as date

-- example in Turkey
SELECT FORMAT (getdate(), 'd', 'tr-TR') as date

/* input profile (language and keyboard pair)
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs?view=windows-11
*/


/*================================================== 
4.				DATE FORMATLARI 
====================================================*/

SELECT FORMAT (getdate(), 'dd-MM-yy') as date
SELECT FORMAT (getdate(), 'hh:mm:ss') as time
SELECT FORMAT (getdate(), 'dd/MM/yyyy ') as date	
SELECT FORMAT (getdate(), 'dd/MM/yyyy, hh:mm:ss ') as date	
SELECT FORMAT (getdate(), 'dddd, MMMM, yyyy') as date	
SELECT FORMAT (getdate(), 'MMM dd yyyy') as date	
SELECT FORMAT (getdate(), 'MM.dd.yy') as date	
SELECT FORMAT (getdate(), 'MM-dd-yy') as date	
SELECT FORMAT (getdate(), 'hh:mm:ss tt') as date	
SELECT FORMAT (getdate(), 'd','us') as date	
SELECT FORMAT (getdate(), 'yyyy-MM-dd hh:mm:ss tt') as date	
SELECT FORMAT (getdate(), 'yyyy.MM.dd hh:mm:ss t') as date
/*
dd - this is day of month from 01-31
dddd - this is the day spelled out
MM - this is the month number from 01-12
MMM - month name abbreviated
MMMM - this is the month spelled out
yy - this is the year with two digits
yyyy - this is the year with four digits
hh - this is the hour from 01-12
HH - this is the hour from 00-23
mm - this is the minute from 00-59
ss - this is the second from 00-59
tt - this shows either AM or PM
d - this is day of month from 1-31 (if this is used on its own it will display the entire date)
us - this shows the date using the US culture which is MM/DD/YYYY
*/


-- 4.a.		SADECE DATE FORMATI OLARAK:

select convert(varchar, getdate(), 1)	-- mm/dd/yy	
select convert(varchar, getdate(), 2)	-- yy.mm.dd
select convert(varchar, getdate(), 3)	-- dd/mm/yy	
select convert(varchar, getdate(), 4)	-- dd.mm.yy	
select convert(varchar, getdate(), 5)	-- dd-mm-yy	
select convert(varchar, getdate(), 6)	-- dd-Mon-yy	
select convert(varchar, getdate(), 7)	-- Mon dd, yy	
select convert(varchar, getdate(), 10)	-- mm-dd-yy	
select convert(varchar, getdate(), 11)	-- yy/mm/dd	
select convert(varchar, getdate(), 12)	-- yymmdd	
select convert(varchar, getdate(), 23)	-- yyyy-mm-dd	
select convert(varchar, getdate(), 101)	-- mm/dd/yyyy
select convert(varchar, getdate(), 102)	-- yyyy.mm.dd	
select convert(varchar, getdate(), 103)	-- dd/mm/yyyy	
select convert(varchar, getdate(), 104)	-- dd.mm.yyyy	
select convert(varchar, getdate(), 105)	-- dd-mm-yyyy	
select convert(varchar, getdate(), 106)	-- dd Mon yyyy	
select convert(varchar, getdate(), 107)	-- Mon dd, yyyy	
select convert(varchar, getdate(), 110)	-- mm-dd-yyyy	
select convert(varchar, getdate(), 111)	-- yyyy/mm/dd	
select convert(varchar, getdate(), 112)	-- yyyymmdd	

-- 4.b.			SADECE TIME FORMATI OLARAK:
select convert(varchar, getdate(), 8)	-- hh:mm:ss	
select convert(varchar, getdate(), 14)	-- hh:mm:ss:nnn	
select convert(varchar, getdate(), 24)	-- hh:mm:ss	
select convert(varchar, getdate(), 108)	-- hh:mm:ss	
select convert(varchar, getdate(), 114)	-- hh:mm:ss:nnn	

-- 4.c.			DATE&TIME FORMATI OLARAK :
select convert(varchar, getdate(), 0)	--Mon dd yyyy hh:mm AM/PM	
select convert(varchar, getdate(), 9)	--Mon dd yyyy hh:mm:ss:nnn AM/PM	
select convert(varchar, getdate(), 13)	--dd Mon yyyy hh:mm:ss:nnn AM/PM	
select convert(varchar, getdate(), 20)	--yyyy-mm-dd hh:mm:ss	
select convert(varchar, getdate(), 21)	--yyyy-mm-dd hh:mm:ss:nnn	
select convert(varchar, getdate(), 22)	--mm/dd/yy hh:mm:ss AM/PM	
select convert(varchar, getdate(), 25)	--yyyy-mm-dd hh:mm:ss:nnn	
select convert(varchar, getdate(), 100)	--Mon dd yyyy hh:mm AM/PM	
select convert(varchar, getdate(), 109)	--Mon dd yyyy hh:mm:ss:nnn AM/PM	
select convert(varchar, getdate(), 113)	--dd Mon yyyy hh:mm:ss:nnn	
select convert(varchar, getdate(), 120)	--yyyy-mm-dd hh:mm:ss	
select convert(varchar, getdate(), 121) --yyyy-mm-dd hh:mm:ss:nnn	
select convert(varchar, getdate(), 126)	--yyyy-mm-dd T hh:mm:ss:nnn	
select convert(varchar, getdate(), 127)	--yyyy-mm-dd T hh:mm:ss:nnn	


/* 4.d.	

Tüm geçerli tarih ve saat biçimlerinin bir listesini almak için aþaðýdaki kodu kullanabilir 
ve @date deðerini GETDATE()'e (o günkü tarihe) veya 
kullanmak istediðiniz baþka bir tarih olarak deðiþtirebilirsiniz.*/

DECLARE @counter INT = 0
DECLARE @date DATETIME = '2006-12-30 00:38:54.840'

CREATE TABLE #dateFormats (dateFormatOption int, dateOutput nvarchar(40))

WHILE (@counter <= 150 )
BEGIN
   BEGIN TRY
      INSERT INTO #dateFormats
      SELECT CONVERT(nvarchar, @counter), CONVERT(nvarchar,@date, @counter) 
      SET @counter = @counter + 1
   END TRY
   BEGIN CATCH;
      SET @counter = @counter + 1
      IF @counter >= 150
      BEGIN
         BREAK
      END
   END CATCH
END

SELECT * FROM #dateFormats


/*========================================================
				DATE and TIME FONKSIYONLARI
==========================================================*/

/* 5.a.	SYSDATETIME, SYSDATETIMEOFFSET and SYSUTCDATETIME Fonksiyonlarý
		
	Yüksek Hassasiyetli Tarih ve Saat Fonksiyonlarý */

SELECT SYSDATETIME()       AS 'DateAndTime';        -- return datetime2(7)       
SELECT SYSDATETIMEOFFSET() AS 'DateAndTime+Offset'; -- datetimeoffset(7)
SELECT SYSUTCDATETIME()    AS 'DateAndTimeInUtc';   -- returns datetime2(7) - UTC



/* 5.b.  CURRENT_TIMESTAMP, GETDATE() and GETUTCDATE() Fonksiyonlarý

	Daha Az Hassas Veri ve Zaman Fonksiyonlarý */

SELECT CURRENT_TIMESTAMP AS 'DateAndTime'; -- Dikkat! : parantez yok!
SELECT GETDATE()         AS 'DateAndTime';    
SELECT GETUTCDATE()      AS 'DateAndTimeUtc'; 



/* 5.c.	DATENAME Fonksiyonlarý 
	
	Verilen tarih için belirtilen tarih bölümüne karþýlýk gelen bir STRING döndürür */

-- returns nvarchar
SELECT DATENAME(YEAR, GETDATE())        AS 'Year';        
SELECT DATENAME(QUARTER, GETDATE())     AS 'Quarter';     
SELECT DATENAME(MONTH, GETDATE())       AS 'Month Name';       
SELECT DATENAME(DAYOFYEAR, GETDATE())   AS 'DayOfYear';   
SELECT DATENAME(DAY, GETDATE())         AS 'Day';         
SELECT DATENAME(WEEK, GETDATE())        AS 'Week';        
SELECT DATENAME(WEEKDAY, GETDATE())     AS 'Day of the Week';     
SELECT DATENAME(HOUR, GETDATE())        AS 'Hour';        
SELECT DATENAME(MINUTE, GETDATE())      AS 'Minute';      
SELECT DATENAME(SECOND, GETDATE())      AS 'Second';      
SELECT DATENAME(MILLISECOND, GETDATE()) AS 'MilliSecond'; 
SELECT DATENAME(MICROSECOND, GETDATE()) AS 'MicroSecond'; 
SELECT DATENAME(NANOSECOND, GETDATE())  AS 'NanoSecond';  
SELECT DATENAME(ISO_WEEK, GETDATE())    AS 'Week';  



/*	5.d	DATEPART Fonksiyonu 

	Belirtilen tarih bölümüne karþýlýk gelen bir tamsayý döndürür) */

-- returns int
SELECT DATEPART(YEAR, GETDATE())        AS 'Year';        
SELECT DATEPART(QUARTER, GETDATE())     AS 'Quarter';     
SELECT DATEPART(MONTH, GETDATE())       AS 'Month';       
SELECT DATEPART(DAYOFYEAR, GETDATE())   AS 'DayOfYear';   
SELECT DATEPART(DAY, GETDATE())         AS 'Day';         
SELECT DATEPART(WEEK, GETDATE())        AS 'Week';        
SELECT DATEPART(WEEKDAY, GETDATE())     AS 'WeekDay';     
SELECT DATEPART(HOUR, GETDATE())        AS 'Hour';        
SELECT DATEPART(MINUTE, GETDATE())      AS 'Minute';      
SELECT DATEPART(SECOND, GETDATE())      AS 'Second';      
SELECT DATEPART(MILLISECOND, GETDATE()) AS 'MilliSecond'; 
SELECT DATEPART(MICROSECOND, GETDATE()) AS 'MicroSecond'; 
SELECT DATEPART(NANOSECOND, GETDATE())  AS 'NanoSecond';  
SELECT DATEPART(ISO_WEEK, GETDATE())    AS 'Week';      



/*	5.e	DAY, MONTH and YEAR Fonksiyonlarý

		DAY  – belirtilen güne karþýlýk gelen bir tamsayý döndürür
		MONTH– belirtilen aya karþýlýk gelen bir tamsayý döndürür
		YEAR – belirtilen yýla karþýlýk gelen bir tamsayý döndürür */

SELECT DAY(GETDATE())   AS 'Day';                            
SELECT MONTH(GETDATE()) AS 'Month';                       
SELECT YEAR(GETDATE())  AS 'Year';    



/*	5.f. DATEFROMPARTS, DATETIME2FROMPARTS, DATETIMEFROMPARTS, 
		 DATETIMEOFFSETFROMPARTS, SMALLDATETIMEFROMPARTS, TIMEFROMPARTS fonksiyonlarý

DATEFROMPARTS			– belirtilen tarihten itibaren bir tarih döndürür
DATETIME2FROMPARTS		– belirtilen kýsýmdan bir datetime2 döndürür
DATETIMEFROMPARTS		– belirtilen kýsýmdan bir tarih saat döndürür
DATETIMEOFFSETFROMPARTS - belirtilen kýsýmdan bir datetimeoffset döndürür
SMALLDATETIMEFROMPARTS	- belirtilen kýsýmdan küçük bir tarih saati döndürür
TIMEFROMPARTS			- belirtilen bölümden bir zaman döndürür */

SELECT DATEFROMPARTS(2019,1,1)                         AS 'Date';          -- returns date
SELECT DATETIME2FROMPARTS(2019,1,1,6,0,0,0,1)          AS 'DateTime2';     -- returns datetime2
SELECT DATETIMEFROMPARTS(2019,1,1,6,0,0,0)             AS 'DateTime';      -- returns datetime
SELECT DATETIMEOFFSETFROMPARTS(2019,1,1,6,0,0,0,0,0,0) AS 'Offset';        -- returns datetimeoffset
SELECT SMALLDATETIMEFROMPARTS(2019,1,1,6,0)            AS 'SmallDateTime'; -- returns smalldatetime
SELECT TIMEFROMPARTS(6,0,0,0,0)                        AS 'Time';          -- returns time



/*	5.g. DATEDIFF and DATEDIFF_BIG Fonksiyonlarý 

DATEDIFF -	belirtilen tarihler arasýnda geçen tarih veya saat tarih bölümü sýnýrlarýnýn sayýsýný 
			int olarak döndürür.
DATEDIFF_BIG - belirtilen tarihler arasýnda geçen tarih veya saat tarih bölümü sýnýrlarýnýn sayýsýný 
			bigint olarak döndürür. */

--	 Date and Time difference
	  -- year, quarter, month, dayofyear, day, week, hour, minute, 
	  --second, millisecond, microsecond, nanosecond
SELECT DATEDIFF(DAY, 2019-31-01, 2019-01-01)      AS 'DateDif'    -- returns int
SELECT DATEDIFF_BIG(DAY, 2019-31-01, 2019-01-01)  AS 'DateDifBig' -- returns bigint
SELECT DATEDIFF(MILLISECOND, '01-01-2020', '02-01-2020') -- !! DATEDIFF_BIG kullanýlmalýydý çünkü sonuç çok büyük

SELECT DATEDIFF(YEAR, '01-01-2000', '01-01-2020')
SELECT DATEDIFF(MONTH, '01-01-2019', '01-01-2020')
SELECT DATEDIFF(DAY, '01-01-2020', '12-31-2020')
SELECT DATEDIFF(HOUR, '01-01-2020', '01-02-2020')
SELECT DATEDIFF(MINUTE, '07-04-2020', '07-05-2020')
SELECT DATEDIFF(MILLISECOND, '07-04-2020', '07-05-2020') 
SELECT DATEDIFF_BIG(NANOSECOND, '07-04-2020', '07-05-2020')



/*	5.h	DATEADD, EOMONTH, SWITCHOFFSET and TODATETIMEOFFSET Fonksiyonlarý 

DATEADD - tarih bölümünü tarih saat olarak eklenen aralýkla döndürür
EOMONTH – baþlangýç_tarihi türü olarak mahsup ayýnýn son gününü döndürür
SWITCHOFFSET - tarih ve saat farkýný ve saat dilimi farkýný döndürür
TODATETIMEOFFSET - saat dilimi farkýyla tarih ve saati döndürür. */

-- modify date and time
SELECT DATEADD(DAY,1,GETDATE())        AS 'DatePlus1';          -- returns data type of the date argument
SELECT EOMONTH(GETDATE(),1)            AS 'LastDayOfNextMonth'; -- returns start_date argument or date
SELECT SWITCHOFFSET(GETDATE(), -6)     AS 'NowMinus6';          -- returns datetimeoffset
SELECT TODATETIMEOFFSET(GETDATE(), -2) AS 'Offset';             -- returns datetimeoffset



/*	5.i.	ISDATE Fonksiyonu (to Validate Date and Time Values)

ISDATE – int döndürür - Geçerli bir tarih-saat türü ise 1, deðilse 0 döndürür.*/

-- validate date and time - returns int
SELECT ISDATE(GETDATE()) AS 'IsDate'; 
SELECT ISDATE(NULL) AS 'IsDate';


/*===========================================================
6.					SAYI YUVARLAMA FONKSÝYONLARI
=============================================================*/

/*	ROUND = sayýyý istenilen haneye göre yuvarlama
		Positive number rounds on the right side of the decimal point!
		Negative number rounds on the left side of the decimal point!
	FLOOR = sayýyý aþaðýya yuvarlama.
	CEILING = sayýyý yukarýya yuvarlama*/

SELECT ROUND(12.4512,2)		 --sayýyý virgülden sonra 2 haneye yuvarlar.
SELECT FLOOR(12.4512) AS deger -- sayýnýn virgülden sonraki deðerini atarak 12 olarak yuvarlar.
SELECT CEILING(12.4512) AS deger -- sayýnýn virgülden sonraki hanesini yukarý yuvarlar ve 13 elde edilir.


	-- 6.a. ROUND, CEILING and FLOOR Examples for DECIMAL, NUMERIC and FLOAT Data Types

--	Example 1a: Desimal (Ondalýk) veri türü ve çeþitli uzunluk parametreleriyle yuvarlama fonksiyonlarý
DECLARE @value decimal(10,2)
SET @value = 11.05

SELECT ROUND(@value, 1)  -- 11.10
SELECT ROUND(@value, -1) -- 10.00 

SELECT ROUND(@value, 2)  -- 11.05 
SELECT ROUND(@value, -2) -- 0.00 

SELECT ROUND(@value, 3)  -- 11.05
SELECT ROUND(@value, -3) -- 0.00

SELECT CEILING(@value)   -- 12 
SELECT FLOOR(@value)     -- 11 
GO

--	Example 1b:  Numeric (sayýsal) veri türü ile yuvarlama fonksiyonlarý 
DECLARE @value numeric(10,10)
SET @value = .5432167890
SELECT ROUND(@value, 1)  -- 0.5000000000 
SELECT ROUND(@value, 2)  -- 0.5400000000
SELECT ROUND(@value, 3)  -- 0.5430000000
SELECT ROUND(@value, 4)  -- 0.5432000000
SELECT ROUND(@value, 5)  -- 0.5432200000
SELECT ROUND(@value, 6)  -- 0.5432170000
SELECT ROUND(@value, 7)  -- 0.5432168000
SELECT ROUND(@value, 8)  -- 0.5432167900
SELECT ROUND(@value, 9)  -- 0.5432167890
SELECT ROUND(@value, 10) -- 0.5432167890
SELECT CEILING(@value)   -- 1
SELECT FLOOR(@value)     -- 0

--	Example 1c:  Float veri türü ile yuvarlama fonksiyonlarý.
DECLARE @value float(10)
SET @value = .1234567890
SELECT ROUND(@value, 1)  -- 0.1
SELECT ROUND(@value, 2)  -- 0.12
SELECT ROUND(@value, 3)  -- 0.123
SELECT ROUND(@value, 4)  -- 0.1235
SELECT ROUND(@value, 5)  -- 0.12346
SELECT ROUND(@value, 6)  -- 0.123457
SELECT ROUND(@value, 7)  -- 0.1234568
SELECT ROUND(@value, 8)  -- 0.12345679
SELECT ROUND(@value, 9)  -- 0.123456791
SELECT ROUND(@value, 10) -- 0.123456791
SELECT CEILING(@value)   -- 1
SELECT FLOOR(@value)     -- 0



	-- 6.b.	ROUND, CEILING and FLOOR Examples for INTEGER Data Types

-- Example 2a: pozitif bir tamsayý yuvarlama (1 kesinlik deðeri için )
DECLARE @value int
SET @value = 6

SELECT ROUND(@value, 1)  -- 6 - No rounding with no digits right of the decimal point
SELECT CEILING(@value)   -- 6 - Smallest integer value
SELECT FLOOR(@value)     -- 6 - Largest integer value 

-- Example 2b: kesinlik deðeri olarak bir negatif sayýnýn etkilerini görelim
DECLARE @value int
SET @value = 6

SELECT ROUND(@value, 1)  -- 6  - No rounding with no digits right of the decimal point
SELECT ROUND(@value, -1) -- 10 - Rounding up with digits on the left of the decimal point
SELECT ROUND(@value, 2)  -- 6  - No rounding with no digits right of the decimal point 
SELECT ROUND(@value, -2) -- 0  - Insufficient number of digits
SELECT ROUND(@value, 3)  -- 6  - No rounding with no digits right of the decimal point
SELECT ROUND(@value, -3) -- 0  - Insufficient number of digits

-- Example 2c: Bu örnekteki rakamlarý geniþletelim ve ROUND fonksiyonu kullanarak etkilerini görelim.
SELECT ROUND(444,  1) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -1) -- 440  - Rounding down
SELECT ROUND(444,  2) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -2) -- 400  - Rounding down
SELECT ROUND(444,  3) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -3) -- 0    - Insufficient number of digits
SELECT ROUND(444,  4) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -4) -- 0    - Insufficient number of digits

SELECT ROUND(555,  1) -- 555  - No rounding with no digits right of the decimal point
SELECT ROUND(555, -1) -- 560  - Rounding up
SELECT ROUND(555,  2) -- 555  - No rounding with no digits right of the decimal point
SELECT ROUND(555, -2) -- 600  - Rounding up
SELECT ROUND(555,  3) -- 555  - No rounding with no digits right of the decimal point
SELECT ROUND(555, -3) -- 1000 - Rounding up
SELECT ROUND(555,  4) -- 555  - No rounding with no digits right of the decimal point
SELECT ROUND(555, -4) -- 0    - Insufficient number of digits

SELECT ROUND(666,  1) -- 666  - No rounding with no digits right of the decimal point
SELECT ROUND(666, -1) -- 670  - Rounding up
SELECT ROUND(666,  2) -- 666  - No rounding with no digits right of the decimal point
SELECT ROUND(666, -2) -- 700  - Rounding up
SELECT ROUND(666,  3) -- 666  - No rounding with no digits right of the decimal point
SELECT ROUND(666, -3) -- 1000 - Rounding up
SELECT ROUND(666,  4) -- 666  - No rounding with no digits right of the decimal point
SELECT ROUND(666, -4) -- 0    - Insufficient number of digits

-- Example 2d : Negatif bir tamsayý yuvarlayalým ve etkilerini görelim.
SELECT ROUND(-444, -1) -- -440  - Rounding down
SELECT ROUND(-444, -2) -- -400  - Rounding down

SELECT ROUND(-555, -1) -- -560  - Rounding up
SELECT ROUND(-555, -2) -- -600  - Rounding up

SELECT ROUND(-666, -1) -- -670  - Rounding up
SELECT ROUND(-666, -2) -- -700  - Rounding up


