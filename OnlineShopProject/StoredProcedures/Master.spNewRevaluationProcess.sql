CREATE PROCEDURE [Master].[spNewRevaluationProcess]
	@MinProd INT = 1,
	@MaxProd INT = 2
AS

BEGIN
	DECLARE
		@RandProd INT,
		@NewPrice SMALLMONEY,
		@NewVersion INT,
		@CurrentDateTime DATETIME


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

	
		UPDATE ##CurrentPriceChanges
		SET NewPrice = (SELECT CEILING(AVG(p.OldPrice))
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


END;
