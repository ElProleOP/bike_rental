CREATE VIEW daily_trips AS
SELECT date_inf.date_key,
    date_inf.date,
    date_inf.month,
    date_inf.day_of_week,
    date_inf.year,
    count(trips.trip_id) AS trips_totals,
    count(users.user_type) filter (where users.user_type = 'Subscriber') as subscriber_trips,
    count(users.user_type) filter (where users.user_type = 'Customer') AS customer_trips,
    count(users.user_type) filter (where users.user_type = 'Unknown')  unknown_trips,
    count(trips.valid_duration) filter (where not trips.valid_duration) AS late_return
   FROM trips
     RIGHT JOIN date_inf ON trips.date_key = date_inf.date_key
     LEFT JOIN users ON trips.user_id = users.user_id
  GROUP BY date_inf.date_key
  ORDER BY date_inf.date_key;


CREATE VIEW daily_info AS
SELECT daily_trips.date_key,
    daily_trips.date,
    daily_trips.month,
    daily_trips.day_of_week,
    daily_trips.year,
    daily_trips.ride_totals,
    daily_trips.subscriber_rides,
    daily_trips.customer_rides,
    daily_trips.unknown_rides,
    daily_trips.late_return,
    weather.precipitation,
    weather.snowfall,
    weather.snow_depth,
    weather.avg_temperature,
    weather.max_temperature,
    weather.min_temperature,
    weather.avg_daily_wind_speed,
    weather.rain,
    weather.snow
    FROM daily_trips
        LEFT JOIN weather ON daily_trips.date_key = weather.date_key
    ORDER BY daily_trips.date_key;

CREATE VIEW monthly_info AS
SELECT date_inf.month,
    ROUND(AVG(daily_trips.trips_totals)) AS avg_trips,
    SUM(daily_trips.trips_totals) AS total_trips,
    ROUND(AVG(daily_trips.subscriber_trips)) AS avg_subscriber_trips,
    SUM(daily_trips.subscriber_trips) AS total_subscriber_trips,
    ROUND(AVG(daily_trips.customer_trips)) AS avg_customer_trips,
        SUM(daily_trips.customer_trips) AS total_customer_trips,
    ROUND(AVG(daily_trips.unknown_trips)) AS avg_unknown_trips,
    SUM(daily_trips.unknown_trips) AS total_unknown_trips,
    ROUND(AVG(daily_trips.late_return)) AS avg_late_return,
    SUM(daily_trips.late_return) AS total_late_return,
    COUNT(daily_info.snow)FILTER (WHERE daily_info.snow) AS total_snow_days,
    COUNT(daily_info.rain)FILTER (WHERE daily_info.rain) AS total_rain_days,
    MAX(daily_info.max_temperature) AS max_temperature,
    MIN(daily_info.avg_temperature) AS min_temperature,
    MAX(daily_info.precipitation) AS max_precipitation
    FROM daily_trips
        LEFT JOIN daily_info ON daily_trips.date_key = daily_info.date_key
    GROUP BY date_inf.month
    ORDER BY date_inf.month;

CREATE VIEW late_return_info AS
SELECT date_inf.date,
    trips.trip_id,
    trips.trip_duration,
    trips.bike_id,
    ( SELECT stations.station_name
          FROM stations
         WHERE trips.start_station_id = stations.id) AS start_location,
    ( SELECT stations.station_name
          FROM stations
         WHERE trips.end_station_id = stations.id) AS end_location,
    ( SELECT users.user_type
          FROM users
        WHERE trips.user_id = users.user_id) AS user_type
    FROM trips
    LEFT JOIN date_inf ON trips.date_key = date_inf.date_key
    WHERE trips.valid_duration = false

