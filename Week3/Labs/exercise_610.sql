DROP TABLE IF EXISTS company.employee;
DROP TABLE IF EXISTS company.department;
DROP TABLE IF EXISTS company.dept_locations;
DROP TABLE IF EXISTS company.project;
DROP TABLE IF EXISTS company.works_on;
DROP TABLE IF EXISTS company.dependent;
DROP SCHEMA IF EXISTS company;

CREATE SCHEMA IF NOT EXISTS company;

CREATE TABLE IF NOT EXISTS company.employee (
	Fname VARCHAR NOT NULL,
	Minit VARCHAR,
	Lname VARCHAR NOT NULL,
	Ssn VARCHAR NOT NULL,
	Bdate VARCHAR NOT NULL,
	Address VARCHAR NOT NULL,
	Sex VARCHAR NOT NULL,
	Salary VARCHAR NOT NULL,
	Super_ssn VARCHAR,
	Dno INT,
	PRIMARY KEY (Ssn),
	FOREIGN KEY (Super_ssn) REFERENCES company.employee(Ssn) ON DELETE SET NULL ON CASCADE UPDATE
	FOREIGN KEY (Dno) REFERENCES company.department(Dnumber) ON DELETE SET NULL ON CASCADE UPDATE
);

CREATE TABLE IF NOT EXISTS company.department (
	Dname VARCHAR NOT NULL,
	Dnumber INT NOT NULL,
	Mgr_ssn VARCHAR,
	Mgr_start_date DATE,
	PRIMARY KEY (Dnumber),
	FOREIGN KEY (Mgr_ssn) REFERENCES company.employee(Ssn) ON DELETE SET NULL ON CASCADE UPDATE
);

CREATE TABLE IF NOT EXISTS company.dept_locations (
	Dnumber INT NOT NULL,
	Dlocation VARCHAR NOT NULL,
	FOREIGN KEY (Dnumber) REFERENCES company.department(Dnumber)
);
