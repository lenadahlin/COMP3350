---- Business Rule 1: A manager's salary is always greater than his/her subordinates 

--CREATE TABLE
DROP TABLE IF EXISTS Employee
CREATE TABLE Employee( 
eid INT PRIMARY KEY, 
ename VARCHAR(100), 
salary FLOAT, 
manager INT REFERENCES Employee) 

--DROP TRIGGER
DROP TRIGGER tr_Verify_BR1

--CREATE TRIGGER 

CREATE TRIGGER tr_Verify_BR1  
ON Employee 
FOR UPDATE, INSERT 
AS 
BEGIN 
  IF ((SELECT COUNT(*) 
   FROM inserted i, Employee m 
   WHERE i.manager = m.eid AND i.salary >= m.salary)>0) 
  BEGIN 
   RAISERROR ('Employee should have a salary less than his/her 
manager', 9, 1) 
   ROLLBACK TRANSACTION 
  END 
    IF ((SELECT COUNT(*)
    FROM inserted m, Employee e
    WHERE m.eid = e.manager AND m.salary <= e.salary)>0)
    BEGIN
        RAISERROR ('Manager should have a salary greater than his/her employee', 9, 1)
        ROLLBACK TRANSACTION
    END  
END 

--INSERT VALID DATA
INSERT INTO Employee VALUES
    (1, 'Bob', 100.0, NULL),
    (2, 'Kat', 99.0, 1),
    (3, 'Jess', 98.0, 2);

SELECT * FROM Employee

--ERROR TESTING FOR CHANGING MANAGER SALARY
UPDATE Employee
SET salary = 97.0
WHERE eid = 2;