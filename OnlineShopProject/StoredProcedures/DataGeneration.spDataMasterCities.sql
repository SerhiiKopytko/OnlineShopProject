CREATE PROCEDURE [DataGeneration].[spDataMasterCities]
AS
BEGIN
	IF OBJECT_ID ('[Master].Cities', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].Customers
		DROP CONSTRAINT FK_MasterCustomersCityID_MasterCitiesCityID

			DELETE [Master].Cities
			DBCC CHECKIDENT ('[Master].Cities', RESEED, 0)
			INSERT INTO [Master].Cities(CityName)
			  VALUES
				('Kyiv'),
				('Kharkiv'),
				('Odessa'),
				('Dnipro'),
				('Lviv')

		ALTER TABLE [Master].Customers
		ADD CONSTRAINT FK_MasterCustomersCityID_MasterCitiesCityID FOREIGN KEY (CityID) REFERENCES [Master].Cities (CityID)
	END
END
