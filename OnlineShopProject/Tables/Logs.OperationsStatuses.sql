CREATE TABLE Logs.OperationsStatuses (
	OperationStatusID INT IDENTITY(1,1) NOT NULL,
	[Status] VARCHAR(50)  NULL,
	StatusName VARCHAR(250) NULL,
	StatusDescription VARCHAR(MAX) NULL,
	CONSTRAINT PK_LogsOperationsStatusesOperationStatusID PRIMARY KEY(OperationStatusID)
);