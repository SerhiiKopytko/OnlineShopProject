
CREATE PROCEDURE DataGeneration.spClearLogs
AS

BEGIN

  DECLARE
  @RowCount INT

  SELECT @RowCount = COUNT(*) FROM Logs.EventLogs

	IF @RowCount > 0
		BEGIN
			DELETE Logs.EventLogs
			DBCC CHECKIDENT ('Logs.EventLogs', RESEED, 0)
		END
	
  SELECT @RowCount = COUNT(*) FROM [Master].VersionConfigs

	IF @RowCount > 0
		BEGIN
			DELETE [Master].VersionConfigs
			DBCC CHECKIDENT ('[Master].VersionConfigs', RESEED, 0)
		END

  SELECT @RowCount = COUNT(*) FROM Logs.OperationRuns

	IF @RowCount > 0
		BEGIN
			DELETE Logs.OperationRuns
			DBCC CHECKIDENT ('Logs.OperationRuns', RESEED, 0)
		END


  SELECT @RowCount = COUNT(*) FROM [Master].WareHouses

	IF @RowCount > 0
		BEGIN
			UPDATE Master.OrderDetails
			SET WareHouseID = NULL

			DELETE [Master].WareHouses
			DBCC CHECKIDENT ('[Master].WareHouses', RESEED, 0)
		END
END;
