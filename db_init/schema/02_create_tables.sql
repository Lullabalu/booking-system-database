CREATE TABLE IF NOT EXISTS campus.building (
  building_id SERIAL PRIMARY KEY,
  name VARCHAR(100) not null,
  address VARCHAR(100) not null
);

CREATE TABLE IF NOT EXISTS campus.room (
  room_id SERIAL PRIMARY KEY,
  building_id INT not null references campus.building (building_id),
  room_number VARCHAR(20) not null,
  capacity INT not null check (capacity > 0),
  floor INT not null,
  type VARCHAR(50) not null check (type in ('lecture', 'seminar', 'lab')),
  UNIQUE (building_id, room_number)
);

CREATE TABLE IF NOT EXISTS campus.users (
  user_id SERIAL PRIMARY KEY,
  full_name VARCHAR(150) not null,
  role VARCHAR(50) not null check (role in ('student', 'seminarist', 'lector', 'assistant')),
  phone VARCHAR(20) not null unique,
  email VARCHAR(100) not null unique
);

create table if not exists campus.purpose (
	purpose_id serial primary key,
	purpose_name VARCHAR(100) not null
);

create table if not exists campus.equipment (
	equipment_id serial primary key,
	equipment_name VARCHAR(100) not null unique 
);

create table if not exists campus.booking (
	booking_id serial primary key,
	room_id INT not null references campus.room (room_id),
	user_id INT not null references campus.users (user_id),
	purpose_id INT not null references campus.purpose (purpose_id),
	start_at timestamp not null,
	end_at timestamp not null check (end_at > start_at),
	status VARCHAR(30) not null check (status in ('active', 'cancelled', 'completed'))
);

CREATE TABLE IF NOT EXISTS campus.room_equipment (
    room_id INT not null REFERENCES campus.room (room_id),
    equipment_id INT not null REFERENCES campus.equipment (equipment_id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (room_id, equipment_id)
);
