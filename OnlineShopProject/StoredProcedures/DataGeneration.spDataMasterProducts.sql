CREATE PROCEDURE [DataGeneration].[spDataMasterProducts]
AS
BEGIN
	
IF OBJECT_ID('[Master].Products', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].WareHouses
		DROP CONSTRAINT FK_MasterWareHousesProductID_MasterProductsProductID
		ALTER TABLE [Master].OrderDetails
		DROP CONSTRAINT FK_MasterOrderDetailsProductID_MasterProductsProductID
		
			DELETE [Master].Products
			DBCC CHECKIDENT('[Master].Products', RESEED, 0)
				INSERT INTO [Master].Products(ProductName, ProductTypeID, IsActive, ProductDescription)
				  VALUES
					('HP Pavilion', 1, 1, 'Description HP Pavilion'),
					('Dell G3', 1, 1, 'Description Dell G3'),
					('Lenovo IdeaPad', 1, 1, 'Description Lenovo IdeaPad'),
					('Apple iPhone12', 2, 1, 'Description Apple iPhone12'),
					('Huawei GT2', 2, 1, 'Description Huawei GT2'),
					('Samsung Galaxy', 2, 1, 'Description Samsung Galaxy')

		ALTER TABLE [Master].WareHouses
		ADD CONSTRAINT FK_MasterWareHousesProductID_MasterProductsProductID FOREIGN KEY (ProductID) REFERENCES [Master].Products(ProductID)
		ALTER TABLE [Master].OrderDetails
		ADD CONSTRAINT FK_MasterOrderDetailsProductID_MasterProductsProductID FOREIGN KEY (ProductID) REFERENCES [Master].Products(ProductID)
	END
END
