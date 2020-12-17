CREATE PROCEDURE [DataGeneration].[spDataMasterCustomers]
AS
BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT

 EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process

	IF OBJECT_ID ('Master.Customers', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].Orders
		DROP CONSTRAINT FK_MasterOrdersCustomerID_MasterCustomersCustomerID

			TRUNCATE TABLE Master.Customers
			
			BULK INSERT Master.Customers
			FROM 'C:\Users\skopy\Desktop\My_SoftServe_files\Ramp up session\Task_21\OnlineShopProject\OnlineShopProject\DataSCV\DataMasterCustomer.csv'
			WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );

		SET @RowCount = (SELECT @@ROWCOUNT)  -- Calculate and save how many rows were populeted

		ALTER TABLE [Master].Orders
		ADD CONSTRAINT FK_MasterOrdersCustomerID_MasterCustomersCustomerID FOREIGN KEY (CustomerID) REFERENCES [Master].Customers(CustomerID)
	END

  EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END;
