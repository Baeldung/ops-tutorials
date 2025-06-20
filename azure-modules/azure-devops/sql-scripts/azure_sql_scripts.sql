-- ========================================
-- /SQLScripts/Tables/CreateCustomersTable.sql
-- ========================================
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

-- ========================================
-- /SQLScripts/Tables/CreateOrdersTable.sql
-- ========================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Orders](
        [OrderId] [int] IDENTITY(1,1) NOT NULL,
        [CustomerId] [int] NOT NULL,
        [OrderDate] [datetime2](7) NOT NULL DEFAULT GETUTCDATE(),
        [OrderStatus] [nvarchar](50) NOT NULL DEFAULT 'Pending',
        [TotalAmount] [decimal](18, 2) NOT NULL,
        [ShippingAddress] [nvarchar](500) NULL,
        [ShippingCity] [nvarchar](100) NULL,
        [ShippingCountry] [nvarchar](100) NULL,
        [Notes] [nvarchar](max) NULL,
        CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderId] ASC),
        CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerId]) REFERENCES [dbo].[Customers] ([CustomerId])
    );
    
    -- Create index on CustomerId for faster joins
    CREATE NONCLUSTERED INDEX [IX_Orders_CustomerId] ON [dbo].[Orders]([CustomerId] ASC);
    
    -- Create index on OrderDate for date-based queries
    CREATE NONCLUSTERED INDEX [IX_Orders_OrderDate] ON [dbo].[Orders]([OrderDate] DESC);
    
    PRINT 'Table Orders created successfully';
END
ELSE
BEGIN
    PRINT 'Table Orders already exists';
END;

-- ========================================
-- /SQLScripts/Views/CustomerOrdersView.sql
-- ========================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_CustomerOrders]'))
    DROP VIEW [dbo].[vw_CustomerOrders];
GO

CREATE VIEW [dbo].[vw_CustomerOrders]
AS
SELECT 
    c.CustomerId,
    c.CustomerName,
    c.Email,
    c.City,
    c.Country,
    o.OrderId,
    o.OrderDate,
    o.OrderStatus,
    o.TotalAmount,
    o.ShippingAddress,
    o.ShippingCity,
    o.ShippingCountry
FROM 
    [dbo].[Customers] c
    INNER JOIN [dbo].[Orders] o ON c.CustomerId = o.CustomerId;
GO

PRINT 'View vw_CustomerOrders created successfully';

-- ========================================
-- /SQLScripts/StoredProcedures/GetCustomerOrders.sql
-- ========================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCustomerOrders]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_GetCustomerOrders];
GO

CREATE PROCEDURE [dbo].[sp_GetCustomerOrders]
    @CustomerId INT = NULL,
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL,
    @OrderStatus NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        o.OrderId,
        o.CustomerId,
        c.CustomerName,
        c.Email,
        o.OrderDate,
        o.OrderStatus,
        o.TotalAmount,
        o.ShippingAddress,
        o.ShippingCity,
        o.ShippingCountry,
        o.Notes
    FROM 
        [dbo].[Orders] o
        INNER JOIN [dbo].[Customers] c ON o.CustomerId = c.CustomerId
    WHERE 
        (@CustomerId IS NULL OR o.CustomerId = @CustomerId)
        AND (@StartDate IS NULL OR o.OrderDate >= @StartDate)
        AND (@EndDate IS NULL OR o.OrderDate <= @EndDate)
        AND (@OrderStatus IS NULL OR o.OrderStatus = @OrderStatus)
    ORDER BY 
        o.OrderDate DESC;
END;
GO

PRINT 'Stored procedure sp_GetCustomerOrders created successfully';

-- ========================================
-- /SQLScripts/Data/InitialData.sql
-- ========================================
-- Insert sample customers
IF NOT EXISTS (SELECT 1 FROM [dbo].[Customers])
BEGIN
    SET IDENTITY_INSERT [dbo].[Customers] ON;
    
    INSERT INTO [dbo].[Customers] (CustomerId, CustomerName, Email, Phone, Address, City, Country)
    VALUES 
        (1, 'Contoso Ltd', 'info@contoso.com', '+1-555-0100', '123 Main St', 'Seattle', 'USA'),
        (2, 'Fabrikam Inc', 'contact@fabrikam.com', '+1-555-0101', '456 Oak Ave', 'New York', 'USA'),
        (3, 'Northwind Traders', 'sales@northwind.com', '+44-20-1234-5678', '789 High St', 'London', 'UK'),
        (4, 'Adventure Works', 'support@adventure-works.com', '+1-555-0102', '321 Pine Rd', 'Los Angeles', 'USA'),
        (5, 'Blue Yonder Airlines', 'info@blueyonder.com', '+1-555-0103', '654 Airport Way', 'Chicago', 'USA');
    
    SET IDENTITY_INSERT [dbo].[Customers] OFF;
    
    PRINT 'Sample customers inserted successfully';
