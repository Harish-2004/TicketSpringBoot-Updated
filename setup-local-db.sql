-- Create database
CREATE DATABASE ticketsystem2;
\q

-- Connect to the database
\c ticketsystem2;

-- Create tables (if they don't exist)
CREATE TABLE IF NOT EXISTS passengerbooking (
    email VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    starting VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS supplementpassengers (
    email VARCHAR(255) PRIMARY KEY,
    intermediate_station VARCHAR(100) NOT NULL,
    passenger_email VARCHAR(255) REFERENCES passengerbooking(email)
);

CREATE TABLE IF NOT EXISTS train (
    station VARCHAR(100) PRIMARY KEY,
    value INTEGER NOT NULL
);

-- Create login table
CREATE TABLE IF NOT EXISTS login (
    emailid VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL
); 