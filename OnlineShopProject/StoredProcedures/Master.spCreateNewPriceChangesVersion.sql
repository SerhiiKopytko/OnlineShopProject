CREATE PROCEDURE [Master].[spCreateNewPriceChangesVersion]
	@NewVersion INT OUTPUT,
	@CurrentDateTime DATETIME OUTPUT
AS

BEGIN
	DECLARE
		@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
		@RowCount INT = 0
		
		SET @CurrentDateTime = CURRENT_TIMESTAMP

		-- logging start operation process
		EXECUTE Logs.spStartOperation @EventProcName 

		INSERT INTO [Master].VersionConfigs (VersionDateTime, 
											 OperationRunID)
			SELECT @CurrentDateTime                    AS VersionDateTime, 
				   IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID

		-- Calculate and save how many rows were populeted
		SET @RowCount += @@ROWCOUNT  
		SET @NewVersion = IDENT_CURRENT('[Master].VersionConfigs')
 
		-- Compliting operation process
		EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount, @NewVersion	


END;

