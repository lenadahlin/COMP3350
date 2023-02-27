CREATE TABLE Student(
    stdNo CHAR(5) PRIMARY KEY,
    login CHAR(6),
    lastName VARCHAR(25),
    givenNames VARCHAR(50),
    programCode CHAR(4)
)

CREATE TABLE Course (
    courseID CHAR(8) PRIMARY KEY,
    cName VARCHAR(25),
    credits INT(3) CHECK (credits>=0 AND credits <=100)
    --assumed knowledge FK
)

CREATE TABLE Semester (
    semesterID INT PRIMARY KEY CHECK (semesterID > 0),
    semester INT CHECK (semester >= 1 AND semester <= 4),
    year INT CHECK (year >= 2000 AND year <= 9999)
)