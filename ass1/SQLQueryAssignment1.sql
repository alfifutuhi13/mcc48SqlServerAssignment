Use [Assignments 1]

Drop Table [TransactionItem];
Drop Table [Item];
Drop Table [Supplier];
Drop Table [Transaction];

CREATE TABLE [Transaction] (
	Id int IDENTITY(101,1) PRIMARY KEY,
	OrderDate Date,
);

INSERT INTO [Transaction] (OrderDate)
VALUES ('2012-10-10');
INSERT INTO [Transaction] (OrderDate)
VALUES ('2012-10-15');
INSERT INTO [Transaction] (OrderDate)
VALUES ('2012-11-05');
INSERT INTO [Transaction] (OrderDate)
VALUES ('2012-11-20');
INSERT INTO [Transaction] (OrderDate)
VALUES ('2012-11-30');

SELECT * FROM [Transaction];

CREATE TABLE Supplier(
	[Sup_Id] varchar(50) PRIMARY KEY,
	[Name] varchar(50),
	JoinDate date,
);

INSERT INTO Supplier([Sup_Id], [Name], JoinDate)
VALUES('SP01', 'PT. Synnex Metrodata Indonesia', '2018-01-15');
INSERT INTO Supplier([Sup_Id], [Name], JoinDate)
VALUES('SP02', 'PT. Metrodata Indonesia', '2018-01-16');
INSERT INTO Supplier([Sup_Id], [Name], JoinDate)
VALUES('SP03', 'PT. Mitra Informatika Indonesia', '2018-01-16');
INSERT INTO Supplier([Sup_Id], [Name], JoinDate)
VALUES('SP04', 'PT. Metro Mobile', '2018-01-15');

SELECT [Sup_Id] as Id, [Name], JoinDate FROM Supplier;

CREATE TABLE Item(
	It_Id varchar(50) PRIMARY KEY,
	[Name] varchar(50),
	Price int,
	Stock int,
	[Supplier_id] varchar(50) NOT NULL REFERENCES Supplier(Sup_Id),
);

INSERT INTO Item(It_Id, [Name], Price, Stock, Supplier_Id)
VALUES('B01','Developer .Net', 6000000, 11, 'SP03');
INSERT INTO Item(It_Id, [Name], Price, Stock, Supplier_Id)
VALUES('B02', 'Developer Java', 6000000, 10, 'SP02');
INSERT INTO Item(It_Id, [Name], Price, Stock, Supplier_Id)
VALUES('B03', 'Developer C#', 5500000, 10, 'SP04');
INSERT INTO Item(It_Id, [Name], Price, Stock, Supplier_Id)
VALUES('B04', 'Developer Python', 5500000, 10, 'SP02');

SELECT It_Id as Id, [Name], Price, Stock, Supplier_id FROM Item;

CREATE TABLE TransactionItem(
	TI_Id varchar(50) PRIMARY KEY,
	Quantity int,
	Transaction_id int NOT NULL REFERENCES [Transaction](Id),
	Item_Id varchar(50) NOT NULL REFERENCES [Item](It_Id),

);

INSERT INTO TransactionItem(TI_Id, Quantity, Transaction_id, Item_Id)
VALUES('01', 10, 101, 'B01');
INSERT INTO TransactionItem(TI_Id, Quantity, Transaction_id, Item_Id)
VALUES('02', 5, 101, 'B02');
INSERT INTO TransactionItem(TI_Id, Quantity, Transaction_id, Item_Id)
VALUES('03', 4, 102, 'B04');
INSERT INTO TransactionItem(TI_Id, Quantity, Transaction_id, Item_Id)
VALUES('04', 5, 103, 'B03');
INSERT INTO TransactionItem(TI_Id, Quantity, Transaction_id, Item_Id)
VALUES('05', 10, 104, 'B04');
INSERT INTO TransactionItem(TI_Id, Quantity, Transaction_id, Item_Id)
VALUES('06', 3, 105, 'B02');

SELECT TI_Id as Id, Quantity, Transaction_id, Item_id from TransactionItem;





--1A
SELECT  
	Item.It_Id as 'Kode Barang', 
	Item.[Name] as 'Nama Barang', 
	Supplier.[Name] as 'Supplier' 
