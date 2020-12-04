CREATE PROCEDURE [DataGeneration].[spAllDataPopulation]
AS
BEGIN
	EXECUTE DataGeneration.spDataMasterCities
	EXECUTE DataGeneration.spDataMasterCustomers
	EXECUTE DataGeneration.spDataMasterProductTypes
	EXECUTE DataGeneration.spDataMasterProducts
END
