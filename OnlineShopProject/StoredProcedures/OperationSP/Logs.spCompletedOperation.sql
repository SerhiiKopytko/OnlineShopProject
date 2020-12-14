CREATE PROCEDURE [Logs].[spCompletedOperation]
(
@EventProcName  VARCHAR(250),
@RowCount INT
)
AS
BEGIN
-- Create event about start of @EventProcName process
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, EventStatusID, EventMessage, AffectedRows)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
		@EventProcName						AS EventProcName,
		(SELECT OperationStatusID 
			FROM Logs.OperationsStatuses 
			WHERE Status = 'C')				AS EventStatusID,
		'is completed'						AS EventMessage,
		@RowCount							AS AffectedRows
END;

