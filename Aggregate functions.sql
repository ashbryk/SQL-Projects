-- Aggregate Functions
-- gather data from many rows, aggregate/return a single values

-- COUNT(); count number of rows of attributed column

SELECT 
    *
FROM
    salaries
ORDER BY salary DESC
LIMIT 10;

SELECT 
    COUNT(salary)
FROM
    salaries;
    
-- COUNT(DISTINCT ); number of times unique values are encountered in column

SELECT 
    COUNT(DISTINCT from_date)
FROM
    salaries;
    
-- COUNT(*); returns number of all rows of table, INCLUDING NULL values

SELECT 
    *
FROM
    dept_emp;

SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;
    
-- SUM(); sum all values in column

SELECT 
    SUM(salary)
FROM
    salaries;
    
SELECT SUM(salary)
FROM salaries
WHERE from_date > '1997-01-01';

-- MAX(), MIN()

SELECT 
    MAX(salary)
FROM
    salaries;
    
-- AVG(); average value of all non-null values in a field

SELECT 
    AVG(salary)
FROM
    salaries;
    
-- ROUND(); often applied to values that aggregate functions return

SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries;

SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

-- IF NULLL() COALESCE
-- IF NULL(); 1 argument; only applied to 1 colomn change result/text of NULL results to different value
-- COALESCE(); can insert N arguments into parenthesis

SELECT 
    dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name
FROM
    departments_dup;
    
SELECT 
    dept_no,
    COALESCE(dept_name,
            'Department name not provided') AS dept_name
FROM
    departments_dup;

SELECT 
    dept_no, dept_name, COALESCE(dept_manager, dept_name, 'N/A')
FROM
    departments_dup
ORDER BY dept_no ASC;

SELECT
dept_no,
dept_name,
COALESCE(dept_no, dept_name) AS dept_info
FROM departments_dup;