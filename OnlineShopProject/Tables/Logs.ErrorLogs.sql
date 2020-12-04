CREATE TABLE Logs.ErrorLogs (
	ErrorID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NOT NULL,
	EventID INT NOT NULL,
	ErrorNumber INT NOT NULL,
	ErrortProcName VARCHAR(50) NOT NULL,
	ErrorParameter VARCHAR(50) NOT NULL,
	ErrorMessage VARCHAR(MAX) NOT NULL,
	ErrorDataTime DATETIME NOT NULL,
	CONSTRAINT PK_LogsErrorLogsErrorID PRIMARY KEY(ErrorID),
	CONSTRAINT FK_LogsErrorLogsEventID_LogsEventLogsEventID FOREIGN KEY (EventID) REFERENCES Logs.EventLogs(EventID)
);