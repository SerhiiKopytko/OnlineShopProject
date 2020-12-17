﻿CREATE PROCEDURE [Master].[spCreateNewLoadVersion]
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

 EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

INSERT INTO [Master].VersionConfigs (VersionDateTime, OperationRunID)
	SELECT DeliveryDate, 
		   IDENT_CURRENT('Logs.OperationRuns') AS OperationRunID
		FROM Staging.NewDeliveries
		ORDER BY DeliveryDate
		OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY

		SET @RowCount = (SELECT @@ROWCOUNT)  -- Calculate and save how many rows were populeted

 EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process

END;

