IF OBJECT_ID ('F_GetFreeClassroom', 'TF') IS NOT NULL
    DROP FUNCTION F_GetFreeClassroom;
GO
CREATE FUNCTION F_GetFreeClassroom (
	@p_DayWeek		  int,
	@p_LessonType	  int,
	@p_LessonNumber   int
)
RETURNS @retFindFreeClassroom TABLE 
(
    Number int primary key NOT NULL
)
AS
BEGIN
	DECLARE @v_StartTime Time,
			@v_EndTime	 Time;
	select @v_StartTime = StartTime,
		   @v_EndTime	= EndTime
	from Lesson
	where LessonType = @p_LessonType and Number = @p_LessonNumber;    
-- copy the required columns to the result of the function 
   INSERT @retFindFreeClassroom
   SELECT cr.Number
   FROM Classroom cr
   WHERE cr.Number not in
   ( SELECT Classroom
	 FROM V_Schedule sch 
	 WHERE ((@v_StartTime BETWEEN sch.StartTime and sch.EndTime) or
			(@v_EndTime BETWEEN sch.StartTime and sch.EndTime)) and
			DayWeek = @p_DayWeek
   );
   RETURN
END;
GO
