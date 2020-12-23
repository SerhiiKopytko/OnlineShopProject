CREATE PROCEDURE [Staging].[spNewDeliveryIntoStagingTable]
AS

BEGIN

	TRUNCATE TABLE Staging.NewDeliveries -- cleare 'Staging.NewDeliveries' table befor creating new delivery

	INSERT INTO Staging.NewDeliveries (ProductID, PricePerUnit, DeliveryDate)
	SELECT ProductID, PricePerUnit, DeliveryDate  
		FROM ##NewDelivery

END;
