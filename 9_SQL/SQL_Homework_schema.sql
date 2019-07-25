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
