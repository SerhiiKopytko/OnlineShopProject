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

	-- BCP process for loading new delivery from temporary table to txt file.

       EXECUTE Staging.spLoadingDataBCP 
							@CreateDateTime = @CurrentDateTime,
							@exe_path = 'call "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\BCP.EXE"',
							@DBTable = ' OnlineShop.##NewOrder',
							@Path = ' C:\TempSSIS\Orders\',
							@FileName = 'NewOrder',
							@FileExtension = '.txt',
							@bcpOperation = ' out',
							@bcpParam = ' -T -c',
							@ServerName = ' -S LV575',
							@UserName = ' -U SOFTSERVE\skopy ',
							@Delimetr = ' -t ","'
--------------------------------------------------------------
	
	END TRY

	BEGIN CATCH

	END CATCH

END;