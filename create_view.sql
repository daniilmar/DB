-- V_Course -------------------------------------------
if object_id('V_Course', 'V') is not null
  drop view V_Course;
go

create view V_Course
as
select CourseID as CourseID,
	   Name		as Name
from Course
go
-- V_Lesson -------------------------------------------
if object_id('V_Lesson', 'V') is not null
  drop view V_Lesson;
go

create view V_Lesson
as
select LessonType as LessonType,
	   Number     as Number,	   
	   StartTime  as StartTime,
	   EndTime	  as EndTime
from Lesson
go

-- V_Classroom -------------------------------------------
if object_id('V_Classroom', 'V') is not null
  drop view V_Classroom;
go

create view V_Classroom
as
select Number as Number
from Classroom
go

-- V_Schedule -------------------------------------------
if object_id('V_Schedule', 'V') is not null
  drop view V_Schedule;
go

create view V_Schedule
as
select sch.LessonType	as LessonType,
	   sch.LessonNumber as LessonNumber,
	   sch.Classroom    as Classroom,
	   sch.CourseID		as CourseID,
	   c.Name   		as Course,
	   sch.DayWeek		as DayWeek,
	   l.StartTime		as StartTime,
	   l.EndTime		as EndTime
from Schedule  sch
inner join Lesson l on (l.LessonType = sch.LessonType and l.Number = sch.LessonNumber)
inner join Course c on (c.CourseID = sch.CourseID)
go
