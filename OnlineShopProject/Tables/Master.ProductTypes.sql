CREATE TABLE [Master].ProductTypes (
	ProductTypeID INT IDENTITY(1,1) NOT NULL,
	ProductTypeName VARCHAR(100) NOT NULL,
	ProductTypeDescription VARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_MasterProductTypesProductTypeID PRIMARY KEY(ProductTypeID)
);