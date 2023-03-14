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



-- d. Create  a  stored  procedure  called  usp_RegisterForCourse  which  takes  as  input  a table-valued parameter (TVP) 

-- Create a type which is a table
CREATE TYPE registerType AS TABLE 
(
stdNo CHAR(5),
courseID CHAR(8),
semesterID INT,
grade CHAR(2),
mark DECIMAL(5,2),
PRIMARY KEY (stdNo))
GO

-- creates the procedure to use the TVP to insert to Register
CREATE PROCEDURE RegisterForCourses @newRegister registerType READONLY
AS
BEGIN
	INSERT INTO Register(stdNo, courseID, semesterID, grade, mark)
	SELECT stdNo, courseID, semesterID, grade, mark
	FROM @newRegister
END

DECLARE @rList registerType -- declares variable

INSERT INTO @rList VALUES ('S0001', 'INFT4001', 3, 'A', 90.10)
INSERT INTO @rList VALUES ('S0210', 'INFT4001', 3, 'C', 60.89)

EXECUTE RegisterForCourses @rList
GO