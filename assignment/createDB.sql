/* Authors: Jessica McEwan C3393168, Lena Dahlin C3391146
   Task: Assignment 1 Hotel database Design 
   Date Created: 11/03/2023 Last updated: ...
*/

-- DROP TABLE statements
DROP TABLE IF EXISTS Payment
DROP TABLE IF EXISTS Discount 
DROP TABLE IF EXISTS Booking 
DROP TABLE IF EXISTS ReservationGuest 
DROP TABLE IF EXISTS Reservation 
DROP TABLE IF EXISTS CustomerAddress 
DROP TABLE IF EXISTS Customer 
DROP TABLE IF EXISTS PackageServiceItem
DROP TABLE IF EXISTS Package 
DROP TABLE IF EXISTS ServiceItem 
DROP TABLE IF EXISTS ServiceCategory 
DROP TABLE IF EXISTS Facility 
DROP TABLE IF EXISTS FacilityType 
DROP TABLE IF EXISTS HotelAddress 
DROP TABLE IF EXISTS Hotel 
GO


--hotel table 
CREATE TABLE Hotel(
    hotelID VARCHAR(10), 
    name VARCHAR(30) NOT NULL UNIQUE, 
    phone VARCHAR(10) NOT NULL, 
    description VARCHAR(100),
    PRIMARY KEY(hotelID)
);

GO

--hotel address table
CREATE TABLE HotelAddress (
    hotelID VARCHAR(10),
    streetNo INT NOT NULL,
    streetName VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postcode INT NOT NULL,
    country VARCHAR(100) NOT NULL,
    PRIMARY KEY(hotelID),
    FOREIGN KEY (hotelID) REFERENCES Hotel(hotelID) ON UPDATE CASCADE ON DELETE NO ACTION
);

GO


--facility type table 
CREATE TABLE FacilityType(
    facilityTypeID VARCHAR(10), 
    name VARCHAR(30) NOT NULL, 
    description VARCHAR(100) NOT NULL,
    capacity INT,
    PRIMARY KEY(facilityTypeID)
);

GO 

