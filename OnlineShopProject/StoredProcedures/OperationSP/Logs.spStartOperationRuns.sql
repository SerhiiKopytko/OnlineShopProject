CREATE PROCEDURE [Logs].[spStartOperationRuns]
AS

BEGIN

	DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

	-- Create new 'OperationRunID' and add information about current status and start time.
	INSERT INTO Logs.OperationRuns (StatusID)
	VALUES
		((SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'R'))	
	
-- Create event about start of 'OperationRuns' process
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, EventMessage)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
							 @EventProcName AS EventProcName,
		(SELECT OperationStatusID 
			FROM Logs.OperationsStatuses 
			WHERE Status = 'R')				AS EventStatusID,
		 'is running'					    AS EventMessage
		
END;
