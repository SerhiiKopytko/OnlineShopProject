CREATE PROCEDURE [Master].[spRestockingNewDeliveryProcess]

AS

BEGIN
DECLARE
@CurrentOperation INT = 2, --Restocking New Delivery Process
@CurrentVersion INT

	EXECUTE Staging.spCreateNewDelivery           -- Generate new random delivery
	EXECUTE Staging.spNewDeliveryIntoStagingTable -- Insert new random delivery into 'Staging.NewDeliveries' table

	-- Starting 'OperationRuns' process:
	-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns @CurrentOperation 
		
		EXECUTE @CurrentVersion = [Master].spCreateNewLoadVersion
		EXECUTE Master.spLoadingWarehouse @CurrentVersion
			   
	-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns

END;
