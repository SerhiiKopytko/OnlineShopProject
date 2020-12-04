CREATE TABLE Logs.OperationsStatuses (
	OperationStatusID INT IDENTITY(1,1) NOT NULL,
	[Status] VARCHAR(30) NOT NULL,
	StatusName VARCHAR(50) NOT NULL,
	StatusDescription VARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_LogsOperationsStatusesOperationStatusID PRIMARY KEY(OperationStatusID)
);