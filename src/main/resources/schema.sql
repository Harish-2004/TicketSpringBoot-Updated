-- Create login table
CREATE TABLE IF NOT EXISTS login (
    emailid VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create train table (stations)
CREATE TABLE IF NOT EXISTS train (
    stations VARCHAR(255) PRIMARY KEY,
    value INTEGER NOT NULL
);

-- Create passengerbooking table
CREATE TABLE IF NOT EXISTS passengerbooking (
    email VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    starting VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    FOREIGN KEY (starting) REFERENCES train(stations),
    FOREIGN KEY (destination) REFERENCES train(stations)
);

-- Create supplementpassengers table
CREATE TABLE IF NOT EXISTS supplementpassengers (
    email VARCHAR(255) PRIMARY KEY,
    intermediate_station VARCHAR(255) NOT NULL,
    FOREIGN KEY (email) REFERENCES passengerbooking(email),
    FOREIGN KEY (intermediate_station) REFERENCES train(stations)
);

-- Insert some sample stations
INSERT INTO train (stations, value) VALUES
    ('Station A', 1),
    ('Station B', 2),
    ('Station C', 3),
    ('Station D', 4),
    ('Station E', 5)
ON CONFLICT (stations) DO NOTHING; 