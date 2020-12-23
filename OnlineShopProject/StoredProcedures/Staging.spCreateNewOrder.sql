CREATE PROCEDURE [Staging].[spCreateNewOrder]
( @MinProd INT = 3,
  @MaxProd INT = 10)
AS

BEGIN

	BEGIN TRY
	
		DECLARE
		@RandCuctomer INT,
		@CurrentOrderID INT,
		@RandProd INT,
		@CurrentDateTime DATETIME,

		@prevAdvancedOptions INT, -- variables for managing xp_cmdshell Server configuration option
		@prevXpCmdshell INT,       --variables for managing xp_cmdshell Server configuration option

		@bcp_cmd VARCHAR(1000),
		@exe_path VARCHAR(200) = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE"',
		@FromTable VARCHAR(250) = ' OnlineShop.##NewOrder',
		@Path VARCHAR(350) = ' C:\TempSSIS\Orders\',
		@FileName VARCHAR(150) = 'NewOrder',
		@FileExtension VARCHAR(50) = '.txt',
		@bcpParam VARCHAR(50) = ' -T -c',
		@ServerName VARCHAR(150) = ' -S LV575',
		@UserName VARCHAR(150) = ' -U SOFTSERVE\skopy ',
		@Delimetr VARCHAR(10) = ' -t ","'

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

		SET @CurrentDateTime = CURRENT_TIMESTAMP

		INSERT INTO ##NewOrder (ProductID, CustomerID, OrderDataTime)
			SELECT TOP(@RandProd) 
					ProductID         AS ProductID,
					@RandCuctomer     AS CustomerID,
					@CurrentDateTime  AS OrderDataTime
			  FROM Master.vwAvailableProd
			  ORDER BY NEWID()

--------------------------------------------------------------
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

	--		SET @FileFullName = @FileName + '_' + Convert(VARCHAR, @CurrentDateTime, 103) + '_' + CAST( CAST(@CurrentDateTime AS TIME(0)) AS VARCHAR) + @FileExtension
 
			SET @bcp_cmd = @exe_path + @FromTable + ' out' + @Path + @FileName + @FileExtension + @bcpParam + @ServerName + @UserName + @Delimetr;
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
--------------------------------------------------------------
	
	END TRY

	BEGIN CATCH

	END CATCH

END;