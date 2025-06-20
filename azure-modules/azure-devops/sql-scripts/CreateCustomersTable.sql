IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Customers](
        [CustomerId] [int] IDENTITY(1,1) NOT NULL,
        [CustomerName] [nvarchar](100) NOT NULL,
        [Email] [nvarchar](255) NOT NULL,
        [Phone] [nvarchar](20) NULL,
        [Address] [nvarchar](500) NULL,
        [City] [nvarchar](100) NULL,
        [Country] [nvarchar](100) NULL,
        [CreatedDate] [datetime2](7) NOT NULL DEFAULT GETUTCDATE(),
        [ModifiedDate] [datetime2](7) NULL,
        CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
    );
    
    -- Create index on Email for faster lookups
    CREATE NONCLUSTERED INDEX [IX_Customers_Email] ON [dbo].[Customers]([Email] ASC);
    
    PRINT 'Table Customers created successfully';
END
ELSE
BEGIN
    PRINT 'Table Customers already exists';
END;
