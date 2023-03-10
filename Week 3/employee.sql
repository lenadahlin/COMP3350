DROP TABLE IF EXISTS Employee
GO
    CREATE TABLE Employee (
        eno INT PRIMARY KEY,
        ename NVARCHAR(255),
        manager INT,
        FOREIGN KEY (manager) REFERENCES Employee(eno)
    )
GO
INSERT INTO
    Employee
VALUES
    (1, 'Peter', NULL),
    (2, 'Mary', 1),
    (3, 'Henry', 1),
    (4, 'Sam', 2),
    (5, 'Shaun', 2),
    (6, 'Nancy', 3),
    (7, 'Garry', 6),
    (8, 'John', 6),
    (9, 'Sue', 7),
    (10, 'Kathy', 7);

GO

--1. iii) Print hierarchical organisation of the company. Print the employee number, employee name, manager number, manager name and the hierarchical level.
WITH levels AS 
(
    SELECT 
        eno AS EmployeeNumber, 
        ename AS EmployeeName, 
        manager AS ManagerNumber, 
        CAST(NULL AS VARCHAR(255)) AS ManagerName,
        0 AS HierarchyLevel 
    FROM Employee
    WHERE manager IS NULL
    UNION ALL
        SELECT     
            e.eno AS EmployeeNumber, 
            e.ename AS EmployeeName, 
            e.manager AS ManagerNumber, 
            CAST(levels.EmployeeName AS VARCHAR(255)) AS ManagerName, 
            HierarchyLevel + 1
        FROM levels 
            INNER JOIN Employee e ON levels.EmployeeNumber = e.manager
)
SELECT * FROM levels

-- 1. iv) How many hierarchical levels does the organisation have?  4
WITH levels AS 
(
    SELECT 
        eno AS EmployeeNumber, 
        ename AS EmployeeName, 
        manager AS ManagerNumber, 
        CAST(NULL AS VARCHAR(255)) AS ManagerName,
        0 AS HierarchyLevel 
    FROM Employee
    WHERE manager IS NULL
    UNION ALL
        SELECT     
            e.eno AS EmployeeNumber, 
            e.ename AS EmployeeName, 
            e.manager AS ManagerNumber, 
            CAST(levels.EmployeeName AS VARCHAR(255)) AS ManagerName, 
            HierarchyLevel + 1
        FROM levels 
            INNER JOIN Employee e ON levels.EmployeeNumber = e.manager
)
SELECT MAX(HierarchyLevel) FROM levels
-- 1. v) Print  all  employees  under  Henry  including  his  subordinates.  Note  that Henry's employee id is 3. 
WITH HenrysEmployees AS 
(
    SELECT 
        eno AS EmployeeNumber, 
        ename AS EmployeeName, 
        manager AS ManagerNumber, 
        CAST(NULL AS VARCHAR(255)) AS ManagerName
    FROM Employee
    WHERE eno = 3
    UNION ALL
        SELECT     
            e.eno AS EmployeeNumber, 
            e.ename AS EmployeeName, 
            e.manager AS ManagerNumber, 
            CAST(HenrysEmployees.EmployeeName AS VARCHAR(255)) AS ManagerName 
        FROM HenrysEmployees 
            INNER JOIN Employee e ON HenrysEmployees.EmployeeNumber = e.manager
)
SELECT * FROM HenrysEmployees 
WHERE ManagerName IS NOT NULL

-- 1. vi) How many managers are under Peter (including  his subordinates). 
--Peter's employee number is 1. A manager is a person who supervisors at least one employee. 
WITH Peters AS 
(
    SELECT 
        eno AS EmployeeNumber, 
        manager AS ManagerNumber
    FROM Employee
    WHERE eno = 1
    UNION ALL
        SELECT     
            e.eno AS EmployeeNumber, 
            e.manager AS ManagerNumber
        FROM Peters as p 
            INNER JOIN Employee e ON p.EmployeeNumber = e.manager
)
SELECT COUNT (DISTINCT ManagerNumber) AS ManagerCount
FROM Peters 
WHERE ManagerNumber IS NOT NULL AND NOT ManagerNumber = '1'

