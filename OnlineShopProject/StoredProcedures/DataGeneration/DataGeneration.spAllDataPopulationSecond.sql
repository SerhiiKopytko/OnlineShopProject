CREATE PROCEDURE [DataGeneration].[spAllDataPopulationSecond]
AS
BEGIN

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
	-- By default:@StartDate= '20200101', @EndDate = '', @CusFrom =10 , @CusTo = 100. 
  EXECUTE DataGeneration.spDataMasterOrders 

	 -- DataGeneration.spDataMasterOrderDetails has next list of parameters:
	 --@ProdFrom and @ProdTo - the interval of the number of random products for each order.
	 -- By default:@ProdFrom = 1, @ProdTo = 3
  EXECUTE DataGeneration.spDataMasterOrderDetails



-- Completing 'OperationRuns' process:
 EXECUTE Logs.spCompletedOperationRuns
END;
