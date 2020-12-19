CREATE PROCEDURE [Staging].[spCreateNewOrder]
( @MinProd INT = 3,
  @MaxProd INT = 10)
AS

BEGIN

	BEGIN TRY
	
		BEGIN TRANSACTION

		DECLARE
		@RandCuctomer INT,
		@CurrentOrderID INT,
		@RandProd INT

		DROP TABLE IF EXISTS ##NewOrder 
		CREATE TABLE ##NewOrder 
		(ProductID INT,
		 CustomerID INT,
		 OrderDataTime DATETIME
		)

		
		SELECT TOP (1) @RandCuctomer = CustomerID
			FROM Master.Customers
			ORDER BY NEWID()

		SET @RandProd = (SELECT FLOOR(RAND()*(@MaxProd - @MinProd+1))+@MinProd)

		INSERT INTO ##NewOrder (ProductID, CustomerID, OrderDataTime)
			SELECT TOP(@RandProd) 
					ProductID         AS ProductID,
					@RandCuctomer     AS CustomerID,
					CURRENT_TIMESTAMP AS OrderDataTime
			  FROM Master.vwAvailableProd
			  ORDER BY NEWID()

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH

	END CATCH

END;
