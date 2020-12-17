CREATE PROCEDURE [Logs].[spCompletedOperationRuns]
AS

BEGIN

	DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

	--Update necessary fields of 'Logs.Operation Runs' table as the end of this process
	UPDATE Logs.OperationRuns 
		SET EndTime  = CURRENT_TIMESTAMP, 
			StatusID = (SELECT OperationStatusID 
						FROM Logs.OperationsStatuses 
						WHERE Status = 'C'),
			OperationRunDescription = 'successfully completed'
		WHERE OperationRunID = IDENT_CURRENT('Logs.OperationRuns')

	-- Create event about complete of 'OperationRuns' process
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, EventMessage)
		SELECT 
			IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
			@EventProcName						AS EventProcName,
			(SELECT OperationStatusID 
				FROM Logs.OperationsStatuses 
				WHERE Status = 'C')				AS EventStatusID,
			'successfully completed'			AS EventMessage
END;
