-- Drop Views
DROP VIEW IF EXISTS flight_ms.all_flight_schedules;
DROP VIEW IF EXISTS flight_ms.itinerary;
-- Drop foreign keys from all tables
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_airline_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_usual_aircraft_type_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_origin_airport_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_destination_airport_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_costs DROP CONSTRAINT IF EXISTS flight_costs_flight_number_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_costs DROP CONSTRAINT IF EXISTS flight_costs_aircraft_type_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_costs DROP CONSTRAINT IF EXISTS flight_costs_valid_from_date_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_costs DROP CONSTRAINT IF EXISTS flight_costs_valid_to_date_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_reservations DROP CONSTRAINT IF EXISTS itinerary_reservations_agent_id_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_reservations DROP CONSTRAINT IF EXISTS itinerary_reservations_passenger_id_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_reservations DROP CONSTRAINT IF EXISTS itinerary_reservations_reservation_status_code_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_reservations DROP CONSTRAINT IF EXISTS itinerary_reservations_ticket_type_code_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_reservations DROP CONSTRAINT IF EXISTS itinerary_reservations_travel_class_code_fkey;
ALTER TABLE IF EXISTS flight_ms.payments DROP CONSTRAINT IF EXISTS payments_payment_status_code_fkey;
ALTER TABLE IF EXISTS flight_ms.reservation_payments DROP CONSTRAINT IF EXISTS reservation_payments_reservation_id_fkey;
ALTER TABLE IF EXISTS flight_ms.reservation_payments DROP CONSTRAINT IF EXISTS reservation_payments_payment_id_fkey;
ALTER TABLE IF EXISTS flight_ms.legs DROP CONSTRAINT IF EXISTS legs_flight_number_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_legs DROP CONSTRAINT IF EXISTS itinerary_legs_reservation_id_fkey;
ALTER TABLE IF EXISTS flight_ms.itinerary_legs DROP CONSTRAINT IF EXISTS itinerary_legs_leg_id_fkey;

---Drop tables from the schema
DROP TABLE IF EXISTS flight_ms.itinerary_legs CASCADE;
DROP TABLE IF EXISTS flight_ms.legs;
DROP TABLE IF EXISTS flight_ms.reservation_payments;
DROP TABLE IF EXISTS flight_ms.payments;
DROP TABLE IF EXISTS flight_ms.itinerary_reservations;
DROP TABLE IF EXISTS flight_ms.flight_costs;
DROP TABLE IF EXISTS flight_ms.flight_schedules;
DROP TABLE IF EXISTS flight_ms.ref_calendar;
DROP TABLE IF EXISTS flight_ms.airlines;
DROP TABLE IF EXISTS flight_ms.travel_classes;
DROP TABLE IF EXISTS flight_ms.ticket_codes;
DROP TABLE IF EXISTS flight_ms.payment_statuses;
DROP TABLE IF EXISTS flight_ms.reservation_statuses;
DROP TABLE IF EXISTS flight_ms.airports;
DROP TABLE IF EXISTS flight_ms.booking_agents;
DROP TABLE IF EXISTS flight_ms.passengers;
DROP TABLE IF EXISTS flight_ms.aircrafts;

DROP SCHEMA IF EXISTS flight_ms;

CREATE SCHEMA IF NOT EXISTS flight_ms;

--- Create all tables without foreign keys

CREATE TABLE IF NOT EXISTS flight_ms.passengers (
	passenger_id INT NOT NULL,
	first_name VARCHAR NOT NULL,
	second_name VARCHAR,
	last_name VARCHAR NOT NULL,
	phone_number VARCHAR NOT NULL,
	email_address VARCHAR NOT NULL,
	address_lines VARCHAR NOT NULL,
	state_province_county VARCHAR NOT NULL,
	country VARCHAR NOT NULL,
	other_passenger_details VARCHAR,
	PRIMARY KEY (passenger_id)
);

CREATE TABLE IF NOT EXISTS flight_ms.booking_agents(
	agent_id INT NOT NULL,
	agent_name VARCHAR NOT NULL,
	agent_details VARCHAR,
	PRIMARY KEY (agent_id)
);

