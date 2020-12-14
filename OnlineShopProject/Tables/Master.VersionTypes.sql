--------------------------
--Version tables
-------------------------
--------------------------
--Version tables
-------------------------
CREATE TABLE [Master].VersionTypes (
	VersionTypeID INT IDENTITY(1,1) NOT NULL,
	VersionTypeDescription VARCHAR(MAX) NULL,
	ModificationDate DATETIME NULL,
	CONSTRAINT PK_MasterVersionTypesVersionTypeID PRIMARY KEY(VersionTypeID)
);