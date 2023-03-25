/* Authors: Jessica McEwan C3393168, Lena Dahlin C3391146
   Task: Assignment 1 Create Package stored procedure
   Date Created: 18/03/2023 Last updated: 26/03/2023
*/

--DROP PROCEDURE IF EXISTS usp_makeReservation 
--creating a type bookedPackages 
CREATE TYPE bookedPackages AS TABLE(
    packageID CHAR(10),
    qtyBooked INT,
    startDate DATETIME,
    endDate DATETIME
)
go
--creating guest list type
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
@bookedPackages bookedPackages READONLY, 
@guests guestList READONLY,
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
    --check to see if the dates booked for the package fall within the packages available dates 
    DECLARE AdvertisedDates CURSOR FOR  
        SELECT bp.packageID, bp.startDate, bp.endDate
        FROM @bookedPackages bp
    DECLARE 
        @packageID CHAR(10),
        @startDate DATETIME,
        @endDate DATETIME;
    OPEN AdvertisedDates   
    FETCH NEXT FROM AdvertisedDates INTO @packageID, @startDate, @endDate    

    WHILE @@FETCH_STATUS = 0   
    BEGIN   
        --check to see if the dates booked for the package fall within the packages available dates 
        BEGIN TRY
        BEGIN TRANSACTION
            IF NOT EXISTS (SELECT bp.packageID, bp.startDate, bp.endDate
            FROM @bookedPackages bp
            JOIN Package p ON bp.packageID = p.packageID
            WHERE bp.startDate >= p.startDate AND bp.endDate <= p.endDate)
            BEGIN
                DECLARE @errorDate NVARCHAR(100) = 'Package cannot be booked outside package available dates'
                RAISERROR (@errorDate, 16, 1) WITH NOWAIT;
            END
        COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            SELECT ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState
        ROLLBACK TRANSACTION
        END CATCH
        -- fetch next row from cursor
        FETCH NEXT FROM AdvertisedDates INTO @packageID, @startDate, @endDate       
    END
    CLOSE AdvertisedDates   
    DEALLOCATE AdvertisedDates
    -- Set reservation ID
    SET @reservationID = CONCAT('R', ABS(CHECKSUM(NEWID())))
    WHILE EXISTS(SELECT * FROM Reservation WHERE reservationID = @reservationID)
        BEGIN 
            SET @reservationID = CONCAT('R', ABS(CHECKSUM(NEWID())))
        END
    -- Set customer ID
        DECLARE @customerID CHAR(10) = CONCAT('C', ABS(CHECKSUM(NEWID())))
        WHILE EXISTS(SELECT * FROM Reservation WHERE reservationID = @reservationID)
        BEGIN 
            SET @customerID = CONCAT('C', ABS(CHECKSUM(NEWID())))
        END
    -- Insert into Customer
    INSERT INTO Customer VALUES (@customerID, @custName, @custPhone, @custEmail);
    -- Insert into Customer Address
    INSERT INTO CustomerAddress VALUES (@customerID, @streetNo, @streetName, @city, @postcode, @country);
    -- Insert into Reservation
    INSERT INTO Reservation VALUES (@reservationID, @customerID, NULL, DEFAULT)
    -- Insert into Booking table    
    INSERT INTO Booking(reservationID, packageID, qtyBooked, startDate, endDate)
    SELECT @reservationID, packageID, qtyBooked, startDate, endDate
    FROM @bookedPackages
    -- Update the pricing in the reservation table 
    UPDATE Reservation 
    SET totalPrice = (
    SELECT SUM(p.advPrice * b.qtyBooked)
    FROM Booking b
    JOIN Package p ON b.packageID = p.packageID
    WHERE b.reservationID = @reservationID) WHERE reservationID = @reservationID

    -- Create deposit in Payment
    DECLARE @totalPrice DECIMAL(18, 2)
    SELECT @totalPrice = totalPrice * 0.25
    FROM Reservation
    WHERE reservationID = @reservationID
    -- need to make payment ID an IDENTITY for this to work 
    INSERT INTO Payment VALUES (@reservationID, @totalPrice, GETDATE())
END     


/* Error for check to see if the dates booked for the package fall within the packages available dates 

DECLARE @bookedPackages bookedPackages
DECLARE @guests guestList
DECLARE @reservationID CHAR(10)

INSERT INTO @bookedPackages VALUES ('P000000001', 1, '1997-04-21', '2000-04-25')
INSERT INTO @guests VALUES ('John', '3123123', 'email@hi.com', '1', 'Bird Street', 'Bird City', '2315', 'Australia')


EXECUTE usp_makeReservation @bookedPackages, @guests, 'Hanna', '1241241', 'hanna@email.com', '500', 'Bird Street', 'Bird City', '2315','Australia', @reservationID OUTPUT
*/


DECLARE @bookedPackages bookedPackages
DECLARE @guests guestList
DECLARE @reservationID CHAR(10)

INSERT INTO @bookedPackages VALUES ('P000000001', 1, '2023-04-21', '2023-04-26')
INSERT INTO @guests VALUES ('John', '3123123', 'email@hi.com', '1', 'Bird Street', 'Bird City', '2315', 'Australia')


EXECUTE usp_makeReservation @bookedPackages, @guests, 'Hanna', '1241241', 'hanna@email.com', '500', 'Bird Street', 'Bird City', '2315','Australia', @reservationID OUTPUT

SELECT * From Reservation
