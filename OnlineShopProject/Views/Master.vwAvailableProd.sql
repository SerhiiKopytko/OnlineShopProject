CREATE VIEW [Master].[vwAvailableProd]
	AS 
	SELECT * 
		FROM Master.WareHouses
		WHERE EndVersion = 999999999
