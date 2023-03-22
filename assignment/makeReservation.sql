
--need a table type for services/packages reserved
CREATE TYPE bookedPackages AS TABLE(
    packageID CHAR(10),
    qtyBooked INT,
    startDate DATETIME,
    endDate DATETIME,
)
go
-- guest list
CREATE TYPE guestList AS TABLE(
    name VARCHAR(30),
    phone VARCHAR(10),
    email VARCHAR(30),
    streetNo VARCHAR(10),
    streetName VARCHAR(30), 
    city VARCHAR(30),  
    postcode VARCHAR(10), 
    country VARCHAR(30)
) 
go

CREATE PROCEDURE usp_makeReservation 
--bring in the booking (its a table)
@bookedPackages bookedPackages, --bookedPackages is a type (my mental note delete at some point) 
@custName VARCHAR(30),
@custPhone VARCHAR(10),
@custEmail VARCHAR(30),
--address
@streetNo VARCHAR(10),
@streetName VARCHAR(40),
@city VARCHAR(30),
@postcode VARCHAR(10),
@country VARCHAR(30),
@reservationID CHAR(10) OUTPUT
AS
BEGIN 
    DECLARE @newResID CHAR(10) 
    SET @newResID = CONCAT('P', ABS(CHECKSUM(NEWID())))
    WHILE EXISTS(SELECT * FROM Reservation WHERE reservationID = @newResID)
        BEGIN 
            SET @newResID =CONCAT('P', ABS(CHECKSUM(NEWID())))
        END 
    BEGIN TRY 
        INSERT INTO Booking (reservationID,packageID,qtyBooked,startDate,endDate)
        SELECT(@newResID,packageID,qtyBooked,startDate,endDate)
        FROM @bookedPackages
    END TRY 
    BEGIN CATCH 
        -- need to get capacity from service item from servicePackage compare with number booked 
        --on a particular date  
        




END     


--ensure hotel does not excess capacity at any given time if there is no capacity raise error and entire reservation cancelled

--bookings of facilities need to be saved at the time of reservation 

-- total amount due and deposit due needs to be calculated for the reservation deposit = 25%


--output is reservationID 
PRINT 'Reservation ID is = ' + @newResID