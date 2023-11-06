-- JOINS
-- construct a relationship between objects
-- pulling data from fields of multiple tables

SELECT * FROM departments_dup;

ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

SELECT * FROM departments_dup;

INSERT INTO departments_dup (dept_name)
VALUES 
('Public Relations');

DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 
INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);

INSERT INTO dept_manager_dup
SELECT * FROM dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES                
(999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');

DELETE FROM dept_manager_dup 
WHERE
    dept_no = 'd001';

SELECT 
    *
FROM
    dept_manager_dup;

-- INNER JOIN
-- all records belonging to joined tables = result set

SELECT * FROM dept_manager_dup ORDER BY dept_no;

SELECT * FROM departments_dup ORDER BY dept_no;

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

SELECT * FROM employees;

SELECT 
    d.emp_no, d.from_date, d.dept_no, e.first_name, e.last_name
FROM
    dept_manager_dup d
        INNER JOIN
    employees e ON d.emp_no = e.emp_no
ORDER BY d.emp_no;

-- Dublicate records; dealing with

INSERT INTO dept_manager_dup
VALUES 
('110228', 'd003', '1992-03-21', '1999-01-01');

INSERT INTO departments_dup
VALUES
('d009', 'Customer Service');

SELECT * FROM dept_manager_dup ORDER BY dept_no;

SELECT * FROM departments_dup ORDER BY dept_no;

-- USE GROUP BY to exclude duplicate values 

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no;

-- LEFT JOIN
-- all matching values from joined tables + all values from left table

DELETE FROM dept_manager_dup
WHERE emp_no = '110228';

DELETE FROM departments_dup
WHERE dept_no = 'd009';

INSERT INTO dept_manager_dup
VALUES
('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES
('d009', 'Customer Service');

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no;

SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM employees e
LEFT JOIN dept_manager d
ON e.emp_no = d.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY d.dept_no DESC, d.emp_no;

-- JOIN + WHERE
-- WHERE used to define the condition(s) that will determine which will
-- be the connecting points between tables

SELECT 
    e.emp_no, e.first_name, e.last_name, s.salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    s.salary > 145000;
    
SELECT * FROM 

set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

SELECT e.first_name, e.last_name, e.hire_date, t.title
FROM employees e
JOIN titles t
ON e.emp_no = t.emp_no
WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovitch'
ORDER BY e.emp_no;

-- CROSS JOIN; take values from certain table, connect them with all values
-- from the tables we want to join it with
-- connects all values, not just those that match
-- can be useful when tables in database are not well connected

SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
ORDER BY dm.emp_no , d.dept_no;

SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;

SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments_dup d
ON dm.dept_no = d.dept_no
WHERE d.dept_no = 'd009';

SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;

-- Aggregate functions with joins

SELECT 
    e.gender, AVG(s.salary) AS average_salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

-- JOINING on more than 2 tables

SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no;

SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE t.title = 'Manager'
ORDER BY e.emp_no;

SELECT 
    d.dept_name, AVG(s.salary)
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING AVG(s.salary) > 60000;

SELECT gender, COUNT(gender)
FROM employees e
JOIN dept_manager m
ON e.emp_no = m.emp_no
GROUP BY gender;

-- UNION
-- UNION ALL

-- SUBQUERIES
-- nesting query inside a query; can have more than 1 subquery
-- most often in the WHERE clause of a SELECT statement

SELECT 
    *
FROM
    dept_manager;
    
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm);
            
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
-- EXISTS; checks whether certain row values are found within subquery
-- returns Boolean value
-- EXISTS faster with larger datasets, IN faster with smaller datasets

SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no)
ORDER BY emp_no;

-- SOME subqueries can be rewritten using joins, subqueries are more efficient
-- inner queries using WHERE clause are more efficient
-- subqueries can enhance code readability

SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no AND title = 'Assistant Engineer');
            
-- subqueries in SELECT
-- subqueries in FROM

SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
    UNION
    SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;

-- SELF JOIN
-- combine rows of a table with other rows of same table
-- using aliases are mandatory

SELECT 
    *
FROM
    emp_manager
ORDER BY emp_manager.emp_no;

SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;
    
-- Views
-- a virtual table whose contents are obtained from an existing table(s)
-- a view into the base table
-- acts as a shortcut for writing the same SELECT statement every time a new
-- request has been made 

SELECT 
    *
FROM
    dept_emp;


SELECT 
    emp_no, to_date, COUNT(emp_no) AS Num
FROM
    dept_emp
GROUP BY emp_no
HAVING Num > 1;

CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
    
SELECT * FROM employees.dept_emp_latest_date;

CREATE OR REPLACE VIEW v_average_manager_salary AS
    SELECT 
        ROUND(AVG(salary), 2)
    FROM
        salaries s
            JOIN
        dept_manager dm ON s.emp_no = dm.emp_no;

SELECT * FROM employees.v_manager_avg_salary;

-- STORED ROUTINES
-- SQL statement(s) that can be stored on the database server 
-- stored procedures;
-- stored functions; user-defined functions, built-in functions in MYSQL

-- stored procedures $$, //

USE employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
SELECT * 
FROM employees 
LIMIT 1000;
END$$
DELIMITER ;

call employees.select_employees();

DELIMITER $$
CREATE PROCEDURE average_employee_salary()
BEGIN
SELECT AVG(salary)
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
LIMIT 1000;
END$$
DELIMITER ;

call employees.average_employee_salary();

-- IN parameter

DELIMITER $$
CREATE PROCEDURE emp_avg_salary(IN p_emp_no INTEGER)
BEGIN
SELECT e.first_name, e.last_name, AVG(s.salary)
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END$$
DELIMITER ;

call employees.emp_avg_salary(11300);

-- IN & OUT parameter
-- out parameter; represent the variable containing the output value of the
-- operation executed by the query of the stored procedure
-- SELECT-INTO structure

DELIMITER $$
CREATE PROCEDURE emp_avg_salary_out(in p_emp_no INTEGER, out p_avg_salary DECIMAL(10,2))
BEGIN 
SELECT AVG(s.salary) INTO p_avg_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END$$
DELIMITER ;

set @p_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @p_avg_salary);
select @p_avg_salary;

DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name VARCHAR(255), in p_last_name VARCHAR(255), out p_emp_no INTEGER)
BEGIN
SELECT e.emp_no INTO p_emp_no
FROM employees e
WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
END$$
DELIMITER ;

set @p_emp_no = 0;
call employees.emp_info('Lillian', 'Fontet', @p_emp_no);
select @p_emp_no;

-- SQL Variables
-- the input value is the argument, the output value is stored as a variable

set @v_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;

set @v_emp_no = 0;
call emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;


-- Functions
-- no OUT parameters, all paramaters are IN
-- RETURN value

USE employees;
DROP FUNCTION IF EXISTS f_emp_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL (10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
DECLARE v_avg_salary DECIMAL(10,2);
SELECT 
    AVG(s.salary)
INTO v_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
RETURN v_avg_salary;
END$$

DELIMITER ;

SELECT f_emp_avg_salary(11300);

DELIMITER $$



CREATE FUNCTION emp_info(p_first_name varchar(255), p_last_name varchar(255)) RETURNS decimal(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
                DECLARE v_max_from_date date;
    DECLARE v_salary decimal(10,2);
SELECT
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;
SELECT
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;
                RETURN v_salary;

END$$

DELIMITER ;

select employees.emp_info('Aruna', 'Journel');

-- stored procedure can have multiple OUT parameters; called by CALL procedure
-- use procedures to deal with INSERT UPDATE DELETE
-- functions can return only a single value; called by SELECT function


