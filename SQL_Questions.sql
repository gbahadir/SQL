/* Günün sorusu: write a query to get the top 3 employees with the highest salary whose first name's second letter is 'e'. */
SELECT TOP 3 First_Name FROM Employees,
WHERE First_Name LIKE '_e%',
ORDER BY Salaries DESC;

/* Günün sorusu: write a query that extracts first five letters of first_name column from employees table */
SELECT SUBSTRING(first_name,1,5) 
FROM employees;

/**/
SELECT left (first_name,5)
FROM Employees;

-- Günün sorusu: how to delete duplicate rows in sql server?

DELETE FROM ....
WHERE DuplicateCount > 1;

/**/

SELECT Adi,  COUNT(*)
FROM employer
GROUP BY Adi
HAVING COUNT(*) > 1;

-- Günün sorusu: Write a query to access the last record from the employees table?

SELECT * 
FROM EMPLOYEES 
WHERE ID = (SELECT MAX(ID) FROM EMPLOYEES)

----
SELECT TOP 1 * FROM Employees
ORDER BY Id DESC;

-- Günün sorusu: Write a query that shows the values from one table that does not exist in another table in the same database.

SELECT id, first_name, last_name, FROM users1
WHERE id NOT IN
    (SELECT id FROM users2);

----
SELECT a.value
FROM  table_1 a
LEFT JOIN table_2 b
ON a.value= b.value
WHERE b.value IS NULL;

----
SELECT p.Adi, p.SoyAdi
FROM Personeller p
WHERE NOT EXISTS(
	SELECT PersonelID
	FROM Satislar s
	WHERE p.PersonelID = s.PersonelID)

-- Günün sorusu: Write an SQL query to print the FIRST_NAME and LAST_NAME from employees table 
-- into a single column FULL_NAME in uppercase. Use "+" between the first and the last name.

select Upper(First_name) + ' ' + upper(Last_name) [FULL_NAME]
from [sale].[staff]