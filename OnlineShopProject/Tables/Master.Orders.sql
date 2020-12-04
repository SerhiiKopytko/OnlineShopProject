CREATE TABLE [Master].Orders (
	OrderID INT IDENTITY(1,1) NOT NULL,
	OrderDataTime DATETIME NOT NULL,
	CustomerID INT NOT NULL,
	CONSTRAINT PK_MasterOrdersOrderID PRIMARY KEY(OrderID),
	CONSTRAINT FK_MasterOrdersCustomerID_MasterCustomersCustomerID FOREIGN KEY (CustomerID) REFERENCES [Master].Customers(CustomerID)
);