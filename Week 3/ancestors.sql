-- Lena Dahlin c3391146
DROP TABLE IF EXISTS Person
GO
    CREATE TABLE Person (
        id INT PRIMARY KEY,
        name NVARCHAR(255),
        mother INT,
        father INT,
        FOREIGN KEY (mother) REFERENCES Person(id),
        FOREIGN KEY (father) REFERENCES Person(id)
    )
GO

INSERT INTO
    Person
VALUES
    (1, 'Sue', NULL, NULL),
    (2, 'Ed', NULL, NULL),
    (3, 'Emma', 1, 2),
    (4, 'Jack', 1, 2),
    (5, 'Jane', NULL, NULL),
    (6, 'Bonnie', 5, 4),
    (7, 'Bill', 5, 4);
GO

-- 1. iii) Find all Bonnie’s ancestors. 
WITH Ancestors AS
(
    SELECT 
        id,
        name,
        father,
        mother
    FROM Person
    WHERE name = 'Bonnie'
    UNION ALL
    SELECT
        p.id,
        p.name,
        p.father,
        p.mother
    FROM Ancestors as a
    JOIN Person p ON a.mother = p.id OR a.father = p.id
)
SELECT *
FROM Ancestors

