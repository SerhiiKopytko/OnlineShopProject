CREATE PROCEDURE [Master].[spCreateNewBuyingVersion]
(
@OrderID INT
)
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

 EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

INSERT INTO [Master].VersionConfigs (VersionDateTime, OperationRunID)
	SELECT OrderDataTime, 
		   IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID 
		FROM Master.Orders
		WHERE OrderID = @OrderID
	
		SET @RowCount = (SELECT @@ROWCOUNT)  -- Calculate and save how many rows were populeted

 EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process

END;
