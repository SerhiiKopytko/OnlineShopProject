CREATE PROCEDURE [Staging].[spNewOrderIntoStagingTable]

AS

BEGIN

TRUNCATE TABLE Staging.NewOrders

	INSERT INTO Staging.NewOrders (ProductID, CustomerID, OrderDataTime)
	SELECT ProductID, CustomerID, OrderDataTime  
		FROM ##NewOrder
END;
