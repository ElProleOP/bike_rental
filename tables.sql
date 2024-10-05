CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    bike_id INTEGER,
    date_key INTEGER REFERENCES date_inf(date_key), 
    user_id INTEGER REFERENCES users(user_id),
    start_station_id INTEGER REFERENCES stations(station_id),
    end_station_id INTEGER REFERENCES stations(station_id),
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    trip_duration INTEGER
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    birth_year INTEGER,
    gender INTEGER,
    age INTEGER,
    user_type VARCHAR(50)
);

CREATE TABLE weather (
    id SERIAL PRIMARY KEY,
    date DATE,
    date_key REFERENCES date_inf(date_key)
    avg_daily_wind_speed FLOAT,
    precipitation FLOAT,
    snowfall FLOAT,
    snow_depth FLOAT,
    avg_temperature INTEGER,
    max_temperature INTEGER,
    min_temperature INTEGER,
    rain BOOLEAN,
    snow BOOLEAN
);

CREATE TABLE date_inf (
    date_key INTEGER PRIMARY KEY,
    date DATE,
    day_of_week INTEGER,
    month INTEGER,
    year INTEGER  
);

CREATE TABLE stations (
    station_id INTEGER PRIMARY KEY,
    station_name VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT
);