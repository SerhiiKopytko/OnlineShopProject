CREATE PROCEDURE [Master].[spLoadingWarehouse]
(
@CurrentVersion INT = NULL
)
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

 EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

	INSERT INTO [Master].WareHouses(ProductID, Price, StartVersion)
		SELECT ProductID, 
			   PricePerUnit, 
			   @CurrentVersion AS StartVersion
			FROM Staging.NewDeliveries

			SET @RowCount = (SELECT @@ROWCOUNT)  -- Calculate and save how many rows were populeted

  EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount, @CurrentVersion	-- Compliting operation process
END;
