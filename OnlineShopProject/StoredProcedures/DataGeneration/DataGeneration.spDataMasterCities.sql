CREATE PROCEDURE [DataGeneration].[spDataMasterCities]
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

	IF OBJECT_ID ('[Master].Cities', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].Customers
		DROP CONSTRAINT FK_MasterCustomersCityID_MasterCitiesCityID

			TRUNCATE TABLE [Master].Cities
				INSERT INTO [Master].Cities(CityName) --  ##Cities
				 VALUES
					('Kyiv'),
					('Kharkiv'),
					('Odessa'),
					('Dnipro'),
					('Lviv')
				
		SET @RowCount = (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted
				
		ALTER TABLE [Master].Customers
		ADD CONSTRAINT FK_MasterCustomersCityID_MasterCitiesCityID FOREIGN KEY (CityID) REFERENCES [Master].Cities (CityID)
	END

EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
