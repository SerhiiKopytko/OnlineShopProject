CREATE PROCEDURE [DataGeneration].[spAllDataPopulation]
AS
BEGIN
    EXECUTE DataGeneration.spCalendars
	EXECUTE DataGeneration.spDataMasterCities
	EXECUTE DataGeneration.spDataMasterCustomers
	EXECUTE DataGeneration.spDataMasterProductTypes
	EXECUTE DataGeneration.spDataMasterProducts
END
