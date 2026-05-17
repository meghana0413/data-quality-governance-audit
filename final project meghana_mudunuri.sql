-- create DB and use it
DROP DATABASE IF EXISTS finalproject;
CREATE DATABASE finalproject;
USE finalproject;

-- DATE DIM
CREATE TABLE DateDim (
    dateID INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    year INT,
    month INT,
    day INT,
    dayOfWeek VARCHAR(10)
);

-- AGENCY DIM
CREATE TABLE AgencyDim (
    agencyID INT AUTO_INCREMENT PRIMARY KEY,
    agencyCode VARCHAR(20),
    agencyName VARCHAR(255),
    agencyShort VARCHAR(50),
    UNIQUE(agencyCode, agencyShort)
);

-- WEATHER DIM (daily aggregated)
CREATE TABLE WeatherDim (
    weatherID INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    temp_max DECIMAL(6,2),
    temp_min DECIMAL(6,2),
    temp_avg DECIMAL(6,2),
    total_precip DECIMAL(6,2),
    precip_type VARCHAR(50),
    humidity_avg DECIMAL(6,2),
    windspeed_avg DECIMAL(6,2),
    windgust_avg DECIMAL(6,2),
    cloudcover_avg DECIMAL(6,2),
    visibility_avg DECIMAL(6,2),
    uvindex_max INT,
    conditions VARCHAR(255)
);

-- VIOLATION FACT TABLE
CREATE TABLE ViolationFact (
    violationID INT AUTO_INCREMENT PRIMARY KEY,
    objectID BIGINT,
    location VARCHAR(255),
    xcoord DECIMAL(12,4),
    ycoord DECIMAL(12,4),
    issue_date DATE,
    issue_time VARCHAR(10),
    violation_code VARCHAR(20),
    violation_desc VARCHAR(255),
    plate_state VARCHAR(10),
    accident_indicator VARCHAR(10),
    fine_amount DECIMAL(10,2),
    total_paid DECIMAL(10,2),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    dateID INT,
    agencyID INT,
    weatherID INT,
    CONSTRAINT fk_date FOREIGN KEY (dateID) REFERENCES DateDim(dateID),
    CONSTRAINT fk_agency FOREIGN KEY (agencyID) REFERENCES AgencyDim(agencyID),
    CONSTRAINT fk_weather FOREIGN KEY (weatherID) REFERENCES WeatherDim(weatherID)
);