END
ELSE
BEGIN
    PRINT 'Customers table already contains data';
END;

-- Insert sample orders
IF NOT EXISTS (SELECT 1 FROM [dbo].[Orders])
BEGIN
    INSERT INTO [dbo].[Orders] (CustomerId, OrderDate, OrderStatus, TotalAmount, ShippingAddress, ShippingCity, ShippingCountry)
    VALUES 
        (1, DATEADD(day, -30, GETUTCDATE()), 'Completed', 1250.00, '123 Main St', 'Seattle', 'USA'),
        (1, DATEADD(day, -15, GETUTCDATE()), 'Shipped', 850.50, '123 Main St', 'Seattle', 'USA'),
        (2, DATEADD(day, -20, GETUTCDATE()), 'Completed', 2100.00, '456 Oak Ave', 'New York', 'USA'),
        (2, DATEADD(day, -5, GETUTCDATE()), 'Processing', 550.25, '456 Oak Ave', 'New York', 'USA'),
        (3, DATEADD(day, -45, GETUTCDATE()), 'Completed', 3200.00, '789 High St', 'London', 'UK'),
        (3, DATEADD(day, -10, GETUTCDATE()), 'Pending', 1750.00, '789 High St', 'London', 'UK'),
        (4, DATEADD(day, -25, GETUTCDATE()), 'Shipped', 980.00, '321 Pine Rd', 'Los Angeles', 'USA'),
        (5, DATEADD(day, -8, GETUTCDATE()), 'Processing', 1500.00, '654 Airport Way', 'Chicago', 'USA');
    
    PRINT 'Sample orders inserted successfully';
END
ELSE
BEGIN
    PRINT 'Orders table already contains data';
END;

-- Verify data insertion
SELECT 'Total Customers: ' + CAST(COUNT(*) AS NVARCHAR(10)) AS Summary FROM [dbo].[Customers];
SELECT 'Total Orders: ' + CAST(COUNT(*) AS NVARCHAR(10)) AS Summary FROM [dbo].[Orders];

-- ========================================
-- Additional utility scripts you might want:
-- ========================================

-- ========================================
-- /SQLScripts/Tables/CreateOrderItemsTable.sql
-- ========================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderItems]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[OrderItems](
        [OrderItemId] [int] IDENTITY(1,1) NOT NULL,
        [OrderId] [int] NOT NULL,
        [ProductName] [nvarchar](200) NOT NULL,
        [Quantity] [int] NOT NULL,
        [UnitPrice] [decimal](18, 2) NOT NULL,
        [LineTotal] AS ([Quantity] * [UnitPrice]) PERSISTED,
        CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED ([OrderItemId] ASC),
        CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([OrderId]) REFERENCES [dbo].[Orders] ([OrderId]) ON DELETE CASCADE
    );
    
    CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderId] ON [dbo].[OrderItems]([OrderId] ASC);
    
    PRINT 'Table OrderItems created successfully';
END;

-- ========================================
-- /SQLScripts/StoredProcedures/GetOrderSummary.sql
-- ========================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetOrderSummary]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_GetOrderSummary];
GO

CREATE PROCEDURE [dbo].[sp_GetOrderSummary]
    @StartDate DATETIME2 = NULL,
    @EndDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set default date range if not provided (last 30 days)
    IF @StartDate IS NULL
        SET @StartDate = DATEADD(day, -30, GETUTCDATE());
    
    IF @EndDate IS NULL
        SET @EndDate = GETUTCDATE();
    
    -- Order summary by status
    SELECT 
        OrderStatus,
        COUNT(*) AS OrderCount,
        SUM(TotalAmount) AS TotalRevenue,
        AVG(TotalAmount) AS AverageOrderValue
    FROM 
        [dbo].[Orders]
    WHERE 
        OrderDate BETWEEN @StartDate AND @EndDate
    GROUP BY 
        OrderStatus
    ORDER BY 
        TotalRevenue DESC;
    
    -- Top customers by revenue
    SELECT TOP 10
        c.CustomerName,
        COUNT(o.OrderId) AS OrderCount,
        SUM(o.TotalAmount) AS TotalSpent
    FROM 
        [dbo].[Customers] c
        INNER JOIN [dbo].[Orders] o ON c.CustomerId = o.CustomerId
    WHERE 
        o.OrderDate BETWEEN @StartDate AND @EndDate
    GROUP BY 
        c.CustomerId, c.CustomerName
    ORDER BY 
        TotalSpent DESC;
END;
GO

PRINT 'Stored procedure sp_GetOrderSummary created successfully';
