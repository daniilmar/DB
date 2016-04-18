--Classroom -----------------------------------------
IF OBJECT_ID('Classroom', 'U') IS NOT NULL
  DROP TABLE Classroom;
GO

CREATE TABLE Classroom
(
Number int IDENTITY(1,1),
PRIMARY KEY (Number)
)

--Course -----------------------------------------
IF OBJECT_ID('Course', 'U') IS NOT NULL
  DROP TABLE Course;
GO

CREATE TABLE Course
(
CourseID int IDENTITY(1,1),
Name	 varchar(256) NOT NULL,
PRIMARY KEY (CourseID)
)

--Lesson -----------------------------------------
IF OBJECT_ID('Lesson', 'U') IS NOT NULL
  DROP TABLE Lesson;
GO

CREATE TABLE Lesson
(
Number		int			NOT NULL,
LessonType  varchar(64) NOT NULL,
StartTime   TIME		NOT NULL,
EndTime		TIME		NOT NULL,
CHECK (LessonType IN ('дневное', 'вечернее', 'факультатив')),
INDEX LessonIndex CLUSTERED (StartTime, LessonType, Number),
PRIMARY KEY (Number, LessonType)
)

--Schedule -----------------------------------------
IF OBJECT_ID('Schedule', 'U') IS NOT NULL
  DROP TABLE Schedule;
GO

CREATE TABLE Schedule
(
DayWeek		 varchar(64) NOT NULL,
LessonNumber int		 NOT NULL,
LessonType   varchar(64) NOT NULL,
Classroom	 int		 NOT NULL,
CourseID	 int		 NOT NULL,
CHECK (DayWeek IN ('пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс')),
INDEX LessonIndex CLUSTERED (DayWeek, LessonNumber, LessonType),
PRIMARY KEY (LessonNumber, LessonType, Classroom, CourseID),
FOREIGN KEY (LessonNumber, LessonType) REFERENCES Lesson(Number, LessonType),
FOREIGN KEY (Classroom)			       REFERENCES Classroom(Number),
FOREIGN KEY (CourseID)				   REFERENCES Course(CourseID)
)