--facility table
CREATE TABLE Facility(
    facilityID VARCHAR(10),
    hotelID VARCHAR(10) NOT NULL,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    status VARCHAR(10) NOT NULL,
    facilityTypeID VARCHAR(10) NOT NULL, 
    PRIMARY KEY(facilityID),
    FOREIGN KEY (facilityTypeID) REFERENCES FacilityType(facilityTypeID) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (hotelID) REFERENCES Hotel(hotelID) ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

--service category table
CREATE TABLE ServiceCategory(
    categoryID VARCHAR(10), 
    name VARCHAR(30) NOT NULL UNIQUE, 
    description VARCHAR(100), 
    type VARCHAR(10) NOT NULL,
    PRIMARY KEY(categoryID)
);

GO

--service item table
CREATE TABLE ServiceItem(
    serviceID VARCHAR(10),
    categoryID VARCHAR(10), 
    name VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    restrictions VARCHAR(100) NOT NULL,
    notes VARCHAR(100),
    comments VARCHAR(100),
    openTime TIME,
    closeTime TIME,
    baseCost SMALLMONEY NOT NULL,
    baseCurrency VARCHAR(20) NOT NULL,
    capacity INT,
    facilityID VARCHAR(10),
    PRIMARY KEY (serviceID),
    FOREIGN KEY (facilityID) REFERENCES Facility(facilityID) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (categoryID) REFERENCES ServiceCategory(categoryID) ON UPDATE CASCADE ON DELETE NO ACTION
);

GO 

--package table 
CREATE TABLE Package(
    packageID VARCHAR(10), 
    name VARCHAR(30) NOT NULL, 
    description VARCHAR(100),
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,
    advPrice SMALLMONEY NOT NULL,
    advCurrency VARCHAR(20) NOT NULL,
    inclusions VARCHAR(100), 
    exclusions VARCHAR(100),
    status VARCHAR(10) NOT NULL,  
    gracePeriod VARCHAR(10),
    empName VARCHAR(30) NOT NULL,
    PRIMARY KEY(packageID),
);

GO


--PackageServiceItem table
CREATE TABLE PackageServiceItem(
    packageID VARCHAR(10), 
    serviceID VARCHAR(10),
    PRIMARY KEY (packageID, serviceID),
    FOREIGN KEY (packageID) REFERENCES Package(packageID) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (serviceID) REFERENCES ServiceItem(serviceID) ON UPDATE NO ACTION ON DELETE NO ACTION
);

GO

--customer table 
CREATE TABLE Customer(
    customerID VARCHAR(10), 
    name VARCHAR(30) NOT NULL, 
    phone VARCHAR(10) NOT NULL, 
    email VARCHAR(30) NOT NULL,
    PRIMARY KEY(customerID)
);

GO 

--customer adress table 
CREATE TABLE CustomerAddress(
    customerID VARCHAR(10), 
    streetNo VARCHAR(10) NOT NULL, 
    streetName VARCHAR(20) NOT NULL,
    city VARCHAR(30) NOT NULL, 
    postcode VARCHAR(10) NOT NULL, 
    country VARCHAR(30) NOT NULL, 
    PRIMARY KEY(customerID), 
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON UPDATE CASCADE ON DELETE NO ACTION
);

GO

--Reservation table
CREATE TABLE Reservation(
    reservationID VARCHAR(10),
    customerID VARCHAR(10) NOT NULL,
    paymentStatus VARCHAR(30) NOT NULL DEFAULT 'Deposit Paid', 
    PRIMARY KEY (reservationID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON UPDATE CASCADE ON DELETE NO ACTION
);

GO

--reservation guest table 
CREATE TABLE ReservationGuest(
    reservationID VARCHAR(10), 
    guestID VARCHAR(10), 
    name VARCHAR(30) NOT NULL, 
    phone VARCHAR(10) NOT NULL, 
    email VARCHAR(30) NOT NULL, 
    streetNo VARCHAR(10) NOT NULL, 
    streetName VARCHAR(30) NOT NULL, 
    city VARCHAR(30) NOT NULL,  
    postcode VARCHAR(10) NOT NULL, 
    country VARCHAR(30) NOT NULL, 
    PRIMARY KEY(reservationID, guestID), 
    FOREIGN KEY(reservationID) REFERENCES Reservation(reservationID) ON UPDATE CASCADE ON DELETE CASCADE
);

GO

--Booking table
CREATE TABLE Booking(
    reservationID VARCHAR(10),
    packageID VARCHAR(10), 
    qtyBooked INT NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,
    PRIMARY KEY(reservationID, packageID),
    FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (packageID) REFERENCES Package(packageID) ON UPDATE NO ACTION ON DELETE NO ACTION
);

GO
--Discount table
CREATE TABLE Discount(
    reservationID VARCHAR(10),
    discount INT CHECK (discount <= 1) NOT NULL, --percentage discount
    employee VARCHAR(50) NOT NULL,
    authorizationStatus VARCHAR(50),
    PRIMARY KEY (reservationID),
    FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CheckAuthorization CHECK ((discount > 0.25 AND authorizationStatus IS NOT NULL) OR (discount <=0.25))
); 

GO

--Payment table
CREATE TABLE Payment(
    paymentID VARCHAR(10) NOT NULL,
    reservationID VARCHAR(10) NOT NULL, 
    amount SMALLMONEY NOT NULL,
    datePaid DATETIME DEFAULT GETDATE() NOT NULL,
    PRIMARY KEY (paymentID),
    FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID) ON UPDATE NO ACTION ON DELETE NO ACTION
);

GO





--inserting data into the tables 

INSERT INTO Hotel VALUES 
('001','The Magpie Resort', '0492857285','5 star beachfront resort with a view'),
('002','The Fairywren Hotel', '0498375728', 'Upscale hotel with river views'),
('003', 'The Cormorant Hotel', '6622485511', 'Luxury hotel in the center of town');
GO
INSERT INTO HotelAddress VALUES 
('001', 20, 'King Street', 'Newcastle', 2400, 'Australia'),
('002', 222, 'Margaret Street', 'Brisbane', 4000, 'Australia'),
('003', 372, 'Thanon Si Ayutthaya', 'Bangkok', 10400, 'Thailand');
GO


INSERT INTO FacilityType VALUES
('FT00001', 'Standard Room', 'Basic room for 2', 2),
('FT00002', 'Family Room', 'Spacious room for a family of 4', 4),
('FT10001', 'Restaurant', 'Fine dining restaurant', 20);
GO

INSERT INTO Facility VALUES
('FAC000001', '001', 'Room 001', 'Small yet spacious', 'Available', 'FT00001'),
('FAC000002', '001', 'Room 002', 'Small yet spacious', 'Available', 'FT00001'),
('FAC100001', '001', 'Room 003', 'Large', 'Available', 'FT00002'),
('FAC000010', '001', 'The Bird Restauraunt', 'Small scale fine dining', 'Running', 'FT10001');
GO

INSERT INTO ServiceCategory VALUES
('SC001', 'Accomodation', NULL, 'Rooms'),
('SC101', 'Food & Meals', NULL, 'Food');
GO

INSERT INTO ServiceItem VALUES
('SI00001', 'SC101', 'Breakfast', 'Buffet Breakfeast with coffee', '2 hour limit', NULL, NULL, '06:00', '10:00', 8.50, 'AUD', 15, 'FAC000010'),
('SI00002', 'SC101', 'Dinner', '3 course meal', 'Semi-formal dress', NULL, 'Takes approx 1 hour per person', '18:00', '21:00', 50, 'AUD', 10, 'FAC000010'),
('SI10001', 'SC001', 'Standard Room', 'Overnight stay', 'No parties', NULL, NULL, '14:00', '10:00', 80, 'AUD', 2, 'FAC000002'),
('SI10002', 'SC001', 'Standard Room', 'Overnight stay', 'No parties', NULL, NULL, '14:00', '10:00', 80, 'AUD', 2, 'FAC000001');

GO

INSERT INTO Package VALUES
('P001','awesome package','a standard room with breakfast','2023-01-20','2023-06-20',300,'AUD','Standard room and a breakfast','excludes laundry','available','5 days','Keanu'),
('P002','Room and dinner','a standard room with dinner','2023-02-10','2023-06-10',278,'AUD','Standard room and dinner','excludes breakfast','available','5 days','John'),
('P003','Bed,Breakfast and dinner','a standard room with breakfast and dinner','2023-02-28','2023-06-30',400,'AUD','Standard room, breakfast and dinner','excludes laundry','available','5 days','Thomas'),
('P004','dinner','dinner','2023-02-28','2023-06-30',60,'AUD','3 course dinner','excludes alcohol','available','1 days','Tom');
GO

INSERT INTO PackageServiceItem VALUES
('P001','SI00001'),
('P001','SI10001'),
('P002','SI10001'),
('P002','SI00002'),
('P003','SI10002'),
('P003','SI00001'),
('P003','SI00002');
GO


INSERT INTO Customer VALUES
('C000000001', 'Cathy Cockatoo', '0412487653', 'cathy@gmail.com'),
('C000000002', 'Donald Duck', '0419657653', 'donald@gmail.com' ),
('C000000003', 'Maggie Magpie', '0419657123', 'maggie@gmail.com');
GO

INSERT INTO CustomerAddress VALUES
('C000000001', '1', 'Cockatoo Lane', 'Cockatoo Island', '2000', 'Australia'),
('C000000002', '2', 'Duck Drive', 'Duck Bay', '3185', 'Australia'),
('C000000003', '3', 'Magpie Motorway', 'Magpie Meadow', '4020', 'Australia');
GO

INSERT INTO Reservation VALUES
('R001','C000000001','Paid in full'),
('R002','C000000002', 'Paid in full'),
('R003','C000000003', DEFAULT);
GO

INSERT INTO ReservationGuest VALUES
('R001','G001','Rhea Ripley','0415987365','mami@gmail.com','23','easy street','2095','melbourne','Australia'),
('R002','G002','Bayley Martinez','0415974563','bayley@gmail.com','10','glass avenue','4675','newcastle','Australia'),
('R003','G003','Ronda Rousey','0450196548','ronda@gmail.com','15','cool close','dubbo','7464','Australia');
GO

INSERT INTO Booking VALUES
('R001','P001',1,'2023-01-22','2023-01-27'),
('R002','P002',1,'2023-02-15','2023-02-20'),
('R003','P003',1,'2023-03-22','2023-03-23');
('R003','P001',1,'2023-03-22','2023-03-23');
GO

INSERT INTO Discount VALUES 
('R001', 0.05, 'Greg', NULL),
('R002', 0.26, 'Janet', 'Authorized');
GO


INSERT INTO Payment VALUES
('PA0001', 'R001', 75, '2023-01-10 11:05:12'),
('PA0002', 'R001', 210, '2023-01-27 09:50:10'),
('PA0003', 'R002', 69.5 , '2023-02-20 09:42:19'),
('PA0004', 'R002', 171.58 , '2023-02-05 14:42:19'),
('PA0005', 'R003', 100, '2023-03-21 20:10:22');
GO
