-- INSERT statements; 

SELECT 
    *
FROM
    employees;
    
INSERT INTO employees
(
emp_no,
birth_date,
first_name,
last_name,
gender,
hire_date
) VALUES
(999901, -- Dont need to include INT in quotes!
'1986-04-21',
'John',
'Smith',
'M',
'2011-01-01'
);

INSERT INTO employees
VALUES
(
999903,
'1998-09-14',
'Johnathan',
'Creek',
'M',
'1999-01-01'
);

SELECT 
    *
FROM
    titles
LIMIT 10;

INSERT INTO titles
(
	emp_no,
    title,
    from_date
)
VALUES
(
999903,
'Senior Engineer',
'1997-10-31'
);

-- INSERT INTO SELECT

CREATE TABLE departments_dup
(
dept_no CHAR(4) NOT NULL,
dept_names VARCHAR(40) NOT NULL
);

INSERT INTO departments_dup
(
dept_no,
dept_name
)
SELECT *
FROM departments;

SELECT 
    *
FROM
    departments_dup;
    
INSERT INTO departments
VALUES
(
'd010',
'Business Analysis'
);

-- UPDATE statements TCL Transation Control Language
-- COMMIT statement; saves transation in the database
-- ROLLBACK clause; reverts back to last non-committed state (1 step back)

-- UPDATE statement; update values of existing records in a table
-- SET

USE employees;

UPDATE employees 
SET 
    first_name = 'Stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE
    emp_no = 999901;
    
SELECT *
FROM employees
WHERE emp_no = 999901;

-- ROLLBACK command; 

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

COMMIT;

UPDATE departments_dup 
SET 
    dept_no = 'd011',
    dept_name = 'Quality Control';

ROLLBACK;

COMMIT;

SELECT 
    *
FROM
    departments;
    
COMMIT;

UPDATE departments 
SET 
    dept_name = 'Data Analysis'
WHERE
    dept_no = 'd010';
    
SELECT * FROM departments;

COMMIT;

-- DELETE statement; deleting items from database

SELECT 
    *
FROM
    titles
WHERE
    emp_no = 999903;

DELETE FROM employees 
WHERE
    emp_no = 999903;

-- ON DELETE CASCADE
-- if value from parent tables primary key has been deleted,
-- all records from child tables referring to this value will be removed

ROLLBACK;

-- DROP, TRUNCATE, DELETE
-- DROP; drop data, table structure, can't rollback, drop = all gone
-- TRUNCATE; remove all records from table, keep table structure
-- DELETE; 

