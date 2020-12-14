CREATE PROCEDURE [DataGeneration].[spDataMasterProducts]
AS
BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process
	
IF OBJECT_ID('[Master].Products', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].WareHouses
		DROP CONSTRAINT FK_MasterWareHousesProductID_MasterProductsProductID
		ALTER TABLE [Master].OrderDetails
		DROP CONSTRAINT FK_MasterOrderDetailsProductID_MasterProductsProductID
		
			TRUNCATE TABLE [Master].Products
			
				INSERT INTO [Master].Products(ProductName, ProductTypeID, IsActive, ProductDescription)
				  VALUES
					('HP Pavilion', 1, 1, 'Description HP Pavilion'),
					('Dell G3', 1, 1, 'Description Dell G3'),
					('Lenovo IdeaPad', 1, 1, 'Description Lenovo IdeaPad'),
					('Acer Aspire5', 1, 1, 'Description Acer Aspire5'),
					('Asus S15', 1, 1, 'Description Asus S15'),
					('Huawei X Pro', 1, 1, 'Description Huawei X Pro'),
					('MSI GF 65', 1, 1, 'Description MSI GF 65'),
					
					('Apple iPhone12', 2, 1, 'Description Apple iPhone12'),
					('Huawei GT2', 2, 1, 'Description Huawei GT2'),
					('Samsung Galaxy', 2, 1, 'Description Samsung Galaxy'),
					('Motorola G8', 2, 1, 'Description Motorola G8'),
					('Nokia GT', 2, 1, 'Description Nokia GT'),
					('Sony xperia 10 Plus', 2, 1, 'Description Sony xperia 10 Plus'),
					('Xiaomi Redmi Note9', 2, 1, 'Description Xiaomi Redmi Note9')

		SET @RowCount = (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted

		ALTER TABLE [Master].WareHouses
		ADD CONSTRAINT FK_MasterWareHousesProductID_MasterProductsProductID FOREIGN KEY (ProductID) REFERENCES [Master].Products(ProductID)
		ALTER TABLE [Master].OrderDetails
		ADD CONSTRAINT FK_MasterOrderDetailsProductID_MasterProductsProductID FOREIGN KEY (ProductID) REFERENCES [Master].Products(ProductID)
	END

  EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
