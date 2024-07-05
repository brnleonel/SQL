/* Ativar configuração Ole Automation 
	https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/ole-automation-procedures-server-configuration-option?view=sql-server-ver16
*/
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
END;

/* Exemplo de uso */
BEGIN
	DECLARE @RESULTADO TABLE(VALOR VARCHAR(MAX));

	INSERT @RESULTADO
	EXEC	[dbo].[webRequest]
			@url = N'https://viacep.com.br/ws/14051260/json',
			@bearertoken = NULL,
			@contentType = NULL,
			@content = NULL,
			@method= 'GET';

	SELECT JSON_VALUE(VALOR, '$.cep') as cep,
	       JSON_VALUE(VALOR, '$.logradouro') as logradouro,
	       JSON_VALUE(VALOR, '$.complemento') as complemento,
	       JSON_QUERY(VALOR, '$.unidade') as unidade,
	       JSON_QUERY(VALOR, '$.bairro') as bairro,
	       JSON_QUERY(VALOR, '$.localidade') as localidade,
	       JSON_QUERY(VALOR, '$.uf') as uf,
	       JSON_QUERY(VALOR, '$.ibge') as ibge
	       JSON_QUERY(VALOR, '$.gia') as gia,
	       JSON_QUERY(VALOR, '$.ddd') as ddd,
	       JSON_QUERY(VALOR, '$.siafi') as siafi
	FROM @RESULTADO;
END
