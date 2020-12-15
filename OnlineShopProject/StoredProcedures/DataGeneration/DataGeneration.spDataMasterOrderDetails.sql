CREATE PROCEDURE [DataGeneration].[spDataMasterOrderDetails]
(
@ProdFrom INT = 1,
@ProdTo INT = 5
)
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT = 0

EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

		TRUNCATE TABLE [Master].OrderDetails

		-- Set first and last 'OrderID' values
		DECLARE
			@StartOrderID INT,
			@LastOrderID INT,
			@Counter INT,
			@RandVal INT

		-- Take 'Id' values from calendar table for start and end date of orders.
		SET @StartOrderID = (SELECT MIN(OrderID) 
							 FROM [Master].Orders)
		SET @LastOrderID  = (SELECT MAX(OrderID) 
							 FROM [Master].Orders)

		-- Create a loop to generating orders details for every orders
		SET @Counter = @StartOrderID

		WHILE @Counter <= @LastOrderID 
			BEGIN
				-- Select a random number of products for each order and add this information to the order details table
				SET @RandVal = (SELECT FLOOR(RAND()*(@ProdTo-@ProdFrom+1))+@ProdFrom)

				INSERT INTO [Master].OrderDetails(ProductID, OrderID)
					SELECT TOP (@RandVal) ProductID, 
								@Counter AS OrderID
					FROM Master.Products
					ORDER BY NEWID()
		
				    SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted
				SET @Counter +=1
			END
	
	EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END; --end of PROC
