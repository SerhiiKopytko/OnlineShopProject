CREATE TABLE [Master].Revaluations (
	RevaluationID INT IDENTITY(1,1) NOT NULL,
	ProductID INT,
	OldPrice SMALLMONEY,
	NewPrice SMALLMONEY,
	OldVersion INT,
	NewVersion INT,
	RevaluationDate DATETIME,
	CONSTRAINT PK_MasterRevaluationsRevaluationID PRIMARY KEY (RevaluationID)
);