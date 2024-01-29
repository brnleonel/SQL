sp_configure 'Advanced Options', 1
GO
RECONFIGURE
GO
sp_configure 'Ole Automation Procedures', 1
GO

RECONFIGURE
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER procedure [dbo].[WebRequest]
(@url varchar(max),
 @bearertoken varchar(max),
 @contentType varchar(max),
 @content varchar(max),
 @method varchar(max)
)
as
	DECLARE @ws INT;
	DECLARE @responsevalue VARCHAR(MAX);
	DECLARE @responsecode INT;

	EXEC @responsecode = sp_OACreate 'MSXML2.ServerXMLHTTP', @ws OUT;
	IF @responsecode <> 0 
		RAISERROR('Unable to open HTTP connection.', 10, 1);

	EXEC @responsecode = sp_OAMethod @ws, 'open', NULL, @method, @url, 'false';

	IF COALESCE(@bearertoken, '') <> ''
	BEGIN
		SET @bearertoken = 'Bearer ' + @bearertoken;
		EXEC @responsecode = sp_OAMethod @ws, 'setRequestHeader', NULL, 'Authorization', @bearertoken;
	END

	IF COALESCE(@contentType, '') <> ''
		EXEC @responsecode = sp_OAMethod @ws, 'setRequestHeader', NULL, 'Content-Type', @contentType;

	IF COALESCE(@content, '') <> ''
		EXEC @responsecode = sp_OAMethod @ws, 'send', NULL, @content;
	ELSE
		EXEC @responsecode = sp_OAMethod @ws, 'send'

	IF @responsecode <> 0
		RAISERROR('Erro inesperado.', 10, 1);

	EXEC @responsecode = sp_OAGetProperty @ws, 'responseText', @responsevalue OUT;
	IF @responsecode <> 0  
	BEGIN
		EXEC @responsecode = sp_OAGetProperty @ws, 'responseText';
		IF @responsecode <> 0
			EXEC sp_OAGetErrorInfo @responsecode;
	END

	EXEC @responsecode = sp_OADestroy @ws;
	IF @responsecode <> 0
		RAISERROR('Unable to close HTTP connection.', 10, 1);
