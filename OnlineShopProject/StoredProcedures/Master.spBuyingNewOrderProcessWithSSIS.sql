CREATE PROCEDURE [Master].[spBuyingNewOrderProcessWithSSIS]

AS

BEGIN

	DECLARE
	  @CurrentOrderID INT,
	  @CurrentOperation INT = 3,--Buying New Order Process
	  @CurrentRunID INT
		-- Starting 'OperationRuns' process:
		-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns @CurrentOperation, @CurrentRunID = @CurrentRunID OUTPUT
			EXECUTE Master.spLoadNewOrder  -- Load new order into '[Master].[Orders] and [Master].[OrderDetails]' tables
		
		    SET @CurrentOrderID = IDENT_CURRENT('Master.Orders')

			EXECUTE Master.spBuyingProducts @CurrentOrderID


		-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns
END;
