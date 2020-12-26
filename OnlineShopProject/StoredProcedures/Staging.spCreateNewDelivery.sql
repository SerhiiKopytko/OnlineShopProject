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
 @CounterProd INT,

 @DeliveryDate DATETIME,
 @CreateDateTime DATETIME,


	@exe_path VARCHAR(200),
	@DBTable VARCHAR(250),
	@Path VARCHAR(350),
	@FileName VARCHAR(150),
	@FileExtension VARCHAR(50),
	@bcpOperation VARCHAR(50),
	@bcpParam VARCHAR(50),
	@ServerName VARCHAR(150),
	@UserName VARCHAR(150),
	@Delimetr VARCHAR(10)


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
(DeliveryID INT IDENTITY(1,1),
 ProductID INT,
 PricePerUnit SMALLMONEY,
 DeliveryDate DATETIME)

-- For each unique kind of product creates a random amount of it and  price
-- and insert this information into 'Staging.NewDeliveries' table
SET  @DeliveryDate = CURRENT_TIMESTAMP

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
							   @DeliveryDate  AS DeliveryDate
							FROM #RanProd
							WHERE ID = @CounterKingProd 
					SET @CounterProd +=1
					END

		SET @CounterKingProd +=1
		END


-- BCP process for loading new delivery from temporary table to txt file.

       EXECUTE Staging.spLoadingDataBCP
							@CreateDateTime = @DeliveryDate,
							@exe_path = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE"',
							@DBTable = ' OnlineShop.##NewDelivery',
							@Path = ' C:\TempSSIS\Delivery\',
							@FileName = 'NewDelivery',
							@FileExtension = '.txt',
							@bcpOperation = ' out',
							@bcpParam = ' -T -c',
							@ServerName = ' -S LV575',
							@UserName = ' -U SOFTSERVE\skopy ',
							@Delimetr = ' -t ","'




END;