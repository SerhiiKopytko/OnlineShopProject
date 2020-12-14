CREATE TABLE Logs.ErrorLogs (
	ErrorID INT IDENTITY(1,1) NOT NULL,
	OperationRunID INT NULL,
	EventID INT NULL,
	ErrortProcName VARCHAR(250) NULL,
	ErrorLine INT,
	ErrorMessage VARCHAR(MAX) NULL,
	ErrorNumber INT NULL,
	ErrorSeverity INT,
	ErrorState VARCHAR(MAX) NULL,
	ErrorParameter VARCHAR(250) NULL,
	ErrorDataTime DATETIME NULL,
	CONSTRAINT PK_LogsErrorLogsErrorID PRIMARY KEY(ErrorID),
	CONSTRAINT FK_LogsErrorLogsEventID_LogsEventLogsEventID FOREIGN KEY (EventID) REFERENCES Logs.EventLogs(EventID)
);