CREATE TABLE [Master].OrderDetails (
	OrderDetailID INT IDENTITY(1,1) NOT NULL,
	ProductID INT NOT NULL,
	OrderID INT NOT NULL,
	WareHouseID INT,
	CONSTRAINT PK_MasterOrderDetailsOrderDetailID PRIMARY KEY(OrderDetailID),
	CONSTRAINT FK_MasterOrderDetailsProductID_MasterProductsProductID FOREIGN KEY (ProductID) REFERENCES [Master].Products(ProductID),
	CONSTRAINT FK_MasterOrderDetailsOrderID_MasterOrdersOrderID FOREIGN KEY (OrderID) REFERENCES [Master].Orders(OrderID),
	CONSTRAINT FK_MasterOrderDetailsWareHouseID_MasterWareHousesWareHouseID FOREIGN KEY(WareHouseID) REFERENCES [Master].WareHouses(WareHouseID)
);