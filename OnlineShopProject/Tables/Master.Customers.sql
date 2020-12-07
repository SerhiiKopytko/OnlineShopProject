CREATE TABLE [Master].Customers (
	CustomerID INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	email VARCHAR(250) NOT NULL,
	DateOfBirth DATE NOT NULL,
	CityID INT NOT NULL,
	CONSTRAINT PK_MasterCustomersCustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT FK_MasterCustomersCityID_MasterCitiesCityID FOREIGN KEY (CityID) REFERENCES [Master].Cities (CityID)
);