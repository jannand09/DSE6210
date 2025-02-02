ALTER TABLE IF EXISTS university.section DROP CONSTRAINT IF EXISTS section_course_number_fkey;
ALTER TABLE IF EXISTS university.grade_report DROP CONSTRAINT IF EXISTS grade_report_student_number_fkey;
ALTER TABLE IF EXISTS university.grade_report DROP CONSTRAINT IF EXISTS grade_report_section_identifier_fkey;
ALTER TABLE IF EXISTS university.prerequisite DROP CONSTRAINT IF EXISTS grade_report_course_number_fkey;
ALTER TABLE IF EXISTS university.prerequisite DROP CONSTRAINT IF EXISTS grade_report_prequisite_number_fkey;

DROP TABLE IF EXISTS university.student;
DROP TABLE IF EXISTS university.course;
DROP TABLE IF EXISTS university.section;
DROP TABLE IF EXISTS university.grade_report;
DROP TABLE IF EXISTS university.prerequisite;
DROP SCHEMA IF EXISTS university;

CREATE SCHEMA IF NOT EXISTS university;

CREATE TABLE IF NOT EXISTS university.course (
	Course_name VARCHAR NOT NULL UNIQUE,
	Course_number VARCHAR NOT NULL,
	Credit_hours INT NOT NULL,
	Department VARCHAR NOT NULL,
	PRIMARY KEY (COurse_number)
);

CREATE TABLE IF NOT EXISTS university.student (
	Student_name VARCHAR NOT NULL,
	Student_number INT NOT NULL,
	Student_class INT,
	Major VARCHAR,
	PRIMARY KEY (Student_number)
);

CREATE TABLE IF NOT EXISTS university.section (
	Section_identifier INT NOT NULL,
	Course_number VARCHAR NOT NULL,
	Semester VARCHAR NOT NULL,
	Section_year VARCHAR NOT NULL,
	Instructor VARCHAR,
	PRIMARY KEY (Section_identifier),
	FOREIGN KEY (Course_number) REFERENCES university.course(Course_number) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS university.grade_report (
	Student_number INT NOT NULL,
	Section_identifier INT NOT NULL,
	Grade VARCHAR,
	FOREIGN KEY (Student_number) REFERENCES university.student(Student_number) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Section_identifier) REFERENCES university.section(Section_identifier) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS university.prerequisite (
	Course_number VARCHAR NOT NULL,
	Prequisite_number VARCHAR,
	FOREIGN KEY (Course_number) REFERENCES university.course(Course_number) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Prequisite_number) REFERENCES university.course(Course_number) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO university.student
VALUES
('Smith',17,1,'CS'),
('Brown',8,2,'CS');

INSERT INTO university.course
VALUES
('Intro to Computer Science','CS1310',4,'CS'),
('Data Structures','CS3320',4,'CS'),
('Discrete Mathematics','MATH2410',3,'MATH'),
('Database','CS3380',3,'CS');

INSERT INTO university.section
VALUES
(85,'MATH2410','Fall','07','King'),
(92,'CS1310','Fall','07','Anderson'),
(102,'CS3320','Spring','08','Knuth'),
(112,'MATH2410','Fall','08','Chang'),
(119,'CS1310','Fall','08','Anderson'),
(135,'CS3380','Fall','08','Stone');

INSERT INTO university.grade_report
VALUES
(17,112,'B'),
(17,119,'C'),
(8,85,'A'),
(8,92,'A'),
(8,102,'B'),
(8,135,'A');

INSERT INTO university.prerequisite
VALUES
('CS3380','CS3320'),
('CS3380','MATH2410'),
('CS3320','CS1310');

---Question 6.12

--- Part A
SELECT Course_name
FROM university.course
WHERE Department='CS';

---Part B
SELECT course.Course_name, section.Instructor
FROM university.course
JOIN university.section
ON course.Course_number=section.Course_number
WHERE section.Semester='Fall' AND section.Section_year='08'
ORDER BY Course_name;

---Part C
SELECT
	section.Course_number
	,section.Semester
	,section.Section_year
	,grade_report.Student_number
	,COUNT(*) 
FROM university.section
JOIN university.grade_report
ON section.Section_identifier=grade_report.Section_identifier
WHERE section.Instructor='Anderson'
GROUP BY section.Course_number,section.Semester,section.Section_year
;

---Part D
SELECT
	student.Student_name
	,course.Course_name
	,section.Course_number
	,section.Semester
	,section.Section_year
	,grade_report.Grade
FROM university.student
JOIN university.grade_report ON student.Student_number=grade_report.Student_number
JOIN university.section ON section.Section_identifier=grade_report.Section_identifier
JOIN university.course ON course.Course_number=section.Course_number
WHERE student.Student_class=1 AND student.Major='MATH';