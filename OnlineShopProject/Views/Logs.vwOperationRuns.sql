CREATE VIEW [Logs].[vwOperationRuns]
	AS 
	SELECT r.OperationRunID,
	   r.ManagerID,
	   s.StatusName,
	   r.OperationRunDescription,
	   r.StartTime,
	   r.EndTime
FROM Logs.OperationRuns AS r
JOIN Logs.OperationsStatuses AS s ON s.OperationStatusID = r.StatusID
