
CREATE SCHEMA IF NOT EXISTS airline;

--- Creat all tbales without foreign keys

CREATE TABLE IF NOT EXISTS airline.passengers (
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

CREATE TABLE IF NOT EXISTS airline.booking_agents(
	agent_id INT NOT NULL,
	agent_name VARCHAR NOT NULL,
	agent_details VARCHAR,
	PRIMARY KEY (agent_id)
);

CREATE TABLE IF NOT EXISTS airline.airports (
	airport_code INT NOT NULL,
	airport_name VARCHAR NOT NULL,
	airport_location VARCHAR NOT NULL,
	other_details VARCHAR
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS airline.reservation_payment_status (
	reservation_status_code INT NOT NULL,
	payment_status_code INT NOT NULL,
	reservation_status VARCHAR NOT NULL,
	payment_status VARCHAR NOT NULL
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS airline.ticket_codes (
	ticket_type_code INT NOT NULL,
	ticket_type VARCHAR NOT NULL,
	PRIMARY KEY (ticket_type_code)
);

--- placeholder table; not outlined in SRS
CREATE TABLE IF NOT EXISTS airline.travel_classes (
	travel_class_code INT NOT NULL,
	travel_class VARCHAR NOT NULL,
	PRIMARY KEY (travel_class_code)
);

CREATE TABLE IF NOT EXISTS airline.ref_calendar (
	day_date DATE NOT NULL,
	day_number INT NOT NULL,
	business_day_yn VARCHAR NOT NULL,
	PRIMARY KEY (day_date)
);

---Self-referential tables
CREATE TABLE IF NOT EXISTS airline.flight_costs (
	flight_number INT NOT NULL,
	aircraft_type_code INT NOT NULL,
	valid_from_date DATE NOT NULL,
	valid_to_date DATE NOT NULL,
	PRIMARY KEY (flight_number),
	PRIMARY KEY (aircraft_type_code),
	PRIMARY KEY (valid_from_date),
	FOREIGN KEY (valid_to_date) REFERENCES airline.flight_costs(valid_from_date) ---probably need to define this constaint after first INSERT
); --- add assertion that valid_to_date must be after valid_from_date
