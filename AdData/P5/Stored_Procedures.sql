
CREATE PROCEDURE [dbo].[DivideTablesForAllCoins]
AS
BEGIN
    -- List of coins
    DECLARE @Coins TABLE (Name VARCHAR(50), Table_Name VARCHAR(50))
    INSERT INTO @Coins VALUES ('Bitcoin', 'Bitcoin'), ('Ethereum', 'Ethereum'), ('Binance Coin', 'BinanceCoin'), ('Cardano', 'Cardano'), ('Dogecoin', 'Dogecoin'), ('Aave', 'Aave')

    -- Loop through each coin and create the tables
    DECLARE @Name VARCHAR(50), @Table_Name VARCHAR(50)
    DECLARE cur CURSOR FOR SELECT Name, Table_Name FROM @Coins
    OPEN cur
    FETCH NEXT FROM cur INTO @Name, @Table_Name
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Create a new table to hold the name and symbol columns
        IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoinNames_'+@Table_Name+']') AND type in (N'U'))
        BEGIN
            EXEC('CREATE TABLE [dbo].[CoinNames_'+@Table_Name+'] (
                Name VARCHAR(50) NOT NULL,
                Symbol VARCHAR(10) NOT NULL,
                CONSTRAINT PK_CoinNames_'+@Table_Name+' PRIMARY KEY (Symbol)
            )')
        END
    
        -- Create a new table to hold all the other columns
        IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoinData_'+@Table_Name+']') AND type in (N'U'))
        BEGIN
            EXEC('CREATE TABLE [dbo].[CoinData_'+@Table_Name+'] (
                SNo INT NOT NULL,
                Symbol VARCHAR(10) NOT NULL,
                Date VARCHAR(20) NOT NULL,
                [High] VARCHAR(20) NOT NULL,
                [Low] VARCHAR(20) NOT NULL,
                [Open] VARCHAR(20) NOT NULL,
                [Close] VARCHAR(20) NOT NULL,
                [Volume] VARCHAR(20) NOT NULL,
                [Marketcap] VARCHAR(20) NOT NULL,
                CONSTRAINT FK_CoinData_CoinNames_'+@Table_Name+' FOREIGN KEY (Symbol) REFERENCES [dbo].[CoinNames_'+@Table_Name+'](Symbol)
            )')
        END
    
        -- Insert the name and symbol values into the CoinNames table
        EXEC('INSERT INTO [dbo].[CoinNames_'+@Table_Name+'] (Name, Symbol)
        SELECT DISTINCT Name, Symbol FROM '+@Table_Name)
    
        -- Insert the other columns into the CoinData table
        EXEC('INSERT INTO [dbo].[CoinData_'+@Table_Name+'] (SNo, Symbol, Date, [High], [Low], [Open], [Close], [Volume], [Marketcap])
        SELECT SNo, Symbol, Date, [High], [Low], [Open], [Close], [Volume], [Marketcap] FROM '+@Table_Name)
    
        FETCH NEXT FROM cur INTO @Name, @Table_Name
    END
    CLOSE cur
    DEALLOCATE cur
END
GO
