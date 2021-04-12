----------------------------------TABEL-----------------------------------------
-----------------------Membuat Tabel Person (Master)
CREATE TABLE TB_M_Person(
	NIK varchar(50) NOT NULL PRIMARY KEY,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	Phone varchar(50) NULL,
	BirthDate date NULL,
	Salary int NULL, 
	Email varchar(50) NULL
)
/* Reset Table
DROP TABLE TB_M_Person;
*/

--------------------Membuat Tabel University (Master)
CREATE TABLE TB_M_University(
	[id number] varchar(50) NOT NULL PRIMARY KEY,
	[Name] varchar(50) NOT NULL
)
/* Reset Table
DROP TABLE TB_M_University;
*/

--------------------------Membuat Tabel Account
CREATE TABLE TB_Account(
	NIK varchar(50) NOT NULL PRIMARY KEY REFERENCES TB_M_Person(NIK),
	[Password] varchar(50) NOT NULL
)
/* Reset Table
DROP TABLE TB_Account;
*/

---------------------Membuat Tabel Education
CREATE TABLE TB_Education(
	Id varchar(50) NOT NULL PRIMARY KEY,
	Degree varchar(50) NOT NULL,
	GPA varchar(50) NOT NULL, 
	University_Id varchar(50) NOT NULL REFERENCES TB_M_University([Id number])
)
/* Reset Table
DROP TABLE TB_Education;
*/

-----------------------Membuat Tabel Profiling
CREATE TABLE TB_Profiling(
	NIK varchar(50) NOT NULL PRIMARY KEY REFERENCES TB_Account(NIK),
	Education_Id varchar(50) NOT NULL REFERENCES TB_Education(Id)
)
/* Reset Table
DROP TABLE TB_Profiling;
*/

/* RESET ALL TABLE
DROP TABLE TB_Profiling;
DROP TABLE TB_Education;
DROP TABLE TB_Account;
DROP TABLE TB_M_University;
DROP TABLE TB_M_Person;
*/

----------------------------------STORE PROCEDURE-------------------------------
GO
----------------------------SP FOR INSERTING DATA Table Person----------------
--Create Sequence for Table Person
CREATE SEQUENCE SQ_Person
AS INT
START WITH 1
INCREMENT BY 1;

GO
/*RESET SQ_Person
DROP SEQUENCE SQ_Person
*/

--Insert Data into Table Person
CREATE PROCEDURE SP_InsertTB_M_Person
	--@NIK AS varchar(50),
	@FirstName AS varchar(50),
	@LastName AS varchar(50),
	@Phone AS varchar(50),
	@BirthDate AS date,
	@Salary AS int,
	@Email AS varchar(50)
AS
BEGIN 
	DECLARE
		@personid as varchar(50),
		@seq as decimal = NEXT VALUE FOR SQ_Person
	SET 
		@personid = 'EMP040121' + RIGHT('0' + CAST(@seq AS varchar),2)
	INSERT INTO TB_M_Person (NIK, FirstName, LastName, Phone, BirthDate, Salary, Email)
	VALUES (@personid, @FirstName, @LastName, @Phone, @BirthDate, @Salary, @Email)
END;
GO

/*RESET SP
DROP PROC SP_InsertTB_M_Person
*/

--Trigger After Insert untuk membuat format NIK EMP04012101 dst
CREATE TRIGGER TR_InsertTB_M_Person
ON TB_M_Person AFTER INSERT
AS
BEGIN
	DECLARE 
		@nik as varchar(50),
		@pass as varchar(50)
	SELECT 
		@nik = j.NIK
	FROM inserted j
	SET
		@pass = 'Password.' + @nik
	INSERT INTO TB_Account
	VALUES (@nik,@pass)
END;
GO

/*RESET ALL ABOUT TB_M_Person
DROP PROC SP_InsertTB_M_Person;
DROP TRIGGER TR_InsertTB_M_Person;
DROP SEQUENCE SQ_Person;
*/

--Execute insertnya
EXEC SP_InsertTB_M_Person 'Alfan','Aisy','8085866535091','1999-11-07',5000000, 'alfanaisy7@gmail.com';
EXEC SP_InsertTB_M_Person 'Alfatehan Arsya','Baharin','8087835053992','1998-09-08',5000000, 'alfatehanarsya8998@gmail.com';
EXEC SP_InsertTB_M_Person 'Alfi', 'Futuhi', '8085782439757', '1997-05-03', 5000000, 'alfi.futuhi13@gmail.com';
EXEC SP_InsertTB_M_Person 'Anindya Sabrina','Pangesti','8087839217981','1997-11-17', 5000000, 'pangestianin@gmail.com';
EXEC SP_InsertTB_M_Person 'Daniel', 'Chandra','8085777337338','1997-08-17', 5000000, 'danielchandra1.dc@gmail.com';
GO
--Membuat SP Untuk Select TB_M_Person
CREATE PROC SP_SelectTB_M_Person
AS
BEGIN
	SELECT * FROM TB_M_Person
