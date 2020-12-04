CREATE PROCEDURE [DataGeneration].[spDataMasterCustomers]
AS
BEGIN
	IF OBJECT_ID ('Master.Customers', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].Orders
		DROP CONSTRAINT FK_MasterOrdersCustomerID_MasterCustomersCustomerID

			DELETE Master.Customers
			DBCC CHECKIDENT('Master.Customers', RESEED, 0)

			BULK INSERT Master.Customers
			FROM 'C:\Users\skopy\Desktop\My_SoftServe_files\Ramp up session\Task_21\OnlineShopProject\OnlineShopProject\DataSCV\DataMasterCustomer.csv'
			WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );

		ALTER TABLE [Master].Orders
		ADD CONSTRAINT FK_MasterOrdersCustomerID_MasterCustomersCustomerID FOREIGN KEY (CustomerID) REFERENCES [Master].Customers(CustomerID)
	END
END
