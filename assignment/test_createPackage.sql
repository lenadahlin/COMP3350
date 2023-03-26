/* Authors: Jessica McEwan C3393168, Lena Dahlin C3391146
   Task: Assignment 1 Create Package stored procedure tests
   Date Created: 18/03/2023 Last updated: 22/03/2023
*/

-- Correct test
DECLARE @services ServiceList
DECLARE @NewPackageID CHAR(10)

INSERT INTO @services VALUES ('SI00001', 1)
INSERT INTO @services VALUES ('SI00002', 3)

EXECUTE usp_createPackage 'new package', @services, 'testing package', '2023-04-21', '2024-04-21', 500, 'AUD', 'John', @NewPackageID OUTPUT

/*Duplicate Service Item testing

DECLARE @services ServiceList
DECLARE @NewPackageID CHAR(10)

INSERT INTO @services VALUES ('SI00002', 1)
INSERT INTO @services VALUES ('SI00002', 1)

EXECUTE usp_createPackage 'new package', @services, 'testing package', '2023-04-21', '2024-04-21', 500, 'AUD', 'John', @NewPackageID OUTPUT

*/
/*0 quantity  Service Item testing

DECLARE @services ServiceList
DECLARE @NewPackageID CHAR(10)

INSERT INTO @services VALUES ('SI00002', 0)

EXECUTE usp_createPackage 'new package', @services, 'testing package', '2023-04-21', '2024-04-21', 500, 'AUD', 'John', @NewPackageID OUTPUT

*/
/*Service item doesn't exist testing

DECLARE @services ServiceList
DECLARE @NewPackageID CHAR(10)

INSERT INTO @services VALUES ('SI00500', 1)

EXECUTE usp_createPackage 'new package', @services, 'testing package', '2023-04-21', '2024-04-21', 500, 'AUD', 'John', @NewPackageID OUTPUT

*/
/*Start date after end date testing

DECLARE @services ServiceList
DECLARE @NewPackageID CHAR(10)

INSERT INTO @services VALUES ('SI00002', 1)
INSERT INTO @services VALUES ('SI00002', 1)

EXECUTE usp_createPackage 'new package', @services, 'testing package', '2024-04-21', '2022-04-21', 500, 'AUD', 'John', @NewPackageID OUTPUT

*/