END;
GO
/*
DROP PROC SP_Select_TB_M_Person
*/

--Menampilkan TB_M_Person
EXEC SP_SelectTB_M_Person;
GO

/*RESET SP
DROP PROC SP_InsertTB_M_Person;
*/

----------------Membuat SP Untuk Select TB_Account (Hasil Trigger)
CREATE PROC SP_SelectTB_Account
AS
BEGIN
	SELECT * FROM TB_Account
END;
GO

--Menampilkan TB_Account
EXEC SP_SelectTB_Account;
GO

---------------------------SP FOR INSERTING INTO Tabel University-----------------------
--Create Suquence univ
CREATE SEQUENCE SQ_Univ
AS INT
START WITH 1
INCREMENT BY 1
GO
/*Reset squence
DROP SEQUENCE SQ_Univ;
*/

--Insert Data Into Tabel University
CREATE PROCEDURE SP_InsertTB_M_University
	--@Id AS varchar(50),
	@Name as varchar(50)
AS
BEGIN 
	INSERT INTO TB_M_University([Id number], [Name])
	VALUES (NEXT VALUE FOR SQ_Univ, @Name)
END;
GO

/*Reset proc
DROP PROC SP_InsertTB_M_University
*/
--Trigger After Insert untuk membuat format Id Univ01 dst
CREATE TRIGGER TR_InsertTB_M_University
ON TB_M_University AFTER INSERT
AS
BEGIN
	UPDATE TB_M_University
	SET 
		[id number] = 'Univ' + RIGHT('0' + CAST(i.[id number] AS varchar),2)
	FROM
		inserted i
	WHERE 
		i.[id number] = TB_M_University.[id number]
END;
GO

/*RESET ALL ABOUT TB_M_University
DROP PROC SP_InsertTB_M_University;
DROP TRIGGER TR_InsertTB_M_University;
DROP SEQUENCE SQ_Univ;
*/

--Execute insertnya
EXEC SP_InsertTB_M_University 'Universitas A';
EXEC SP_InsertTB_M_University 'Universitas B';
EXEC SP_InsertTB_M_University 'Universitas C';
EXEC SP_InsertTB_M_University 'Universitas D';
EXEC SP_InsertTB_M_University 'Universitas E';
GO
--Membuat SP Untuk Select TB_M_University
CREATE PROC SP_SelectTB_M_University
AS
BEGIN
	SELECT * FROM TB_M_University
END;
GO
/*
DROP PROC SP_SelectTB_M_University
*/

--Menampilkan TB_M_University
EXEC SP_SelectTB_M_University;
GO

-------------------------SP FOR INSERTING INTO Tabel Education---------------------
--Create Suquence Education
CREATE SEQUENCE SQ_Edu
AS INT
START WITH 1
INCREMENT BY 1
GO
/*Reset squence
DROP SEQUENCE SQ_Edu;
*/

--Insert Data Into Tabel University
CREATE PROCEDURE SP_InsertTB_Education
	--@Id AS varchar(50),
	@Degree as varchar(50),
	@GPA as varchar(50),
	@University_Id as varchar(50)
AS
BEGIN 
	INSERT INTO TB_Education(Id, Degree, GPA, University_Id)
	VALUES (NEXT VALUE FOR SQ_Edu, @Degree, @GPA, @University_Id)
END;
GO

/*Reset proc
DROP PROC SP_InsertTB_Education
*/
--Trigger After Insert untuk membuat format Id Edu01 dst
CREATE TRIGGER TR_InsertTB_Education
ON TB_Education AFTER INSERT
AS
BEGIN
	UPDATE TB_Education
	SET 
		Id = 'Edu' + RIGHT('0' + CAST(i.Id AS varchar),2),
		Degree = 
		CASE 
		WHEN i.Degree = 'S1' THEN 'Sarjana'
		WHEN i.Degree = 'S2' THEN 'Master'
		WHEN i.Degree = 'S3' THEN 'Doctor'
		END		
	FROM
		inserted i
	WHERE 
		i.Id = TB_Education.Id
	
END;
GO

/*RESET ALL ABOUT TB_Education
DROP PROC SP_InsertTB_Education;
DROP TRIGGER TR_InsertTB_Education;
DROP SEQUENCE SQ_Edu;
*/

--Execute insertnya
EXEC SP_InsertTB_Education 'S1', '3.66', 'Univ01';
EXEC SP_InsertTB_Education 'S1', '3.69', 'Univ02';
EXEC SP_InsertTB_Education 'S1', '3.69', 'Univ03';
EXEC SP_InsertTB_Education 'S1', '3.66', 'Univ04';
EXEC SP_InsertTB_Education 'S1', '3.69', 'Univ05';
GO
/* Tes insert selain s1 s2 s3
EXEC SP_InsertTB_Education 'S9', '3.69', 'Univ69';

*/
--Membuat SP Untuk Select TB_Education
CREATE PROC SP_SelectTB_Education
AS
BEGIN
	SELECT * FROM TB_Education
