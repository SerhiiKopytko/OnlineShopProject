CREATE PROCEDURE [Master].[spLoadingWarehouse]
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

 EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

	INSERT INTO [Master].WareHouses(ProductID, Price, StartVersion)
		SELECT ProductID, 
			   PricePerUnit, 
			   IDENT_CURRENT('[Master].VersionConfigs') AS StartVersion
			FROM Staging.NewDeliveries

			SET @RowCount = (SELECT @@ROWCOUNT)  -- Calculate and save how many rows were populeted

			
	TRUNCATE TABLE Staging.NewDeliveries
	
  EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
