CREATE PROCEDURE [Staging].[spCreateNewDelivery]
(
 @MinAmountKindProd INT = 5,
 @MaxAmountKindProd INT = 10,
 @MinPriceProd INT = 500,
 @MaxPriceProd INT = 3000,
 @MinAmountProd INT = 3,
 @MaxAmountProd INT = 5
)
AS

BEGIN

DECLARE
 @RandomAmountKindProd INT,
 @CounterKingProd INT,
 @RandomPriceProd INT,
 @RandomAmountProd INT,
 @CounterProd INT

DROP TABLE IF EXISTS #RanProd -- temporary table for storing random unique kind of products for new delivery
CREATE TABLE #RanProd
(ID INT IDENTITY(1,1),
 ProductID INT)

-- Storing into @RandomAmountKindProd random amount of unique products
SELECT @RandomAmountKindProd = FLOOR(RAND()*(@MaxAmountKindProd-@MinAmountKindProd+1))+@MinAmountKindProd


INSERT INTO #RanProd (ProductID)
SELECT TOP(@RandomAmountKindProd) ProductID
	FROM Master.Products
	ORDER BY NEWID()


DROP TABLE IF EXISTS ##NewDelivery -- temporary table for storing all information about new delivery
CREATE TABLE ##NewDelivery
(ProductID INT,
 PricePerUnit SMALLMONEY,
 DeliveryDate DATETIME)

-- For each unique kind of product creates a random amount of it and  price
-- and insert this information into 'Staging.NewDeliveries' table
SET @CounterKingProd = 1
	WHILE @CounterKingProd <= @RandomAmountKindProd
		BEGIN
			SELECT @RandomPriceProd = FLOOR(RAND()*(@MaxPriceProd-@MinPriceProd+1))+@MinPriceProd
			SELECT @RandomAmountProd = FLOOR(RAND()*(@MaxAmountProd-@MinAmountProd+1))+@MinAmountProd

			SET @CounterProd = 1
				WHILE @CounterProd <= @RandomAmountProd
					BEGIN
						INSERT INTO ##NewDelivery (ProductID, PricePerUnit, DeliveryDate)
						SELECT ProductID AS ProductID,
							   @RandomPriceProd AS PricePerUnit,
							   GETDATE() AS DeliveryDate
							FROM #RanProd
							WHERE ID = @CounterKingProd 
					SET @CounterProd +=1
					END

		SET @CounterKingProd +=1
		END
END;
