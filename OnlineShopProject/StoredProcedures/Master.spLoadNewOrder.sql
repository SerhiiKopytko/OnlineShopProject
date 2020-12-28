CREATE PROCEDURE [Master].[spLoadNewOrder]
AS

BEGIN
	BEGIN TRY
	  
	 

		DECLARE
		  @NewOrderID INT,
		  @CustomerID INT,
		  @OrderDataTime DATETIME,

		  @EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
		  @RowCount INT = 0

    EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

		SELECT TOP(1) @CustomerID = CustomerID 
		  FROM Staging.NewOrders
		  ORDER BY CustomerID 

		SELECT TOP(1) @OrderDataTime = OrderDataTime
		  FROM Staging.NewOrders
		  ORDER BY OrderDataTime 

		INSERT INTO [Master].Orders(OrderDataTime, CustomerID)
		  VALUES
		  (@OrderDataTime, @CustomerID)

		  SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

		INSERT INTO [Master].OrderDetails(ProductID, OrderID)
			SELECT ProductID, IDENT_CURRENT('[Master].Orders') AS OrderID 
			FROM  Staging.NewOrders

		  SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

	EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process

	
	END TRY

	BEGIN CATCH

	END CATCH

END;
