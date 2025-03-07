
SELECT json_build_object(
    'passenger_id', MAX(passenger_id),
    'reservation_id', MAX(reservation_id),
    'legs', json_agg(
        json_build_object(
            'flight_number', flight_number,
            'origin_airport', origin_airport,
            'destination_airport', destination_airport,
            'actual_departure_time', actual_departure_time,
            'actual_arrival_time', actual_arrival_time,
            'leg_id', leg_id,
            'ticket_type', ticket_type,
            'travel_class', travel_class
        )
    )
) AS itinerary_json
INTO TEMP TABLE temp_itinerary_json
FROM itinerary
WHERE passenger_id = 202
GROUP BY passenger_id, reservation_id;
 ---must use \copy in SQL shell
\copy temp_itinerary_json TO 'C:/Users/janna/Documents/Merrimack MSDS/DSE6210/Project 1/itinerary_json.json' WITH (FORMAT text, HEADER false);


WITH reservation_data AS (
  SELECT
    ir.reservation_id,
    ir.date_reservation_made,
    ir.number_in_party,
    ba.agent_id,
    ba.agent_name,
    ba.agent_details,
    ir.passenger_id,
    p.first_name,
    p.last_name,
    p.phone_number,
    p.email_address,
    p.address_lines,
    p.state_province_county,
    p.country,
    rs.reservation_status_code,
    rs.reservation_status,
    tt.ticket_type_code,
    tt.ticket_type,
    tc.travel_class_code,
    tc.travel_class
  FROM flight_ms.itinerary_reservations ir
  JOIN flight_ms.booking_agents ba ON ir.agent_id = ba.agent_id
  JOIN flight_ms.passengers p ON ir.passenger_id = p.passenger_id
  JOIN flight_ms.reservation_statuses rs ON ir.reservation_status_code = rs.reservation_status_code
  JOIN flight_ms.ticket_codes tt ON ir.ticket_type_code = tt.ticket_type_code
  JOIN flight_ms.travel_classes tc ON ir.travel_class_code = tc.travel_class_code
),
flight_data AS (
  SELECT
    fs.flight_number,
    fs.airline_code,
    fs.origin_airport_code,
    fs.destination_airport_code,
    fs.departure_date_time,
    fs.arrival_date_time,
    ac.aircraft_type_code,
    ac.aircraft_type,
    fc.flight_cost
  FROM flight_ms.flight_schedules fs
  JOIN flight_ms.aircrafts ac ON fs.usual_aircraft_type_code = ac.aircraft_type_code
  JOIN flight_ms.flight_costs fc ON fs.flight_number = fc.flight_number
),
leg_data AS (
  SELECT
    l.leg_id,
    l.flight_number,
    l.origin_airport,
    l.destination_airport,
    l.actual_departure_time,
    l.actual_arrival_time
  FROM flight_ms.legs l
),
itinerary_leg_data AS (
  SELECT
    il.reservation_id,
    il.leg_id
  FROM flight_ms.itinerary_legs il
),
payment_data AS (
  SELECT
    rp.reservation_id,
    p.payment_id,
    p.payment_status_code,
    ps.payment_status,
    p.payment_date,
    p.payment_amount
  FROM flight_ms.reservation_payments rp
  JOIN flight_ms.payments p ON rp.payment_id = p.payment_id
  JOIN flight_ms.payment_statuses ps ON p.payment_status_code = ps.payment_status_code
)
SELECT
  jsonb_build_object(
    '_id', 'reservation_' || rd.reservation_id,
    'reservation_id', rd.reservation_id,
    'date_reservation_made', rd.date_reservation_made,
    'number_in_party', rd.number_in_party,
    'agent', jsonb_build_object(
      'agent_id', rd.agent_id,
      'agent_name', rd.agent_name,
      'agent_details', rd.agent_details
    ),
    'passenger', jsonb_build_object(
      'passenger_id', rd.passenger_id,
      'first_name', rd.first_name,
      'last_name', rd.last_name,
      'phone_number', rd.phone_number,
      'email_address', rd.email_address,
      'address_lines', rd.address_lines,
      'state_province_county', rd.state_province_county,
      'country', rd.country
    ),
    'reservation_status', jsonb_build_object(
      'reservation_status_code', rd.reservation_status_code,
      'reservation_status', rd.reservation_status
    ),
    'ticket_type', jsonb_build_object(
      'ticket_type_code', rd.ticket_type_code,
      'ticket_type', rd.ticket_type
    ),
    'travel_class', jsonb_build_object(
      'travel_class_code', rd.travel_class_code,
      'travel_class', rd.travel_class
    ),
    'flights', (
      SELECT jsonb_agg(
        jsonb_build_object(
          'flight_number', fd.flight_number,
          'airline', jsonb_build_object(
            'airline_code', fd.airline_code,
            'airline_name', (SELECT airline_name FROM flight_ms.airlines WHERE airline_code = fd.airline_code)
          ),
          'departure', jsonb_build_object(
            'airport', jsonb_build_object(
              'airport_code', fd.origin_airport_code,
              'airport_name', (SELECT airport_name FROM flight_ms.airports WHERE airport_code = fd.origin_airport_code),
              'airport_location', (SELECT airport_location FROM flight_ms.airports WHERE airport_code = fd.origin_airport_code)
            ),
            'date_time', fd.departure_date_time
          ),
          'arrival', jsonb_build_object(
            'airport', jsonb_build_object(
              'airport_code', fd.destination_airport_code,
              'airport_name', (SELECT airport_name FROM flight_ms.airports WHERE airport_code = fd.destination_airport_code),
              'airport_location', (SELECT airport_location FROM flight_ms.airports WHERE airport_code = fd.destination_airport_code)
            ),
            'date_time', fd.arrival_date_time
          ),
          'costs', (
            SELECT jsonb_agg(
              jsonb_build_object(
                'aircraft_type_code', fd.aircraft_type_code,
                'valid_from_date', fc.valid_from_date,
                'valid_to_date', fc.valid_to_date,
                'flight_cost', fc.flight_cost
              )
            )
            FROM flight_ms.flight_costs fc
            WHERE fc.flight_number = fd.flight_number
          ),
          'legs', (
            SELECT jsonb_agg(
              jsonb_build_object(
                'leg_id', ld.leg_id,
                'origin_airport', ld.origin_airport,
                'destination_airport', ld.destination_airport,
                'actual_departure_time', ld.actual_departure_time,
                'actual_arrival_time', ld.actual_arrival_time
              )
            )
            FROM leg_data ld
            JOIN itinerary_leg_data ild ON ld.leg_id = ild.leg_id
            WHERE ild.reservation_id = rd.reservation_id
          )
        )
      )
      FROM flight_data fd
      WHERE fd.flight_number IN (
        SELECT flight_number
        FROM flight_ms.flight_schedules fs
        WHERE fs.flight_number IN (
          SELECT flight_number
          FROM flight_ms.itinerary_legs il
          JOIN flight_ms.itinerary_reservations ir ON il.reservation_id = ir.reservation_id
          WHERE ir.reservation_id = rd.reservation_id
        )
      )
    ),
    'payments', (
      SELECT jsonb_agg(
        jsonb_build_object(
          'payment_id', pd.payment_id,
          'payment_status', jsonb_build_object(
            'payment_status_code', pd.payment_status_code,
            'payment_status', pd.payment_status
          ),
          'payment_date', pd.payment_date,
          'payment_amount', pd.payment_amount
        )
      )
      FROM payment_data pd
      WHERE pd.reservation_id = rd.reservation_id
    )
  ) AS reservation_json
FROM reservation_data rd
GROUP BY rd.reservation_id;
