


-- Create a type which is a table
CREATE TYPE ServiceList AS TABLE(
    serviceID VARCHAR(10),
    quantity INT
)
GO

-- we don't have all details needed for package? status is on spec
CREATE PROCEDURE usp_createPackage @PackageName VARCHAR(30), 
@ServiceItems ServiceList,
@Description VARCHAR(100),
@StartDate DATETIME,
@EndDate DATETIME,
@AdvPrice SMALLMONEY,
@AdvCurrency VARCHAR(20),
@Employee VARCHAR(30),
@NewPackageID VARCHAR(4) OUTPUT
AS
BEGIN
    SET @NewPackageID = CONCAT('P', ABS(CHECKSUM(NEWID())))
    WHILE EXISTS(SELECT * FROM Package WHERE PackageID = @NewPackageID)
    BEGIN
        SET @NewPackageID = CONCAT('P', ABS(CHECKSUM(NEWID())))
    END
    PRINT 'New packageID = ' + @NewPackageID
    BEGIN TRY
        INSERT INTO Package VALUES
        (@NewPackageID, @PackageName, @Description, @StartDate, @EndDate, @AdvPrice, @AdvCurrency, NULL, NULL, 'Available', NULL, @Employee);
    END TRY
    BEGIN CATCH
        -- add errors
        ROLLBACK TRANSACTION
    END CATCH

END
