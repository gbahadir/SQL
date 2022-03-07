/* Constraint 2 yerde oluşturabilirsiniz.
Tablo oluşturuken
Tablo oluşturduktan sonra
Tablo oluştururken script daha basit. Örneğin */

CREATE TABLE TableName (
	Col1 int PRIMARY KEY ,
	Col2 nvarchar(50)
);
-- Bu tabloda Col1 alanında primary key constraint i oluşturuldu.
-- Aynı tabloyu ve constraint i şu şekilde de oluşturabilirdik: İlk önce tabloyu create edip sonra primary key i create edebiliriz:

CREATE TABLE TableName (
	Col1 int NOT NULL,
	Col2 nvarchar(50)
);

ALTER TABLE TableName
ADD CONSTRAINT ConstraintName
PRIMARY KEY (Col1)
;