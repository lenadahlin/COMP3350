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
    capacity VARCHAR(10),
    PRIMARY KEY(facilityTypeID)
);

GO 

--facility table
CREATE TABLE Facility(
    facilityID VARCHAR(10),
    name VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    status VARCHAR(10) NOT NULL,
    facilityTypeID VARCHAR(10) NOT NULL, 
    PRIMARY KEY(facilityID),
    FOREIGN KEY (facilityTypeID) REFERENCES FacilityType(facilityTypeID) ON UPDATE NO ACTION ON DELETE NO ACTION
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
    name VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    restrictions VARCHAR(100) NOT NULL,
    notes VARCHAR(100),
    comments VARCHAR(100),
    openTime DATETIME,
    closeTime DATETIME,
    baseCost SMALLMONEY NOT NULL,
    baseCurrency VARCHAR(20) NOT NULL,
    capacity VARCHAR(10),
    facilityID VARCHAR(10),
    PRIMARY KEY (serviceID),
    FOREIGN KEY (facilityID) REFERENCES Facility(facilityID) ON UPDATE NO ACTION ON DELETE NO ACTION
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
    paymentStatus VARCHAR(30) NOT NULL, -- maybe we can add a default for deposit paid here?
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
    authorizingEmployee VARCHAR(50),
    PRIMARY KEY (reservationID),
    FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CheckAuthorization CHECK ((discount > 0.25 AND authorizingEmployee IS NOT NULL) OR (discount <=0.25))
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
('001','')


  /*  hotelID VARCHAR(10), 
    name VARCHAR(30) NOT NULL, 
    phone VARCHAR(10) NOT NULL, 
    description VARCHAR(100),
    PRIMARY KEY(hotelID)