

-- Sutunlarin metadatasini getirir

exec sys.sp_columns 'product'; 

-- Product tablosunun sütun isimlerini ve özelliklerini listeleyiniz.

exec sys.sp_columns 'product.product'; -- Bos tablo gelir

exec sys.sp_columns 'product', 'product';  -- Bu calisir

-- Orter_item tablosunun sütun isimlerini ve özelliklerini listeleyiniz.

exec sys.sp_columns 'order_item';  

exec sys.sp_columns @table_name = 'product', @column_name = model_year; -- parametreleri bu şekilde de kullanabiliyoruz, pythondaki gibi

-------------------
-- sys.sp_columns'a sag tiklayip Modify'i secince kodlari gelir:

USE [SampleRetail]
GO
/****** Object:  StoredProcedure [sys].[sp_columns]    Script Date: 19.03.2022 09:39:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [sys].[sp_columns]
(
    @table_name         nvarchar(384),
    @table_owner        nvarchar(384) = null,
    @table_qualifier    sysname = null,
    @column_name        nvarchar(384) = null,
    @ODBCVer            int = 2
)
as
    declare @full_table_name    nvarchar(769) -- 384 + 1 + 384
    declare @table_id           int
    declare @fUsePattern        bit

    select @fUsePattern = 1

    if (@ODBCVer is null) or (@ODBCVer <> 3)
        select @ODBCVer = 2

    if @table_qualifier is not null
    begin
        if db_name() <> @table_qualifier
        begin   -- If qualifier doesn't match current database
            raiserror (15250, -1,-1)
            return
        end
    end

    -- "ALL" is represented by NULL value.
    if @table_name = '%'
        select @table_name = null
    if @table_owner = '%'
        select @table_owner = null
    if @table_qualifier = '%'
        select @table_qualifier = null
    if @column_name = '%'
        select @column_name = null

    -- Empty string means nothing, so use invalid identifier.
    -- A quoted space will never match any object name.
    if @table_owner = ''
        select @table_owner = ' '

    select @full_table_name = isnull(quotename(@table_owner), '') + '.' + isnull(quotename(@table_name), '')
    select @table_id = object_id(@full_table_name)

    if (@fUsePattern = 1) -- Does the user want it?
    begin
        if ((isnull(charindex('%', @full_table_name),0) = 0) and
            (isnull(charindex('_', @full_table_name),0) = 0) and
            (isnull(charindex('[', @table_name),0) = 0) and
            (isnull(charindex('[', @table_owner),0) = 0) and
            (isnull(charindex('%', @column_name),0) = 0) and
            (isnull(charindex('_', @column_name),0) = 0) and
            (@table_id <> 0))
        begin
            select @fUsePattern = 0 -- not a single wild char, so go the fast way.
        end
    end

    if @fUsePattern = 0
    begin
        /* -- Debug output, do not remove it.
        print '*************'
        print 'No pattern matching.'
        print @fUsePattern
        print isnull(convert(sysname, @table_id), '@table_id = null')
        print isnull(@full_table_name, '@full_table_name = null')
        print isnull(@table_owner, '@table_owner = null')
        print isnull(@table_name, '@table_name = null')
        print isnull(@column_name, '@column_name = null')
        print '*************'
        */
        select
            TABLE_QUALIFIER             = s_cov.TABLE_QUALIFIER,
            TABLE_OWNER                 = s_cov.TABLE_OWNER,
            TABLE_NAME                  = s_cov.TABLE_NAME,
            COLUMN_NAME                 = s_cov.COLUMN_NAME,
            DATA_TYPE                   = s_cov.DATA_TYPE_28,
            TYPE_NAME                   = s_cov.TYPE_NAME_28,
            "PRECISION"                 = s_cov.PRECISION_28,
            "LENGTH"                    = s_cov.LENGTH_28,
            SCALE                       = s_cov.SCALE_90,
            RADIX                       = s_cov.RADIX,
            NULLABLE                    = s_cov.NULLABLE,
            REMARKS                     = s_cov.REMARKS,
            COLUMN_DEF                  = s_cov.COLUMN_DEF,
            SQL_DATA_TYPE               = s_cov.SQL_DATA_TYPE_28,
            SQL_DATETIME_SUB            = s_cov.SQL_DATETIME_SUB_90,
            CHAR_OCTET_LENGTH           = s_cov.CHAR_OCTET_LENGTH_28,
            ORDINAL_POSITION            = s_cov.ORDINAL_POSITION,
            IS_NULLABLE                 = s_cov.IS_NULLABLE,
            SS_DATA_TYPE                = s_cov.SS_DATA_TYPE

        from
            sys.spt_columns_odbc_view s_cov

        where
            s_cov.object_id = @table_id -- (2nd) (@table_name is null or o.name like @table_name)
            -- (2nd) and (@table_owner is null or schema_name(o.schema_id) like @table_owner)
            and (@column_name is null or s_cov.COLUMN_NAME = @column_name) -- (2nd)             and (@column_name is NULL or c.name like @column_name)
            and s_cov.ODBCVER = @ODBCVer
            and s_cov.OBJECT_TYPE <> 'TT'
            and ( s_cov.SS_IS_SPARSE = 0 OR objectproperty ( s_cov.OBJECT_ID, 'tablehascolumnset' ) = 0 )
        order by 17
    end
    else
    begin
        /* -- Debug output, do not remove it.
        print '*************'
        print 'THERE IS pattern matching!'
        print @fUsePattern
        print isnull(convert(sysname, @table_id), '@table_id = null')
        print isnull(@full_table_name, '@full_table_name = null')
        print isnull(@table_owner, '@table_owner = null')
        print isnull(@table_name, '@table_name = null')
        print isnull(@column_name, '@column_name = null')
        print '*************'
    */
        select
            TABLE_QUALIFIER             = s_cov.TABLE_QUALIFIER,
            TABLE_OWNER                 = s_cov.TABLE_OWNER,
            TABLE_NAME                  = s_cov.TABLE_NAME,
            COLUMN_NAME                 = s_cov.COLUMN_NAME,
            DATA_TYPE                   = s_cov.DATA_TYPE_28,
            TYPE_NAME                   = s_cov.TYPE_NAME_28,
            "PRECISION"                 = s_cov.PRECISION_28,
            "LENGTH"                    = s_cov.LENGTH_28,
            SCALE                       = s_cov.SCALE_90,
            RADIX                       = s_cov.RADIX,
            NULLABLE                    = s_cov.NULLABLE,
            REMARKS                     = s_cov.REMARKS,
            COLUMN_DEF                  = s_cov.COLUMN_DEF,
            SQL_DATA_TYPE               = s_cov.SQL_DATA_TYPE_28,
            SQL_DATETIME_SUB            = s_cov.SQL_DATETIME_SUB_90,
            CHAR_OCTET_LENGTH           = s_cov.CHAR_OCTET_LENGTH_28,
            ORDINAL_POSITION            = s_cov.ORDINAL_POSITION,
            IS_NULLABLE                 = s_cov.IS_NULLABLE,
            SS_DATA_TYPE                = s_cov.SS_DATA_TYPE

        from
            sys.spt_columns_odbc_view s_cov

        where
            s_cov.ODBCVER = @ODBCVer and
            s_cov.OBJECT_TYPE <> 'TT' and
            (@table_name is null or s_cov.TABLE_NAME like @table_name) and
            (@table_owner is null or schema_name(s_cov.SCHEMA_ID) like @table_owner) and
            (@column_name is null or s_cov.COLUMN_NAME like @column_name) and
            ( s_cov.SS_IS_SPARSE = 0 OR objectproperty ( s_cov.OBJECT_ID, 'tablehascolumnset' ) = 0 )

        order by 2, 3, 17
    end
	-----------------------------------