END;
GO
/*
DROP PROC SP_SelectTB_Education
*/

--Menampilkan TB_Education
EXEC SP_SelectTB_Education
GO

--------------------------------SP FOR INSERTING INTO Tabel Profiling------------------

--Create Suquence Profiling
/*CREATE SEQUENCE SQ_Profiling
AS INT
START WITH 1
INCREMENT BY 1
GO*/
/*Reset squence
DROP SEQUENCE SQ_Profiling;
*/

--Insert Data Into Tabel University
CREATE PROCEDURE SP_InsertTB_Profiling
	@NIK AS varchar(50),
	@Education_Id as varchar(50)
	
AS
BEGIN 
	INSERT INTO TB_Profiling(NIK, Education_Id)
	VALUES (@NIK, @Education_Id)
END;
GO

/*Reset proc
DROP PROC SP_InsertTB_Profiling
*/
--Trigger After Insert untuk membuat format Id Edu01 dst
/*CREATE TRIGGER TR_InsertTB_Profiling
ON TB_Profiling AFTER INSERT
AS
BEGIN
	UPDATE TB_Profiling
	SET 
		NIK = 'EMP040121' + RIGHT('0' + CAST(i.NIK AS varchar),2)
	FROM
		inserted i
	WHERE 
		i.NIK = TB_Profiling.NIK
END;
GO*/

/*RESET ALL ABOUT TB_Profiling
DROP PROC SP_InsertTB_Profiling;
--DROP TRIGGER TR_InsertTB_Profiling;
DROP SEQUENCE SQ_Profiling;
*/

--Execute insertnya
EXEC SP_InsertTB_Profiling 'EMP04012101','Edu01';
EXEC SP_InsertTB_Profiling 'EMP04012102','Edu02';
EXEC SP_InsertTB_Profiling 'EMP04012103','Edu03';
EXEC SP_InsertTB_Profiling 'EMP04012104','Edu04';
EXEC SP_InsertTB_Profiling 'EMP04012105','Edu05';

GO

--Membuat SP Untuk Select TB_Profiling
CREATE PROC SP_SelectTB_Profiling
AS
BEGIN
	SELECT * FROM TB_Profiling
END;
GO
/*
DROP PROC SP_SelectTB_Profiling
*/

--Menampilkan TB_Profiling
EXEC SP_SelectTB_Profiling
GO
/*RESET SP
DROP PROC SP_InsertTB_Profiling;

*/

----------------------------Tabel account datanya trigger dari insert Tabel Person------------------
--DONE

--------------------------NOMOR 4: SP Buat tampilin semua data yang diminta-------------
CREATE PROC SP_RetrieveTB_M_PersonTB_Account
AS
BEGIN
	SELECT
		CONCAT('Tn/Ny ', p.FirstName , ' ',p.LastName) as 'Full Name',
		p.Phone, --Nanti gantinya
		FORMAT(p.BirthDate, 'dd-MMMM-yy') as 'BirthDate',
		CONCAT('Rp. ' , FORMAT(p.Salary, 'N')) as 'Salary'
	FROM 
		TB_M_Person p 
		LEFT JOIN TB_Account a ON p.NIK = a.NIK
	
END;

GO
EXEC SP_RetrieveTB_M_PersonTB_Account;
GO
/*
DROP PROC SP_RetrieveTB_M_PersonTB_Account;

EXEC SP_SelectTB_M_Person;
EXEC SP_SelectTB_Account;
*/

-----------------NOMOR 5: SP untuk data yang diminta--------------
CREATE PROCEDURE SP_RetrieveTB_all
AS
BEGIN
    SELECT
    TB_M_Person.nik NIK, 
	CONCAT('Tn/Ny', ' ', firstName, ' ', lastName) AS 'Full Name', 
	TB_Education.degree AS Degree, 
	TB_M_University.name AS University
FROM
    TB_M_Person
	INNER JOIN TB_Profiling ON TB_M_Person.NIK = TB_Profiling.NIK
	INNER JOIN TB_Education ON TB_Profiling.Education_Id = TB_Education.id
	INNER JOIN TB_M_University ON TB_Education.University_Id = TB_M_University.[id number]
ORDER BY 'Full Name' ASC
END;
GO

EXEC SP_RetrieveTB_all;


/*
DROP PROC SP_RetrieveTB_all
EXEC SP_SelectTB_M_University
EXEC SP_SelectTB_Education
EXEC SP_SelectTB_M_Person
EXEC SP_SelectTB_Profiling

EXEC SP_SelectTB_Account


*/