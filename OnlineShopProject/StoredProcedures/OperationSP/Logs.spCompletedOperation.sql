CREATE PROCEDURE [Logs].[spCompletedOperation]
(
@EventProcName  VARCHAR(250),
@RowCount INT,
@Version INT = NULL
)
AS
BEGIN
-- Create event about start of @EventProcName process
	INSERT INTO Logs.EventLogs (OperationRunID, EventProcName, Parameter, EventStatusID, EventMessage, AffectedRows)
	SELECT 
		IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID,
		@EventProcName						AS EventProcName,
		@Version                            AS Parameter,
		(SELECT OperationStatusID 
			FROM Logs.OperationsStatuses 
			WHERE Status = 'C')				AS EventStatusID,
		'is completed'						AS EventMessage,
		@RowCount							AS AffectedRows
END;

