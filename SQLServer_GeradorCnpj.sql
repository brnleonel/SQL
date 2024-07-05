CREATE OR ALTER PROCEDURE [dbo].[GenerateCNPJ] 
@formatar varchar(1) = 'S',
@CNPJ VARCHAR(MAX) OUTPUT
AS
begin
    DECLARE @n INTEGER;
    DECLARE @n1 INTEGER;
    DECLARE @n2 INTEGER;
    DECLARE @n3 INTEGER;
    DECLARE @n4 INTEGER;
    DECLARE @n5 INTEGER;
    DECLARE @n6 INTEGER;
    DECLARE @n7 INTEGER;
    DECLARE @n8 INTEGER;
    DECLARE @n9 INTEGER;
    DECLARE @n10 INTEGER;
    DECLARE @n11 INTEGER;
    DECLARE @n12 INTEGER;    
    DECLARE @d1 INTEGER;
    DECLARE @d2 INTEGER;
	           
    SET @n = 9;
    SET @n1 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n2 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n3 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n4 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n5 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n6 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n7 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n8 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
    SET @n9 = 0;
    SET @n10 = 0;
    SET @n11 = 0;
    SET @n12 = 1;
             
    SET @d1 = @n12 * 2 + @n11 * 3 + @n10 * 4 + @n9 * 5 + @n8 * 6 + @n7 * 7 + @n6 * 8 + @n5 * 9 + @n4 * 2 + @n3 * 3 + @n2 * 4 + @n1 * 5;
    SET @d1 = 11 - (@d1 % 11);
            
    IF @d1 >= 10
        SET @d1 = 0;

    SET @d2 = @d1 * 2 + @n12 * 3 + @n11 * 4 + @n10 * 5 + @n9 * 6 + @n8 * 7 + @n7 * 8 + @n6 * 9 + @n5 * 2 + @n4 * 3 + @n3 * 4 + @n2 * 5 + @n1 * 6;
    SET @d2 = 11 - (@d2 % 11);

    IF @d2 >= 10
        SET @d2 = 0;

	IF @formatar = 'S'
		SET @cnpj = CONCAT(@n1, @n2, '.', @n3, @n4, @n5, '.', @n6, @n7, @n8, '/', @n9, @n10, @n11, @n12, '-', @d1, @d2);
	ELSE
		SET @cnpj = CONCAT(@n1, @n2, @n3, @n4, @n5, @n6, @n7, @n8, @n9, @n10, @n11, @n12, @d1, @d2);
	print @cnpj;
end;

/* Exemplo de uso */
declare @cnpj VARCHAR(MAX);
EXEC GenerateCNPJ 'S', @cnpj OUTPUT
SELECT @cnpj
