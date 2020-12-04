--------------------------
--Version tables
-------------------------
CREATE TABLE [Master].VersionTypes (
	VersionTypeID INT IDENTITY(1,1) NOT NULL,
	VersionTypeDescription VARCHAR(MAX) NOT NULL,
	ModificationDate DATETIME NOT NULL,
	CONSTRAINT PK_MasterVersionTypesVersionTypeID PRIMARY KEY(VersionTypeID)
);