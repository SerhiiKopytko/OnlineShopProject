CREATE PROCEDURE [DataGeneration].[spDataMasterOrders]
(
	@StartDate DATE = '20200101',
	@EndDate DATE = '20201208',
	@CusFrom INT = 30,
	@CusTo INT = 100
)
AS

BEGIN

DECLARE
	@EventProcName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID)+'.'+OBJECT_NAME(@@PROCID),
	@RowCount INT = 0

EXECUTE Logs.spStartOperation @EventProcName -- logging start operation process


IF OBJECT_ID('[Master].Orders', 'U') IS NOT NULL
	BEGIN
		ALTER TABLE [Master].OrderDetails
		DROP CONSTRAINT FK_MasterOrderDetailsOrderID_MasterOrdersOrderID

		TRUNCATE TABLE [Master].Orders
		TRUNCATE TABLE [Master].OrderDetails

	-- Set start and end of period for orders
	DECLARE
	@StartID INT,
	@EndID INT,
	@Counter INT,
	@CurDate DATE,
	@RandVal INT

	-- Take 'Id' values from calendar table for start and end date of orders.
	SET @StartID = (SELECT CalendarID 
					FROM DataGeneration.Calendars
					WHERE TheDate = @StartDate)
	SET @EndID = (SELECT CalendarID 
					FROM DataGeneration.Calendars
					WHERE TheDate = @EndDate)

	-- Create a loop to generating orders for every date
	SET @Counter = @StartID

		WHILE @Counter <= @EndID
			BEGIN
			-- Select random number of customers that is doing orders and add this information to orders table
				SET @RandVal = (SELECT FLOOR(RAND()*(@CusTo-@CusFrom+1))+@CusFrom)

			-- Specify current date
				SET @CurDate = (SELECT TheDate 
								FROM DataGeneration.Calendars
								WHERE CalendarID = @Counter)
 
				INSERT INTO [Master].Orders(CustomerID, OrderDataTime)
					SELECT TOP (@RandVal) CustomerID, 
								@CurDate AS OrderDataTime
					FROM Master.Customers
					ORDER BY NEWID()
					
					SET @RowCount = @RowCount + (SELECT @@ROWCOUNT) -- Calculate and save how many rows were populeted
					
			SET @Counter +=1
			END -- end While

		ALTER TABLE [Master].OrderDetails
		ADD CONSTRAINT FK_MasterOrderDetailsOrderID_MasterOrdersOrderID FOREIGN KEY (OrderID) REFERENCES [Master].Orders(OrderID)
	END -- end IF

	EXECUTE Logs.spCompletedOperation @EventProcName, @RowCount	-- Compliting operation process
END -- end Proc
