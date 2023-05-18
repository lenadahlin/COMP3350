/* Authors: Jessica McEwan C3393168, Lena Dahlin C3391146
   Task: Assignment 1 Make Reservation stored procedure test
   Date Created: 18/03/2023 Last updated: 26/03/2023
*/

-- Correct test
DECLARE @bookedPackages bookedPackages
DECLARE @guests guestList
DECLARE @reservationID CHAR(10)

INSERT INTO @bookedPackages VALUES ('P000000001', 1, '2023-04-21', '2023-04-26')
INSERT INTO @bookedPackages VALUES ('P000000002', 1, '2023-04-21', '2023-04-26')

EXECUTE usp_makeReservation @bookedPackages, @guests, 'Hanna', '1241241', 'hanna@email.com', '500', 'Bird Street', 'Bird City', '2315','Australia', @reservationID OUTPUT


/* Error for check to see if the dates booked for the package fall within the packages available dates 

DECLARE @bookedPackages bookedPackages
DECLARE @guests guestList
DECLARE @reservationID CHAR(10)

INSERT INTO @bookedPackages VALUES ('P000000001', 1, '1997-04-21', '2000-04-25')
INSERT INTO @guests VALUES ('John', '3123123', 'email@hi.com', '1', 'Bird Street', 'Bird City', '2315', 'Australia')


EXECUTE usp_makeReservation @bookedPackages, @guests, 'Hanna', '1241241', 'hanna@email.com', '500', 'Bird Street', 'Bird City', '2315','Australia', @reservationID OUTPUT
*/

/* Testing to get error for < 1 quantity booked
DECLARE @bookedPackages bookedPackages
DECLARE @guests guestList
DECLARE @reservationID CHAR(10)

INSERT INTO @bookedPackages VALUES ('P000000001', -1, '2023-04-21', '2023-04-26')
INSERT INTO @guests VALUES ('John', '3123123', 'email@hi.com', '1', 'Bird Street', 'Bird City', '2315', 'Australia')

EXECUTE usp_makeReservation @bookedPackages, @guests, 'Hanna', '1241241', 'hanna@email.com', '500', 'Bird Street', 'Bird City', '2315','Australia', @reservationID OUTPUT
*/

/* Testing to get error for not enough capacity
DECLARE @bookedPackages bookedPackages
DECLARE @guests guestList
DECLARE @reservationID CHAR(10)

INSERT INTO @bookedPackages VALUES ('P000000001', 1, '2023-04-21', '2023-04-26')
INSERT INTO @bookedPackages VALUES ('P000000002', 200, '2023-04-21', '2023-04-26')
INSERT INTO @guests VALUES ('John', '3123123', 'email@hi.com', '1', 'Bird Street', 'Bird City', '2315', 'Australia')


EXECUTE usp_makeReservation @bookedPackages, @guests, 'Hanna', '1241241', 'hanna@email.com', '500', 'Bird Street', 'Bird City', '2315','Australia', @reservationID OUTPUT
*/
