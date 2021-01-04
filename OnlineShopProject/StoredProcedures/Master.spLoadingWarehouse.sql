-- =========================================================================================
-- Author: Serhii Kopytko
-- Create date:	2021/01/04
-- Description:	Loading delivery data into warehouse
-- Parameters: @orderID - Required. Order ID for new record
--			   @productID - Required. Product ID for Order
--			   @quantity - Required. quantity of product for Order
-- Execution: On Demand
-- ==========================================================================================



CREATE PROCEDURE [Master].[spLoadingWarehouse](
	@CurrentVersion INT = NULL
)
AS

BEGIN
	BEGIN TRY
		DECLARE @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID)
		DECLARE @RowCount INT

		-- SET NOCOUNT ON added to prevent extra result sets from
		SET NOCOUNT ON;

		-- logging start operation process
		EXECUTE Logs.spStartOperation @EventProcName 

		INSERT INTO [Master].WareHouses(ProductID 
										,Price
										,StartVersion)
			SELECT ProductID        AS ProductID
				   ,PricePerUnit    AS Price
			       ,@CurrentVersion AS StartVersion
			FROM Staging.NewDeliveries

			-- Calculate and save how many rows were populeted
			SET @RowCount = (SELECT @@ROWCOUNT)  

		EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount, @CurrentVersion	-- Compliting operation process


	END TRY

	BEGIN CATCH

	END CATCH




END;
