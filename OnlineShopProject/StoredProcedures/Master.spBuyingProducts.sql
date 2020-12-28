CREATE PROCEDURE [Master].[spBuyingProducts]
(
@OrderID  INT
)
AS

BEGIN

DECLARE
@StartOrderDetailID INT,
@EndOrderDetailID INT,
@CurrentOrderDetailID INT,
@CurrentWHid INT,

@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
@RowCount INT = 0,
@CurrentVersion INT

EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

EXECUTE @CurrentVersion = [Master].spCreateNewBuyingVersion @OrderID -- Create a new Version for the current order

-- SELECT 'OrderDetailID' for chosen @OrderID
	SELECT @StartOrderDetailID = MIN(od.OrderDetailID), 
		   @EndOrderDetailID   = MAX(od.OrderDetailID)
	FROM Master.Orders AS o
	JOIN Master.OrderDetails AS od ON o.OrderID = od.OrderID
	WHERE o.OrderID = @OrderID


	SET @CurrentOrderDetailID = @StartOrderDetailID

	-- selecting a current product from the 'WareHouse' table and update necessary fields
		WHILE @CurrentOrderDetailID <= @EndOrderDetailID
			BEGIN
				SELECT @CurrentWHid = WareHouseID 
					FROM Master.WareHouses
					WHERE 1 = 1
					  AND ProductID = (SELECT ProductID 
										FROM Master.OrderDetails
										WHERE OrderDetailID = @CurrentOrderDetailID)
					  AND EndVersion = 999999999
					ORDER BY StartVersion, WareHouseID
					OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY

					UPDATE Master.WareHouses
						SET EndVersion = IDENT_CURRENT('Master.VersionConfigs')  
						WHERE WareHouseID = @CurrentWHid

					UPDATE Master.OrderDetails
						SET WareHouseID = @CurrentWHid
						WHERE OrderDetailID = @CurrentOrderDetailID

					SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

			  SET @CurrentOrderDetailID +=1 
			END
	
	EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount, @CurrentVersion	-- Compliting operation process

	RETURN @RowCount
END;
