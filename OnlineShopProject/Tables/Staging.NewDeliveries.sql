--------------------------
--Staging Schema
-------------------------
CREATE TABLE Staging.NewDeliveries(
	DeliveryID INT NOT NULL IDENTITY(1,1),
	ProductID INT,
	PricePerUnit SMALLMONEY,
	DeliveryDate DATE,
	CONSTRAINT PK_StagingNewDeliveriesDeliveryID PRIMARY KEY (DeliveryID)
);

--CREATE TABLE Staging.AcceptedInWarehouse(
--	AcceptedID INT NOT NULL IDENTITY(1,1),
--	DeliveryID INT,
--	ProductID INT,
--	PricePerUnit SMALLMONEY,
--	DeliveryDate DATE,
--	IsAccepted BIT DEFAULT 1,
--	CONSTRAINT PK_StagingNewDeliveriesAcceptedID PRIMARY KEY (DeliveryID)
--)