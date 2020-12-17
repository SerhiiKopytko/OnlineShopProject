CREATE PROCEDURE [Logs].[spDataOperationStatus]
AS
BEGIN

	IF OBJECT_ID('Logs.OperationsStatuses', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE Logs.OperationRuns
		DROP CONSTRAINT FK_LogsOperationRunsStatusID_LogsOperationsStatusesOperationStatusID

		ALTER TABLE Logs.EventLogs
		DROP FK_LogsEventLogsEventStatusID_LogsOperationsStatusesOperationStatusID

		TRUNCATE TABLE Logs.OperationsStatuses
			INSERT INTO Logs.OperationsStatuses (Status, StatusName, StatusDescription)
			VALUES
			('R', 'Running', NULL),
			('F', 'Failed', NULL),
			('C', 'Completed', NULL)

		ALTER TABLE Logs.OperationRuns
		ADD CONSTRAINT FK_LogsOperationRunsStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (StatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID)

		ALTER TABLE  Logs.EventLogs
		ADD CONSTRAINT FK_LogsEventLogsEventStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (EventStatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID)
    END
END;
