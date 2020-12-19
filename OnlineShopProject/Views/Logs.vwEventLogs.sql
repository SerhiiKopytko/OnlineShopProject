CREATE VIEW [Logs].[vwEventLogs]
	AS 
	SELECT e.EventID,
	   e.OperationRunID,
	   s.StatusName,
	   e.AffectedRows,
	   e.EventProcName,
	   e.EventMessage,
	   e.EventDataTime,
	   e.[User]
FROM Logs.EventLogs AS e
JOIN Logs.OperationsStatuses AS s ON s.OperationStatusID = e.EventStatusID