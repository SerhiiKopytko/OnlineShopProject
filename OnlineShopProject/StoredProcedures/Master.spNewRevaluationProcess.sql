CREATE PROCEDURE [Master].[spNewRevaluationProcess]
	@MinProd INT = 1,
	@MaxProd INT = 2,
	@percent DECIMAL (4,2) = 15
AS

BEGIN
	DECLARE
		@CurrentOperation INT = 4, --Revaluation of the products Process
		@RandProd INT,
		@NewPrice SMALLMONEY,
		@NewVersion INT,
		@CurrentDateTime DATETIME

		-- Starting 'OperationRuns' process:
		-- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
		EXECUTE Logs.spStartOperationRuns @CurrentOperation


		SET @RandProd = (SELECT FLOOR(RAND()*(@MaxProd - @MinProd+1))+@MinProd)

		DROP TABLE IF EXISTS ##CurrentPriceChanges  
		CREATE TABLE  ##CurrentPriceChanges( 
			ProductID INT,
			OldPrice SMALLMONEY,
			NewPrice SMALLMONEY,
			OldVersion INT,
			NewVersion INT,
			RevaluationDate DATETIME)

		INSERT INTO ##CurrentPriceChanges(ProductID, 
										 OldVersion,
										 OldPrice)
			SELECT ProductID    AS ProductID, 
				   StartVersion AS OldVersion, 
				   Price        AS OldPrice
			FROM Master.vwAvailableProd
			WHERE ProductID IN (SELECT TOP(2) p.ProductID 
								FROM (SELECT DISTINCT ProductID 
									  FROM Master.vwAvailableProd) AS p
									  ORDER BY NEWID()
								)

		SET @percent = @percent/100 + 1 

		UPDATE ##CurrentPriceChanges
		SET NewPrice = (SELECT CEILING(AVG(p.OldPrice) * @percent)
						FROM ##CurrentPriceChanges AS p
						GROUP BY p.ProductID
						HAVING p.ProductID = ##CurrentPriceChanges.ProductID
						)


		EXECUTE [Master].[spCreateNewPriceChangesVersion]
						@NewVersion      = @NewVersion OUTPUT,
						@CurrentDateTime = @CurrentDateTime OUTPUT


		UPDATE ##CurrentPriceChanges
		SET NewVersion      = @NewVersion,
			RevaluationDate = @CurrentDateTime 



		-- Completing 'OperationRuns' process:
		EXECUTE Logs.spCompletedOperationRuns


END;
