create database Task;
use Task;
create table Department(
	dept_id INT PRIMARY KEY,
    dept_name varchar(50));
    
create table Employee(
	emp_id int primary key,
    emp_name varchar(50),
    salary decimal(10,2),
    hire_date date,
    dept_id int,
    foreign key(dept_id) references Department(dept_id));
    
insert into Department values
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'sales');

INSERT INTO Employee VALUES
(101,'Amit',50000,'2025-01-10',1),
(102,'Rohit',70000,'2024-12-15',2),
(103,'Sneha',60000,'2025-03-20',2),
(104,'Priya',80000,'2024-08-01',3),
(105,'Karan',55000,'2025-04-05',1),
(106,'Neha',90000,'2025-02-18',2),
(107,'Raj',75000,'2024-11-25',4),
(108,'Pooja',65000,'2025-05-12',3),
(109,'Vikas',85000,'2025-01-28',4),
(110,'Anjali',70000,'2025-06-01',2);

-- 1. Top 5 Highest Salary Employees

select * from Employee 
order by salary DESC LIMIT 5;

-- 2. Department Wise Employee Count

SELECT d.dept_name,
       COUNT(e.emp_id) AS employee_count
FROM Department d
JOIN Employee e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 3.find second highest salary

select max(salary) from Employee
where salary<(select max(salary) from Employee);

-- 4. Employees Whose Salary > Department Average Salary

select emp_name,salary,dept_id
from Employee e1
where salary > (
select avg(salary)
from Employee e2
where e1.dept_id = e2.dept_id);

-- 5. Inner Join

select e.emp_id,e.emp_name,d.dept_name
from Employee e
inner join Department d
on e.dept_id=d.dept_id;

-- 6. Left join

select e.emp_id,e.emp_name,d.dept_name
from Employee e
left join Department d
on e.dept_id=d.dept_id;

-- 7. Group By with Having
-- Departments having more than 2 employees.

select dept_id,
count(*)
from Employee 
group by dept_id
having count(*)>2;

-- 8. Employees Hired in Last 6 Months

SELECT *
FROM Employee
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 9. Find Duplicate Records

INSERT INTO Employee VALUES
(111,'Amit',50000,'2025-01-10',1),
(112,'Amit',50000,'2025-01-10',1);
SELECT emp_name,
       salary,
       hire_date,
       dept_id,
       COUNT(*) AS duplicate_count
FROM Employee
GROUP BY emp_name,
         salary,
         hire_date,
         dept_id
HAVING COUNT(*) > 1;

SET SQL_SAFE_UPDATES = 0;

-- 10. Remove Duplicate Records

DELETE e1
FROM Employee e1
JOIN Employee e2
ON e1.emp_name = e2.emp_name
AND e1.salary = e2.salary
AND e1.hire_date = e2.hire_date
AND e1.dept_id = e2.dept_id
AND e1.emp_id > e2.emp_id;

-- TASK:- 2
-- 1. Add Some Data in Existing Table

SELECT emp_id FROM Employee;

insert into Employee values
(113,'Akash',95000,'2025-06-15',2),
(114,'Riya',62000,'2025-05-20',3),
(115,'Sagar',58000,'2025-04-10',4);

-- 2. Window Functions
-- ROW_NUMBER()

-- Assign a unique row number based on salary.

select emp_id,emp_name,salary,row_number() over(order by salary DESC) AS row_num
from Employee;

-- RANK()

select emp_name,salary,rank() over(order by salary DESC)as rank_no
from Employee;

-- DENSE_RANK()

select emp_name,salary, dense_rank() over(order by salary DESC) as dense_rank_no
from Employee;

-- 3. CASE WHEN
-- Employee Salary Category
select emp_name,salary,
	case 
		when salary >= 80000 then 'high salary'
        when salary >= 60000 then 'medium salary'
        else 'low salary'
	end as salary_category
from Employee;

-- 4. Views
-- Create a view to show employee and department details.
create view Employee_details as 
select e.emp_id,e.emp_name,e.salary,d.dept_name 
from Employee e
join Department d
on e.dept_id = d.dept_id;
select * from Employee_details

-- 5. Triggers
-- Create an Audit Table first.

Create Table Employee_Audit (
    audit_id int  AUTO_INCREMENT PRIMARY KEY,
    emp_id int,
    action_type varchar(20),
    action_date Timestamp Default Current_Timestamp
);

-- AFTER INSERT Trigger
-- Whenever a new employee is inserted, store a record in audit table.

DELIMITER $$

CREATE TRIGGER trg_employee_insert
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit(emp_id, action_type)
    VALUES (NEW.emp_id, 'insert');
END$$

DELIMITER ;

INSERT INTO Employee
VALUES (116,'Rahul',72000,'2025-06-20',1);

SELECT * FROM Employee_Audit;

















