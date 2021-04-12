USE MCC48

DROP TABLE employee
CREATE TABLE employee
(
NIK int IDENTITY(1,1) primary key NOT NULL,
firstname varchar(50) ,
lastname varchar(50),
address varchar(50) NOT NULL,
phonenumber varchar(50) NOT NULL,
email varchar(50) NOT NULL,
birthplace varchar(50) NOT NULL,
birthdate Date,
);

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Alfan','Aisy','Pekalongan', '085866535091', 'alfanaisy7@gmail.com', 'Pekalongan', '1999-11-07');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Alfatehan Arsya', 'Baharin', 'Jakarta Pusat', '087835053992', 'alfatehanarsya8998@gmail.com', 'Jakarta', '1998-09-08');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Alfi','Futuhi','Tangerang Selatan','085782439757','alfi.futuhi13@gmail.com','Jakarta','1997-05-03');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Anindya Sabrina','Pangesti','Yogyakarta','087839217981','pangestianin@gmail.com','Bekasi','1997-11-17');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Daniel', 'Chandra','Bekasi','085777337338','danielchandra1.dc@gmail.com','Bekasi','1997-08-17');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthplace,birthdate)
VALUES('Gusti','Alfahmi','Jakarta Timur','087783872959','gustialfahmi@gmail.com','Jakarta','1997-04-29');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Ilham','Prasetyo','Bandung','085858525226','ilprasetyo2125@gmail.com','Bandung','1998/05/21');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Khanza','Rahmasilla','Bintaro', '08112258838', 'khanzarg17@gmail.com', 'Bandung', '1997-01-17');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('M jurnalies', 'Habibie', 'Jakarta', '081398560195', 'habibie598@gmail.com', 'Lamongan', '1996-06-18');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Muljadi', 'Muljadi', 'Bandung', '087821190267','muljadiyadi29@gmail.com', 'Bandung', '1996-03-29');

INSERT into employee (firstName,lastName,address,phoneNumber,email,birthPlace,birthDate)
VALUES('Paulus','Siahaan','Jakarta Barat','082160965663','siahaan.paulus123@gmail.com','Porsea','1998-10-17');

SELECT NIK, CONCAT(firstName,' ',lastName) as name, address, phonenumber, email, birthplace, format(birthdate,'dd MMMM yyyy') as birthdate from employee
order by convert(datetime, birthdate, 103) ASC