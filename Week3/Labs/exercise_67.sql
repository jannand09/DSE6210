DROP TABLE IF EXISTS hotels.booking;
DROP TABLE IF EXISTS hotels.guest;
DROP TABLE IF EXISTS hotels.room;
DROP TABLE IF EXISTS hotels.hotel;
DROP SCHEMA IF EXISTS hotels;

CREATE SCHEMA IF NOT EXISTS hotels;

CREATE TABLE IF NOT EXISTS hotels.hotel (
	hotelNo INT NOT NULL,
	hotelName VARCHAR NOT NULL,
	hotelType VARCHAR,
	hotelAddress VARCHAR,
	hotelCity VARCHAR,
	numRoom INT,
	PRIMARY KEY(hotelNo)
	);
	
CREATE TABLE IF NOT EXISTS hotels.room (
	roomNo INT NOT NULL, 
	hotelNo INT NOT NULL,
	roomPrice DECIMAL(7,2),
	PRIMARY KEY (roomNo,hotelNo),
	FOREIGN KEY (hotelNo) REFERENCES hotels.hotel(hotelNo)
);

CREATE TABLE IF NOT EXISTS hotels.guest (
	guestNo INT NOT NULL,
	firstName VARCHAR,
	lastName VARCHAR,
	guestAddress VARCHAR,
	PRIMARY KEY (guestNo)
);

CREATE TABLE IF NOT EXISTS hotels.booking (
	bookingNo INT NOT NULL,
	hotelNo INT NOT NULL,
	guestNo INT NOT NULL,
	checkIn TIMESTAMP NOT NULL,
	checkOut TIMESTAMP NOT NULL,
	roomNo INT NOT NULL,
	PRIMARY KEY (bookingNo),
	FOREIGN KEY (hotelNo) REFERENCES hotels.hotel(hotelNo),
	FOREIGN KEY (guestNo) REFERENCES hotels.guest(guestNo),
	FOREIGN KEY (roomNo,hotelNo) REFERENCES hotels.room(roomNo,hotelNo)
);

INSERT INTO hotels.hotel (hotelno,hotelname,hoteltype,hoteladdress,hotelcity,numroom)
VALUES (101,'Holiday Inn','Business','123 Main Street','Rockwall',86),
(102,'Omni Hotel Dallas','Luxury','404 Briar Street','Dallas',105),
(103,'Radison','All Inclusive','444 Red Street','Heath',100),
(104,'JW Marriot','Luxury','505 Blue Street','New York',540),
(105,'Fairmont','Business','155 Green Street','Rockwall',75),
(106,'Hilton','All Inclusive','101 Fair Street','Rockwall',105),
(107,'Hyatt Regency','Luxury','202 Carter Street','Dallas',400),
(108,'Rockwall Inn','Bed & Breakfast','100 Goliad Street','Rockwall',12);

INSERT INTO hotels.room (roomno, hotelno, roomprice)
VALUES (100,101,123.00),
(101,101,123.00),
(102,101,123.00),
(103,101,183.00),
(100,102,350.00),
(101,102,350.00),
(102,102,350.00),
(103,102,600.00),
(101,103,255.00),
(102,103,285.00),
(201,103,255.00),
(202,103,285.00),
(102,104,455.00),
(202,104,555.00),
(302,104,600.00),
(402,104,1200.00),
(101,105,160.00),
(102,105,160.00),
(103,105,160.00),
(104,105,160.00),
(101,106,275.00),
(102,106,275.00),
(103,106,275.00),
(104,106,275.00),
(101,107,880.00),
(102,107,752.00),
(103,107,805.00),
(104,107,790.00),
(10,108,120.00),
(11,108,125.00);

INSERT INTO hotels.guest (guestno,firstname,lastname,guestaddress)
VALUES (1,'James','Woods','123 Main Street'),
(2, 'Rob','Snyder','303 Harper Street'),
(3, 'Bob','Dole','600 Green Street'),
(4,'Fabio','Lanzoni','200 Brown Street'),
(5,'Perter','Griffin','31 Spooner Street');

INSERT INTO hotels.booking (bookingno,hotelno,guestno,checkin,checkout,roomno)
VALUES (1,102,4,'2017-03-14 01:59:26','2017-03-15 11:01:54',103),
(2,101,1,'2018-03-14 01:59:26','2018-03-15 11:01:54',103),
(3,103,2,'2019-03-14 01:59:26','2019-03-15 11:01:54',102),
(4,104,3,'2020-03-14 01:59:26','2020-03-15 11:01:54',302),
(5,105,4,'2016-03-14 01:59:26','2016-03-15 11:01:54',104),
(6,104,5,'2018-03-14 01:59:26','2018-03-15 11:01:54',102);