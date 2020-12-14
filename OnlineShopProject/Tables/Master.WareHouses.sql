CREATE TABLE [Master].WareHouses (
	WareHouseID INT IDENTITY(1,1) NOT NULL,
	ProductID INT NOT NULL,
	StartVersion INT NOT NULL,
	EndVersion INT NOT NULL CONSTRAINT DF_MasterWareHousesEndVersion DEFAULT 999999999,
	Price MONEY NOT NULL,
	CONSTRAINT PK_MasterWareHousesWareHouseID PRIMARY KEY(WareHouseID),
	CONSTRAINT FK_MasterWareHousesProductID_MasterProductsProductID FOREIGN KEY (ProductID) REFERENCES [Master].Products(ProductID)
);