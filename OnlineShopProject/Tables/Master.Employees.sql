﻿CREATE TABLE [Master].Employees (
	ManagerID INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(100) NOT NULL,
	LastNameName VARCHAR(100) NOT NULL,
	email VARCHAR(250) NOT NULL,
	DateOfBirth DATE NOT NULL,
	CONSTRAINT PK_MasterEmployeesManagerID PRIMARY KEY(ManagerID)
);