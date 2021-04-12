-----------------------------------Procedure Tabel Transaction-----------------------

/* RESET 
DROP PROCEDURE SP_InsertTB_T_Transaction
*/

CREATE PROCEDURE SP_InsertTB_T_Transaction
	@OrderDate date
	
AS
BEGIN

	INSERT INTO TB_T_Transaction(OrderDate) 
	VALUES (@OrderDate)
	
END;

--Create table dan input data

/*
DROP TABLE TB_T_Transaction;
DROP PROCEDURE IF EXISTS SP_InsertTB_T_Transaction
*/

CREATE TABLE TB_T_Transaction(
	Id int IDENTITY(101,1) PRIMARY KEY,
	OrderDate date
)

EXECUTE SP_InsertTB_T_Transaction '2012-10-05';
EXECUTE SP_InsertTB_T_Transaction '2012-10-15';
EXECUTE SP_InsertTB_T_Transaction '2012-11-05';
EXECUTE SP_InsertTB_T_Transaction '2012-11-20';
EXECUTE SP_InsertTB_T_Transaction '2012-11-30';

CREATE PROC SP_SelectTB_T_Transaction
AS
BEGIN
	SELECT * from TB_T_Transaction
END
GO
EXEC SP_SelectTB_T_Transaction
GO
/*
SELECT * from TB_T_Transaction
*/
-------------------------------------SUPPLIER TABLE---------------------------------------------
--Membuat Tabel Supplier
CREATE TABLE TB_S_Supplier
(
	ID varchar(50) PRIMARY KEY,
	Name varchar(50),
	JoinDate date
);

--Membuat Sequence agar bisa auto increment
CREATE SEQUENCE SQ_SupplierOrderNumber
AS INT
START WITH 1
INCREMENT BY 1;

--DROP SEQUENCE SQ_OrderNumber;

GO

--Membuat SP untuk Insert data ke Tabel Supplier
CREATE PROCEDURE SP_InsertTB_S_Supplier
AS
BEGIN
	INSERT INTO TB_S_Supplier(ID, [Name], JoinDate) 
	VALUES
	(NEXT VALUE FOR SQ_SupplierOrderNumber, 'PT. Synnex Metrodata Indonesia', '2018-01-15'),
	(NEXT VALUE FOR SQ_SupplierOrderNumber, 'PT. Metrodata Indonesia', '2018-01-16'),
	(NEXT VALUE FOR SQ_SupplierOrderNumber, 'PT. Mitra Informatika Indonesia', '2018-01-16'),
	(NEXT VALUE FOR SQ_SupplierOrderNumber, 'PT. Metro Mobile', '2018-01-15');
END;
GO
--Membuat Trigger saat setelah insert data ke tabel Supplier, agar auto increment bisa dipasangkan dengan
--kata 'SP0'
CREATE TRIGGER TR_InsertTB_S_Supplier
ON TB_S_Supplier
AFTER INSERT
AS
BEGIN
	UPDATE TB_S_Supplier
	SET 
		ID = 'SP' + RIGHT('0' + CAST(i.ID AS varchar),2)
	FROM
		inserted i
	WHERE 
		i.ID = TB_S_Supplier.ID
END;
GO

EXEC SP_InsertTB_S_Supplier;
GO

--Membuat SP untuk Menampilkan Tabel Supplier
CREATE PROC SP_SelectTB_S_Supplier
AS
BEGIN
	SELECT * FROM TB_S_Supplier
END;
GO
EXEC SP_SelectTB_S_Supplier;
GO

/*
SELECT * FROM TB_S_Supplier;



DROP TABLE TB_S_Supplier;
DROP PROCEDURE SP_InsertTB_S_Supplier;
DROP TRIGGER TR_InsertTB_S_Supplier;
DROP SEQUENCE SQ_OrderNumber;

*/

---------------------------------------ITEM TABLE-------------------------------------------------
--Membuat tabel Item
CREATE TABLE TB_I_Item
(
	ID varchar(50) NOT NULL PRIMARY KEY,
	Name varchar(50),
	Price int,
	Stock int,
	Supplier_ID varchar(50) FOREIGN KEY REFERENCES TB_S_Supplier(ID)
);

--Membuat sequence untuk auto increment
CREATE SEQUENCE SQ_ItemOrderNumber
AS INT
START WITH 1
INCREMENT BY 1;


