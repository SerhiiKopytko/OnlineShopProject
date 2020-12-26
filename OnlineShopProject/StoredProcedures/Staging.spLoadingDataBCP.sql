CREATE PROCEDURE [Staging].[spLoadingDataBCP]
(
 @exe_path VARCHAR(200),
 @DBTable VARCHAR(250),
 @Path VARCHAR(350),
 @FileName VARCHAR(150) = NULL,
 @FileExtension VARCHAR(50),
 @bcpOperation VARCHAR(50),
 @bcpParam VARCHAR(50),
 @ServerName VARCHAR(150),
 @UserName VARCHAR(150),
 @Delimetr VARCHAR(10),
 @CreateDateTime DATETIME = NULL,
 @FullFileName VARCHAR(250) = NULL
)
AS

BEGIN


DECLARE
	@prevAdvancedOptions INT, -- variables for managing xp_cmdshell Server configuration option
	@prevXpCmdshell INT,       --variables for managing xp_cmdshell Server configuration option

	@bcp_cmd VARCHAR(1000),
	@Date VARCHAR(10),
	@Time VARCHAR(8)


	IF @bcpOperation = ' out'
		BEGIN
			SELECT @Date = CONVERT(VARCHAR, @CreateDateTime, 102)
			SELECT @Time = CAST(CAST(@CreateDateTime AS TIME(0)) AS VARCHAR(8))
			SELECT @Time = REPLACE(@Time, ':', '')

			SET @FullFileName = @FileName + '_' + @Date + '_' + @Time
		END

	

	-- BCP process for loading new delivery from temporary table to txt file.

	--xp_cmdshell Server configuration option
			
		SELECT @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
		SELECT @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'

			IF (@prevAdvancedOptions = 0)
			BEGIN
				exec sp_configure 'show advanced options', 1
				reconfigure
			END

			IF (@prevXpCmdshell = 0)
			BEGIN
				exec sp_configure 'xp_cmdshell', 1
				reconfigure
			END


 --	start main bcp block 

	SET @bcp_cmd = @exe_path + @DBTable + @bcpOperation + @Path + @FullFileName + @FileExtension + @bcpParam + @ServerName + @UserName + @Delimetr;
	EXEC master..xp_cmdshell @bcp_cmd;

 --	 end main bcp block 

 			IF (@prevXpCmdshell = 1)
			BEGIN
				exec sp_configure 'xp_cmdshell', 0
				reconfigure
			END

			IF (@prevAdvancedOptions = 1)
			BEGIN
				exec sp_configure 'show advanced options', 0
				reconfigure
			END


END;
