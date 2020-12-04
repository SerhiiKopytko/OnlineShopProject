CREATE PROCEDURE [DataGeneration].[spDataMasterProductTypes]
AS
BEGIN
	IF OBJECT_ID ('[Master].ProductTypes', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].Products
		DROP CONSTRAINT FK_MasterProductsProductTypeID_MasterProductTypesProductTypeID

			TRUNCATE TABLE [Master].ProductTypes
			
			INSERT INTO [Master].ProductTypes(ProductTypeName, ProductTypeDescription)
			VALUES
				('Laptop', 'A laptop (also laptop computer), is a small, portable personal computer (PC)'),
				('Smartphones', 'A smartphone is a mobile device that combines cellular and mobile computing functions into one unit.')

		ALTER TABLE [Master].Products
		ADD CONSTRAINT FK_MasterProductsProductTypeID_MasterProductTypesProductTypeID FOREIGN KEY (ProductTypeID) REFERENCES [Master].ProductTypes(ProductTypeID)
	END
END