GO
--Membuat SP untuk Insert data ke tabel Item
CREATE PROCEDURE SP_InsertTB_I_Item
AS
BEGIN
	INSERT INTO TB_I_Item (ID, Name, Price, Stock, Supplier_ID) VALUES
	(NEXT VALUE FOR SQ_ItemOrderNumber, 'Developer .Net',  6000000, 11, 'SP03'),
	(NEXT VALUE FOR SQ_ItemOrderNumber, 'Developer Java', 6000000, 10, 'SP02'),
	(NEXT VALUE FOR SQ_ItemOrderNumber, 'Developer C#', 5500000, 10, 'SP04'),
	(NEXT VALUE FOR SQ_ItemOrderNumber, 'Developer Python', 5500000, 10, 'SP02');
END;
GO

--Membuat Trigger untuk membuat auto increment dipasangkan dengan kata 'B0'
CREATE TRIGGER TR_UpdateTB_I_Item
ON TB_I_Item
AFTER INSERT
AS
BEGIN
	UPDATE TB_I_Item
	SET 
		ID = 'B' + RIGHT('0' + CAST(i.ID AS varchar),2)
	FROM
		inserted i --virtual temporary table dalam trigger
	WHERE 
		i.ID = TB_I_Item.ID
END;
GO
--Membuat SP untuk menampilkan Tabel Item
CREATE PROC SP_SelectTB_I_Item
AS
BEGIN
	SELECT * FROM TB_I_Item
END;
GO
EXEC SP_SelectTB_I_Item;
GO
/*
EXEC SP_InsertTB_I_Item;
SELECT * FROM TB_I_Item;

DROP TABLE TB_I_Item;
DROP PROCEDURE SP_InsertTB_I_Item;
DROP TRIGGER TR_InsertTB_I_Item;
DROP SEQUENCE SQ_ItemOrderNumber;
*/

-----------------------------------TransactionItem TABLE-----------------------------------------------
--Membuat Tabel TransactionItem
CREATE TABLE TB_TI_TransactionItem
(
	ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Quantity int,
	Transaction_ID int FOREIGN KEY REFERENCES TB_T_Transaction(ID),
	Item_ID varchar(50) FOREIGN KEY REFERENCES TB_I_Item(ID)
);

GO
--membuat SP untuk memasukkan Data ke Tabel TransactionItem
CREATE PROCEDURE SP_InsertTB_TI_TransactionItem (
	@Quantity AS DECIMAL,
	@Transaction_ID AS DECIMAL,
	@Item_ID AS VARCHAR(50)
)
AS
BEGIN
	--Kondisi dimana data bisa dimasukkan HANYA KALAU quantity minimal 1
	IF @Quantity > 0
	BEGIN
		INSERT INTO TB_TI_TransactionItem (Quantity, Transaction_ID, Item_ID) VALUES
		(@Quantity, @Transaction_ID, @Item_ID);
	END
	ELSE
	BEGIN
		--Kalau quantity tidak bernilai minimal 1, akan muncul tulisan ini
		PRINT 'Tolong masukkan Quantity dengan jumlah lebih dari NOL';
	END
END;
GO
--Memasukkan Data
EXECUTE SP_InsertTB_TI_TransactionItem 10,'101','B01';
EXECUTE SP_InsertTB_TI_TransactionItem 5,'101','B02';
EXECUTE SP_InsertTB_TI_TransactionItem 4,'102','B04';
EXECUTE SP_InsertTB_TI_TransactionItem 5,'103','B03';
EXECUTE SP_InsertTB_TI_TransactionItem 10,'104','B04';
EXECUTE SP_InsertTB_TI_TransactionItem 3,'105','B02';

--Pengecekan kalau input dibawah 1
EXECUTE SP_InsertTB_TI_TransactionItem 0,103,'B02';

--Membuat SP untuk menampilkan Data TransactionItem
CREATE PROC SP_SelectTB_TI_TransactionItem
AS
BEGIN
	SELECT * FROM TB_TI_TransactionItem
END;
GO
EXEC SP_SELECTTB_TI_TransactionItem;
GO
/*

EXECUTE SP_InsertTB_TI_TransactionItem 0,103,'B02';
SELECT * FROM TB_TI_TransactionItem;

DROP TABLE TB_I_Item;
DROP PROCEDURE SP_InsertTB_I_Item;
DROP TRIGGER TR_InsertTB_I_Item;
DROP SEQUENCE SQ_ItemOrderNumber;
*/

