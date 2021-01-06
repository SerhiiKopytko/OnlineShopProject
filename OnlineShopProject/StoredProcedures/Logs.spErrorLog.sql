CREATE PROCEDURE [Logs].[spErrorLog] (
	@OperationRunID INT = NULL
	,@IventID INT = NULL
	,@ErrorDateTime DATETIME =NULL
)

AS
	BEGIN
		INSERT INTO Logs.ErrorLogs (OperationRunID
									,EventID
									,ErrorProcName
									,ErrorDataTime
									,ErrorLine
									,ErrorNumber
									,ErrorSeverity
									,ErrorState
									,ErrorMessage)
		SELECT  @OperationRunID     AS OperationRunID 
				,@IventID		   AS IventID
				,ERROR_PROCEDURE() AS ErrortProcName
				,@ErrorDateTime	   AS ErrorDataTime
				,ERROR_LINE()	   AS ErrorLine
				,ERROR_NUMBER()    AS ErrorNumber
				,ERROR_SEVERITY()  AS ErrorSeverity
				,ERROR_STATE()     AS ErrorState
				,ERROR_MESSAGE()   AS ErrorMessage
	
	END;
