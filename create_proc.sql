-- P_CourseCreate -------------------------------------------
if object_id('P_CourseCreate', 'P') is not null
  drop procedure P_CourseCreate;
go

create procedure P_CourseCreate(
 @p_Name varchar(max)
)
as set nocount, xact_abort on set concat_null_yields_null off
begin try

  begin transaction;

  begin try

    insert into Course(Name)
    values (@p_Name);
    commit;

  end try
  begin catch
    rollback;
	RAISERROR('Course не добавлен',10, 1);
  end catch;

end try
begin catch  
	RAISERROR('Course не добавлен',10, 1);
end catch
go

-- P_ClassroomCreate -------------------------------------------
if object_id('P_ClassroomCreate', 'P') is not null
  drop procedure P_ClassroomCreate;
go

create procedure P_ClassroomCreate
as set nocount, xact_abort on set concat_null_yields_null off
begin try

  begin transaction;

  begin try

    insert  Classroom default values;
    commit;

  end try
  begin catch
    rollback;
	RAISERROR('Classroom не добавлен',10, 1);
  end catch;

end try
begin catch  
	RAISERROR('Classroom не добавлен',10, 1);
end catch
go

-- P_LessonCreate -------------------------------------------
if object_id('P_LessonCreate', 'P') is not null
  drop procedure P_LessonCreate;
go

create procedure P_LessonCreate(
 @p_Type		int,
 @p_StartTime	Time,
 @p_Duration	Time
)
as set nocount, xact_abort on set concat_null_yields_null off
begin try
	DECLARE @v_EndTime Time = @p_StartTime;
	
	select @v_EndTime = DATEADD(HOUR,DATEPART(HOUR,@p_Duration),   @v_EndTime );
	select @v_EndTime = DATEADD(MINUTE,DATEPART(MINUTE,@p_Duration),@v_EndTime );

	if @p_Type is null
		RAISERROR('Не указан тип пары',10,2);
	if @p_StartTime is null
		RAISERROR('Не указано время начала пары',10,2);
	if @p_Duration is null
		RAISERROR('Не указан время длительности пары',10,2);
	if (select count(*) from Lesson where LessonType = @p_Type and  
									((@p_StartTime between StartTime and EndTime) or 
									(@v_EndTime between StartTime and EndTime))) >0
		RAISERROR('Наложение времени пары на другое время',10,2);
	declare  @count_lesson int;
	set @count_lesson = (select count(*) from Lesson where LessonType = @p_Type);
  begin transaction;

  begin try

    insert  Lesson(Number, LessonType, StartTime, EndTime)
	values (@count_lesson+1, @p_Type, @p_StartTime, @v_EndTime);
	commit;
	
  end try
  begin catch
    rollback;
	RAISERROR('Classroom не добавлен',10, 1);
  end catch;

end try
begin catch  
	RAISERROR('Classroom не добавлен',10, 1);
end catch
go

-- P_ScheduleCreate -------------------------------------------
if object_id('P_ScheduleCreate', 'P') is not null
  drop procedure P_ScheduleCreate;
go

create procedure P_ScheduleCreate(
 @p_LessonType		int,
 @p_LessonNumber	int,
 @p_Classroom		int,
 @p_CourseID		int,
 @p_DayWeek			int
)
as set nocount, xact_abort on set concat_null_yields_null off
begin try

	if @p_LessonType is null
		RAISERROR('Не указан тип пары',10,2);
	if @p_LessonNumber is null
		RAISERROR('Не указан номер пары',10,2);
	if @p_Classroom is null
		RAISERROR('Не указана аудитория',10,2);
	if @p_CourseID is null
		RAISERROR('Не указан номер курса',10,2);
	if @p_DayWeek is null
		RAISERROR('Не указан день недели',10,2);

  begin transaction;

  begin try

    insert  Schedule(DayWeek, LessonNumber, LessonType, Classroom, CourseID)
	values (@p_DayWeek, @p_LessonNumber, @p_LessonType, @p_Classroom, @p_CourseID);
	commit;
	
  end try
  begin catch
    rollback;
	RAISERROR('Schedule не добавлен',10, 1);
  end catch;

end try
begin catch  
	RAISERROR('Schedule не добавлен',10, 1);
end catch
go



