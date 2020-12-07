CREATE TABLE Logs.EventLogs (
	EventID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NOT NULL,
	[User] VARCHAR(250) NULL,
	AffectedRows INT NULL,
	EventProcName VARCHAR(250) NULL,
	EventParameter VARCHAR(250) NULL,
	EventMessage VARCHAR(MAX) NULL,
	EventDataTime DATETIME NULL,
	CONSTRAINT PK_LogsEventLogsEventID PRIMARY KEY(EventID),
	CONSTRAINT FK_LogsEventLogsOperationRunID_LogsOperationRunsOperationRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID)
);