CREATE TABLE Grades(
  [Student] VARCHAR(50),
  [Subject] VARCHAR(50),
  [Marks]   INT
)
GO
 
INSERT INTO Grades VALUES 
('Jacob','Mathematics',100),
('Jacob','Science',95),
('Jacob','Geography',90),
('Amilee','Mathematics',90),
('Amilee','Science',90),
('Amilee','Geography',100)
GO


select *
from grades

-- PIVOT TABLE EXAMPLE ON DERSNOTLARI DATABASE

SELECT * FROM (
  SELECT
    [Student],
    [Subject],
    [Marks]
  FROM Grades
) StudentResults
PIVOT (
  SUM([Marks])
  FOR [Subject]
  IN (
    [Mathematics],
    [Science],
    [Geography]
  )
) AS PivotTable


-- INSERT ADDITIONAL DATA 

INSERT INTO Grades VALUES 
('Jacob','History',80),
('Amilee','History',90)
GO


-- CREATE PROCEDURE 

CREATE PROCEDURE dbo.DynamicPivotTableInSql
  @ColumnToPivot  NVARCHAR(255),
  @ListToPivot    NVARCHAR(255)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'
    SELECT * FROM (
      SELECT
        [Student],
        [Subject],
        [Marks]
      FROM Grades
    ) StudentResults
    PIVOT (
      SUM([Marks])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 
  EXEC(@SqlStatement)
 
END


-- EXECUTION

EXEC dbo.DynamicPivotTableInSql
  N'Subject'
  ,N'[Mathematics],[Science],[Geography]';


EXEC dbo.DynamicPivotTableInSql
  N'Subject'
  ,N'[Mathematics],[Science],[Geography],[History]';


 EXEC dbo.DynamicPivotTableInSql
 N'Student'
 ,N'[Amilee],[Jacob]';