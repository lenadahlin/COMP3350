-- CREATE TABLE + DATA
/*
-- CREATE TABLE + DATA
DROP TABLE IF EXISTS Register --
DROP TABLE IF EXISTS Semester --
DROP TABLE IF EXISTS Course --
DROP TABLE IF EXISTS Student --

CREATE TABLE Student(
    stdNo CHAR(5) PRIMARY KEY,
    login CHAR(6),
    lastName VARCHAR(25),
    givenNames VARCHAR(50),
    programCode CHAR(4)
) CREATE TABLE Course (
    courseID CHAR(8) PRIMARY KEY,
    cName VARCHAR(25),
    credits INT CHECK (credits BETWEEN 0 AND 200)
         DEFAULT '20',
    assumedKnowledge CHAR(8),   
    FOREIGN KEY (assumedKnowledge) REFERENCES Course(courseID) ON UPDATE NO ACTION ON DELETE NO ACTION
) CREATE TABLE Semester (
    semesterID INT PRIMARY KEY CHECK (semesterID >= 0),
    semester INT CHECK (
        semester BETWEEN 1 AND 4
    ),
    year INT CHECK (
        year BETWEEN 2000 AND 9999
    )
) CREATE TABLE Register (
    stdNo CHAR(5), 
    courseID CHAR(8),
    semesterID INT,
    grade CHAR(2),
    mark DECIMAL(5,2) CHECK (mark BETWEEN 0 AND 100) DEFAULT '0.0',
    PRIMARY KEY(stdNo, courseID, semesterID),
    FOREIGN KEY (stdNo) REFERENCES Student(stdNo) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (courseID) REFERENCES Course(courseID) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (semesterID) REFERENCES Semester(semesterID) ON UPDATE CASCADE ON DELETE NO ACTION
    )

GO

INSERT INTO
    Student
VALUES
    (
        'S0001',
        'ABI723',
        'Ingel',
        'Abby Kate',
        'BITC'
    ),
    (
        'S0210',
        'KWE231',
        'Kent',
        'Robert',
        'BSCS'
    );

INSERT INTO
    Course
VALUES
    (
        'INFT2040',
        'Database Management',
        20,
        NULL
    ),
    (
        'INFT2132',
        'Advance Programming',
        20,
        NULL
    ),
    (
        'INFT4001',
        'Project',
        40,
        'INFT2132'
    ),
        (
        'INFT4002',
        'Project',
        40,
        'INFT2132'
    ),
     (
        'INFT4003',
        'Project',
        40,
        'INFT2132'
    ),
     (
        'INFT4004',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4005',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4006',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4007',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4008',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4009',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4010',
        'Project',
        40,
        'INFT2132'
    ),
    (
        'INFT4011',
        'Project',
        40,
        'INFT2132'
    );

INSERT INTO
    Semester
VALUES
    (1, 1, 2006),
    (2, 2, 2006),
    (3, 1, 2007),
    (4, 3, 2010);

INSERT INTO
    Register
VALUES
    (
        'S0001',
        'INFT2040',
        1,
        'A',
        98.02
    ),
    (
        'S0001',
        'INFT2132',
        2,
        'B',
        80.32
    ),
    (
        'S0210',
        'INFT2132',
        2,
        'B+',
        87.89
    ),
    (
        'S0210',
        'INFT2040',
        '3',
        NULL,
        NULL
    );




---------------
--DROP TRIGGER
DROP TRIGGER tr_EnforceCourseRepetitionPolicy

--CREATE TRIGGER A student is not allowed to repeat a course more than three times
/*
CREATE TRIGGER tr_EnforceCourseRepetitionPolicy  
ON Register 
FOR UPDATE, INSERT 
AS 
BEGIN 
    IF ((SELECT COUNT(*) 
        FROM inserted i, Register r
        WHERE i.courseID = r.courseID AND i.stdNo = r.stdNo) >3)
    BEGIN
        RAISERROR ('Student cannot enrol in a course more than 3 times', 9, 1) 
        ROLLBACK TRANSACTION
    END
END
*/
--DROP TRIGGER
DROP TRIGGER IF EXISTS tr_EnforceCourseRepetitionPolicy
*/
--CREATE TRIGGER A student cannot register for more than 10 courses in a single semester
CREATE TRIGGER tr_EnforceCourseRegistrationPolicy
ON Register
FOR UPDATE, INSERT
AS
BEGIN
    IF ((SELECT COUNT(*)
        FROM inserted i, Register r
        WHERE i.stdNo = r.stdNo AND i.semesterID = r.semesterID) > 10)
    BEGIN 
        DECLARE @stdNum AS CHAR(5)
            SELECT @stdNum = stdNo
            FROM inserted 

        DECLARE @semester AS INT 
            SELECT @semester = s.semester
            FROM inserted i, semester s
            WHERE i.semesterID = s.semesterID

        DECLARE @year as INT
            SELECT @year = s.year
            FROM inserted i, semester s
            WHERE i.semesterID = s.semesterID

        DECLARE @errMsg AS VARCHAR(255)
        SET @errMsg = 'Student ' + @stdNum + ' cannot register for more than 10 courses in the semester ' + CAST(@semester AS VARCHAR(10)) + ', ' + CAST(@year AS VARCHAR(10))

        RAISERROR (@errMsg, 9, 1)
        ROLLBACK TRANSACTION
    END
END

-- should give error

INSERT INTO Register VALUES
    (
        'S0001',
        'INFT4001',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4002',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4003',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4004',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4005',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4006',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4007',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4008',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4009',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4010',
        4,
        'A',
        98.02
    ),
        (
        'S0001',
        'INFT4011',
        4,
        'A',
        98.02
    );