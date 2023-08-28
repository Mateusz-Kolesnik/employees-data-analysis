-- Data Source:
-- The dataset utilized in this project was sourced 
-- from the [The Business Intelligence Analyst Course 2023]
-- https://www.udemy.com/course/the-business-intelligence-analyst-course-2018/
-- created by 365 Careers

-- The dataset remains unaltered and in its original form, 
-- with no modifications made for the duration of this project.

	-- 	ORIGINAL LICENSE LINES
	--
	--  Sample employee database 
	--  See changelog table for details
	--  Copyright (C) 2007,2008, MySQL AB
	--  
	--  Original data created by Fusheng Wang and Carlo Zaniolo
	--  http://www.cs.aau.dk/TimeCenter/software.htm
	--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
	-- 
	--  Current schema by Giuseppe Maxia 
	--  Data conversion from XML to relational by Patrick Crews
	-- 
	--  This work is licensed under the 
	--  Creative Commons Attribution-Share Alike 3.0 Unported License. 
	--  To view a copy of this license, visit 
	--  http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
	--  Creative Commons, 171 Second Street, Suite 300, San Francisco, 
	--  California, 94105, USA.
	-- 
	--  DISCLAIMER
	--  To the best of our knowledge, this data is fabricated, and
	--  it does not correspond to real people. 
	--  Any similarity to existing people is purely coincidental.
	--
	-- 	END OF ORIGINAL LICENSE LINES

-- Employees Data Analysis

-- Queries answering questions:

-- 1. List of departments with current managers
SELECT d.dept_name,
	   e.first_name,
	   e.last_name,
	   e.gender
FROM departments d
	 JOIN dept_manager dm ON d.dept_no = dm.dept_no
	 JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.to_date = "9999-01-01";

-- 2. Number of employees in each department
SELECT d.dept_name,
	   COUNT(de.emp_no) AS num_of_employees
FROM departments d
	 JOIN dept_emp de on d.dept_no = de.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY d.dept_no;

-- 3. Number of male and female employees hired in years 1985-2002
SELECT YEAR(e.hire_date) AS calendar_year,
	   e.gender,
       COUNT(e.emp_no) AS employees_hired
FROM employees e
GROUP BY calendar_year , e.gender
ORDER BY calendar_year;

-- 4. Average male and female salary in each department, years 1985-2002
SELECT e.gender,
	   d.dept_name,
	   ROUND(AVG(s.salary),2) AS avg_salary,
	   YEAR(s.from_date) AS calendar_year
FROM employees e
	 JOIN salaries s ON e.emp_no = s.emp_no
	 JOIN dept_emp de ON e.emp_no = de.emp_no
	 JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name, e.gender, calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no, gender, calendar_year;

-- 5. Highest earning employee
SELECT e.first_name,
	   e.last_name,
	   s.salary,
	   t.title,
	   d.dept_name
FROM employees e
	 JOIN salaries s ON e.emp_no = s.emp_no
	 JOIN titles t ON e.emp_no = t.emp_no
	 JOIN dept_emp de ON e.emp_no = de.emp_no
	 JOIN departments d ON de.dept_no = d.dept_no
WHERE s.to_date = '9999-01-01' AND t.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 1;

-- 6. Difference between the maximum and minimum earnings for each position
SELECT t.title,
       MIN(s.salary) AS min_salary,
       MAX(s.salary) AS max_salary,
       MAX(s.salary) - MIN(s.salary) AS salary_difference
FROM titles t
	 JOIN salaries s ON t.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' AND t.to_date = '9999-01-01'
GROUP BY t.title
ORDER BY min_salary;