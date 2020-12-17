CREATE PROCEDURE [DataGeneration].[spRunOneBuying]
AS

BEGIN

DECLARE
@FirstOrderID INT,
@LastOrderID INT,
@CurrentOrderID INT,

@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
@RowCount INT = 0,
@RowCountProd INT

	EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

	SELECT @FirstOrderID = MIN(OrderID), 
		   @LastOrderID  = MAX(OrderID)
	FROM Master.Orders

	SET @CurrentOrderID = @FirstOrderID

		WHILE @CurrentOrderID <= @LastOrderID
			BEGIN
				EXECUTE @RowCountProd = Master.spBuyingProducts @CurrentOrderID

				SET @RowCount = @RowCount + @RowCountProd -- Calculate and save how many rows were populeted
			    SET @CurrentOrderID +=1
			END

EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
