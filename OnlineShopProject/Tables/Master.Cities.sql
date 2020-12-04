--------------------------------
-- SCHEMA Master
--------------------------------
CREATE TABLE [Master].Cities (
	CityID INT IDENTITY(1,1) NOT NULL,
	CityName VARCHAR(50) NOT NULL,
	CONSTRAINT PK_MasterCitiesCityID PRIMARY KEY(CityID)
);