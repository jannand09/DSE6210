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
	Ssn INT NOT NULL,
	Bdate VARCHAR NOT NULL,
	Address VARCHAR NOT NULL,
	Sex VARCHAR NOT NULL,
	Salary VARCHAR NOT NULL,
	Super_ssn INT,
	Dno INT,
	PRIMARY KEY (Ssn),
	FOREIGN KEY (Super_ssn) REFERENCES company.employee(Ssn) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS company.department (
	Dname VARCHAR NOT NULL,
	Dnumber INT NOT NULL,
	Mgr_ssn VARCHAR,
	Mgr_start_date DATE,
	PRIMARY KEY (Dnumber),
	FOREIGN KEY (Mgr_ssn) REFERENCES company.employee(Ssn) ON DELETE SET NULL ON UPDATE CASCADE
);

ALTER TABLE IF EXISTS company.employee
ADD FOREIGN KEY (Dno) REFERENCES company.department(Dnumber) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS company.dept_locations (
	Dnumber INT NOT NULL,
	Dlocation VARCHAR NOT NULL,
	FOREIGN KEY (Dnumber) REFERENCES company.department(Dnumber)
);

CREATE TABLE IF NOT EXISTS company.project (
	Pname VARCHAR NOT NULL,
	Pnumber INT NOT NULL,
	Plocation VARCHAR NOT NULL,
	Dnum INT NOT NULL,
	PRIMARY KEY (Pnumber),
	FOREIGN KEY (Dnum) REFERENCES company.department(Dnumber) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS company.works_on (
	Essn VARCHAR NOT NULL,
	Pno INT NOT NULL,
	Hours INT,
	FOREIGN KEY (Essn) REFERENCES company.employee(Ssn) ON UPDATE CASCADE,
	FOREIGN KEY (Pno) REFERENCES company.project(Pnumber) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS company.dependent (
	Essn INT NOT NULL,
	Dependent_name VARCHAR NOT NULL,
	Sex VARCHAR,
	Bdate DATE NOT NULL,
	Relationship VARCHAR NOT NULL,
	PRIMARY KEY (Dependent_name),
	FOREIGN KEY (Essn) REFERENCES company.employee(Ssn) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO company.employee
VALUES
('James', 'E', 'Borg', 888665555, '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1),
('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20','291 Berry, Bellaire, TX','F',43000,88866555,4),
('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring, TX','F',25000,987654321,4),
('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston, TX','M',25000,987654321,4),
('Franklin', 'T','Wong',333445555, '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, 888665555, 5),
('John', 'B','Smith', 123456789, '1965-01-09', '731 Fondren, Houston, TX','M', 30000, 333445555, 5),
('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble, TX','M',38000,333445555,5),
('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston, TX','F',25000,987654321,4)