--------------------------------PROBLEM SP-----------------------------------------
---------------1a--------------
CREATE PROCEDURE SP_RetrieveTB_I_ItemTB_S_Supplier
AS
BEGIN
	SELECT 
		i.ID AS 'Kode Barang', 
		i.[Name] AS 'Nama Barang', 
		s.Name AS 'Supplier'
	FROM 
		TB_I_Item i
		INNER JOIN TB_S_Supplier s ON i.Supplier_ID = s.ID;
END;

GO
EXEC SP_RetrieveTB_I_ItemTB_S_Supplier;
GO
/*
Retrieve Data Table 1a

*/
-------------------1b-----------------
--GO
CREATE PROCEDURE SP_RetrieveTB_I_ItemTB_S_SupplierTB_TI_TransactionItem
AS
BEGIN
	SELECT 
		TI.Transaction_ID AS 'Nomor Faktur', 
		s.Name AS 'Supplier', i.Name AS 'Nama Barang', 
		i.Price AS 'Price'
	FROM 
		TB_I_Item i
		INNER JOIN TB_S_Supplier s ON i.Supplier_ID = s.ID
		INNER JOIN TB_TI_TransactionItem ti ON i.ID = ti.Item_ID 
	WHERE 
		TI.Transaction_ID = 101;
END;
GO
/*
Retrieve data table 1b
EXEC SP_RetrieveTB_I_ItemTB_S_SupplierTB_TI_TransactionItem;
*/

--------------------1c--------------------------
--GO
CREATE PROCEDURE SP_RetrieveTB_I_ItemTB_TI_TransactionItem
AS
BEGIN
	SELECT 
		ti.Transaction_ID AS 'Nomor Faktur',
		i.[Name] AS 'Nama Barang', 
		ti.Quantity, 
		FORMAT(i.Price,'N') AS 'Harga', 
		FORMAT((Ti.Quantity * i.Price),'N') as 'Total Harga'
	FROM 
		TB_I_Item i
		INNER JOIN TB_TI_TransactionItem ti ON i.ID = ti.Item_ID;
END;
GO

/*
Retrieve Data 1c
EXEC SP_RetrieveTB_I_ItemTB_TI_TransactionItem;
DROP PROC SP_RetrieveTB_I_ItemTB_TI_TransactionItem;
*/

-------------------2---------------------------
--GO
CREATE PROCEDURE SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item
AS
BEGIN
	SELECT 
		ti.Transaction_ID AS 'Nomor Faktur', 
		FORMAT(SUM(ti.Quantity * i.Price),'N') AS 'Total Faktur', 
		t.OrderDate AS 'Tanggal Faktur', 
		DATEADD(DAY, 14, T.OrderDate) AS 'Jatuh Tempo'
	FROM 
		TB_TI_TransactionItem ti
		INNER JOIN TB_T_Transaction t ON TI.Transaction_ID = t.ID
		INNER JOIN TB_I_Item i ON TI.Item_ID = i.ID
	GROUP BY 
		ti.Transaction_ID,t.OrderDate;
END;
GO

/*
Retrieve Data 2
EXEC SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item;
DROP PROC SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item;
*/

-----------------3a---------------------
--GO
CREATE PROCEDURE SP_RetrieveTB_I_ItemTB_TI_TransactionItem3A
AS
BEGIN
	SELECT 
		i.Name, 
		SUM(ti.Quantity) AS 'Quantity'
	FROM 
		TB_I_Item i
		INNER JOIN TB_TI_TransactionItem ti ON i.ID = ti.Item_ID
	GROUP BY 
		i.[Name];
END;
GO

/*
Retrieve data 3a
EXEC SP_RetrieveTB_I_ItemTB_TI_TransactionItem3A;
*/

------------------3b-------------------------
--GO
CREATE PROCEDURE SP_RetrieveTB_TI_TransactionItemTB_I_ItemTB_T_Transaction
AS
BEGIN
	SELECT 
		i.Name, 
		SUM(ti.Quantity) AS 'Quantity'
	FROM 
		TB_TI_TransactionItem ti
		INNER JOIN TB_I_Item i ON i.ID = ti.Item_ID
		INNER JOIN TB_T_Transaction t ON t.ID = ti.Transaction_ID
	WHERE 
		t.OrderDate LIKE '2012-10%'
	GROUP BY 
		i.Name;
