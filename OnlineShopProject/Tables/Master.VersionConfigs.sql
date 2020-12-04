CREATE TABLE [Master].VersionConfigs (
	VersionID INT IDENTITY(1,1) NOT NULL,
	CurrentVersion INT NOT NULL,
	VersionDateTime DATETIME NOT NULL,
	VersionTypeID INT NOT NULL,
	OperationRunID INT NOT NULL,
	CONSTRAINT PK_MasterVersionConfigsVersionID PRIMARY KEY(VersionID),
	CONSTRAINT FK_MasterVersionConfigsVersionTypeID_MasterVersionTypesVersionTypeID FOREIGN KEY (VersionTypeID) REFERENCES [Master].VersionTypes(VersionTypeID),
	CONSTRAINT FK_MasterVersionConfigsOperationRunID_LogsOperationRunsOperationRunID FOREIGN KEY (OperationRunID) REFERENCES Logs.OperationRuns(OperationRunID)
);