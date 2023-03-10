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