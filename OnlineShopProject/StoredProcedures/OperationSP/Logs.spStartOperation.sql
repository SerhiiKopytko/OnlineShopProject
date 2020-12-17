CREATE PROCEDURE [Logs].[spStartOperation]
(
@EventProcName  VARCHAR(250)
)
AS
BEGIN
-- Create event about start of @EventProcName process
	INSERT INTO Logs.EventLogs(OperationRunID, EventProcName, EventStatusID, EventMessage)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
		@EventProcName						AS EventProcName,
		(SELECT OperationStatusID 
			FROM Logs.OperationsStatuses 
			WHERE Status = 'R')			    AS EventStatusID,
		'is running'						AS EventMessage
END;

