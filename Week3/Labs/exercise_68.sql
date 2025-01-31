DROP TABLE IF EXISTS lib.book;
DROP TABLE IF EXISTS lib.book_authors;
DROP TABLE IF EXISTS lib.publisher;
DROP TABLE IF EXISTS lib.book_copies;
DROP TABLE IF EXISTS lib.book_loans;
DROP TABLE IF EXISTS lib.library_branch;
DROP TABLE IF EXISTS lib.borrower;
DROP SCHEMA IF EXISTS lib;

CREATE SCHEMA IF NOT EXISTS lib;

CREATE TABLE IF NOT EXISTS lib.publisher (
	Publisher_name VARCHAR NOT NULL,
	Address VARCHAR,
	Phone VARCHAR,
	PRIMARY KEY (Publisher_name)
);

CREATE TABLE IF NOT EXISTS lib.borrower (
	Card_no INT NOT NULL,
	Borrower_name VARCHAR NOT NULL,
	Address VARCHAR NOT NULL,
	Phone VARCHAR NOT NULL,
	PRIMARY KEY (Card_no)
);

CREATE TABLE IF NOT EXISTS lib.library_branch (
	Branch_id INT NOT NULL,
	Branch_name VARCHAR,
	Address VARCHAR,
	PRIMARY KEY (Branch_id)
);

CREATE TABLE IF NOT EXISTS lib.book (
	Book_id INT NOT NULL,
	Title VARCHAR,
	Publisher_name VARCHAR,
	PRIMARY KEY (Book_id),
	FOREIGN KEY (Publisher_name) REFERENCES lib.publisher(Publisher_name) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS lib.book_authors (
	Book_id INT NOT NULL,
	Author_name VARCHAR NOT NULL,
	FOREIGN KEY (Book_id) REFERENCES lib.book(Book_id) ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS lib.book_copies (
	Book_id INT NOT NULL,
	Branch_id INT NOT NULL,
	No_of_copies INT,
	PRIMARY KEY (Book_id, Branch_id),
	FOREIGN KEY (Book_id) REFERENCES lib.book(Book_id) ON UPDATE CASCADE,
	FOREIGN KEY (Branch_id) REFERENCES lib.library_branch(Branch_id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS lib.book_loans (
	Book_id INT NOT NULL,
	Branch_id INT NOT NULL,
	Card_no INT NOT NULL,
	Date_out DATE NOT NULL,
	Due_date DATE NOT NULL,
	FOREIGN KEY (Book_id) REFERENCES lib.book(Book_id) ON UPDATE CASCADE,
	FOREIGN KEY (Branch_id) REFERENCES lib.library_branch(Branch_id) ON UPDATE CASCADE,
	FOREIGN KEY (Card_no) REFERENCES lib.borrower(Card_no)
);


