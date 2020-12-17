CREATE TABLE Logs.OperationRuns (
	OperationRunID INT IDENTITY(1,1) NOT NULL,
	OperationID INT NULL,
	StatusID INT NULL,
	StartTime DATETIME CONSTRAINT DF_LogsOperationRunsStartTime DEFAULT CURRENT_TIMESTAMP,
	EndTime DATETIME NULL,
	OperationRunDescription VARCHAR(MAX) CONSTRAINT DF_LogsOperationRunsOperationRunDescription DEFAULT 'Created new OperationRunID field and process is waiting following events.',
	ManagerID INT NULL--,
	CONSTRAINT PK_LogsOperationRunsOperationRunID PRIMARY KEY(OperationRunID),
	CONSTRAINT FK_LogsOperationRunsOperationID_LogsOperationsOperationID FOREIGN KEY (OperationID) REFERENCES Logs.Operations(OperationID),
	CONSTRAINT FK_LogsOperationRunsStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (StatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID),
	CONSTRAINT FK_LogsOperationRunsManagerID_MasterEmployeesManagerID FOREIGN KEY (ManagerID) REFERENCES [Master].Employees(ManagerID)
);