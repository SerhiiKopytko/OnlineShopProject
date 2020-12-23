CREATE PROCEDURE [Master].[spRestockingNewDeliveryProcessWithSSIS]

AS

BEGIN

	-- Starting 'OperationRuns' process:
	-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns 
		
		EXECUTE Master.spCreateNewLoadVersion
		EXECUTE Master.spLoadingWarehouse 
			   
	-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns

END;