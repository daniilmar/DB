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
select Number     as Number,
	   LessonType as LessonType,
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
select sch.LessonNumber as LessonNumber,
	   sch.LessonType	as LessonType,
	   sch.Classroom    as Classroom,
	   sch.CourseID		as CourseID,
	   sch.DayWeek		as DayWeek,
	   l.StartTime		as StartTime,
	   l.EndTime		as EndTime
from Schedule  sch
inner join Lesson l on (l.LessonType = sch.LessonType and l.Number = sch.LessonNumber)
go
