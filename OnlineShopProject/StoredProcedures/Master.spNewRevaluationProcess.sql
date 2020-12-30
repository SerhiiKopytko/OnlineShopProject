﻿-- =========================================================================================
-- Author: Serhii Kopytko
-- Create date:	2020/12/30
-- Description:	General procedure that describe full revaluation process of products
-- Parameters: @orderID - Required. Order ID for new record
--			   @productID - Required. Product ID for Order
--			   @quantity - Required. quantity of product for Order
-- Execution: On Demand
-- ==========================================================================================


CREATE PROCEDURE [Master].[spNewRevaluationProcess](
	@MinProd INT = 1
	,@MaxProd INT = 2
	,@percent DECIMAL (4,2) = 15
	,@Action VARCHAR(150) = 'up'
)
AS
BEGIN
	BEGIN TRY
		DECLARE @CurrentOperation INT = 4 --Revaluation of the products Process
		DECLARE	@NewVersion INT
		DECLARE	@CurrentDateTime DATETIME
		DECLARE @RandProdIDList TABLE (ProdID INT)
		DECLARE @NewPrice TABLE (ProdID INT, Price SMALLMONEY)
		DECLARE	@RandProd INT
		
		-- SET NOCOUNT ON added to prevent extra result sets from
		SET NOCOUNT ON;

		/* Starting 'OperationRuns' process:
			 Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table*/
		EXECUTE Logs.spStartOperationRuns @CurrentOperation


		/* Selecting @RandProd random number of unique products that will be evaluated 
		   and storing these data into @RandProdIDList variable*/
		SET @RandProd = (SELECT FLOOR(RAND()*(@MaxProd - @MinProd+1))+@MinProd)

		INSERT INTO @RandProdIDList (ProdID)
			SELECT TOP(@RandProd) p.ProductID 
			FROM (SELECT DISTINCT ProductID 
				  FROM Master.vwAvailableProd) AS p
			ORDER BY NEWID()


		-- Create a new version for revaluation
		EXECUTE Master.spCreateNewPriceChangesVersion @NewVersion      = @NewVersion      OUTPUT
													 ,@CurrentDateTime = @CurrentDateTime OUTPUT


		/*updating revaluated products with the new version to close them 
		  and insert all updated products into Staging.NewDeliveries table 
		  for creating new delivery with new version and price */
		TRUNCATE TABLE Staging.NewDeliveries

		UPDATE Master.WareHouses
		SET EndVersion = @NewVersion
			OUTPUT Inserted.ProductID
				  ,Inserted.Price
			INTO Staging.NewDeliveries(ProductID, 
									   PricePerUnit)
		WHERE ProductID IN (SELECT ProdID 
							FROM @RandProdIDList)

		/* Create a new price as an average price of different deliveries appropriate product 
		   adjusted by a certain amount of interest*/
		IF @Action = 'up'
			SET @percent = @percent/100 + 1	
		IF @Action = 'down'
			SET @percent = 1 - @percent/100 

		INSERT INTO @NewPrice (ProdID, 
							   Price)
			SELECT ProductID							 AS ProdID 
				  ,CEILING(AVG(PricePerUnit) * @percent) AS Price
			FROM Staging.NewDeliveries
			GROUP BY ProductID




		


		-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns

	END TRY

	BEGIN CATCH

	END CATCH
END;