END;
GO
/*
DROP PROC SP_RetrieveTB_TI_TransactionItemTB_I_ItemTB_T_Transaction;
Retrieve data 3b
EXEC SP_RetrieveTB_TI_TransactionItemTB_I_ItemTB_T_Transaction;
*/

----------------------------4a-------------------------------
--GO
CREATE PROCEDURE SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item4
AS
BEGIN
	SELECT 
		i.[Name],
		SUM(CASE WHEN t.OrderDate LIKE '2012-10%' THEN ti.Quantity ELSE 0 END) AS 'October',
		SUM(CASE WHEN t.OrderDate LIKE '2012-11%' THEN ti.Quantity ELSE 0 END) AS 'November',
		SUM(CASE WHEN t.OrderDate LIKE '2012-12%' THEN ti.Quantity ELSE 0 END) AS 'December'
	FROM 
		TB_TI_TransactionItem ti
		INNER JOIN TB_T_Transaction t ON ti.Transaction_ID = t.ID
		INNER JOIN TB_I_Item i ON i.ID = ti.Item_ID
	GROUP BY i.Name;
END;
GO

/*
Retrieve data 4
EXEC SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item4;
*/

---------------------------5---------------------------
--GO
CREATE PROCEDURE SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item5
AS
BEGIN
	SELECT 
	COALESCE(i.[Name], 'TOTAL') AS 'Name',
	SUM(CASE WHEN t.OrderDate LIKE '2012-10%' THEN ti.Quantity ELSE 0 END) AS 'October',
	SUM(CASE WHEN t.OrderDate LIKE '2012-11%' THEN ti.Quantity ELSE 0 END) AS 'November',
	SUM(CASE WHEN t.OrderDate LIKE '2012-12%' THEN ti.Quantity ELSE 0 END) AS 'December'
	FROM 
		TB_TI_TransactionItem ti
		INNER JOIN TB_T_Transaction t ON ti.Transaction_ID = t.ID
		INNER JOIN TB_I_Item i ON i.ID = ti.Item_ID
	GROUP BY ROLLUP([Name]);
END;
GO
/*
Retrieve data 5
EXEC SP_RetrieveTB_TI_TransactionItemTB_T_TransactionTB_I_Item5;
*/

-----------------------------------PROBLEM VIEW-----------------------------------------------------

------------------1a--------------------------
--Membuat View
CREATE VIEW View_TB_I_ItemTB_S_Supplier 
AS
SELECT 
	i.ID AS 'Kode Barang', 
	i.[Name] AS 'Nama Barang', 
	s.Name AS 'Supplier'
FROM 
	TB_I_Item i
	INNER JOIN TB_S_Supplier s ON i.Supplier_ID = s.ID;
GO
SELECT * FROM View_TB_I_ITemTB_S_Supplier

/*
Retrieve data 1a view
SELECT * FROM View_TB_I_ITemTB_S_Supplier
*/

---------------1b----------------------
CREATE VIEW View_TB_I_ItemTB_S_SupplierTB_TI_TransactionItem
AS
SELECT 
	TI.Transaction_ID AS 'Nomor Faktur', 
	s.Name AS 'Supplier', i.Name AS 'Nama Barang', 
	i.Price AS 'Price'
FROM 
	TB_I_Item i
	INNER JOIN TB_S_Supplier s ON i.Supplier_ID = s.ID
	INNER JOIN TB_TI_TransactionItem ti ON i.ID = ti.Item_ID 
WHERE 
	TI.Transaction_ID = 101;

GO
SELECT * FROM View_TB_I_ItemTB_S_SupplierTB_TI_TransactionItem
/*
Retrieve data 1b view

*/

--------------------1c------------------------------
CREATE VIEW View_TB_I_ItemTB_TI_TransactionItem
AS
SELECT 
	ti.Transaction_ID AS 'Nomor Faktur',
	i.[Name] AS 'Nama Barang', 
	ti.Quantity, 
	FORMAT(i.Price, 'N') AS 'Harga', 
	FORMAT((Ti.Quantity * i.Price),'N') as 'Total Harga'
