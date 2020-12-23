--------------------------
--Version tables
-------------------------

--------------------------
--Version tables
-------------------------

--------------------------
--Version tables
-------------------------

--------------------------
--Version tables
-------------------------

CREATE TABLE [Master].VersionConfigs (
	VersionID INT IDENTITY(10000,10000) NOT NULL,
	VersionDateTime DATETIME NULL,
	OperationRunID INT NULL,
	CONSTRAINT PK_MasterVersionConfigsVersionID PRIMARY KEY(VersionID),
	CONSTRAINT FK_MasterVersionConfigsOperationRunID_LogsOperationRunsOperationRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID)
);