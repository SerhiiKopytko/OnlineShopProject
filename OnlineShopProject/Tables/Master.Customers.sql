CREATE TABLE [Master].Customers (
	CustomerID INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL,
	DateOfBirth DATE NOT NULL,
	CityID INT NOT NULL,
	CONSTRAINT PK_MasterCustomersCustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT FK_MasterCustomersCityID_MasterCitiesCityID FOREIGN KEY (CityID) REFERENCES [Master].Cities (CityID)
);