drop database project;
create database project;
CREATE USER 'pranav'@'localhost' IDENTIFIED BY '9766901015';

use project;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    age INT,
    gender VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15)
);

CREATE TABLE Trains (
    train_id INT PRIMARY KEY AUTO_INCREMENT,
    train_name VARCHAR(100) NOT NULL,
    train_code INT,
    source VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    total_seats INT NOT NULL,
    fare_km FLOAT NOT NULL
);
CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    train_id INT,
    arrival_time DATETIME NOT NULL,
    departure_time DATETIME NOT NULL,
    status VARCHAR(20),
    FOREIGN KEY (train_id) REFERENCES Trains(train_id)
);


CREATE TABLE station (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_code INT,
    station_name VARCHAR(20),
    coordinate INT
);
CREATE TABLE Reservations (
    PNR_NO INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    train_id INT,
    no_reserved_seats INT NOT NULL,
    reservation_date DATE NOT NULL,
    from_station INT,
    to_station INT, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (from_station) REFERENCES station(station_id),
    FOREIGN KEY (to_station) REFERENCES station(station_id),
    FOREIGN KEY (train_id) REFERENCES Trains(train_id)
);
CREATE TABLE Reservation_Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    PNR_NO INT,
    seat_number VARCHAR(10) NOT NULL,
    FOREIGN KEY (PNR_NO) REFERENCES Reservations(PNR_NO)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    PNR_NO INT,
    
    payment_method VARCHAR(30) NOT NULL,
    payment_date DATE,
    FOREIGN KEY (PNR_NO) REFERENCES Reservations(PNR_NO),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);



CREATE VIEW Payments_view AS
SELECT 
    P.payment_id,
    U.user_id,
    R.PNR_NO,
    P.payment_method,
    P.payment_date,
    R.from_station,
    R.to_station,
    (S2.coordinate - S1.coordinate) AS distance,  -- Distance calculation
    T.fare_km,
    R.no_reserved_seats,
    (R.no_reserved_seats * T.fare_km * (S2.coordinate - S1.coordinate)) AS total_amount
FROM 
    Users U
JOIN 
    Reservations R ON U.user_id = R.user_id 
JOIN 
    Trains T ON R.train_id = T.train_id 
JOIN 
    station S1 ON R.from_station = S1.station_id
JOIN 
    station S2 ON R.to_station = S2.station_id
JOIN 
    Payments P ON R.PNR_NO = P.PNR_NO;  -- Adding Payments table for reference

 -- Ensure that the join is based on PNR_NO
 CREATE TABLE Amount (
    amount_id INT PRIMARY KEY AUTO_INCREMENT,
    PNR_NO INT,
    total_amount DECIMAL(10, 2),  -- Ensure precision for total amount
    FOREIGN KEY (PNR_NO) REFERENCES Reservations(PNR_NO)
);
CREATE VIEW User_Reservation_View AS
SELECT 
    U.user_id,
    U.username,
    R.PNR_NO,
    R.no_reserved_seats,
    T.train_name,
    T.fare_km,
    A.total_amount as Amount,
    A.total_amount,
    S1.station_name AS from_station_name,
    S2.station_name AS to_station_name,
    (S2.coordinate - S1.coordinate) AS distance
FROM 
    Users U
JOIN 
    Reservations R ON U.user_id = R.user_id 
JOIN 
    Trains T ON R.train_id = T.train_id 
JOIN 
    Station S1 ON R.from_station = S1.station_code
JOIN 
    Station S2 ON R.to_station = S2.station_code
JOIN 
    Payments P ON R.PNR_NO = P.PNR_NO
JOIN 
    Amount A ON R.PNR_NO = A.PNR_NO ;
    
GRANT SELECT ON payments_view TO 'pranav'@'localhost';           -- granted views for read_only
GRANT SELECT ON user_reservation_view TO 'pranav'@'localhost';
    
 -- Insert Data into Users
INSERT INTO Users (username, age, gender, email, phone_number) VALUES
('Om', 25, 'Male', 'Ompatil1100@gmail.com', '1234567890'),
('Pranav_Patil', 30, 'Male', 'pranavpatil97@gmail.com', '9987654321'),
('Pavan_patil', 28, 'Male', 'pavanpatil2007@gmail.com', '9345678901'),
('Nitin Patil', 22, 'Male', 'nitinpatil1722@gmail.com', '9322054341'),
('Sai_More', 35, 'Male', 'saimore@gmail.com', '4567890123'),
('Ashwin Patil', 27, 'Male', 'ashwinpatil2021@gmail.com', '9678901234'),
('Mahavir_patil', 29, 'Male', 'mahavirpatil1100@gmail.com', '9789012345'),
('Harshu Patil', 28, 'Female', 'harshupatil2007@gmail.com', '7890123456'),
('Jayshri Patil', 26, 'Female', 'jayshripatil2024@gmail.com', '8901234567'),
('Bhagyashri Patil', 32, 'Female', 'bhagyashripatil2025@gmail.com', '9012345678');