---- USER DEFINED PROCEDURES ----

select	top 1 *
from	sale.orders
order by order_id desc
;

-- Yukarıdaki sorguyu döndüren prosedürü oluşturup exec komutu ile çalıştırınız
/*
create procedure ......
as
;
*/

-- Yeni bir fonksiyon olusturalim. 
-- Bu procedure stored procedures altina kaydedilir ve her cagrildiginda (exec) calisir 

create procedure usp_thelastorder
AS
	select	top 1 *
	from	sale.orders
	order by order_id desc
	;
	;
exec usp_thelastorder
; 

create OR alter procedure usp_thelastorder  -- Bu isimde prosedur varsa degistirir, yoksa olusturur
AS
	select	top 1 *
	from	sale.orders
	order by order_id desc
	;
	;
exec usp_thelastorder
; 

-- Bugünün tarihi: '2020-04-29'
-- Bugün yapılan toplam sipariş sayısını getiren prosedür

create procedure usp_datecount
AS
select  order_date, count(order_id)
from    sale.orders
WHERE order_date = '2020-04-29'
GROUP by    order_date
;
;
exec usp_datecount
;
; 

-- Girdiğimiz tarihte yapılan toplam sipariş sayısını getiren bir prosedür yazınız.

create procedure usp_datecount2 
(@tarih DATE)  -- girilmesi istenen data ismini @ ile baslayip yaziyoruz sonra data tipini yaziyoruz

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date = @tarih
GROUP by    order_date
;

exec usp_datecount2 '2020-04-04' -- proseduru calistirirken yanina istedigimiz taihi giriyoruz
;

