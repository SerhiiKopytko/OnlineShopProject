CREATE VIEW [Logs].[vwEventLogs]
AS

SELECT e.EventID,
	   e.OperationRunID,
	   o.OperationName,
	   s.StatusName,
	   e.AffectedRows,
	   e.EventProcName,
	   e.Parameter,
	   e.EventMessage,
	   e.EventDataTime,
	   e.[User]
FROM Logs.EventLogs AS e
JOIN Logs.OperationsStatuses AS s ON s.OperationStatusID = e.EventStatusID
JOIN Logs.OperationRuns AS r ON e.OperationRunID = r.OperationRunID
JOIN Logs.Operations AS o ON o.OperationID = r.OperationID