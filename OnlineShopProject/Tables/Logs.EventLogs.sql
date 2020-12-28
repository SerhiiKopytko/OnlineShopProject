CREATE TABLE Logs.EventLogs (
	EventID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NOT NULL,
	[User] VARCHAR(250) CONSTRAINT DF_LogsEventLogsUser DEFAULT SUSER_NAME(),
	EventDataTime DATETIME CONSTRAINT DF_LogsEventLogsEventStartTime DEFAULT CURRENT_TIMESTAMP,
	EventStatusID INT NULL,
	AffectedRows INT CONSTRAINT DF_LogsEventLogsAffectedRows DEFAULT 0,
	Parameter VARCHAR(250) NULL,
	EventProcName VARCHAR(250) NULL,
	EventMessage VARCHAR(MAX),
	CONSTRAINT PK_LogsEventLogsEventID PRIMARY KEY(EventID),
	CONSTRAINT FK_LogsEventLogsOperationRunID_LogsOperationRunsOperationRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID),
	CONSTRAINT FK_LogsEventLogsEventStatusID_LogsOperationsStatusesOperationStatusID FOREIGN KEY (EventStatusID) REFERENCES Logs.OperationsStatuses(OperationStatusID)
);