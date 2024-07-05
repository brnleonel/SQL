/* Gera lista temporaria de cpf validos e invalidos aleatoriamente */
begin
	declare @quantidade integer = 100;
	declare @registro integer = 1;
	declare @tabelacpf TABLE(id integer, cpf bigint);
	
	declare @randomize nvarchar(max) = N'SELECT @result = CAST(RAND(CHECKSUM(NEWID()))*(@max-@min+1)+@min AS BIGINT);';
	declare @randomizeparam nvarchar(max) = N'@min bigint, @max bigint, @result bigint OUTPUT';
	declare @randomizeresult bigint = 0;
		
	declare @mod bigint = 0;
	EXEC sp_executesql @randomize, @randomizeparam, 1, 20, @mod OUTPUT;
	print CONCAT('mod aleatorio: ',@mod);

	while (@registro < @quantidade)
	begin
		if (@registro % @mod = 0)
		begin
			/* Gerador de CPF invalido */
			EXEC sp_executesql @randomize, @randomizeparam, 11111111111, 99999999999, @randomizeresult OUTPUT;
			PRINT CONCAT('Valido: ', @randomizeresult);
			insert @tabelacpf values (@registro, @randomizeresult);
		end
		else
		begin
			/* Gerador de CPF valido */
			declare @cpf VARCHAR(MAX);
			EXEC GenerateCPF 'N', @cpf OUTPUT;
			insert @tabelacpf values (@registro, @cpf);
      PRINT CONCAT('Invalido: ', @cpf);
		end;
				
		set @registro = @registro + 1;
	end;
	
	select * from @tabelacpf;
end;