CREATE TABLE IF NOT EXISTS flight_ms.airports (
	airport_code INT NOT NULL,
	airport_name VARCHAR NOT NULL,
	airport_location VARCHAR NOT NULL,
	other_details VARCHAR,
	PRIMARY KEY (airport_code)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS flight_ms.reservation_statuses (
	reservation_status_code INT NOT NULL,
	reservation_status VARCHAR NOT NULL,
	PRIMARY KEY (reservation_status_code)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS flight_ms.payment_statuses (
	payment_status_code INT NOT NULL,
	payment_status VARCHAR NOT NULL,
	PRIMARY KEY (payment_status_code)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS flight_ms.ticket_codes (
	ticket_type_code INT NOT NULL,
	ticket_type VARCHAR NOT NULL,
	PRIMARY KEY (ticket_type_code)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS flight_ms.travel_classes (
	travel_class_code INT NOT NULL,
	travel_class VARCHAR NOT NULL,
	PRIMARY KEY (travel_class_code)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS flight_ms.airlines (
	airline_code INT NOT NULL,
	airline_name VARCHAR NOT NULL,
	PRIMARY KEY (airline_code)
);

CREATE TABLE IF NOT EXISTS flight_ms.ref_calendar (
	day_date DATE NOT NULL,
	day_number INT NOT NULL,
	business_day_yn VARCHAR NOT NULL,
	PRIMARY KEY (day_date)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS flight_ms.aircrafts (
	aircraft_type_code INT NOT NULL,
	aircraft_type VARCHAR NOT NULL,
	PRIMARY KEY (aircraft_type_code)
);

--- Tables that reference each other
CREATE TABLE IF NOT EXISTS flight_ms.flight_schedules (
	flight_number INT NOT NULL,
	airline_code INT NOT NULL,
	usual_aircraft_type_code INT NOT NULL,
	origin_airport_code INT NOT NULL,
	destination_airport_code INT NOT NULL,
	departure_date_time TIMESTAMP NOT NULL,
	arrival_date_time TIMESTAMP NOT NULL,
	PRIMARY KEY (flight_number),
	FOREIGN KEY (airline_code) REFERENCES flight_ms.airlines(airline_code),
	FOREIGN KEY (usual_aircraft_type_code) REFERENCES flight_ms.aircrafts(aircraft_type_code),
	FOREIGN KEY (origin_airport_code) REFERENCES flight_ms.airports(airport_code),
	FOREIGN KEY (destination_airport_code) REFERENCES flight_ms.airports(airport_code)
);

CREATE TABLE IF NOT EXISTS flight_ms.flight_costs (
	flight_number INT NOT NULL,
	aircraft_type_code INT NOT NULL,
	valid_from_date DATE NOT NULL,
	valid_to_date DATE NOT NULL,
	flight_cost INT NOT NULL,
	PRIMARY KEY (flight_number, aircraft_type_code, valid_from_date),
	FOREIGN KEY (flight_number) REFERENCES flight_ms.flight_schedules(flight_number),
	FOREIGN KEY (aircraft_type_code) REFERENCES flight_ms.aircrafts(aircraft_type_code),
	FOREIGN KEY (valid_from_date) REFERENCES flight_ms.ref_calendar(day_date),
	FOREIGN KEY (valid_to_date) REFERENCES flight_ms.ref_calendar(day_date)
);

--- Tables associated with reservation and payments
CREATE TABLE IF NOT EXISTS flight_ms.itinerary_reservations (
	reservation_id INT NOT NULL,
	agent_id INT NOT NULL,
	passenger_id INT NOT NULL,
	reservation_status_code INT NOT NULL,
	ticket_type_code INT NOT NULL,
	travel_class_code INT NOT NULL,
	date_reservation_made DATE NOT NULL,
	number_in_party INT NOT NULL,
	PRIMARY KEY (reservation_id),
	FOREIGN KEY (agent_id) REFERENCES flight_ms.booking_agents(agent_id) ON UPDATE CASCADE,
	FOREIGN KEY (passenger_id) REFERENCES flight_ms.passengers(passenger_id) ON UPDATE CASCADE,
	FOREIGN KEY (reservation_status_code) REFERENCES flight_ms.reservation_statuses(reservation_status_code) ON UPDATE CASCADE,
	FOREIGN KEY (ticket_type_code) REFERENCES flight_ms.ticket_codes(ticket_type_code) ON UPDATE CASCADE,
	FOREIGN KEY (travel_class_code) REFERENCES flight_ms.travel_classes(travel_class_code) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS flight_ms.payments (
	payment_id INT NOT NULL,
	payment_status_code INT NOT NULL,
	payment_date DATE NOT NULL,
	payment_amount INT NOT NULL,
	PRIMARY KEY (payment_id),
	FOREIGN KEY (payment_status_code) REFERENCES flight_ms.payment_statuses(payment_status_code) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS flight_ms.reservation_payments (
	reservation_id INT NOT NULL,
	payment_id INT NOT NULL,
	PRIMARY KEY (reservation_id,payment_id),
	FOREIGN KEY (reservation_id) REFERENCES flight_ms.itinerary_reservations(reservation_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (payment_id) REFERENCES flight_ms.payments(payment_id) ON UPDATE CASCADE
);

--- Tables associated with legs
CREATE TABLE IF NOT EXISTS flight_ms.legs (
	leg_id INT NOT NULL,
	flight_number INT NOT NULL,
	origin_airport VARCHAR NOT NULL,
	destination_airport VARCHAR NOT NULL,
	actual_departure_time TIMESTAMP NOT NULL,
	actual_arrival_time TIMESTAMP NOT NULL,
	PRIMARY KEY (leg_id),
	FOREIGN KEY (flight_number) REFERENCES flight_ms.flight_schedules(flight_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS flight_ms.itinerary_legs (
	reservation_id INT NOT NULL,
	leg_id INT NOT NULL,
	PRIMARY KEY (reservation_id,leg_id),
	FOREIGN KEY (reservation_id) REFERENCES flight_ms.itinerary_reservations(reservation_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (leg_id) REFERENCES flight_ms.legs(leg_id) ON UPDATE CASCADE ON DELETE CASCADE
);

---ASSERTIONS

---add date constraint to flight_costs
--- ensure that the "valid to" date is after the "valid from" date
ALTER TABLE flight_ms.flight_costs
ADD CONSTRAINT cost_dates_constraint
CHECK (valid_from_date < valid_to_date)
;

---add time constraint to flight_schedules
---ensure that departure time is before arrival time
ALTER TABLE flight_ms.flight_schedules
ADD CONSTRAINT schedule_time_constraint
CHECK (departure_date_time < arrival_date_time)
;

---add airport constraint to flight_schedules
---ensure that the destination and origin airports are not the same
ALTER TABLE flight_ms.flight_schedules
ADD CONSTRAINT airport_code_constraint
CHECK (destination_airport_code != origin_airport_code)
;

---add time constraint to legs
---ensure that departure time is before arrival time
ALTER TABLE flight_ms.legs
ADD CONSTRAINT valid_leg_time
CHECK (actual_departure_time < actual_arrival_time)
;

---add cost constraint to flight_costs
---ensure that the cost of the flight is not negative
ALTER TABLE flight_ms.flight_costs
ADD CONSTRAINT positive_flight_cost
CHECK (flight_cost > 0);

---add payment constraint to payments
---ensure that the amount of the payment is not negative
ALTER TABLE flight_ms.payments
ADD CONSTRAINT positive_payment_amount
CHECK (payment_amount > 0);

---add party constraint in itinerary_reservations
---ensure that the number ina party is not negative
ALTER TABLE flight_ms.itinerary_reservations
ADD CONSTRAINT positive_number_in_party
CHECK (number_in_party > 0);

---add date constraint to payments
---ensure that the date of a payment is not in the future
ALTER TABLE flight_ms.payments
ADD CONSTRAINT valid_payment_date
CHECK (payment_date <= CURRENT_DATE);

---TRIGGERS
---prevent overlapping periods in flight_costs
CREATE OR REPLACE FUNCTION prevent_overlapping_costs() 
  RETURNS trigger 
AS
$BODY$
BEGIN
    IF EXISTS (
	SELECT * FROM flight_ms.flight_costs
	WHERE flight_number=NEW.flight_number
	AND aircraft_type_code=NEW.aircraft_type_code
	AND (
	(NEW.valid_from_date BETWEEN valid_from_date AND valid_to_date)
	OR
	(NEW.valid_to_date BETWEEN valid_to_date AND valid_from_date)
	)
	) THEN
	RAISE EXCEPTION 'Range must not overlap with exisiting one for flight'
	;
	END IF;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;
	
CREATE OR REPLACE TRIGGER overlap_costs
BEFORE INSERT OR UPDATE ON flight_ms.flight_costs
FOR EACH ROW
EXECUTE FUNCTION prevent_overlapping_costs();

---prevent duplicate reservations by the same passenger

---Insert statements
-- Insert into ref_calendar (First week of February 2025)
INSERT INTO flight_ms.ref_calendar (day_date, day_number, business_day_yn)
VALUES
('2025-02-01', 1, 'N'),
('2025-02-02', 2, 'N'),
('2025-02-03', 3, 'Y'),
('2025-02-04', 4, 'Y'),
('2025-02-05', 5, 'Y');

-- Insert into reservation_statuses
INSERT INTO flight_ms.reservation_statuses (reservation_status_code, reservation_status) 
VALUES
(1, 'Confirmed'),
(2, 'Pending'),
(3, 'Cancelled');

-- Insert into payment_statuses
INSERT INTO flight_ms.payment_statuses (payment_status_code, payment_status)
VALUES
(1, 'Paid'),
(2, 'Pending'),
(3, 'Failed');

-- Insert into ticket_codes
INSERT INTO flight_ms.ticket_codes (ticket_type_code, ticket_type)
VALUES
(1, 'One-Way'),
(2, 'Round-Trip');

-- Insert into travel_classes
INSERT INTO flight_ms.travel_classes (travel_class_code, travel_class)
VALUES
(1, 'Economy'),
(2, 'Business');

-- Insert into airlines
INSERT INTO flight_ms.airlines (airline_code, airline_name)
VALUES
(1, 'Sky Airways'),
(2, 'Global Flights');

-- Insert into aircrafts
INSERT INTO flight_ms.aircrafts (aircraft_type_code, aircraft_type)
VALUES
(1, 'Boeing 737'),
(2, 'Airbus A320');

-- Insert into airports
INSERT INTO flight_ms.airports (airport_code, airport_name, airport_location) 
VALUES
(101, 'JFK International', 'New York'),
(102, 'LAX International', 'Los Angeles'),
(103, 'O''Hare International', 'Chicago');

-- Insert into booking_agents
INSERT INTO flight_ms.booking_agents (agent_id, agent_name, agent_details) VALUES
(1, 'John Doe Travels', 'Premium Travel Agency'),
(2, 'Elite Bookings', 'VIP Travel Services');

-- Insert into flight_schedules
INSERT INTO flight_ms.flight_schedules (flight_number, airline_code, usual_aircraft_type_code, origin_airport_code, destination_airport_code, departure_date_time, arrival_date_time)
VALUES
(1001, 1, 1, 101, 102, '2025-02-01 08:00:00', '2025-02-01 11:00:00'),
(1002, 2, 2, 102, 103, '2025-02-02 09:00:00', '2025-02-02 12:00:00');

-- Insert into flight_costs
INSERT INTO flight_ms.flight_costs (flight_number, aircraft_type_code, valid_from_date, valid_to_date, flight_cost)
VALUES
(1001, 1, '2025-02-01', '2025-02-05', 300),
(1002, 2, '2025-02-01', '2025-02-05', 350);

-- Insert into passengers
INSERT INTO flight_ms.passengers (passenger_id, first_name, last_name, phone_number, email_address, address_lines, state_province_county, country)
VALUES
(201, 'Alice', 'Smith', '1234567890', 'alice@example.com', '123 Elm St', 'NY', 'USA'),
(202, 'Bob', 'Johnson', '2345678901', 'bob@example.com', '456 Oak St', 'CA', 'USA'),
(203, 'Charlie', 'Davis', '3456789012', 'charlie@example.com', '789 Pine St', 'IL', 'USA'),
(204, 'Daniel', 'Evans', '4567890123', 'daniel@example.com', '101 Maple St', 'TX', 'USA'),
(205, 'Emma', 'Wilson', '5678901234', 'emma@example.com', '202 Cedar St', 'FL', 'USA');

-- Insert into itinerary_reservations (Ensuring at least two passengers have multiple legs)
INSERT INTO flight_ms.itinerary_reservations (reservation_id, agent_id, passenger_id, reservation_status_code, ticket_type_code, travel_class_code, date_reservation_made, number_in_party) 
VALUES
(301, 1, 201, 1, 1, 1, '2025-02-01', 1),
(302, 1, 202, 1, 2, 2, '2025-02-01', 2),
(303, 2, 203, 1, 1, 1, '2025-02-02', 1),
(304, 2, 204, 1, 2, 2, '2025-02-02', 1),
(305, 1, 205, 1, 1, 1, '2025-02-02', 1);

-- Insert into payments
INSERT INTO flight_ms.payments (payment_id, payment_status_code, payment_date, payment_amount) VALUES
(401, 1, '2025-02-01', 300),
(402, 1, '2025-02-02', 350),
(403, 1, '2025-02-03', 400);

-- Insert into reservation_payments
INSERT INTO flight_ms.reservation_payments (reservation_id, payment_id) 
VALUES
(301, 401),
(302, 402),
(303, 403);

-- Insert into legs (Ensuring at least two passengers have multiple legs)
INSERT INTO flight_ms.legs (leg_id, flight_number, origin_airport, destination_airport, actual_departure_time, actual_arrival_time)
VALUES
(501, 1001, 'JFK International', 'LAX International', '2025-02-01 08:00:00', '2025-02-01 11:00:00'),
(502, 1002, 'LAX International', 'O''Hare International', '2025-02-02 09:00:00', '2025-02-02 12:00:00'),
(503, 1001, 'JFK International', 'LAX International', '2025-02-03 08:00:00', '2025-02-03 11:00:00');

--Insert into itinerary_legs (Ensuring two passengers have multiple legs)
INSERT INTO flight_ms.itinerary_legs (reservation_id, leg_id) 
VALUES
(301, 501),
(302, 501),
(302, 502),
(303, 503);

---CREATE VIEW FOR CUSTOMER ITINERARY
DROP VIEW IF EXISTS itinerary;
CREATE VIEW itinerary AS
WITH leg_schedules AS (
	SELECT f.flight_number
	,l.origin_airport
	,l.destination_airport
	,l.actual_departure_time
	,l.actual_arrival_time
	,i.reservation_id
	,i.leg_id
	FROM flight_ms.flight_schedules AS f
	JOIN flight_ms.legs AS l ON f.flight_number=l.flight_number
	JOIN flight_ms.itinerary_legs AS i ON l.leg_id=i.leg_id
), ticket_details AS (
	SELECT r.reservation_id
	,r.passenger_id
	,t.ticket_type
	,c.travel_class
	FROM flight_ms.itinerary_reservations AS r
	JOIN flight_ms.ticket_codes AS t ON r.ticket_type_code=t.ticket_type_code
	JOIN flight_ms.travel_classes as c ON r.travel_class_code=c.travel_class_code
)
SELECT leg_schedules.reservation_id,
	leg_schedules.flight_number,
    leg_schedules.origin_airport,
    leg_schedules.destination_airport,
    leg_schedules.actual_departure_time,
    leg_schedules.actual_arrival_time,
    leg_schedules.leg_id,
    ticket_details.passenger_id,
    ticket_details.ticket_type,
    ticket_details.travel_class
FROM leg_schedules
JOIN ticket_details ON leg_schedules.reservation_id=ticket_details.reservation_id
WHERE ticket_details.passenger_id=202
;

SELECT * FROM itinerary;

---Get all customers who have seats on a given flight
WITH passenger_legs AS (
	SELECT p.passenger_id
	,i.leg_id
	,p.first_name
	,p.second_name
	,p.last_name
	FROM flight_ms.passengers AS p
	JOIN flight_ms.itinerary_reservations AS r ON p.passenger_id=r.passenger_id
	JOIN flight_ms.itinerary_legs AS i ON r.reservation_id=i.reservation_id
)
SELECT l.flight_number
	,p.passenger_id
	,p.first_name
	,p.second_name
	,p.last_name
FROM passenger_legs AS p
JOIN flight_ms.legs as l ON p.leg_id=l.leg_id
WHERE l.flight_number=1001
;

---View flight schedules
DROP VIEW IF EXISTS all_flight_schedules;
CREATE VIEW all_flight_schedules AS
SELECT f.flight_number
	,f.departure_date_time
	,f.arrival_date_time
	,o.airport_name AS origin_airport_name
	,o.airport_location AS origin_location
	,d.airport_name AS destination_airport_name
	,d.airport_location AS destination_location
	,l.airline_name
	,c.aircraft_type
FROM flight_ms.flight_schedules AS f
JOIN flight_ms.airports AS o ON f.origin_airport_code=o.airport_code
JOIN flight_ms.airports AS d ON f.destination_airport_code=d.airport_code
JOIN flight_ms.airlines AS l ON f.airline_code=l.airline_code
JOIN flight_ms.aircrafts AS c ON f.usual_aircraft_type_code=c.aircraft_type_code
;

SELECT * FROM all_flight_schedules;

---Get all flights whose arrival and departure times are on time/delayed
WITH flight_data AS (
	SELECT f.flight_number
	,l.origin_airport
	,l.destination_airport
	,f.departure_date_time
	,f.arrival_date_time
	,l.actual_departure_time
	,l.actual_arrival_time
	FROM flight_ms.flight_schedules AS f
	JOIN flight_ms.legs as l ON f.flight_number=l.flight_number
)
SELECT
	d.flight_number
	,d.origin_airport
	,d.destination_airport
	,CASE 
		WHEN departure_date_time < actual_departure_time 
		OR arrival_date_time < actual_arrival_time THEN 'DELAYED'
		ELSE 'ON TIME'
	END AS tracking
FROM flight_data AS d
;

---Calculate total sales for a given flight
-- WITH all_flights AS (
-- 	SELECT
-- 		c.flight_number
-- 		,c.valid_from_date
-- 		,c.valid_to_date
-- 		,c.flight_cost
-- 		,r.reservation_id
-- 		,r.date_reservation_made
-- 		,r.number_in_party
-- 		,ps.payment_status
-- 	FROM flight_ms.flight_costs AS c
-- 	JOIN flight_ms.legs AS l ON c.flight_number=l.flight_number
-- 	JOIN flight_ms.itinerary_legs AS i ON l.leg_id=i.leg_id
-- 	JOIN flight_ms.itinerary_reservations AS r ON i.reservation_id=r.reservation_id
-- 	JOIN flight_ms.reservation_payments AS rp ON r.reservation_id=rp.reservation_id
-- 	JOIN flight_ms.payments AS p ON rp.payment_id=p.payment_id
-- 	JOIN flight_ms.payment_statuses AS ps ON p.payment_status_code=ps.payment_status_code
-- 	WHERE c.flight_number=1001
-- ), get_prices AS (
-- 	SELECT
-- 	FROM all_flights
-- )
WITH paid_flights AS (
	SELECT
		l.flight_number
		,r.reservation_id
		,r.date_reservation_made
		,r.number_in_party
		,ps.payment_status
	FROM flight_ms.legs AS l 
	JOIN flight_ms.itinerary_legs AS i ON l.leg_id=i.leg_id
	JOIN flight_ms.itinerary_reservations AS r ON i.reservation_id=r.reservation_id
	JOIN flight_ms.reservation_payments AS rp ON r.reservation_id=rp.reservation_id
	JOIN flight_ms.payments AS p ON rp.payment_id=p.payment_id
	JOIN flight_ms.payment_statuses AS ps ON p.payment_status_code=ps.payment_status_code
	WHERE l.flight_number=1001
	AND ps.payment_status='PAID'
), with_costs AS (
	SELECT
		pf.flight_number 
		,pf.reservation_id
		,pf.number_in_party 
		,c.flight_cost
	FROM paid_flights AS pf
	JOIN flight_ms.flight_costs AS c ON c.flight_number=pf.flight_number
	WHERE pf.date_reservation_made BETWEEN c.valid_from_date AND c.valid_to_date
), get_prices AS (
	SELECT
		*,
		w.number_in_party * w.flight_cost AS total_paid
	FROM with_costs AS w
)
SELECT
	g.flight_number
	,SUM(total_paid) AS total_sales
FROM get_prices AS g
GROUP BY flight_number
;

