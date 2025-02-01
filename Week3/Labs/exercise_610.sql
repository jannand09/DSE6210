ALTER TABLE IF EXISTS company.employee DROP CONSTRAINT IF EXISTS employee_super_ssn_fkey;
ALTER TABLE IF EXISTS company.employee DROP CONSTRAINT IF EXISTS employee_dno_fkey;
ALTER TABLE IF EXISTS company.department DROP CONSTRAINT IF EXISTS department_mgr_ssn_fkey;
ALTER TABLE IF EXISTS company.dept_locations DROP CONSTRAINT IF EXISTS dept_locations_dnumber_fkey;
ALTER TABLE IF EXISTS company.project DROP CONSTRAINT IF EXISTS project_dnum_fkey;
ALTER TABLE IF EXISTS company.works_on DROP CONSTRAINT IF EXISTS works_on_essn_fkey;
ALTER TABLE IF EXISTS company.works_on DROP CONSTRAINT IF EXISTS works_on_pno_fkey;
ALTER TABLE IF EXISTS company.dependent DROP CONSTRAINT IF EXISTS dependent_essn_fkey;

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
	Mgr_ssn INT,
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
	Essn INT NOT NULL,
	Pno INT NOT NULL,
	Hours DECIMAL,
	FOREIGN KEY (Essn) REFERENCES company.employee(Ssn) ON UPDATE CASCADE,
	FOREIGN KEY (Pno) REFERENCES company.project(Pnumber) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS company.dependent (
	Essn INT NOT NULL,
	Dependent_name VARCHAR NOT NULL,
	Sex VARCHAR,
	Bdate DATE NOT NULL,
	Relationship VARCHAR NOT NULL,
	FOREIGN KEY (Essn) REFERENCES company.employee(Ssn) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO company.department
VALUES
('Research',5,NULL,'1988-05-22'),
('Administration',4,NULL,'1995-01-01'),
('Headquarters','1',NULL,'1981-06-19');

INSERT INTO company.employee
VALUES
('James', 'E', 'Borg', 888665555, '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1),
('Jennifer', 'S', 'Wallace',987654321, '1941-06-20','291 Berry, Bellaire, TX','F',43000,NULL,4),
('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring, TX','F',25000,NULL,4),
('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston, TX','M',25000,NULL,4),
('Franklin', 'T','Wong',333445555, '1955-12-08', '638 Voss, Houston, TX', 'M', 40000,NULL, 5),
('John', 'B','Smith', 123456789, '1965-01-09', '731 Fondren, Houston, TX','M', 30000, NULL, 5),
('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble, TX','M',38000,NULL,5),
('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston, TX','F',25000,NULL,4);

UPDATE company.department SET Mgr_ssn = 333445555 WHERE Dnumber=5;
UPDATE company.department SET Mgr_ssn = 987654321 WHERE Dnumber=4;
UPDATE company.department SET Mgr_ssn = 888665555 WHERE Dnumber=1;

UPDATE company.employee SET Super_ssn = 333445555 WHERE Ssn IN (123456789,66688444,453453453);
UPDATE company.employee SET Super_ssn = 987654321 WHERE Ssn IN (999887777,987987987);
UPDATE company.employee SET Super_ssn = 888665555 WHERE Ssn IN (333445555,987654321);

INSERT INTO company.dept_locations
VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

INSERT INTO company.project
VALUES
('ProductX',1,'Bellaire',5),
('ProductY',2,'Sugarland',5),
('ProductZ',3,'Houston',5),
('Computerization',10,'Stafford',4),
('Reorganization',20,'Houston',1),
('Newbenefits',30,'Stafford',4);

INSERT INTO company.works_on
VALUES
(123456789,1,32.5),
(123456789,2,7.5),
(666884444,3,40.0),
(453453453,1,20.0),
(453453453,2,20.0),
(333445555,2,10.0),
(333445555,3,10.0),
(333445555,10,10.0),
(333445555,20,10.0),
(999887777,30,30.0),
(999887777,10,10.0),
(987987987,10,35.0),
(987987987,30,5.0),
(987654321,30,20.0),
(987654321,20,15.0),
(888665555,20,NULL);

INSERT INTO company.dependent
VALUES
(333445555,'Alice','F','1986-04-05','Daughter'),
(333445555,'Theordore','M','1983-10-25','Son'),
(333445555,'Joy','F','1958-05-03','Spouse'),
(987654321,'Abner','M','1942-02-28','Spouse'),
(123456789,'Michael','M','1988-01-04','Son'),
(123456789,'Alice','F','1988-12-30','Daughter'),
(123456789,'Elizabeth','F','1967-05-05','Spouse');