-- Insert Data into Trains
INSERT INTO Trains (train_name, train_code, source, destination, total_seats, fare_km) VALUES
('kashi Express', 101, 'Mumbai', 'Jaynagar', 100, 5.00),
('kamayani Express', 102, 'Mumbai', 'Varanasi', 50, 3.00),
('Hawarah Express', 103, 'Mumbai', 'Chalisgaon', 80, 4.50),
('Rajdhani Express', 104, 'Mumbai', 'Ghazipur city', 120, 6.00),
('Khandesh Express', 105, 'Mumbai', 'Ballia', 90, 5.50),
('Gitanjali Express', 106, 'Mumbai', 'sakri Junction', 60, 7.00),
('Pawan Express', 107, 'Mumbai', 'Madhubani', 70, 8.00),
('Khushinagar SF Express', 108, 'Mumbai', 'Ghazipur city', 150, 10.00),
('Mumbai LTT Express', 109, 'Mumbai', 'Jaynagar', 40, 12.00),
('Jhelam Express', 110, 'Mumbai', 'Ballia', 30, 2.00);

-- Insert Data into Station
INSERT INTO Station (station_code, station_name, coordinate) VALUES
(1, 'Mumbai', 0),
(2, 'Nashik', 166),
(3, 'Jalgoan', 400),
(4, 'Maihar', 1005),
(5, 'Varanasi', 1400),
(6, 'Ghazipur city',1540),
(7, 'Ballia', 1605),
(8, 'sakri Junction', 1869),
(9, 'Madhubani', 1893),
(10, 'Jaynagar',1962);

-- Insert Data into Schedules
INSERT INTO Schedules (train_id, arrival_time, departure_time, status) VALUES
(1, '2024-09-30 10:00:00', '2024-09-30 10:30:00', 'On Time'),
(2, '2024-09-30 11:00:00', '2024-09-30 11:30:00', 'Cancelled'),
(3, '2024-09-30 12:00:00', '2024-09-30 12:30:00', 'Delayed'),
(4, '2024-09-30 13:00:00', '2024-09-30 13:30:00', 'On Time'),
(5, '2024-09-30 14:00:00', '2024-09-30 14:30:00', 'On Time'),
(6, '2024-09-30 15:00:00', '2024-09-30 15:30:00', 'Delayed'),
(7, '2024-09-30 16:00:00', '2024-09-30 16:30:00', 'On Time'),
(8, '2024-09-30 17:00:00', '2024-09-30 17:30:00', 'Delayed'),
(9, '2024-09-30 18:00:00', '2024-09-30 18:30:00', 'On Time'),
(10, '2024-09-30 19:00:00', '2024-09-30 19:30:00', 'Delayed');

-- Insert Data into Reservations
INSERT INTO Reservations (user_id, train_id, no_reserved_seats, reservation_date, from_station, to_station) VALUES
(1, 1, 2, '2024-09-30', 1, 3),  
(2, 2, 1, '2024-09-30', 2, 6),  
(3, 3, 3, '2024-09-30', 5, 6),  
(4, 4, 2, '2024-09-30', 7, 8),  
(5, 5, 1, '2024-09-30', 9, 10), 
(6, 6, 4, '2024-09-30', 1, 3),  
(7, 7, 2, '2024-09-30', 2, 4),  
(8, 8, 1, '2024-09-30', 3, 5),  
(9, 9, 3, '2024-09-30', 6, 7),  
(10, 10, 2, '2024-09-30', 8, 9);


-- Insert Data into Reservation_Seats
INSERT INTO Reservation_Seats (PNR_NO, seat_number) VALUES
(1, '1A'), 
(1, '1B'),
(2, '2A'), 
(3, '3A'), 
(3, '3B'), 
(4, '4A'), 
(5, '5A'), 
(6, '6A'), 
(7, '7A'), 
(8, '8A'), 
(9, '9A'), 
(10, '10A');

-- Insert Data into Payments
INSERT INTO Payments (user_id, PNR_NO, payment_method, payment_date) VALUES
(1, 1, 'Credit Card', '2024-09-30'),  
(2, 2, 'Debit Card', '2024-09-30'),   
(3, 3, 'PayPal', '2024-09-30'),    
(4, 4, 'Cash', '2024-09-30'),    
(5, 5, 'Credit Card', '2024-09-30'),  
(6, 6, 'Debit Card', '2024-09-30'),    
(7, 7, 'PayPal', '2024-09-30'),   
(8, 8, 'Cash', '2024-09-30'),    
(9, 9, 'Credit Card', '2024-09-30'),  
(10, 10, 'Debit Card', '2024-09-30');  


INSERT INTO Amount (PNR_NO, total_amount)
SELECT 
    PNR_NO, 
    total_amount
FROM 
    Payments_view;
select* from user_reservation_view;
select *from Payments_view;
SELECT * FROM Users;
SELECT * FROM Reservations;
SELECT * FROM Trains;
SELECT * FROM station;
SELECT * FROM Payments;   
select * from Schedules;
select * from amount;  
SAVEPOINT transaction;

