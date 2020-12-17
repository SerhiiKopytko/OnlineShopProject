CREATE PROCEDURE [DataGeneration].[spRunOneRestocking]
AS

BEGIN

DECLARE
	@StartTime DATETIME,
	@CurrentProdID INT = 1,
	@LastProdID INT,
	@ProdAmount INT,
	@Counter INT,
	@RandProdPrice SMALLMONEY,
	@MinPrice SMALLMONEY = 500,
	@MaxPrice SMALLMONEY = 3000,

	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT = 0
	
	EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process


	TRUNCATE TABLE  Staging.NewDeliveries

-- store information about the all amount of ordered product in the temporary table.
	DROP TABLE IF EXISTS #ProdperDay
		SELECT od.ProductID, COUNT(*) AS AllProd
		INTO #ProdperDay
			FROM Master.Orders AS o
			JOIN Master.OrderDetails AS od ON od.OrderID = o.OrderID
				GROUP BY od.ProductID
				ORDER BY od.ProductID


-- Creating nested loop to populate 'Staging.NewDeliveries' table


	SELECT @StartTime = MIN(OrderDataTime)
	FROM Master.Orders

	SELECT @LastProdID = MAX(ProductID)
	FROM Master.Products

	WHILE @CurrentProdID <= @LastProdID
		BEGIN
			SELECT @ProdAmount = AllProd * 1.2 
				FROM #ProdperDay
				WHERE ProductID = @CurrentProdID

			-- Select a random price for @CurrentProdID 
				SET @RandProdPrice = (SELECT FLOOR(RAND()*(@MaxPrice-@MinPrice+1))+@MinPrice)

			SET @Counter = 1
			WHILE @Counter <= @ProdAmount
				BEGIN
					INSERT INTO Staging.NewDeliveries(ProductID, PricePerUnit, DeliveryDate)
					SELECT @CurrentProdID, @RandProdPrice, @StartTime

					SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

				SET @Counter += 1
				END
		
		 SET @CurrentProdID +=1
		END;


	EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
