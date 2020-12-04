CREATE TABLE Logs.EventLogs (
	EventID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NOT NULL,
	[User] VARCHAR(50) NOT NULL,
	AffectedRows INT NOT NULL,
	EventProcName VARCHAR(50) NOT NULL,
	EventParameter VARCHAR(50) NOT NULL,
	EventMessage VARCHAR(MAX) NOT NULL,
	EventDataTime DATETIME NOT NULL,
	CONSTRAINT PK_LogsEventLogsEventID PRIMARY KEY(EventID),
	CONSTRAINT FK_LogsEventLogsOperationRunID_LogsOperationRunsOperationRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID)
);