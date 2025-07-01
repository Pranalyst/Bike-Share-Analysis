CREATE DATABASE IF NOT EXISTS divvy_data;
use divvy_data;

CREATE TABLE IF NOT EXISTS divvy_tripdata (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    member_casual VARCHAR(20),
    month INT,
    day_name VARCHAR(20),
    hour INT,
    ride_length FLOAT,
    day_num INT,
    ride_range VARCHAR(20),
    day_date INT,
    source_file VARCHAR(20)
);
SHOW VARIABLES LIKE 'secure_file_priv';


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2025_01.csv'
INTO TABLE divvy_tripdata
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id, rideable_type, member_casual, month, day_name, hour, ride_length, day_num, ride_range, day_date)
SET source_file = '2025_01';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2025_02.csv'
INTO TABLE divvy_tripdata
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id, rideable_type, member_casual, month, day_name, hour, ride_length, day_num, ride_range, day_date)
SET source_file = '2025_02';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2025_03.csv'
INTO TABLE divvy_tripdata
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ride_id, rideable_type, member_casual, month, day_name, hour, ride_length, day_num, ride_range, day_date)
SET source_file = '2025_03';

SELECT * FROM divvy_tripdata LIMIT 100;

-- Total_rides by source_file(month)
SELECT source_file AS month, member_casual, COUNT(*) AS total_rides
FROM divvy_tripdata
GROUP BY source_file, member_casual
ORDER BY source_file;


-- Avg_Ride_len by member type
SELECT member_casual, ROUND(AVG(ride_length), 2) AS avg_ride_length
FROM divvy_tripdata
GROUP BY member_casual;

-- Ride count by hour and user type
SELECT hour, member_casual, COUNT(*) AS total_rides
FROM divvy_tripdata
GROUP BY hour, member_casual
ORDER BY hour;

-- Rides per day of week
SELECT day_name, member_casual, COUNT(*) AS total_rides
FROM divvy_tripdata
GROUP BY day_name, member_casual
ORDER BY FIELD(day_name, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- Bike type preference
SELECT rideable_type, member_casual, COUNT(*) AS total_rides
FROM divvy_tripdata
GROUP BY rideable_type, member_casual;

-- Ride range (time) as per member and casual
SELECT ride_range, member_casual, COUNT(*) AS total_rides
FROM divvy_tripdata
GROUP BY ride_range, member_casual
ORDER BY FIELD(ride_range, 'Under 10', '10 to 50', '50 to 100', 'Over 100');

-- Weekday v/s weekend -> total rides
SELECT 
  CASE 
    WHEN day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
  END AS week_type,
  member_casual,
  COUNT(*) AS total_rides
FROM divvy_tripdata
GROUP BY week_type, member_casual;

-- Longer Rides
SELECT member_casual, COUNT(*) AS long_rides
FROM divvy_tripdata
WHERE ride_length > 30
GROUP BY member_casual;

-- Ride length distribution (Pointing out the outliers)
SELECT member_casual, 
       MIN(ride_length) AS min_ride,
       MAX(ride_length) AS max_ride,
       ROUND(AVG(ride_length), 2) AS avg_ride
FROM divvy_tripdata
GROUP BY member_casual;

-- Top hours for casual riders
SELECT hour, COUNT(*) AS rides
FROM divvy_tripdata
WHERE member_casual = 'casual'
GROUP BY hour
ORDER BY rides DESC
LIMIT 5;

