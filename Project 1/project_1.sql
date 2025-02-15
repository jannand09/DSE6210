ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_airline_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_origin_airport_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_destination_aiport_code_fkey;
ALTER TABLE IF EXISTS flight_ms.flight_schedules DROP CONSTRAINT IF EXISTS flight_schedules_usual_aircraft_type_code_fkey;

ALTER TABLE IF EXISTS flight_ms.flight_costs DROP CONSTRAINT IF EXISTS flight_costs_flight_number_fkey;
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

---add date constraint to flight_costs
ALTER TABLE flight_ms.flight_costs
ADD CONSTRAINT cost_dates_constraint
CHECK (valid_from_date < valid_to_date)
;

---add time constraint to flight_schedules
ALTER TABLE flight_ms.flight_schedules
ADD CONSTRAINT schedule_time_constraint
CHECK (departure_date_time < arrival_date_time)
;

---add airport constraint to flight_schedules
ALTER TABLE flight_ms.flight_schedules
ADD CONSTRAINT airport_code_constraint
CHECK (destination_airport_code != origin_airport_code)
;