﻿CREATE PROCEDURE [DataGeneration].[spDataMasterProductTypes]
AS
BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

	IF OBJECT_ID ('[Master].ProductTypes', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].Products
		DROP CONSTRAINT FK_MasterProductsProductTypeID_MasterProductTypesProductTypeID

			TRUNCATE TABLE [Master].ProductTypes
			--DBCC CHECKIDENT ('[Master].ProductTypes', RESEED, 0)

			INSERT INTO [Master].ProductTypes(ProductTypeName, ProductTypeDescription)
			VALUES
				('Laptop', 'A laptop (also laptop computer), is a small, portable personal computer (PC)'),
				('Smartphones', 'A smartphone is a mobile device that combines cellular and mobile computing functions into one unit.')

		SET @RowCount = (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

		ALTER TABLE [Master].Products
		ADD CONSTRAINT FK_MasterProductsProductTypeID_MasterProductTypesProductTypeID FOREIGN KEY (ProductTypeID) REFERENCES [Master].ProductTypes(ProductTypeID)
	END

  EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
