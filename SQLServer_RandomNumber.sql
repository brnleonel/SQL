begin	
	declare @randomize nvarchar(max) = N'SELECT @result = CAST(RAND(CHECKSUM(NEWID()))*(@max-@min+1)+@min AS BIGINT);';
	declare @randomizeparam nvarchar(max) = N'@min bigint, @max bigint, @result bigint OUTPUT';
	declare @randomizeresult bigint;

	EXEC sp_executesql @randomize, @randomizeparam, 11111111111, 99999999999, @randomizeresult OUTPUT;
	PRINT CONCAT('N: ', @randomizeresult);
	SELECT @randomizeresult AS NumberRandom;
end;
