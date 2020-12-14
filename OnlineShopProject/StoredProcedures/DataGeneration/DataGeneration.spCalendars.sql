CREATE PROCEDURE [DataGeneration].[spCalendars]
	@StartDate DATE  = '19700101',
	@Years INT = 70
AS
BEGIN

DECLARE 
	@CutoffDate DATE

	SET @CutoffDate = DATEADD(DAY, -1, DATEADD(YEAR, @Years, @StartDate));

	IF OBJECT_ID ('DataGeneration.Calendars', 'U') IS NOT NULL
	DROP TABLE DataGeneration.Calendars;

WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
	d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
	src AS
(
  SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  FROM d
)
	SELECT * 
	  INTO DataGeneration.Calendars
	FROM src
	ORDER BY TheDate
	OPTION (MAXRECURSION 0);

ALTER TABLE DataGeneration.Calendars
ADD CalendarID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_DataGenerationCalendarsCalendarID PRIMARY KEY (CalendarID)

END;
