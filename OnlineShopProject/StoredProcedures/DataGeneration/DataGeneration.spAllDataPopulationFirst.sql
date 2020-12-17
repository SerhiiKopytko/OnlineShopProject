CREATE PROCEDURE [DataGeneration].[spAllDataPopulationFirst]
AS
BEGIN

--Populating all data necessary befor logging processes.
	EXECUTE Logs.spDataOperationStatus
	EXECUTE DataGeneration.spCalendars -- sp has two parameters: 'start date' and period in years (by default is '19700101', 70)

END;
