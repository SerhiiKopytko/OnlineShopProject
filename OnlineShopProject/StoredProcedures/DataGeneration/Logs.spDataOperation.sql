CREATE PROCEDURE [Logs].[spDataOperation]
AS

BEGIN

IF OBJECT_ID('Logs.Operations', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE Logs.OperationRuns
		DROP CONSTRAINT FK_LogsOperationRunsOperationID_LogsOperationsOperationID

		TRUNCATE TABLE Logs.Operations
			INSERT INTO Logs.Operations (OperationName)
			VALUES
			('Initial Filling of the Database'),
			('Restocking New Delivery Process'),
			('Buying New Order Process'),
			('Revaluation of the products')

		ALTER TABLE Logs.OperationRuns
		ADD CONSTRAINT FK_LogsOperationRunsOperationID_LogsOperationsOperationID FOREIGN KEY (OperationID) REFERENCES Logs.Operations(OperationID)

		
    END

END;
