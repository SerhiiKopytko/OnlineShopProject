CREATE PROCEDURE [DataGeneration].[spAllDataPopulationSecond]
AS
BEGIN

EXECUTE DataGeneration.spClearLogs -- Clear 'Log' schema and Warehouse 

-- Starting 'OperationRuns' process:
  -- Creating new OperationRunID and creating new record in 'Logs.OperationEvent' table
  EXECUTE Logs.spStartOperationRuns 

-- Starting next events related to run one data population
  EXECUTE DataGeneration.spDataMasterCities
  EXECUTE DataGeneration.spDataMasterCustomers
  EXECUTE DataGeneration.spDataMasterProductTypes
  EXECUTE DataGeneration.spDataMasterProducts

    -- DataGeneration.spDataMasterOrders has next list of parameters:
    -- @StartDate, @EndDate of orders AND 
	-- @CusFrom, @CusTo - the interval of the number of random customers
	-- By default:@StartDate= '20200901', @EndDate = '20201215', @CusFrom =5 , @CusTo = 10. 
  EXECUTE DataGeneration.spDataMasterOrders 

	 -- DataGeneration.spDataMasterOrderDetails has next list of parameters:
	 --@ProdFrom and @ProdTo - the interval of the number of random products for each order.
	 -- By default:@ProdFrom = 1, @ProdTo = 5
  EXECUTE DataGeneration.spDataMasterOrderDetails


		
	 -- Populate 'Staging.NewDeliveries' table for all orders for RunOne script
  EXECUTE DataGeneration.spRunOneRestocking
	
  EXECUTE Master.spCreateNewLoadVersion -- Create a new version for new delivery
  EXECUTE Master.spLoadingWarehouse     -- Load last delivery into warehouse

  EXECUTE DataGeneration.spRunOneBuying -- run 'RunOne' buying process


-- Completing 'OperationRuns' process:
 EXECUTE Logs.spCompletedOperationRuns
END;

