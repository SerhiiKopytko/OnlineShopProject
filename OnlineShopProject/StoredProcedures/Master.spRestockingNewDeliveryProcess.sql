﻿CREATE PROCEDURE [Master].[spRestockingNewDeliveryProcess]

AS

BEGIN

	EXECUTE Staging.spCreateNewDelivery           -- Generate new random delivery
	EXECUTE Staging.spNewDeliveryIntoStagingTable -- Insert new random delivery into 'Staging.NewDeliveries' table

	-- Starting 'OperationRuns' process:
	-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns 
		
		EXECUTE Master.spCreateNewLoadVersion
		EXECUTE Master.spLoadingWarehouse 
			   
	-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns

END;