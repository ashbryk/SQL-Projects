-- Advanced SQL topics

-- Scope = visibility; the region of a computer program where a pehnomenon,
-- such as a variable is considered valid
-- variables can be applied to different scopes (local, session, global)

-- Local Variables
-- only visible in the BEGIN-END block in which it was created
-- DECLARE only used for local variables

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

-- Session Variables
-- session: series of information exchanged interactions, or dialogue, between
-- a computer and a user 
-- sessions begin and terminate at certain points of time 
-- variables are limited to connection that they are made on

SET @s_var1 = 3;

SELECT @s_var1;

-- Global Variables
-- apply to all connections related to a specific server
-- cannot set any variable as global
-- a specific group of pre-definied variables in MySQL is suitable for this;
-- these are called system variables

SET GLOBAL max_connections = 1000;
SET @@global.max_connections = 1;

-- User Defined Variables; set by user manually
-- USERS can defined a local or session variable
-- System Variables; pre-definied on system
--

SET GLOBAL sql_mode='STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- Triggers; type of stored progrem associated w a table; that will be automatically
-- executed when a specific event occurs
-- related to associated table; represented by 1 of 3 DML statements
-- INSERT, UPDATE, DELETE

USE employees;

COMMIT;

# BEFORE INSERT
DELIMITER $$

CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN
IF NEW.salary < 0 THEN
SET NEW.salary = 0;
END IF;
END $$

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    
INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');


# BEFORE UPDATE
DELIMITER $$
CREATE TRIGGER before_salaries_update
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN
IF NEW.salary < 0 THEN
SET NEW.salary = OLD.salary;
END IF;
END $$

DELIMITER ;

UPDATE salaries
SET salary = 98765
WHERE emp_no = '10001'
AND from_date = '2010-06-22';

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';

UPDATE salaries
SET salary = -50000
WHERE emp_no = '10001' AND from_date = '2010-06-22';

-- System definied functions

SELECT SYSDATE();

SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;

DELIMITER $$

-- More complex triggers
-- making automatic updates/triggers to salaries table once a modification is
-- made in the department manager table

CREATE TRIGGER trig_ins_dept_mng
AFTER INSERT ON dept_manager
FOR EACH ROW
BEGIN
DECLARE v_curr_salary int;

SELECT 
    MAX(salary)
INTO v_curr_salary FROM
    salaries
WHERE
    emp_no = NEW.emp_no;

IF v_current_salary IS NOT NULL THEN
UPDATE salaries
SET to_date = SYSDATE()
WHERE emp_no = NEW.emp_no AND to_date = NEW.to_date;

INSERT INTO salaries
VALUES (NEW.emp_no, v_curr_salary + 20000, NEW.from_date, NEW.to_date);
END IF;
END $$

DELIMITER $$

INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%Y-%m-%d'), '9999-01-01');

DELIMITER $$

CREATE TRIGGER hire_date_check
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
IF NEW.hire_date > date_format(SYSDATE(), '%y-%m-%d') 
THEN SET NEW.hire_date = date_format(SYSDATE(), '%y-%m-%d');
END IF;
END $$
DELIMITER ; 

INSERT employees VALUES('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');

SELECT *
FROM employees
ORDER BY emp_no DESC;



 