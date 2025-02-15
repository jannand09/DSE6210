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
DROP TABLE IF EXISTS flight_ms.itinerary_legs;
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
--- insert sample airlines data
INSERT INTO flight_ms.airlines (airline_code, airline_name) VALUES
(1, 'American Airlines'),
(2, 'Delta Airlines'),
(3, 'United Airlines');

--- insert sample airports data
INSERT INTO flight_ms.airports (airport_code, airport_name, airport_location, other_details) VALUES
(100, 'JFK International Airport', 'New York, USA', NULL),
(200, 'Los Angeles International Airport', 'Los Angeles, USA', NULL),
(300, 'O''Hare International Airport', 'Chicago, USA', NULL);

-- insert sample reservation statuses
INSERT INTO flight_ms.reservation_statuses (reservation_status_code, reservation_status) VALUES
(1, 'Pending'),
(2, 'Confirmed'),
(3, 'Cancelled');

-- insert payment statuses
INSERT INTO flight_ms.payment_statuses (payment_status_code, payment_status) VALUES
(1, 'Pending'),
(2, 'Completed'),
(3, 'Failed');

-- insert sample ticket codes
INSERT INTO flight_ms.ticket_codes (ticket_type_code, ticket_type) VALUES
(1, 'Economy'),
(2, 'Business'),
(3, 'First Class');

-- insert sample travel codes
INSERT INTO flight_ms.travel_classes (travel_class_code, travel_class) VALUES
(1, 'Economy'),
(2, 'Business'),
(3, 'First Class');

-- insert sample aircrafts
INSERT INTO flight_ms.aircrafts (aircraft_type_code, aircraft_type) VALUES
(1, 'Boeing 737'),
(2, 'Airbus A320'),
(3, 'Boeing 777');

-- insert sample calendar data
INSERT INTO flight_ms.ref_calendar (day_date, day_number, business_day_yn) VALUES
('2025-02-02', 1, 'N'),
('2025-02-03', 2, 'Y'),
('2025-02-04', 3, 'Y'),
('2025-02-05', 4, 'Y'),
('2025-02-06', 5, 'Y');

-- insert sample data into passengers
INSERT INTO flight_ms.passengers (passenger_id, first_name, second_name, last_name, phone_number, email_address, address_lines, state_province_county, country, other_passenger_details) VALUES
(101, 'John', 'M.', 'Doe', '123-456-7890', 'john.doe@example.com', '123 Main St', 'New York', 'USA', NULL),
(102, 'Jane', NULL, 'Smith', '987-654-3210', 'jane.smith@example.com', '456 Elm St', 'California', 'USA', NULL),
(103, 'Alice', 'L.', 'Johnson', '555-666-7777', 'alice.johnson@example.com', '789 Oak St', 'Illinois', 'USA', NULL);

-- insert sample data into booking_agents
INSERT INTO flight_ms.booking_agents (agent_id, agent_name, agent_details) VALUES
(201, 'Best Travel Agency', NULL),
(202, 'Elite Travels', NULL),
(203, 'Fast Flights', NULL);

-- insert sample data into flight_schedules
INSERT INTO flight_ms.flight_schedules (flight_number, airline_code, usual_aircraft_type_code, origin_airport_code, destination_airport_code, departure_date_time, arrival_date_time) VALUES
(301, 1, 1, 100, 200, '2025-06-01 08:00:00', '2025-06-01 11:00:00'),
(302, 2, 2, 200, 300, '2025-06-02 09:00:00', '2025-06-02 12:00:00'),
(303, 3, 3, 300, 100, '2025-06-03 07:30:00', '2025-06-03 10:30:00');

-- insert sample data into flight_costs
INSERT INTO flight_ms.flight_costs (flight_number, aircraft_type_code, valid_from_date, valid_to_date, flight_cost) VALUES
(301, 1, '2025-02-02', '2025-02-03', 200),
(302, 2, '2025-02-03', '2025-02-04', 300),
(303, 3, '2025-02-04', '2025-02-06', 400);

-- insert sample data into itinerary_reservations
INSERT INTO flight_ms.itinerary_reservations (reservation_id, agent_id, passenger_id, reservation_status_code, ticket_type_code, travel_class_code, date_reservation_made, number_in_party) VALUES
(401, 201, 101, 2, 1, 1, '2025-02-02', 1),
(402, 202, 102, 2, 2, 2, '2025-02-03', 2),
(403, 203, 103, 1, 3, 3, '2025-02-04', 1);

-- insert sample data into payments
INSERT INTO flight_ms.payments (payment_id, payment_status_code, payment_date, payment_amount) VALUES
(501, 2, '2025-02-02', 200),
(502, 2, '2025-02-03', 300),
(503, 1, '2025-02-04', 400);

-- insert sample data into reservation payments
INSERT INTO flight_ms.reservation_payments (reservation_id, payment_id) VALUES
(401, 501),
(402, 502),
(403, 503);

-- insert sample data into legs
INSERT INTO flight_ms.legs (leg_id, flight_number, origin_airport, destination_airport, actual_departure_time, actual_arrival_time) VALUES
(601, 301, 'JFK International Airport', 'Los Angeles International Airport', '2025-06-01 08:10:00', '2025-06-01 11:05:00'),
(602, 302, 'Los Angeles International Airport', 'O''Hare International Airport', '2025-06-02 09:10:00', '2025-06-02 12:05:00'),
(603, 303, 'O''Hare International Airport', 'JFK International Airport', '2025-06-03 07:40:00', '2025-06-03 10:25:00');

-- insert sample data into itinerary_legs
INSERT INTO flight_ms.itinerary_legs (reservation_id, leg_id) VALUES
(401, 601),
(402, 602),
(403, 603);

---CREATE VIEW FOR CUSTOMER ITINERARY
CREATE VIEW itinerary AS
WITH leg_schedules AS (
	SELECT f.flight_number,l.origin_aiport,l.destination_airport,l.actual_departure_time,l.actual_arrival_time,i.reservation_id,i.leg_id
	FROM flight_ms.flight_schedules AS f
	JOIN flight_ms.legs AS l ON f.flight_number=l.flight_number
	JOIN flight_ms.itinerary_legs AS i ON l.leg_id=i.leg_id
) ticket_details AS (
	SELECT r.reservation_id,r.passenger_id,t.ticket_type,c.travel_class
	FROM itinerary_reservations AS r
	JOIN ticket_codes AS t ON r.ticket_type_code=t.ticket_type_code
	JOIN travel_classes as c ON r.travel_class_code=c.travel_class_code
)
SELECT *
FROM leg_schedules
JOIN ticket_details ON leg_schedules_reservation_id=ticket_details
WHERE ticket_details.passenger_id=101