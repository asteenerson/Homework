--Create table for employees CSV
CREATE TABLE employees (
	emp_no INT PRIMARY KEY,
	brith_date DATE,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	gender VARCHAR (1),
	hire_date DATE
);
--Import employee CSV
--View table
SELECT * FROM employees;

--Create table for departments CSV
CREATE TABLE departments (
	dept_no VARCHAR(15) PRIMARY KEY,
	dept_name VARCHAR(255)
);

--Import departments CSV
--View table
SELECT * FROM departments;

--Create table for titles CSV
CREATE TABLE titles (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	title VARCHAR(255),
	from_date DATE,
	to_date DATE
);

--Import titles CSV
--View table
SELECT * FROM titles;

--Create table for salaries CSV
CREATE TABLE salaries (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	salary INT,
	from_date DATE,
	to_date DATE
);

--Import salaries CSV
--View table
SELECT * FROM salaries;

--Create table for dept_manager CSV
CREATE TABLE dept_manager (
	dept_no VARCHAR(15),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	from_date DATE,
	to_date DATE
);

--Import dept_manager CSV
--View table
SELECT * FROM dept_manager;

--Create table for dept_emp CSV
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	dept_no VARCHAR(15),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	from_date DATE,
	to_date DATE
);

--Import dept_emp CSV
--View table
SELECT * FROM dept_emp;

-- 1. List the following details of each employee: 
-- employee number, last name, first name, gender, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;

-- 2. List employees who were hired in 1986.
SELECT *
FROM employees
WHERE hire_date >= '1986-01-01' AND hire_date <= '1986-12-31';

-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT d.dept_no, d.dept_name, de.emp_no, e.last_name, e.first_name, e.hire_date, de.to_date 
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN employees e ON de.emp_no = e.emp_no;

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no;

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
SELECT last_name, first_name
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development'; 

-- 8. In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.
SELECT last_name, COUNT (last_name) AS "Count of Last Name"
FROM employees
GROUP BY last_name 
ORDER BY "Count of Last Name" DESC;

--BONUS Epilogue
-- Evidence in hand, you march into your boss's office and present the visualization. 
-- With a sly grin, your boss thanks you for your work. On your way out of the office, 
-- you hear the words, "Search your ID number." You look down at your badge to see that 
-- your employee ID number is 499942.
SELECT * 
FROM employees
WHERE emp_no = 499942;
