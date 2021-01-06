-- =========================================================================================
-- Author: Serhii Kopytko
-- Create date:	2020/12/30
-- Update date: 2021/01/06
-- Description:	Create new 'OperationRunID' and add information about current status and start time
-- Parameters: @MinProd, @MaxProd - Required. Minimum and maximum value of the number of unique products for revaluation
--			   ,@percent - Required. The percentage by which the price of revalued products will be changed
--			   ,@Action - Required. Can be 'up' to increase, or 'down' - to reduce the price
-- Execution: On Demand
-- ==========================================================================================

CREATE PROCEDURE [Logs].[spStartOperationRuns] (
	@CurrentOperation INT = NULL
	,@CurrentRunID INT = NULL OUTPUT
)
AS

BEGIN
	BEGIN TRY
		DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)

	-- Create new 'OperationRunID' and add information about current status and start time.
	INSERT INTO Logs.OperationRuns (StatusID
									,OperationID)
		VALUES
		((SELECT OperationStatusID FROM Logs.OperationsStatuses WHERE Status = 'R') 
		,@CurrentOperation)	

	SET @CurrentRunID = SCOPE_IDENTITY()
	
	-- Create event about start of 'OperationRuns' process
	INSERT INTO Logs.EventLogs (OperationRunID
								,EventProcName
								,EventStatusID
								,EventMessage)
		SELECT 
							@CurrentRunID AS OperationRunID
						  ,@EventProcName AS EventProcName,
			(SELECT OperationStatusID 
			 FROM Logs.OperationsStatuses 
			 WHERE Status = 'R')		  AS EventStatusID,
			 'is running'				  AS EventMessage

	END TRY
	
	BEGIN CATCH

	END CATCH
		
END;