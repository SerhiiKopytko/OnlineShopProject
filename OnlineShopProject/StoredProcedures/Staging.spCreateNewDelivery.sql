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

	@prevAdvancedOptions INT, -- variables for managing xp_cmdshell Server configuration option
	@prevXpCmdshell INT,       --variables for managing xp_cmdshell Server configuration option

	@bcp_cmd VARCHAR(1000),
	@exe_path VARCHAR(200) = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE"',
	@FromTable VARCHAR(250) = ' OnlineShop.##NewDelivery',
	@Path VARCHAR(350) = ' C:\TempSSIS\',
	@FileName VARCHAR(150) = 'NewDelivery.txt',
	@bcpParam VARCHAR(50) = ' -T -c',
	@ServerName VARCHAR(150) = ' -S LV575',
	@UserName VARCHAR(150) = ' -U SOFTSERVE\skopy ',
	@Delimetr VARCHAR(10) = ' -t ","'

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

	--xp_cmdshell Server configuration option
			
		SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
		SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'

			IF (@prevAdvancedOptions = 0)
			BEGIN
				exec sp_configure 'show advanced options', 1
				reconfigure
			END

			IF (@prevXpCmdshell = 0)
			BEGIN
				exec sp_configure 'xp_cmdshell', 1
				reconfigure
			END


	--	 start main bcp block 
 
			SET @bcp_cmd = @exe_path + @FromTable + ' out' + @Path + @FileName + @bcpParam + @ServerName + @UserName + @Delimetr;
			EXEC master..xp_cmdshell @bcp_cmd;

	--	 end main bcp block 


			SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
			SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'


			IF (@prevXpCmdshell = 1)
			BEGIN
				exec sp_configure 'xp_cmdshell', 0
				reconfigure
			END

			IF (@prevAdvancedOptions = 1)
			BEGIN
				exec sp_configure 'show advanced options', 0
				reconfigure
			END


END;