exec usp_datecount2 '2020-04-01'

-- iki tarih arasindaki toplam siparis sayilarini getiririn

create procedure usp_datecount3
(@tarih1 DATE, @tarih2 DATE)
AS
select  order_date, count(order_id)
from    sale.orders
WHERE order_date between @tarih1 and @tarih2
GROUP by    order_date
;

exec usp_datecount3 '2020-04-01', '2020-04-06'


---- PARAMETRELER ----

DECLARE @param1 DATE  -- parametreyi tanimladik

SET @param1 = '2020-04-28'  -- parametreye deger atadik  

select	*
from	sale.orders
where	order_date = @param1  -- hepsini calistirmaliyiz
;

-- Select blogu icinde parametrelerin atanmasi

DECLARE @param1 DATE, @param2 INT

SET @param1 = '2020-04-29'

select	count(*)
from	sale.orders
where	order_date = @param1

---

DECLARE @param1 DATE, @param2 INT

SET @param1 = '2020-04-29'

SET @param2 = (
	select	count(*)
	from	sale.orders
	where	order_date = @param1
)
print @param2
;


-- Girdiğimiz tarihte yapılan toplam sipariş sayısını getiren bir prosedür yazınız.
-- Print komutunu kullanınız.

create procedure usp_datecount4
(@tarih DATE)

AS

DECLARE @param INT

select  @param = count(order_id)
from    sale.orders
WHERE order_date = @tarih
GROUP by    order_date

print @param
;

exec usp_datecount4 '2020-04-04'
;

---- FUNCTIONS ----

select len('abc');  -- table value function

print len('abc');  --  scalar value function

-- Girilen yaziyi buyuk harflere ceviren fonksiyon yazalim

create function udf_upper 
(@param nvarchar(max))

RETURNS nvarchar(max)

AS

BEGIN
	return upper(@param)
END;

select	dbo.udf_upper('abc')
;

---
print upper('abc');  -- text olarak albiliriz

-- Bir harfin sesli mi sessiz mi olduğunu döndüren fonksiyon yazınız.

DECLARE @harf char(1)

SET @harf = 'a'

if @harf in ('a', 'e', 'ı', 'i', 'o', 'ö', 'u', 'ü')
	print 'sesli harf'
else if @harf in ('b', 'c', 'ç', 'd', 'f', 'g', 'ğ', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', 'ş', 't', 'v', 'y', 'z')
	print 'sessiz harf'
else
	print 'Lütfen Türkçe bir harf yazınız.'
;

---

CREATE FUNCTION udf_sesli
(@harf NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)

BEGIN 

    if @harf in ('a', 'e', 'ı', 'i', 'o', 'ö', 'u', 'ü')
       SET @harf =   'sesli harf'
    else if @harf in ('b', 'c', 'ç', 'd', 'f', 'g', 'ğ', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', 'ş', 't', 'v', 'y', 'z')
       SET @harf =  'sessiz harf'
    else
       SET @harf =   'Lütfen Türkçe bir harf yazınız.'

    RETURN @harf
END;

select	dbo.udf_sesli('a');

-- 1 2 3 4 5 6 7 8 9 
-- Girdiğimiz rakama kadar tüm rakamların toplamını döndüren bir kod yazınız.

DECLARE @input INT,
		@counter INT,
		@sonuc INT

SET @input = 10
SET @counter = 1
SET @sonuc = 0

while @counter <= @input  -- while kosulundan sonra calisacak kodlari BEGIN ve END arasina yazacagiz.
	BEGIN
		set @sonuc = @sonuc + @counter
		set @counter = @counter + 1
	END;

print @sonuc; 

-- Bu ifadeyi fonksiyon olarak calistiralim

CREATE FUNCTION udf_SumOfNum
(@input INT)

RETURNS INT
as
BEGIN
DECLARE 
		@counter INT,
		@sonuc INT

SET @counter = 1
SET @sonuc = 0

while @counter <= @input  
	BEGIN
		set @sonuc = @sonuc + @counter
		set @counter = @counter + 1
	END;

RETURN @sonuc; 
END

SELECT dbo.udf_SumOfNum(10)

-- Girilen sayinin faktoriyel carpim veren fonksiyon

CREATE FUNCTION udf_Mult_factoriyel
(@input INT)

RETURNS INT
AS BEGIN
DECLARE 
	@counter INT = 1,
	@sonuc INT = 1

-- SET @counter = 1
-- SET @sonuc = 1

WHILE @counter <= @input  
	BEGIN
		SET @sonuc = @sonuc * @counter
		SET @counter  += 1
	END;

RETURN @sonuc; 
END

SELECT dbo.udf_Mult_factoriyel(5)