FROM 
	TB_I_Item i
	INNER JOIN TB_TI_TransactionItem ti ON i.ID = ti.Item_ID;
GO
SELECT * FROM View_TB_I_ItemTB_TI_TransactionItem;
/*
Retrieve data 1c view

DROP VIEW View_TB_I_ItemTB_TI_TransactionItem
*/

--------------------2---------------------------
CREATE VIEW View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item
AS
SELECT 
	ti.Transaction_ID AS 'Nomor Faktur', 
	FORMAT(SUM(ti.Quantity * i.Price),'N') AS 'Total Faktur', 
	t.OrderDate AS 'Tanggal Faktur', 
	DATEADD(DAY, 14, T.OrderDate) AS 'Jatuh Tempo'
FROM 
	TB_TI_TransactionItem ti
	INNER JOIN TB_T_Transaction t ON TI.Transaction_ID = t.ID
	INNER JOIN TB_I_Item i ON TI.Item_ID = i.ID
GROUP BY 
	ti.Transaction_ID,t.OrderDate;
GO
SELECT * FROM View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item;
/*
Retrieve data 2 view

DROP VIEW View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item
*/

-----------------3a-------------------------
CREATE VIEW View_TB_I_ItemTB_TI_TransactionItem3A
AS
SELECT 
	i.Name, 
	SUM(ti.Quantity) AS 'Quantity'
FROM 
	TB_I_Item i
	INNER JOIN TB_TI_TransactionItem ti ON i.ID = ti.Item_ID
GROUP BY 
	i.[Name];
GO

SELECT * FROM View_TB_I_ItemTB_TI_TransactionItem3A
/*
Retrieve data 3a view

*/

------------------------3b--------------------
CREATE VIEW View_TB_TI_TransactionItemTB_I_ItemTB_T_Transaction
AS
SELECT 
	i.Name, 
	SUM(ti.Quantity) AS 'Quantity'
FROM 
	TB_TI_TransactionItem ti
	INNER JOIN TB_I_Item i ON i.ID = ti.Item_ID
	INNER JOIN TB_T_Transaction t ON t.ID = ti.Transaction_ID
WHERE 
	t.OrderDate LIKE '2012-10%'
GROUP BY 
	i.Name;
GO

SELECT * FROM View_TB_TI_TransactionItemTB_I_ItemTB_T_Transaction

/*
Retrieve data 3b view

*/

-----------------4--------------------
CREATE VIEW View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item4
AS
SELECT 
	i.[Name],
	SUM(CASE WHEN t.OrderDate LIKE '2012-10%' THEN ti.Quantity ELSE 0 END) AS 'October',
	SUM(CASE WHEN t.OrderDate LIKE '2012-11%' THEN ti.Quantity ELSE 0 END) AS 'November',
	SUM(CASE WHEN t.OrderDate LIKE '2012-12%' THEN ti.Quantity ELSE 0 END) AS 'December'
FROM 
	TB_TI_TransactionItem ti
	INNER JOIN TB_T_Transaction t ON ti.Transaction_ID = t.ID
	INNER JOIN TB_I_Item i ON i.ID = ti.Item_ID
GROUP BY i.[Name];
GO

SELECT * FROM View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item4
/*
Retrieve data 4 view

*/

----------------------5-------------------
CREATE VIEW View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item5
AS
SELECT 
	COALESCE(i.[Name], 'TOTAL') AS 'Name',
	SUM(CASE WHEN t.OrderDate LIKE '2012-10%' THEN ti.Quantity ELSE 0 END) AS 'October',
	SUM(CASE WHEN t.OrderDate LIKE '2012-11%' THEN ti.Quantity ELSE 0 END) AS 'November',
	SUM(CASE WHEN t.OrderDate LIKE '2012-12%' THEN ti.Quantity ELSE 0 END) AS 'December'
FROM 
	TB_TI_TransactionItem ti
	INNER JOIN TB_T_Transaction t ON ti.Transaction_ID = t.ID
	INNER JOIN TB_I_Item i ON i.ID = ti.Item_ID
GROUP BY ROLLUP([Name]);
GO

SELECT * FROM View_TB_TI_TransactionItemTB_T_TransactionTB_I_Item5
/*
Retrieve data 5 view

*/
