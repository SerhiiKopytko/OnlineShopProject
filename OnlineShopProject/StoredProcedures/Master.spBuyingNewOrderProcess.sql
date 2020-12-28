CREATE PROCEDURE [Master].[spBuyingNewOrderProcess]

AS

BEGIN

	DECLARE
	  @CurrentOrderID INT,
	  @CurrentOperation INT = 3 --Buying New Order Process

		EXECUTE [Staging].[spCreateNewOrder]           -- Generate new random order
		EXECUTE [Staging].[spNewOrderIntoStagingTable] -- Insert new random order into '[Staging].[NewOrders]' table

		-- Starting 'OperationRuns' process:
		-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns @CurrentOperation

			EXECUTE Master.spLoadNewOrder  -- Load new order into '[Master].[Orders] and [Master].[OrderDetails]' tables
		
		    SET @CurrentOrderID = IDENT_CURRENT('Master.Orders')

			EXECUTE Master.spBuyingProducts @CurrentOrderID


		-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns
END;

