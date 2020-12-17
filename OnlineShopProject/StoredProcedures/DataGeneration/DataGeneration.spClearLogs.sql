CREATE PROCEDURE [DataGeneration].[spClearLogs]
AS

BEGIN
	DELETE Logs.EventLogs
	DBCC CHECKIDENT ('Logs.EventLogs', RESEED, 0)


	DELETE [Master].VersionConfigs
	DBCC CHECKIDENT ('[Master].VersionConfigs', RESEED, 0)

	DELETE Logs.OperationRuns
	DBCC CHECKIDENT ('Logs.OperationRuns', RESEED, 0)


	UPDATE Master.OrderDetails
		SET WareHouseID = NULL

	DELETE [Master].WareHouses
	DBCC CHECKIDENT ('[Master].WareHouses', RESEED, 0)
END;
