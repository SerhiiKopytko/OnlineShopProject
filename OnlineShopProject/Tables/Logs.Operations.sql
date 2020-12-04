--------------------------------
-- SCHEMA Logs
--------------------------------
CREATE TABLE Logs.Operations (
	OperationID INT IDENTITY(1,1) NOT NULL,
	OperationName VARCHAR(50) NOT NULL,
	OperationDescription VARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_LogsOperationsOperationsID PRIMARY KEY(OperationID)
);