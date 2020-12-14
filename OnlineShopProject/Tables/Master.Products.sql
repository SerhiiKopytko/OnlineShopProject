CREATE TABLE [Master].Products (
	ProductID INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(250) NOT NULL,
	ProductDescription VARCHAR(MAX) NOT NULL,
	ProductTypeID INT NOT NULL,
	IsActive BIT NOT NULL,
	CONSTRAINT PK_MasterProductsProductID PRIMARY KEY(ProductID),
	CONSTRAINT FK_MasterProductsProductTypeID_MasterProductTypesProductTypeID FOREIGN KEY (ProductTypeID) REFERENCES [Master].ProductTypes(ProductTypeID)
);