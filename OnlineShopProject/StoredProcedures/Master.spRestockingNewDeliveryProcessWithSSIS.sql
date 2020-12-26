CREATE PROCEDURE [Master].[spRestockingNewDeliveryProcessWithSSIS]

AS

BEGIN
DECLARE
@CurrentOperation INT = 2 --Restocking New Delivery Process

	-- Starting 'OperationRuns' process:
	-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns @CurrentOperation
		
		EXECUTE Master.spCreateNewLoadVersion
		EXECUTE Master.spLoadingWarehouse 
			   
	-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns

END;