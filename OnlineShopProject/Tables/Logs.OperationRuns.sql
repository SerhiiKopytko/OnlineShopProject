CREATE TABLE Logs.OperationRuns (
	OperationRunID INT IDENTITY(1,1) NOT NULL,
	OperationID INT NOT NULL,
	StatusID INT NOT NULL,
	StartTime DATETIME NOT NULL,
	EndTime DATETIME NOT NULL,
	OperationRunDescription VARCHAR(50) NOT NULL,
	ManagerID INT NOT NULL,
	CONSTRAINT PK_LogsOperationRunsOperationRunID PRIMARY KEY(OperationRunID),
	CONSTRAINT FK_LogsOperationRunsOperationID_LogsOperationsOperationID FOREIGN KEY (OperationID) REFERENCES Logs.Operations(OperationID),
	CONSTRAINT FK_LogsOperationRunsStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (StatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID),
	CONSTRAINT FK_LogsOperationRunsManagerID_MasterEmployeesManagerID FOREIGN KEY (ManagerID) REFERENCES [Master].Employees(ManagerID)
);