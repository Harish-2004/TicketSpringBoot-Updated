-- Create tables
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

CREATE TABLE IF NOT EXISTS login (
    emailid VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Insert initial data for train stations
INSERT INTO train (station, value) VALUES
    ('Station A', 1),
    ('Station B', 2),
    ('Station C', 3),
    ('Station D', 4),
    ('Station E', 5)
ON CONFLICT (station) DO NOTHING;

-- Insert a test admin user
INSERT INTO login (emailid, name, password) VALUES
    ('admin@example.com', 'Admin User', 'admin123')
ON CONFLICT (emailid) DO NOTHING; 