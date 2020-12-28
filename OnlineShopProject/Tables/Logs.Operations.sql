--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
--------------------------------
-- SCHEMA Logs
--------------------------------
CREATE TABLE Logs.Operations (
	OperationID INT IDENTITY(1,1) NOT NULL,
	OperationName VARCHAR(250) NULL,
	OperationDescription VARCHAR(MAX) NULL,
	CONSTRAINT PK_LogsOperationsOperationsID PRIMARY KEY(OperationID)
);