FROM 
	Item INNER JOIN Supplier 
	ON Item.Supplier_id = Supplier.Sup_Id;

--1B
SELECT 
	[TransactionItem].Transaction_id as 'Nomor Faktur', 
	Supplier.[Name] as 'Supplier', 
	Item.[Name] as 'Barang', 
	Item.Price as Price 
FROM 
	([TransactionItem] INNER JOIN Item ON TransactionItem.Item_Id = It_Id ) 
	INNER JOIN Supplier ON Item.Supplier_id = Sup_Id 
WHERE 
	[TransactionItem].Transaction_Id = 101;

--1C
SELECT 
	[TransactionItem].Transaction_id as 'Nomor Faktur', 
	Item.[Name] as 'Barang', 
	TransactionItem.Quantity as Quantity,
	Item.price as Price, 
	(TransactionItem.Quantity*Item.Price) as 'Total Harga'
FROM 
	(TransactionItem INNER JOIN Item ON TransactionItem.Item_Id = It_Id)
	INNER JOIN Supplier ON Item.Supplier_id = Sup_Id

--2
SELECT 
	[TransactionItem].Transaction_id as 'Nomor Faktur', 
	FORMAT(SUM(Item.Price*TransactionItem.Quantity),'N') as 'Total Faktur', 
	[Transaction].OrderDate as 'Tanggal Faktur', 
	DATEADD(day, 14, [Transaction].OrderDate) as 'Jatuh Tempo'
FROM 
	(TransactionItem INNER JOIN [Transaction] ON [Transaction].Id = TransactionItem.Transaction_id)
	INNER JOIN Item ON TransactionItem.Item_Id = It_Id
GROUP BY 
	Transaction_id, 
	[Transaction].OrderDate;

--3a
SELECT 
	Item.[Name] as 'Name', 
	SUM(TransactionItem.Quantity) as 'Quantity'
FROM 
	(Item INNER JOIN TransactionItem ON Item.It_Id = TransactionItem.Item_Id)
	INNER JOIN [Transaction] ON TransactionItem.Transaction_id = [Transaction].Id
GROUP BY Item.[Name];

--3b
SELECT 
	Item.[Name] as 'Name', 
	TransactionItem.Quantity as 'Quantity'
FROM 
	(Item INNER JOIN TransactionItem ON Item.It_Id = TransactionItem.Item_Id)
	INNER JOIN [Transaction] ON TransactionItem.Transaction_id = [Transaction].Id
WHERE 
	[Transaction].OrderDate LIKE '2012-10%';

--4
SELECT 
	Item.[Name] as 'Name', 
	SUM(CASE WHEN [Transaction].OrderDate LIKE '2012-10%' THEN TransactionItem.Quantity ELSE 0 END) as 'October',
	SUM(CASE WHEN [Transaction].OrderDate LIKE '2012-11%' THEN TransactionItem.Quantity ELSE 0 END) as 'November',
	SUM(CASE WHEN [Transaction].OrderDate LIKE '2012-12%' THEN TransactionItem.Quantity ELSE 0 END) as 'December'
	
FROM 
	(Item INNER JOIN TransactionItem ON Item.It_Id = TransactionItem.Item_Id)
	INNER JOIN [Transaction] ON TransactionItem.Transaction_id = [Transaction].Id
GROUP BY Item.[Name];

--5
SELECT 
	ISNULL(item.[Name], 'TOTAL') as 'Name',
	SUM(CASE WHEN [Transaction].OrderDate LIKE '2012-10%' THEN TransactionItem.Quantity ELSE 0 END) as 'October',
	SUM(CASE WHEN [Transaction].OrderDate LIKE '2012-11%' THEN TransactionItem.Quantity ELSE 0 END) as 'November',
	SUM(CASE WHEN [Transaction].OrderDate LIKE '2012-12%' THEN TransactionItem.Quantity ELSE 0 END) as 'December'
	
	
FROM 
	(Item INNER JOIN TransactionItem ON Item.It_Id = TransactionItem.Item_Id)
	INNER JOIN [Transaction] ON TransactionItem.Transaction_id = [Transaction].Id
GROUP BY 
	--Item.[Name],
	ROLLUP(Item.[Name]);
