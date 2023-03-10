-- a. Print  all  student  information  (i.e.  information  in  the  student  table).  
--    Call  your stored procedure usp_getStudentInfo.

CREATE PROCEDURE usp_getStudentInfo
AS
SELECT * 
FROM Student
GO

EXECUTE usp_getStudentInfo

-- b. Print  the  grades  for  a  particular  student.  
-- Student  number  is  passed  as  an  input parameter  and  the  store  procedure  
-- prints  the  course  id,  course  name,  semester, 
-- year and grade obtained. Call your stored procedure usp_getStudentTranscript

CREATE PROCEDURE usp_getStudentTranscript
@stdNo CHAR(5) -- input
AS 
SELECT r.courseID, c.cName, s.semester, s.year, r.grade
FROM ((Register AS r
INNER JOIN Semester AS s ON r.semesterID = s.semesterID) 
INNER JOIN Course AS c ON r.courseID = c.courseID)
WHERE r.stdNo = @stdNo
GO


EXECUTE usp_getStudentTranscript @stdNo = 'S0001'

-- c. Return  the  number  of  courses  that  a  particular  student  has  got  an  A  grade.  
--    The student number is passed as an input parameter and number of A grades is passed as an output parameter.  
--    If a non-existing student number is passed  as input, then the number of courses with A grade is returned as -1. 

CREATE PROCEDURE usp_getNoAGrades
@stdNo CHAR(5), -- input
@gradeCount INT OUTPUT
AS 
    SELECT @gradeCount = COUNT(*)
    FROM Register
    WHERE @stdNo = stdNo AND grade = 'A'
    IF @gradeCount = 0
    BEGIN
        SET @gradeCount = -1
    END
GO

-- test for no A's
DECLARE @gradeCount INT
EXECUTE usp_getNoAGrades 
'S0210', -- input parameter
@gradeCount OUT -- output parameter
PRINT 'Number of A grades = ' + CAST(@gradeCount AS CHAR)

-- test for A's
DECLARE @gradeCount INT
EXECUTE usp_getNoAGrades 
'S0001', -- input parameter
@gradeCount OUT -- output parameter
PRINT 'Number of A grades = ' + CAST(@gradeCount AS CHAR)

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

