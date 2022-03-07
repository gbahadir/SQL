-- Foreign Key olusturma 

CREATE TABLE employee
(
	id BIGINT NOT NULL,
	name VARCHAR(20) NULL,
  CONSTRAINT foreignkey_1 FOREIGN KEY (id) REFERENCES departments(id)
);


-- Table or Column Constraints

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

-- Uniqe deger olusturma

 CREATE TABLE employee
(
id BIGINT NOT NULL UNIQUE
name VARCHAR(20) NOT NULL
);
-- Check Constraint

[CONSTRAINT constraint_name]
CHECK [NOT FOR REPLICATION] (expression)

CREATE TABLE departments
(
	id BIGINT NOT NULL,
	name VARCHAR(20) NULL,
	dept_name VARCHAR(20) NULL,
	seniority VARCHAR(20) NULL,
	graduation VARCHAR(20) NULL,
	salary BIGINT NULL,
	hire_date DATE NULL,
        CONSTRAINT pk_1 PRIMARY KEY (id),
        CHECK (salary BETWEEN 40000 AND 100000)
 ) ;

 -- Dfault Constraint
 
 [CONSTRAINT constraint_name]
DEFAULT {constant_expression | niladic-function | NULL}
[FOR col_name];


ALTER TABLE departments
ADD CONSTRAINT def_dept_name DEFAULT ‘HR’ FOR dept_name;
