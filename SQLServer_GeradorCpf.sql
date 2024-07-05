CREATE OR ALTER PROCEDURE [dbo].[GenerateCPF] 
	@formatar varchar(1) = 'S',
	@CPF VARCHAR(MAX) OUTPUT
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
    SET @n9 = CAST(( @n + 1 ) * RAND(CAST(NEWID() AS VARBINARY )) AS INT);
                 
    SET @d1 = @n1 * 10 + @n2 * 9 + @n3 * 8 + @n4 * 7 + @n5 * 6 + @n6 * 5 + @n7 * 4 + @n8 * 3 + @n9 * 2;
    SET @d1 = (@d1 % 11);

    IF @d1 < 2
        SET @d1 = 0;
	ELSE
		SET @d1 = 11 - @d1;

    SET @d2 = @n1 * 11 + @n2 * 10 + @n3 * 9 + @n4 * 8 + @n5 * 7 + @n6 * 6 + @n7 * 5 + @n8 * 4 + @n9 * 3 + @d1 * 2;
	SET @d2 = (@d2 % 11);

	IF @d2 < 2
        SET @d2 = 0;
	ELSE
		SET @d2 = 11 - @d2;

	IF @formatar = 'S'
		SET @cpf = CONCAT(@n1, @n2, @n3, '.', @n4, @n5, @n6, '.', @n7, @n8, @n9, '-', @d1, @d2);
	ELSE
		SET @cpf = CONCAT(@n1, @n2, @n3, @n4, @n5, @n6, @n7, @n8, @n9, @d1, @d2);
	print @cpf;
end;

/* Exemplo de uso */
declare @cpf VARCHAR(MAX);
EXEC GenerateCPF 'N', @cpf OUTPUT
SELECT @cpf
