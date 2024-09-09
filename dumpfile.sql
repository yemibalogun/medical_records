CREATE TABLE regular_courses (
	id INTEGER NOT NULL, 
	course_no INTEGER NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO regular_courses VALUES(1,71);
INSERT INTO regular_courses VALUES(2,72);
INSERT INTO regular_courses VALUES(3,73);
INSERT INTO regular_courses VALUES(4,74);
INSERT INTO regular_courses VALUES(5,75);
INSERT INTO regular_courses VALUES(6,78);
CREATE TABLE genders (
	id INTEGER NOT NULL, 
	gender_type VARCHAR NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO genders VALUES(1,'male');
INSERT INTO genders VALUES(2,'female');
CREATE TABLE battalions (
	id INTEGER NOT NULL, 
	bn VARCHAR NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO battalions VALUES(1,'mogadishu');
INSERT INTO battalions VALUES(2,'dalet');
INSERT INTO battalions VALUES(3,'abyssinia');
INSERT INTO battalions VALUES(4,'burma');
CREATE TABLE services (
	id INTEGER NOT NULL, 
	service_type VARCHAR NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO services VALUES(1,'army');
INSERT INTO services VALUES(2,'navy');
INSERT INTO services VALUES(3,'airforce');
CREATE TABLE visits (
	id INTEGER NOT NULL, 
	cadet_id INTEGER NOT NULL, 
	check_in_time DATE NOT NULL, 
	status VARCHAR(50) NOT NULL, 
	reason VARCHAR(255), 
	doctor_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(cadet_id) REFERENCES cadets (id), 
	FOREIGN KEY(doctor_id) REFERENCES staffs (staff_id)
);
INSERT INTO visits VALUES(1,1,'2024-05-20','completed','Nam egestas euismod lorem, sit amet varius leo ultrices ut. ',1);
INSERT INTO visits VALUES(2,5,'2024-05-21','waiting','headache',1);
INSERT INTO visits VALUES(3,9,'2024-05-21','waiting','dentist appointment',1);
INSERT INTO visits VALUES(4,10,'2024-05-21','completed','gynae',1);
INSERT INTO visits VALUES(5,11,'2024-05-21','completed','orthopaedic appointment',1);
CREATE TABLE staffs (
	staff_id INTEGER NOT NULL, 
	firstname VARCHAR(255) NOT NULL, 
	middlename VARCHAR(255), 
	lastname VARCHAR(255) NOT NULL, 
	email VARCHAR(255) NOT NULL, 
	password VARCHAR(255) NOT NULL, 
	phone VARCHAR(255) NOT NULL, 
	address VARCHAR(255) NOT NULL, 
	gender_id INTEGER NOT NULL, 
	role VARCHAR(50) NOT NULL, 
	status VARCHAR(20) NOT NULL, 
	appointment VARCHAR(255) NOT NULL, 
	date_of_birth DATE NOT NULL, 
	date_tos DATE NOT NULL, 
	date_of_joining DATE NOT NULL, 
	visit_id INTEGER, 
	PRIMARY KEY (staff_id), 
	UNIQUE (email), 
	UNIQUE (phone), 
	FOREIGN KEY(gender_id) REFERENCES genders (id), 
	FOREIGN KEY(visit_id) REFERENCES visits (id)
);
INSERT INTO staffs VALUES(1,'Yemi','Rasheed','Balogun','slickact2006@gmail.com','$2b$12$PLtm6iYK6I/Lv.uNf83bG.Ws3elXGwypsCpKT1ih6Zll4zN4LBue.','08069190791','Barnawa High Cost Kaduna',1,'doctor','active','Doctor','1986-10-16','2024-05-20','2024-05-20',NULL);
INSERT INTO staffs VALUES(2,'Joan','Kash','Balogun','mssjoanne@gmail.com','$2b$12$ek9NA92.xnfWL9MZf6G6wO2ROu7FjWuKue991bP52nu6UmfYrAXuy','08137838967','Nbte Quarters Highcost',2,'doctor','active','doctor','1993-09-30','2024-05-21','2024-05-21',NULL);
CREATE TABLE faculties (
	id INTEGER NOT NULL, 
	faculty_name VARCHAR NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO faculties VALUES(1,'Arts and Social Sciences');
INSERT INTO faculties VALUES(2,'Engineering and Technology');
INSERT INTO faculties VALUES(3,'Management Sciences');
INSERT INTO faculties VALUES(4,'Military Science and Interdisciplinary Studies');
INSERT INTO faculties VALUES(5,'Sciences');
CREATE TABLE departments (
	id INTEGER NOT NULL, 
	department_name VARCHAR NOT NULL, 
	faculty_id INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(faculty_id) REFERENCES faculties (id)
);
INSERT INTO departments VALUES(1,'defence and security studies',1);
INSERT INTO departments VALUES(2,'geography',1);
INSERT INTO departments VALUES(3,'history and war studies',1);
INSERT INTO departments VALUES(4,'french',1);
INSERT INTO departments VALUES(5,'arabic',1);
INSERT INTO departments VALUES(6,'political science',1);
INSERT INTO departments VALUES(7,'psychology',1);
INSERT INTO departments VALUES(8,'civil engineering',2);
INSERT INTO departments VALUES(9,'electrical electronics engineering',2);
INSERT INTO departments VALUES(10,'mechanical engineering',2);
INSERT INTO departments VALUES(11,'mechatronics engineering',2);
INSERT INTO departments VALUES(12,'accounting',3);
INSERT INTO departments VALUES(13,'economics',3);
INSERT INTO departments VALUES(14,'logistics and supply chain management',3);
INSERT INTO departments VALUES(15,'management studies',3);
INSERT INTO departments VALUES(16,'computer science',4);
INSERT INTO departments VALUES(17,'cyber security',4);
INSERT INTO departments VALUES(18,'intelligence and security science',4);
INSERT INTO departments VALUES(19,'biology',5);
INSERT INTO departments VALUES(20,'biotechnology',5);
INSERT INTO departments VALUES(21,'chemistry',5);
INSERT INTO departments VALUES(22,'mathematical sciences',5);
INSERT INTO departments VALUES(23,'physics',5);
CREATE TABLE service_subjects (
	id INTEGER NOT NULL, 
	subject_code VARCHAR(10), 
	subject_title VARCHAR(255) NOT NULL, 
	status VARCHAR(5) NOT NULL, 
	service_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(service_id) REFERENCES services (id)
);
CREATE TABLE cadets (
	id INTEGER NOT NULL, 
	cadet_no VARCHAR NOT NULL, 
	first_name VARCHAR NOT NULL, 
	middle_name VARCHAR, 
	last_name VARCHAR NOT NULL, 
	religion VARCHAR NOT NULL, 
	state VARCHAR NOT NULL, 
	lga VARCHAR NOT NULL, 
	date_of_enlistment VARCHAR NOT NULL, 
	date_of_birth VARCHAR NOT NULL, 
	department_id INTEGER NOT NULL, 
	bn_id INTEGER NOT NULL, 
	gender_id INTEGER NOT NULL, 
	service_id INTEGER NOT NULL, 
	regular_id INTEGER NOT NULL, 
	admission_count INTEGER NOT NULL, 
	board_status VARCHAR NOT NULL, 
	admission_date DATE, 
	PRIMARY KEY (id), 
	UNIQUE (cadet_no), 
	FOREIGN KEY(department_id) REFERENCES departments (id), 
	FOREIGN KEY(bn_id) REFERENCES battalions (id), 
	FOREIGN KEY(gender_id) REFERENCES genders (id), 
	FOREIGN KEY(service_id) REFERENCES services (id), 
	FOREIGN KEY(regular_id) REFERENCES regular_courses (id)
);
INSERT INTO cadets VALUES(1,'12309F','Ian','Wallace','Julian','Islam','Abia','Nasarawa','2020-09-17','2003-01-01',1,1,2,1,1,2,'','2024-05-21');
INSERT INTO cadets VALUES(2,'12882','Dan','Alsop','Michael','Islam','Abia','Jere','2020-09-17','2003-01-01',2,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(3,'12975','Richard','Morrison','Jake','Islam','Abia','Burutu','2020-09-17','2003-01-01',3,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(4,'13092','Luke','Peters','Alexander','Islam','Abia','Moba','2021-09-17','2001-01-01',4,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(5,'13148','Nicholas','Carr','Kevin','Islam','Abia','Ihitte/Uboma','2021-09-17','2001-01-01',5,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(6,'13273','Phil','Clarkson','Joshua','Islam','Abia','Kaugama','2021-09-17','2002-01-01',6,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(7,'13356','Audrey','White','Colin','Christianity','Abia','Zaria','2019-09-17','2002-01-01',7,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(8,'12899','Trevor','White','Owen','Christianity','Abia','Jere','2019-09-17','2002-01-01',8,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(9,'13018','Harry','Martin','Eric','Christianity','Abia','Burutu','2019-09-17','2002-01-01',9,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(10,'13278','Owen','Duncan','Joe','Christianity','Abia','Moba','2019-09-17','2001-01-01',10,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(11,'13224','Colin','Henderson','Matt','Christianity','Abia','Ihitte/Uboma','2019-09-17','2001-01-01',11,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(12,'12430','Dominic','Mackenzie','Benjamin','Christianity','Abia','Kaugama','2019-09-17','2001-01-01',12,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(13,'12959','Andrew','Scott','Keith','Christianity','Abia','Ethiope West','2021-09-17','2002-01-01',13,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(14,'13119','Evan','Knox','Sebastian','Christianity','Abia','Aninri','2021-09-17','2002-01-01',14,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(15,'13261','William','Cameron','Andrew','Christianity','Abia','Isiala Mbano','2019-09-17','2000-01-01',15,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(16,'12347','Austin','Hart','Charles','Islam','Adamawa','Ado','2020-09-17','2003-01-01',16,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(17,'12884','Sebastian','Young','Eric','Islam','Adamawa','Kaga','2020-09-17','2003-01-01',17,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(18,'12980','Leonard','Rutherford','Dominic','Islam','Adamawa','Ethiope East','2020-09-17','2003-01-01',18,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(19,'13094','Owen','Kerr','Warren','Islam','Adamawa','Oye','2021-09-17','2002-01-01',19,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(20,'13149','Owen','Metcalfe','Alexander','Islam','Adamawa','Ikeduru','2021-09-17','2002-01-01',20,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(21,'13274','Jonathan','Kelly','James','Islam','Adamawa','Kazaure','2021-09-17','2002-01-01',21,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(22,'13357','Karen','Oliver','Simon','Christianity','Adamawa','Ado','2019-09-17','2002-01-01',22,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(23,'12901','Sebastian','Terry','Steven','Christianity','Adamawa','Kaga','2019-09-17','2002-01-01',23,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(24,'13019','Gordon','Rees','Piers','Christianity','Adamawa','Ethiope East','2019-09-17','2002-01-01',1,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(25,'13282','Christian','Brown','Edward','Christianity','Adamawa','Oye','2019-09-17','2001-01-01',2,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(26,'13225','Charles','Knox','Christian','Christianity','Adamawa','Ikeduru','2019-09-17','2001-01-01',3,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(27,'12477','Richard','Cornish','Alexander','Christianity','Adamawa','Kazaure','2019-09-17','2001-01-01',4,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(28,'12961','Isaac','Hart','Owen','Christianity','Adamawa','Ika North East','2021-09-17','2002-01-01',5,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(29,'13183','Alan','Grant','Stewart','Christianity','Adamawa','Awgu','2021-09-17','2002-01-01',6,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(30,'13263','Sam','Randall','Edward','Christianity','Adamawa','Isu','2019-09-17','2000-01-01',7,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(31,'12360','Alan','Quinn','Matt','Islam','Akwa Ibom','Agatu','2020-09-17','2004-01-01',8,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(32,'12885','Edward','Mills','Victor','Islam','Akwa Ibom','Kala/Balge','2020-09-17','2004-01-01',9,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(33,'12981','Adam','Lee','Luke','Islam','Akwa Ibom','Ethiope West','2020-09-17','2004-01-01',10,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(34,'13095F','Julian','Jones','Carl','Islam','Akwa Ibom','Aninri','2021-09-17','2002-01-01',11,2,2,1,4,0,'',NULL);
INSERT INTO cadets VALUES(35,'13150','Stephen','Morgan','Edward','Islam','Akwa Ibom','Isiala Mbano','2021-09-17','2003-01-01',12,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(36,'13277','Austin','Skinner','Jack','Islam','Akwa Ibom','Kiri Kasama','2021-09-17','2003-01-01',13,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(37,'13362','Bernadette','Edmunds','Trevor','Christianity','Akwa Ibom','Agatu','2019-09-17','2002-01-01',14,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(38,'12906','Peter','Hardacre','Joseph','Christianity','Akwa Ibom','Kala/Balge','2019-09-17','2003-01-01',15,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(39,'13027','Richard','Wilkins','Warren','Christianity','Akwa Ibom','Ethiope West','2019-09-17','2003-01-01',16,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(40,'13290','Harry','Lawrence','Anthony','Christianity','Akwa Ibom','Aninri','2019-09-17','2001-01-01',17,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(41,'13226','Ian','Underwood','Jack','Christianity','Akwa Ibom','Isiala Mbano','2019-09-17','2001-01-01',18,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(42,'12478','Sam','Coleman','Colin','Christianity','Akwa Ibom','Kiri Kasama','2019-09-17','2002-01-01',19,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(43,'12965','Austin','Newman','Eric','Christianity','Akwa Ibom','Ika South','2021-09-17','2003-01-01',20,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(44,'13184','Julian','Mitchell','Carl','Christianity','Akwa Ibom','Enugu East','2021-09-17','2003-01-01',21,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(45,'13264','Ian','Clarkson','Tim','Christianity','Akwa Ibom','Mbaitoli','2019-09-17','2000-01-01',22,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(46,'13073','Brian','McGrath','Harry','Islam','Anambra','Apa','2020-09-17','2004-01-01',23,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(47,'12887','Edward','Piper','Steven','Islam','Anambra','Konduga','2020-09-17','2004-01-01',1,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(48,'12985','Leonard','Anderson','Paul','Islam','Anambra','Ika North East','2020-09-17','2004-01-01',2,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(49,'13098','Matt','Russell','Leonard','Islam','Anambra','Awgu','2021-09-17','2003-01-01',3,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(50,'13151','Colin','Mitchell','Frank','Islam','Anambra','Isu','2021-09-17','2003-01-01',4,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(51,'13280','Ryan','Robertson','Oliver','Islam','Anambra','Kiyawa','2021-09-17','2003-01-01',5,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(52,'13364','Bella','Hughes','Liam','Christianity','Anambra','Apa','2019-09-17','2003-01-01',6,4,1,1,2,1,'','2024-05-21');
INSERT INTO cadets VALUES(53,'12907','Harry','Campbell','Lucas','Christianity','Anambra','Konduga','2019-09-17','2003-01-01',7,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(54,'13034','Gordon','Lyman','Adrian','Christianity','Anambra','Ika North East','2019-09-17','2003-01-01',8,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(55,'13295','Adrian','Dowd','Brian','Christianity','Anambra','Awgu','2019-09-17','2002-01-01',9,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(56,'13228','Paul','North','Sean','Christianity','Anambra','Isu','2019-09-17','2002-01-01',10,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(57,'12605','Gordon','Cameron','Liam','Christianity','Anambra','Kiyawa','2019-09-17','2002-01-01',11,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(58,'12968','David','Anderson','Peter','Christianity','Anambra','Isoko North','2021-09-17','2003-01-01',12,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(59,'13185','David','Wright','Nathan','Christianity','Anambra','Enugu North','2021-09-17','2003-01-01',13,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(60,'13267','Nathan','Dyer','Evan','Christianity','Anambra','Ngor Okpala','2019-09-17','2000-01-01',14,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(61,'12392','Eric','Langdon','Alan','Islam','Bauchi','Buruku','2020-09-17','2004-01-01',15,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(62,'12888','Luke','Reid','Michael','Islam','Bauchi','Kukawa','2020-09-17','2004-01-01',16,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(63,'12989','Ryan','Peake','Jason','Islam','Bauchi','Ika South','2020-09-17','2004-01-01',17,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(64,'13101','Colin','Wright','Cameron','Islam','Bauchi','Enugu East','2021-09-17','2004-01-01',18,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(65,'13152','Trevor','Rampling','Owen','Islam','Bauchi','Mbaitoli','2021-09-17','2004-01-01',19,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(66,'13285','John','Abraham','Harry','Islam','Bauchi','Maigatari','2021-09-17','2004-01-01',20,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(67,'13365','Amy','Coleman','Adam','Christianity','Bauchi','Buruku','2019-09-17','2003-01-01',21,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(68,'12908','Thomas','Dyer','Christopher','Christianity','Bauchi','Kukawa','2019-09-17','2003-01-01',22,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(69,'13044F','Evan','Mills','Connor','Christianity','Bauchi','Ika South','2019-09-17','2003-01-01',23,1,2,2,4,0,'',NULL);
INSERT INTO cadets VALUES(70,'13300','Richard','Thomson','Ian','Christianity','Bauchi','Enugu East','2019-09-17','2002-01-01',1,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(71,'13229','Neil','Bell','Victor','Christianity','Bauchi','Mbaitoli','2019-09-17','2002-01-01',2,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(72,'12721','Robert','Mathis','Trevor','Christianity','Bauchi','Maigatari','2021-09-17','2004-01-01',3,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(73,'12973','Sebastian','Miller','Evan','Christianity','Bauchi','Isoko South','2021-09-17','2004-01-01',4,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(74,'13186','Leonard','Grant','Sean','Christianity','Bauchi','Enugu South','2021-09-17','2004-01-01',5,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(75,'13271','Austin','Churchill','Adam','Christianity','Bauchi','Njaba','2019-09-17','2000-01-01',6,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(76,'12399','Victor','Mathis','Benjamin','Islam','Bayelsa','Gboko','2020-09-17','2000-01-01',7,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(77,'12891','Gordon','Jones','Ian','Islam','Bayelsa','Kwaya Kusar','2020-09-17','2000-01-01',8,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(78,'12992','Joe','Hill','Adrian','Islam','Bayelsa','Isoko North','2020-09-17','2000-01-01',9,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(79,'13104','Cameron','Tucker','Edward','Islam','Bayelsa','Enugu North','2021-09-17','2004-01-01',10,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(80,'13153','Matt','Campbell','Joshua','Islam','Bayelsa','Ngor Okpala','2021-09-17','2004-01-01',11,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(81,'13286','Carl','Churchill','Victor','Islam','Bayelsa','Malam Madori','2021-09-17','2004-01-01',12,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(82,'13368','Lisa','Ogden','Sebastian','Christianity','Bayelsa','Gboko','2019-09-17','2003-01-01',13,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(83,'12916','Dan','Glover','Alan','Christianity','Bayelsa','Kwaya Kusar','2019-09-17','2004-01-01',14,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(84,'13045','Leonard','Bailey','Christian','Christianity','Bayelsa','Isoko North','2019-09-17','2004-01-01',15,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(85,'13304','Warren','Butler','Kevin','Christianity','Bayelsa','Enugu North','2019-09-17','2002-01-01',16,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(86,'13230','Steven','Peters','John','Christianity','Bayelsa','Ngor Okpala','2019-09-17','2002-01-01',17,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(87,'12730','Dylan','Dyer','Frank','Christianity','Bayelsa','Malam Madori','2021-09-17','2000-01-01',18,3,1,3,2,1,'','2024-05-21');
INSERT INTO cadets VALUES(88,'12979F','Oliver','Wilson','Jack','Christianity','Bayelsa','Ndokwa East','2021-09-17','2000-01-01',19,4,2,3,3,0,'',NULL);
INSERT INTO cadets VALUES(89,'13187','Cameron','Newman','Adam','Christianity','Bayelsa','Ezeagu','2021-09-17','2000-01-01',20,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(90,'13276','Jack','King','Isaac','Christianity','Bayelsa','Nkwerre','2019-09-17','2000-01-01',21,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(91,'12400','Trevor','Young','Max','Islam','Benue','Guma','2020-09-17','2000-01-01',22,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(92,'12892','Jake','Ferguson','Dan','Islam','Benue','Mafa','2020-09-17','2000-01-01',23,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(93,'12993F','Joshua','Nash','Isaac','Islam','Benue','Isoko South','2020-09-17','2000-01-01',1,1,2,1,3,0,'',NULL);
INSERT INTO cadets VALUES(94,'13105','Kevin','Davies','Christian','Islam','Benue','Enugu South','2021-09-17','2000-01-01',2,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(95,'13154','Alan','North','Ryan','Islam','Benue','Njaba','2021-09-17','2000-01-01',3,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(96,'13287','Sebastian','Russell','Jake','Islam','Benue','Miga','2021-09-17','2000-01-01',4,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(97,'13370','Alexandra','Davidson','William','Christianity','Benue','Guma','2019-09-17','2004-01-01',5,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(98,'12922','Sebastian','Wilkins','Matt','Christianity','Benue','Mafa','2019-09-17','2004-01-01',6,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(99,'13049','Phil','May','Jonathan','Christianity','Benue','Isoko South','2019-09-17','2004-01-01',7,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(100,'12544','Piers','Clark','Owen','Christianity','Benue','Enugu South','2019-09-17','2002-01-01',8,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(101,'13231','Piers','Springer','Thomas','Christianity','Benue','Njaba','2019-09-17','2003-01-01',9,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(102,'12774','Phil','Hodges','Evan','Christianity','Benue','Miga','2021-09-17','2000-01-01',10,2,1,3,2,1,'','2024-05-21');
INSERT INTO cadets VALUES(103,'12983','Victor','Kelly','Christopher','Christianity','Benue','Ndokwa West','2021-09-17','2000-01-01',11,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(104,'13188','Harry','Hill','Joshua','Christianity','Benue','Igbo Etiti','2021-09-17','2000-01-01',12,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(105,'13279','Leonard','Anderson','Adam','Christianity','Benue','Nwangele','2020-09-17','2000-01-01',13,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(106,'12457','Joseph','Dickens','Julian','Islam','Borno','Gwer East','2020-09-17','2000-01-01',14,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(107,'12895','Lucas','Martin','Keith','Islam','Borno','Magumeri','2020-09-17','2000-01-01',15,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(108,'12994','James','Allan','Owen','Islam','Borno','Ndokwa East','2020-09-17','2001-01-01',16,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(109,'13110','Charles','Ball','Carl','Islam','Borno','Ezeagu','2021-09-17','2001-01-01',17,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(110,'13155','Neil','Terry','Neil','Islam','Borno','Nkwerre','2021-09-17','2001-01-01',18,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(111,'13289','Anthony','Wright','Sebastian','Islam','Borno','Ringim','2021-09-17','2001-01-01',19,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(112,'13372','Carol','Wright','Gordon','Christianity','Borno','Gwer East','2019-09-17','2004-01-01',20,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(113,'12927','Neil','Cornish','Dominic','Christianity','Borno','Magumeri','2019-09-17','2004-01-01',21,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(114,'13053','Adrian','Alsop','Alexander','Christianity','Borno','Ndokwa East','2019-09-17','2004-01-01',22,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(115,'13306','Owen','Bell','Adrian','Christianity','Borno','Ezeagu','2019-09-17','2003-01-01',23,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(116,'13232','Blake','Fisher','Kevin','Christianity','Borno','Nkwerre','2019-09-17','2003-01-01',1,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(117,'12778','Jacob','Graham','Lucas','Christianity','Borno','Ringim','2021-09-17','2001-01-01',2,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(118,'12986','Keith','Berry','Piers','Christianity','Borno','Okpe','2021-09-17','2001-01-01',3,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(119,'13189','Dan','Oliver','Cameron','Christianity','Borno','Igbo Eze North','2021-09-17','2001-01-01',4,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(120,'13283','Joshua','Springer','Thomas','Christianity','Borno','Obowo','2020-09-17','2001-01-01',5,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(121,'12464','Colin','Abraham','Anthony','Islam','Cross River','Gwer West','2020-09-17','2001-01-01',6,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(122,'12897','Eric','Vaughan','Julian','Islam','Cross River','Maiduguri','2020-09-17','2001-01-01',7,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(123,'12996','Justin','Dyer','Charles','Islam','Cross River','Ndokwa West','2020-09-17','2001-01-01',8,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(124,'13112','John','Sutherland','Peter','Islam','Cross River','Igbo Etiti','2021-09-17','2001-01-01',9,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(125,'13156','Tim','Robertson','Sebastian','Islam','Cross River','Nwangele','2021-09-17','2001-01-01',10,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(126,'13292','Kevin','Dowd','Jack','Islam','Cross River','Roni','2021-09-17','2001-01-01',11,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(127,'13376','Victoria','Blake','Isaac','Christianity','Cross River','Gwer West','2019-09-17','2004-01-01',12,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(128,'12936','Dan','King','Stewart','Christianity','Cross River','Maiduguri','2019-09-17','2000-01-01',13,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(129,'13058','Joseph','Lyman','Peter','Christianity','Cross River','Ndokwa West','2019-09-17','2000-01-01',14,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(130,'13309','Paul','Jackson','Christopher','Christianity','Cross River','Igbo Etiti','2019-09-17','2003-01-01',15,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(131,'13233','Joe','Wilkins','Ian','Christianity','Cross River','Nwangele','2019-09-17','2003-01-01',16,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(132,'12793','Adrian','Carr','Jacob','Christianity','Cross River','Roni','2021-09-17','2002-01-01',17,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(133,'12998','Christian','Sharp','Joshua','Christianity','Cross River','Oshimili North','2021-09-17','2002-01-01',18,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(134,'13190','Cameron','Russell','Lucas','Christianity','Cross River','Igbo Eze South','2021-09-17','2002-01-01',19,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(135,'13284','Carl','Robertson','William','Christianity','Cross River','Oguta','2020-09-17','2001-01-01',20,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(136,'12475','Adam','Randall','Christian','Islam','Delta','Katsina-Ala','2020-09-17','2001-01-01',21,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(137,'12903','Stephen','Hunter','Julian','Islam','Delta','Marte','2020-09-17','2001-01-01',22,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(138,'13005','William','Rampling','Ian','Islam','Delta','Okpe','2020-09-17','2001-01-01',23,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(139,'13115','William','Roberts','Ian','Islam','Delta','Igbo Eze North','2021-09-17','2002-01-01',1,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(140,'13158','James','King','Dan','Islam','Delta','Obowo','2021-09-17','2002-01-01',2,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(141,'13293','Jake','Edmunds','Dylan','Islam','Delta','Sule Tankarkar','2021-09-17','2002-01-01',3,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(142,'13377','Jane','Ross','John','Christianity','Delta','Katsina-Ala','2019-09-17','2000-01-01',4,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(143,'12939','Joseph','Skinner','Peter','Christianity','Delta','Marte','2019-09-17','2000-01-01',5,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(144,'13060','Oliver','Hamilton','Robert','Christianity','Delta','Okpe','2019-09-17','2000-01-01',6,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(145,'13312','Michael','Hart','Stephen','Christianity','Delta','Igbo Eze North','2019-09-17','2003-01-01',7,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(146,'13234','Gordon','Hudson','Colin','Christianity','Delta','Obowo','2019-09-17','2003-01-01',8,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(147,'12829','Trevor','Baker','Jake','Christianity','Delta','Sule Tankarkar','2021-09-17','2002-01-01',9,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(148,'13003','Neil','James','Michael','Christianity','Delta','Oshimili South','2021-09-17','2002-01-01',10,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(149,'13191','Peter','Gibson','Evan','Christianity','Delta','Isi Uzo','2021-09-17','2002-01-01',11,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(150,'13288','Richard','Sharp','Robert','Christianity','Delta','Ohaji/Egbema','2020-09-17','2002-01-01',12,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(151,'12491','Matt','Johnston','Adam','Islam','Ebonyi','Konshisha','2020-09-17','2002-01-01',13,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(152,'12909','Frank','Thomson','Sebastian','Islam','Ebonyi','Mobbar','2020-09-17','2002-01-01',14,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(153,'13013F','Brandon','Mackenzie','Matt','Islam','Ebonyi','Oshimili North','2020-09-17','2002-01-01',15,1,2,1,3,0,'',NULL);
INSERT INTO cadets VALUES(154,'13117','Sam','Short','Victor','Islam','Ebonyi','Igbo Eze South','2021-09-17','2003-01-01',16,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(155,'13159','Sean','Mathis','Simon','Islam','Ebonyi','Oguta','2021-09-17','2003-01-01',17,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(156,'13297','Lucas','Alsop','Richard','Islam','Ebonyi','Taura','2021-09-17','2003-01-01',18,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(157,'13378','Alison','Marshall','Colin','Christianity','Ebonyi','Konshisha','2019-09-17','2000-01-01',19,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(158,'12943','Trevor','Rutherford','Blake','Christianity','Ebonyi','Mobbar','2019-09-17','2000-01-01',20,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(159,'13065','Steven','Quinn','Sean','Christianity','Ebonyi','Oshimili North','2019-09-17','2000-01-01',21,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(160,'13317','Peter','Mathis','Kevin','Christianity','Ebonyi','Igbo Eze South','2019-09-17','2003-01-01',22,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(161,'13235','Dominic','MacDonald','Connor','Christianity','Ebonyi','Oguta','2019-09-17','2003-01-01',23,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(162,'12847','Julian','Lyman','Adrian','Christianity','Ebonyi','Taura','2021-09-17','2003-01-01',1,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(163,'13015','Julian','Scott','Blake','Christianity','Ebonyi','Patani','2021-09-17','2003-01-01',2,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(164,'13192','Julian','Mackenzie','Dylan','Christianity','Ebonyi','Nkanu East','2021-09-17','2003-01-01',3,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(165,'13291','Brandon','Reid','Matt','Christianity','Ebonyi','Okigwe','2020-09-17','2002-01-01',4,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(166,'12493','Luke','Powell','Joseph','Islam','Edo','Kwande','2020-09-17','2002-01-01',5,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(167,'12910','Julian','Russell','Stewart','Islam','Edo','Monguno','2020-09-17','2002-01-01',6,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(168,'13017','Oliver','Wilson','Blake','Islam','Edo','Oshimili South','2020-09-17','2002-01-01',7,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(169,'13120','Jack','Hughes','Keith','Islam','Edo','Isi Uzo','2021-09-17','2003-01-01',8,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(170,'13161','Benjamin','Hart','Piers','Islam','Edo','Ohaji/Egbema','2021-09-17','2003-01-01',9,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(171,'13298','Stephen','Welch','Ryan','Islam','Edo','Yankwashi','2021-09-17','2003-01-01',10,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(172,'13380','Caroline','Hunter','Austin','Christianity','Edo','Kwande','2019-09-17','2000-01-01',11,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(173,'13398','Boris','Pullman','Warren','Christianity','Edo','Monguno','2019-09-17','2001-01-01',12,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(174,'13067','Jack','Young','Piers','Christianity','Edo','Oshimili South','2019-09-17','2001-01-01',13,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(175,'13320','Alexander','Gray','Peter','Christianity','Edo','Isi Uzo','2019-09-17','2004-01-01',14,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(176,'13236F','Robert','Churchill','Brandon','Christianity','Edo','Ohaji/Egbema','2019-09-17','2004-01-01',15,4,2,2,1,0,'',NULL);
INSERT INTO cadets VALUES(177,'12852','Jacob','Bell','Ian','Christianity','Edo','Yankwashi','2021-09-17','2004-01-01',16,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(178,'13021','Lucas','MacDonald','Victor','Christianity','Edo','Sapele','2021-09-17','2004-01-01',17,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(179,'13193','Liam','Randall','Nathan','Christianity','Edo','Nkanu West','2021-09-17','2004-01-01',18,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(180,'13296','Neil','King','Steven','Christianity','Edo','Orlu','2020-09-17','2002-01-01',19,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(181,'12529','Sam','Carr','Gordon','Islam','Ekiti','Logo','2020-09-17','2003-01-01',20,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(182,'12912','Joe','Mitchell','James','Islam','Ekiti','Ngala','2020-09-17','2003-01-01',21,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(183,'13020','Brandon','Gray','Owen','Islam','Ekiti','Patani','2020-09-17','2003-01-01',22,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(184,'13122','Adrian','Anderson','Andrew','Islam','Ekiti','Nkanu East','2021-09-17','2004-01-01',23,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(185,'13162','Christian','Thomson','Liam','Islam','Ekiti','Okigwe','2021-09-17','2004-01-01',1,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(186,'13301','Alan','Wilkins','Austin','Islam','Ekiti','Kaduna State','2021-09-17','2004-01-01',2,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(187,'13383','Rose','Short','Jack','Christianity','Ekiti','Logo','2019-09-17','2001-01-01',3,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(188,'12945F','Brian','Jackson','Gavin','Christianity','Ekiti','Ngala','2019-09-17','2001-01-01',4,4,2,2,3,0,'',NULL);
INSERT INTO cadets VALUES(189,'13072','Simon','Randall','Cameron','Christianity','Ekiti','Patani','2019-09-17','2004-01-01',5,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(190,'13325','Richard','Slater','Jacob','Christianity','Ekiti','Nkanu East','2019-09-17','2004-01-01',6,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(191,'13238','Boris','Ball','Richard','Christianity','Ekiti','Okigwe','2019-09-17','2004-01-01',7,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(192,'12857F','Eric','Paterson','Trevor','Christianity','Ekiti','Kaduna State','2021-09-17','2004-01-01',8,4,2,3,2,0,'',NULL);
INSERT INTO cadets VALUES(193,'13023','James','Anderson','John','Christianity','Ekiti','Udu','2021-09-17','2004-01-01',9,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(194,'13195F','Keith','Fraser','Paul','Christianity','Ekiti','Nsukka','2021-09-17','2004-01-01',10,2,2,3,4,0,'',NULL);
INSERT INTO cadets VALUES(195,'13299','Joseph','Berry','Matt','Christianity','Ekiti','Orsu','2020-09-17','2003-01-01',11,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(196,'12535','Nathan','Grant','Adam','Islam','Enugu','Makurdi','2020-09-17','2003-01-01',12,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(197,'12914','Adrian','Sutherland','Gordon','Islam','Enugu','Nganzai','2020-09-17','2003-01-01',13,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(198,'13025F','Dylan','Bower','Simon','Islam','Enugu','Sapele','2020-09-17','2003-01-01',14,2,2,1,3,0,'',NULL);
INSERT INTO cadets VALUES(199,'13123','Jason','Scott','Jake','Islam','Enugu','Nkanu West','2021-09-17','2000-01-01',15,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(200,'13164','Warren','Hughes','Dylan','Islam','Enugu','Orlu','2021-09-17','2000-01-01',16,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(201,'13303','Christopher','Cornish','Jacob','Islam','Enugu','Birnin Gwari','2021-09-17','2000-01-01',17,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(202,'13384','Emma','King','Robert','Christianity','Enugu','Makurdi','2019-09-17','2001-01-01',18,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(203,'12951','Paul','Hudson','Nathan','Christianity','Enugu','Nganzai','2019-09-17','2001-01-01',19,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(204,'13075','Carl','Graham','Boris','Christianity','Enugu','Sapele','2019-09-17','2004-01-01',20,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(205,'13328','Isaac','May','Joshua','Christianity','Enugu','Nkanu West','2019-09-17','2004-01-01',21,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(206,'13239','Max','Glover','Tim','Christianity','Enugu','Orlu','2019-09-17','2004-01-01',22,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(207,'12862','Edward','Wilkins','Owen','Christianity','Enugu','Birnin Gwari','2021-09-17','2000-01-01',23,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(208,'13029F','Alexander','King','David','Christianity','Enugu','Ughelli North','2021-09-17','2000-01-01',1,4,2,3,3,0,'',NULL);
INSERT INTO cadets VALUES(209,'13196','Owen','Blake','Robert','Christianity','Enugu','Oji River','2021-09-17','2000-01-01',2,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(210,'13302','Colin','Oliver','David','Christianity','Enugu','Oru East','2021-09-17','2000-01-01',3,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(211,'12557','Neil','Wilson','David','Islam','Gombe','Obi','2020-09-17','2003-01-01',4,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(212,'12918','David','Graham','Anthony','Islam','Gombe','Shani','2020-09-17','2003-01-01',5,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(213,'13026','Dominic','Cameron','Nicholas','Islam','Gombe','Udu','2020-09-17','2004-01-01',6,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(214,'13124','John','Black','Cameron','Islam','Gombe','Nsukka','2021-09-17','2000-01-01',7,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(215,'13165','Paul','Hemmings','David','Islam','Gombe','Orsu','2021-09-17','2000-01-01',8,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(216,'13305','James','Grant','James','Islam','Gombe','Chikun','2021-09-17','2001-01-01',9,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(217,'13388','Amelia','Ross','Peter','Christianity','Gombe','Obi','2019-09-17','2001-01-01',10,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(218,'12956','Oliver','Berry','Anthony','Christianity','Gombe','Shani','2019-09-17','2001-01-01',11,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(219,'13079','Sebastian','Simpson','Joseph','Christianity','Gombe','Udu','2019-09-17','2005/01/01',12,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(220,'13336','Eric','Robertson','Justin','Christianity','Gombe','Nsukka','2019-09-17','2000-01-01',13,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(221,'13240','Jake','Buckland','Justin','Christianity','Gombe','Orsu','2019-09-17','2000-01-01',14,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(222,'12865','Richard','MacDonald','Ian','Christianity','Gombe','Chikun','2021-09-17','2001-01-01',15,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(223,'13030','Warren','Clarkson','Paul','Christianity','Gombe','Ughelli South','2021-09-17','2001-01-01',16,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(224,'13197','Austin','Taylor','Phil','Christianity','Gombe','Udenu','2021-09-17','2001-01-01',17,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(225,'13307','Warren','Ferguson','Oliver','Christianity','Gombe','Oru West','2021-09-17','2001-01-01',18,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(226,'12562','Michael','Tucker','Jason','Islam','Imo','Ogbadibo','2020-09-17','2004-01-01',19,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(227,'12921','Keith','Carr','Jack','Islam','Imo','Abi','2020-09-17','2004-01-01',20,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(228,'13028','Owen','Allan','Sam','Islam','Imo','Ughelli North','2020-09-17','2004-01-01',21,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(229,'13127F','Adam','Poole','Nicholas','Islam','Imo','Oji River','2021-09-17','2001-01-01',22,1,2,1,4,0,'',NULL);
INSERT INTO cadets VALUES(230,'13166','Stephen','Gill','Phil','Islam','Imo','Oru East','2021-09-17','2001-01-01',23,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(231,'13308','Brandon','Vaughan','Dominic','Islam','Imo','Giwa','2021-09-17','2001-01-01',1,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(232,'13391','Caroline','Kerr','Dan','Christianity','Imo','Ogbadibo','2019-09-17','2001-01-01',2,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(233,'12957','Alexander','Clarkson','Dylan','Christianity','Imo','Abi','2019-09-17','2002-01-01',3,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(234,'13081','John','White','Phil','Christianity','Imo','Ughelli North','2019-09-17','2000-01-01',4,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(235,'13339F','Carl','Hodges','William','Christianity','Imo','Oji River','2019-09-17','2000-01-01',5,3,2,2,5,0,'',NULL);
INSERT INTO cadets VALUES(236,'13241','Dylan','Bell','John','Christianity','Imo','Oru East','2019-09-17','2000-01-01',6,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(237,'12872','Jason','Underwood','Joe','Christianity','Imo','Giwa','2021-09-17','2001-01-01',7,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(238,'13035','Adrian','Dickens','Piers','Christianity','Imo','Ukwuani','2021-09-17','2002-01-01',8,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(239,'13199','Joseph','Piper','Edward','Christianity','Imo','Udi','2021-09-17','2002-01-01',9,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(240,'13310','Stewart','McDonald','Piers','Christianity','Imo','Owerri Municipal','2021-09-17','2002-01-01',10,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(241,'12564','Oliver','Springer','John','Islam','Jigawa','Ohimini','2020-09-17','2004-01-01',11,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(242,'12926','Luke','Roberts','Jack','Islam','Jigawa','Akamkpa','2020-09-17','2004-01-01',12,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(243,'13031','John','Lambert','Paul','Islam','Jigawa','Ughelli South','2020-09-17','2004-01-01',13,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(244,'13128','Oliver','Wallace','Dominic','Islam','Jigawa','Udenu','2021-09-17','2002-01-01',14,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(245,'13168','Austin','Campbell','Anthony','Islam','Jigawa','Oru West','2021-09-17','2002-01-01',15,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(246,'13311','Brian','Henderson','Brian','Islam','Jigawa','Igabi','2021-09-17','2002-01-01',16,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(247,'13393','Jessica','White','Richard','Christianity','Jigawa','Ohimini','2019-09-17','2002-01-01',17,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(248,'12963','Thomas','Lewis','John','Christianity','Jigawa','Akamkpa','2019-09-17','2002-01-01',18,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(249,'13089','Stewart','Baker','Eric','Christianity','Jigawa','Ughelli South','2019-09-17','2000-01-01',19,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(250,'13343','Steven','Berry','Liam','Christianity','Jigawa','Udenu','2019-09-17','2000-01-01',20,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(251,'13242','Ian','McDonald','Joe','Christianity','Jigawa','Oru West','2019-09-17','2000-01-01',21,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(252,'12874','Peter','Grant','Steven','Christianity','Jigawa','Igabi','2021-09-17','2002-01-01',22,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(253,'13039','Trevor','Randall','Jason','Christianity','Jigawa','Uvwie','2022-09-17','2002-01-01',23,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(254,'13200','Jake','Parr','Joe','Christianity','Jigawa','Uzo-Uwani','2022-09-17','2002-01-01',1,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(255,'13314F','Thomas','Forsyth','Harry','Christianity','Jigawa','Owerri North','2022-09-17','2003-01-01',2,3,2,3,5,0,'',NULL);
INSERT INTO cadets VALUES(256,'12566','Victor','Alsop','John','Islam','Kaduna','Oju','2020-09-17','2004-01-01',3,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(257,'12928','Edward','Slater','Oliver','Islam','Kaduna','Akpabuyo','2020-09-17','2004-01-01',4,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(258,'13036','Warren','Anderson','Alan','Islam','Kaduna','Ukwuani','2020-09-17','2000-01-01',5,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(259,'13129','Richard','Ross','Christopher','Islam','Kaduna','Udi','2022-09-17','2003-01-01',6,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(260,'13169','Joseph','Hudson','Steven','Islam','Kaduna','Owerri Municipal','2022-09-17','2003-01-01',7,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(261,'13313','Adrian','Mills','Edward','Islam','Kaduna','Ikara','2022-09-17','2003-01-01',8,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(262,'13401','Alison','Mathis','Thomas','Christianity','Kaduna','Oju','2019-09-17','2002-01-01',9,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(263,'12964F','Owen','Lambert','James','Christianity','Kaduna','Akpabuyo','2019-09-17','2002-01-01',10,3,2,2,3,0,'',NULL);
INSERT INTO cadets VALUES(264,'13402','Julian','Underwood','Sam','Christianity','Kaduna','Ukwuani','2019-09-17','2000-01-01',11,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(265,'13346','Leonard','King','Justin','Christianity','Kaduna','Udi','2019-09-17','2001-01-01',12,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(266,'13243','Michael','Murray','David','Christianity','Kaduna','Owerri Municipal','2019-09-17','2001-01-01',13,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(267,'12877','Christian','Edmunds','Leonard','Christianity','Kaduna','Ikara','2022-09-17','2003-01-01',14,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(268,'13047','Luke','Hemmings','Jonathan','Christianity','Kaduna','Warri North','2022-09-17','2003-01-01',15,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(269,'13201','Michael','Peake','Nicholas','Christianity','Kaduna','Akko','2022-09-17','2003-01-01',16,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(270,'13316','Benjamin','White','Owen','Christianity','Kaduna','Owerri West','2022-09-17','2003-01-01',17,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(271,'12569','Owen','Grant','Austin','Islam','Kano','Okpokwu','2020-09-17','2000-01-01',18,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(272,'12931','Austin','Greene','Richard','Islam','Kano','Bakassi','2020-09-17','2000-01-01',19,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(273,'13037','Julian','Campbell','Lucas','Islam','Kano','Uvwie','2020-09-17','2000-01-01',20,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(274,'13130F','Edward','Springer','Lucas','Islam','Kano','Uzo-Uwani','2022-09-17','2003-01-01',21,2,2,1,4,0,'',NULL);
INSERT INTO cadets VALUES(275,'13170','Carl','Poole','Julian','Islam','Kano','Owerri North','2022-09-17','2004-01-01',22,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(276,'13315','Piers','Hughes','Brian','Islam','Kano','Jaba','2022-09-17','2004-01-01',23,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(277,'13407','Andrea','Campbell','Boris','Christianity','Kano','Okpokwu','2019-09-17','2002-01-01',1,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(278,'12970','Colin','Walker','Jacob','Christianity','Kano','Bakassi','2019-09-17','2002-01-01',2,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(279,'13404F','Boris','Lewis','Sebastian','Christianity','Kano','Uvwie','2019-09-17','2001-01-01',3,3,2,2,4,0,'',NULL);
INSERT INTO cadets VALUES(280,'13351','Jacob','Avery','Trevor','Christianity','Kano','Uzo-Uwani','2019-09-17','2001-01-01',4,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(281,'13244F','Gordon','Manning','Nicholas','Christianity','Kano','Owerri North','2019-09-17','2001-01-01',5,1,2,2,1,0,'',NULL);
INSERT INTO cadets VALUES(282,'12883','Christian','Hemmings','Tim','Christianity','Kano','Jaba','2022-09-17','2004-01-01',6,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(283,'13052','Richard','Berry','Alexander','Christianity','Kano','Warri South','2022-09-17','2004-01-01',7,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(284,'13202','Evan','Cornish','Dylan','Christianity','Kano','Balanga','2020-09-17','2000-01-01',8,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(285,'13321','Thomas','Payne','Jason','Christianity','Kano','Onuimo','2022-09-17','2004-01-01',9,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(286,'12573','John','Gill','David','Islam','Katsina','Oturkpo','2020-09-17','2000-01-01',10,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(287,'12933','Jack','MacLeod','Dan','Islam','Katsina','Bekwarra','2020-09-17','2000-01-01',11,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(288,'13038','Julian','Tucker','Christopher','Islam','Katsina','Warri North','2020-09-17','2000-01-01',12,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(289,'13131','Richard','Graham','Evan','Islam','Katsina','Akko','2022-09-17','2004-01-01',13,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(290,'13171','Dominic','Sharp','Alexander','Islam','Katsina','Owerri West','2022-09-17','2004-01-01',14,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(291,'13318','Austin','Russell','Thomas','Islam','Katsina','Jema''a','2022-09-17','2004-01-01',15,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(292,'13408','Sonia','Poole','Richard','Christianity','Katsina','Oturkpo','2019-09-17','2002-01-01',16,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(293,'12972','Peter','Terry','Anthony','Christianity','Katsina','Bekwarra','2019-09-17','2002-01-01',17,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(294,'13406','Max','Watson','Adam','Christianity','Katsina','Warri North','2019-09-17','2001-01-01',18,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(295,'13353','Stephen','Scott','Dylan','Christianity','Katsina','Akko','2019-09-17','2001-01-01',19,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(296,'13245','Adam','Greene','Christopher','Christianity','Katsina','Owerri West','2019-09-17','2001-01-01',20,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(297,'12886','Dan','Kerr','Keith','Christianity','Katsina','Jema''a','2022-09-17','2004-01-01',21,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(298,'13054','Christopher','Payne','Julian','Christianity','Katsina','Warri South West','2022-09-17','2000-01-01',22,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(299,'13203','Boris','Young','Lucas','Christianity','Katsina','Billiri','2020-09-17','2000-01-01',23,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(300,'13323','Isaac','Graham','Jason','Christianity','Katsina','Auyo','2022-09-17','2000-01-01',1,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(301,'12610','Owen','Baker','Eric','Islam','Kebbi','Tarka','2020-09-17','2001-01-01',2,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(302,'12935','Benjamin','Smith','Max','Islam','Kebbi','Biase','2020-09-17','2001-01-01',3,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(303,'13041','Thomas','Bower','Piers','Islam','Kebbi','Warri South','2020-09-17','2001-01-01',4,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(304,'13132','Frank','McLean','Andrew','Islam','Kebbi','Balanga','2022-09-17','2000-01-01',5,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(305,'13172','Edward','Kerr','Max','Islam','Kebbi','Onuimo','2022-09-17','2000-01-01',6,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(306,'13319','Amanda','Nash','Andrew','Christianity','Kebbi','Kachia','2019-09-17','2003-01-01',7,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(307,'12682','Carolyn','Wallace','Simon','Christianity','Kebbi','Tarka','2019-09-17','2003-01-01',8,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(308,'12977','Jason','Edmunds','Dan','Christianity','Kebbi','Biase','2019-09-17','2003-01-01',9,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(309,'13097','Connor','Parr','Boris','Christianity','Kebbi','Warri South','2019-09-17','2001-01-01',10,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(310,'13358','Christopher','Cornish','Sebastian','Christianity','Kebbi','Balanga','2019-09-17','2002-01-01',11,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(311,'13392','Phil','Lewis','Jason','Christianity','Kebbi','Onuimo','2019-09-17','2002-01-01',12,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(312,'12890','Michael','Hunter','Isaac','Christianity','Kebbi','Kachia','2022-09-17','2000-01-01',13,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(313,'13056','Brandon','Parsons','Carl','Christianity','Kebbi','Ado Ekiti','2022-09-17','2000-01-01',14,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(314,'13204','Victor','Buckland','Dan','Christianity','Kebbi','Dukku','2020-09-17','2001-01-01',15,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(315,'13324','Evan','Dickens','Blake','Christianity','Kebbi','Babura','2022-09-17','2000-01-01',16,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(316,'12656','Phil','Robertson','Justin','Islam','Kogi','Ukum','2020-09-17','2001-01-01',17,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(317,'12937','Oliver','Sharp','Phil','Islam','Kogi','Boki','2020-09-17','2001-01-01',18,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(318,'13042','Luke','Coleman','Adam','Islam','Kogi','Warri South West','2020-09-17','2001-01-01',19,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(319,'13133','Luke','White','Justin','Islam','Kogi','Billiri','2022-09-17','2000-01-01',20,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(320,'13174','Dylan','Skinner','Justin','Islam','Kogi','Auyo','2022-09-17','2000-01-01',21,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(321,'13322','Vanessa','Dowd','Brian','Christianity','Kogi','Kaduna North','2019-09-17','2003-01-01',22,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(322,'12697','Ella','Abraham','Sean','Christianity','Kogi','Ukum','2019-09-17','2003-01-01',23,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(323,'12966','Jake','Walker','Eric','Christianity','Kogi','Boki','2019-09-17','2003-01-01',1,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(324,'13100','Brian','Vaughan','Gordon','Christianity','Kogi','Warri South West','2019-09-17','2002-01-01',2,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(325,'13360','Julian','Bond','Charles','Christianity','Kogi','Billiri','2019-09-17','2002-01-01',3,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(326,'13394','Lucas','Lee','Peter','Christianity','Kogi','Auyo','2019-09-17','2002-01-01',4,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(327,'12893','Eric','Johnston','Brandon','Christianity','Kogi','Kaduna North','2022-09-17','2001-01-01',5,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(328,'13061','Boris','Jackson','Richard','Christianity','Kogi','Efon','2022-09-17','2001-01-01',6,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(329,'13205','Gordon','Arnold','Blake','Christianity','Kogi','Funakaye','2020-09-17','2001-01-01',7,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(330,'13327','Julian','May','Joshua','Christianity','Kogi','Biriniwa','2022-09-17','2001-01-01',8,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(331,'12658','Adrian','Butler','Neil','Islam','Kwara','Ushongo','2020-09-17','2001-01-01',9,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(332,'12940','Owen','Lee','Jason','Islam','Kwara','Calabar Municipal','2020-09-17','2002-01-01',10,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(333,'13043','Alexander','Hamilton','Liam','Islam','Kwara','Ado Ekiti','2020-09-17','2002-01-01',11,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(334,'13134','Boris','Pullman','Stewart','Islam','Kwara','Dukku','2022-09-17','2001-01-01',12,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(335,'13175','Charles','Lyman','Colin','Islam','Kwara','Babura','2022-09-17','2001-01-01',13,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(336,'13326','Abigail','Sharp','Colin','Christianity','Kwara','Kaduna South','2019-09-17','2003-01-01',14,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(337,'12495','Madeleine','Thomson','Julian','Christianity','Kwara','Ushongo','2019-09-17','2003-01-01',15,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(338,'12982','Eric','Wallace','Connor','Christianity','Kwara','Calabar Municipal','2019-09-17','2003-01-01',16,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(339,'13103','Joseph','Gibson','Joseph','Christianity','Kwara','Ado Ekiti','2019-09-17','2002-01-01',17,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(340,'13366','Julian','Allan','Simon','Christianity','Kwara','Dukku','2019-09-17','2002-01-01',18,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(341,'13395','Alexander','McLean','Brandon','Christianity','Kwara','Babura','2019-09-17','2002-01-01',19,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(342,'12898','Robert','Lyman','Edward','Christianity','Kwara','Kaduna South','2022-09-17','2001-01-01',20,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(343,'13064','Oliver','Brown','Lucas','Christianity','Kwara','Ekiti East','2022-09-17','2001-01-01',21,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(344,'13206','Jason','Manning','Justin','Christianity','Kwara','Gombe','2020-09-17','2002-01-01',22,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(345,'13331','Brandon','Edmunds','Peter','Christianity','Kwara','Birnin Kudu','2022-09-17','2001-01-01',23,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(346,'12695','Charles','Oliver','William','Islam','Lagos','Vandeikya','2020-09-17','2002-01-01',1,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(347,'12942','Jason','Murray','Boris','Islam','Lagos','Calabar South','2020-09-17','2002-01-01',2,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(348,'13048','Gordon','Randall','Evan','Islam','Lagos','Efon','2020-09-17','2002-01-01',3,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(349,'13135','Gordon','Berry','Joe','Islam','Lagos','Funakaye','2022-09-17','2001-01-01',4,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(350,'13176','Matt','Hart','Dylan','Islam','Lagos','Biriniwa','2022-09-17','2002-01-01',5,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(351,'13329','Tracey','Wilkins','Neil','Christianity','Lagos','Kagarko','2019-09-17','2004-01-01',6,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(352,'12845','Amy','Burgess','Warren','Christianity','Lagos','Vandeikya','2019-09-17','2004-01-01',7,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(353,'12988','Andrew','Ross','Andrew','Christianity','Lagos','Calabar South','2019-09-17','2004-01-01',8,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(354,'13107','Warren','Berry','Isaac','Christianity','Lagos','Efon','2019-09-17','2002-01-01',9,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(355,'13367','Austin','Stewart','Michael','Christianity','Lagos','Funakaye','2019-09-17','2003-01-01',10,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(356,'13396','Anthony','Howard','Andrew','Christianity','Lagos','Biriniwa','2019-09-17','2003-01-01',11,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(357,'12900','Justin','Sutherland','Brandon','Christianity','Lagos','Kagarko','2022-09-17','2002-01-01',12,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(358,'13068','Nicholas','Grant','Sebastian','Christianity','Lagos','Ekiti South-West','2022-09-17','2002-01-01',13,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(359,'13207','Warren','McDonald','Eric','Christianity','Lagos','Kaltungo','2020-09-17','2002-01-01',14,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(360,'13335','Evan','Rees','Stephen','Christianity','Lagos','Buji','2022-09-17','2002-01-01',15,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(361,'12696','Leonard','Watson','Julian','Islam','Nasarawa','Abadam','2020-09-17','2002-01-01',16,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(362,'12947','Julian','Buckland','Anthony','Islam','Nasarawa','Etung','2020-09-17','2002-01-01',17,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(363,'13050','Justin','Allan','Stephen','Islam','Nasarawa','Ekiti East','2020-09-17','2003-01-01',18,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(364,'13136','Tim','Peake','William','Islam','Nasarawa','Gombe','2022-09-17','2002-01-01',19,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(365,'13177','Gordon','Cameron','Joseph','Islam','Nasarawa','Birnin Kudu','2022-09-17','2002-01-01',20,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(366,'13330','Karen','Gray','Brandon','Christianity','Nasarawa','Kajuru','2019-09-17','2004-01-01',21,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(367,'12677','Wanda','McLean','Tim','Christianity','Nasarawa','Abadam','2019-09-17','2004-01-01',22,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(368,'12734','Peter','Sharp','William','Christianity','Nasarawa','Etung','2019-09-17','2004-01-01',23,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(369,'13111','John','Hardacre','Blake','Christianity','Nasarawa','Ekiti East','2019-09-17','2003-01-01',1,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(370,'13374','Joshua','Bond','Jake','Christianity','Nasarawa','Gombe','2019-09-17','2003-01-01',2,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(371,'13246','Stewart','Butler','Nathan','Christianity','Nasarawa','Birnin Kudu','2019-09-17','2003-01-01',3,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(372,'12905F','Andrew','Butler','Luke','Christianity','Nasarawa','Kajuru','2022-09-17','2002-01-01',4,4,2,3,2,0,'',NULL);
INSERT INTO cadets VALUES(373,'13071','Keith','Robertson','David','Christianity','Nasarawa','Ekiti West','2022-09-17','2002-01-01',5,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(374,'13208','James','Hardacre','Connor','Christianity','Nasarawa','Kwami','2020-09-17','2003-01-01',6,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(375,'13338','Charles','Vaughan','Nicholas','Christianity','Nasarawa','Dutse','2022-09-17','2002-01-01',7,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(376,'12735','Jason','Watson','Keith','Islam','Niger','Askira/Uba','2020-09-17','2003-01-01',8,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(377,'12949','Dan','Greene','Oliver','Islam','Niger','Ikom','2020-09-17','2003-01-01',9,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(378,'13051','Dylan','Piper','Adam','Islam','Niger','Ekiti South-West','2020-09-17','2003-01-01',10,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(379,'13137','Justin','Paige','Sebastian','Islam','Niger','Kaltungo','2022-09-17','2003-01-01',11,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(380,'13178','Trevor','Piper','Gavin','Islam','Niger','Buji','2022-09-17','2003-01-01',12,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(381,'13332','Olivia','Ross','Nathan','Christianity','Niger','Kaura','2019-09-17','2004-01-01',13,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(382,'12433','Emily','Fraser','Charles','Christianity','Niger','Askira/Uba','2019-09-17','2004-01-01',14,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(383,'12745','Keith','Ince','Dylan','Christianity','Niger','Ikom','2019-09-17','2004-01-01',15,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(384,'13116','Nathan','Carr','Edward','Christianity','Niger','Ekiti South-West','2019-09-17','2003-01-01',16,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(385,'13379','Sam','Langdon','Harry','Christianity','Niger','Kaltungo','2019-09-17','2003-01-01',17,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(386,'13247','Keith','Hemmings','Jonathan','Christianity','Niger','Buji','2019-09-17','2003-01-01',18,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(387,'12911','Luke','Bailey','Sean','Christianity','Niger','Kaura','2022-09-17','2003-01-01',19,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(388,'13077','Michael','James','Brandon','Christianity','Niger','Emure','2022-09-17','2003-01-01',20,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(389,'13209','Evan','Pullman','Isaac','Christianity','Niger','Nafada','2020-09-17','2003-01-01',21,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(390,'13340','Steven','Langdon','Jake','Christianity','Niger','Gagarawa','2022-09-17','2003-01-01',22,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(391,'12781','Sam','Springer','Jacob','Islam','Ogun','Bama','2020-09-17','2003-01-01',23,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(392,'12952','Oliver','Lambert','Adam','Islam','Ogun','Obanliku','2020-09-17','2003-01-01',1,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(393,'13055','Adrian','Bond','Lucas','Islam','Ogun','Ekiti West','2020-09-17','2003-01-01',2,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(394,'13138','Frank','Hunter','Richard','Islam','Ogun','Kwami','2022-09-17','2003-01-01',3,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(395,'13179','Stephen','Burgess','Carl','Islam','Ogun','Dutse','2022-09-17','2003-01-01',4,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(396,'13333','Bella','Hart','Anthony','Christianity','Ogun','Kauru','2019-09-17','2000-01-01',5,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(397,'12859','Nathan','Oliver','Joe','Christianity','Ogun','Bama','2019-09-17','2000-01-01',6,1,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(398,'12991','Carl','Manning','Dan','Christianity','Ogun','Obanliku','2019-09-17','2000-01-01',7,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(399,'13093','Austin','Peters','William','Christianity','Ogun','Ekiti West','2019-09-17','2003-01-01',8,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(400,'13385','Alan','Jackson','Piers','Christianity','Ogun','Kwami','2019-09-17','2004-01-01',9,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(401,'13248','Tim','Miller','Eric','Christianity','Ogun','Dutse','2019-09-17','2004-01-01',10,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(402,'12917','Neil','Kerr','Paul','Christianity','Ogun','Kauru','2022-09-17','2003-01-01',11,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(403,'13080','Evan','Forsyth','Colin','Christianity','Ogun','Gbonyin','2022-09-17','2003-01-01',12,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(404,'13210','William','Underwood','Dominic','Christianity','Ogun','Shongom','2020-09-17','2004-01-01',13,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(405,'13344','Joseph','Hudson','Kevin','Christianity','Ogun','Garki','2022-09-17','2004-01-01',14,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(406,'12799','Joseph','Nash','Jacob','Islam','Ondo','Bayo','2020-09-17','2004-01-01',15,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(407,'12954','Gavin','Jackson','Alan','Islam','Ondo','Obubra','2020-09-17','2004-01-01',16,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(408,'13057','Brian','James','Matt','Islam','Ondo','Emure','2020-09-17','2004-01-01',17,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(409,'13139','Jason','Graham','Anthony','Islam','Ondo','Nafada','2022-09-17','2004-01-01',18,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(410,'13180','Austin','Watson','Brandon','Islam','Ondo','Gagarawa','2022-09-17','2004-01-01',19,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(411,'13337','Diana','Welch','Colin','Christianity','Ondo','Kubau','2019-09-17','2000-01-01',20,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(412,'12861','Dan','Alsop','Simon','Christianity','Ondo','Bayo','2019-09-17','2000-01-01',21,4,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(413,'12995','Max','Rutherford','Alexander','Christianity','Ondo','Obubra','2019-09-17','2000-01-01',22,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(414,'13118','Jacob','Hardacre','Ian','Christianity','Ondo','Emure','2019-09-17','2004-01-01',23,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(415,'13386','Christian','Springer','Blake','Christianity','Ondo','Nafada','2019-09-17','2004-01-01',1,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(416,'13249','Liam','Henderson','Joseph','Christianity','Ondo','Gagarawa','2019-09-17','2004-01-01',2,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(417,'12919','Owen','Morrison','Stephen','Christianity','Ondo','Kubau','2022-09-17','2004-01-01',3,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(418,'13084','Joe','Smith','Sebastian','Christianity','Ondo','Ido Osi','2022-09-17','2004-01-01',4,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(419,'13211','Matt','James','Max','Christianity','Ondo','Yamaltu/Deba','2020-09-17','2004-01-01',5,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(420,'13347','Eric','Mills','Phil','Christianity','Ondo','Gumel','2022-09-17','2004-01-01',6,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(421,'12858','Frank','Quinn','Christopher','Islam','Osun','Biu','2020-09-17','2004-01-01',7,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(422,'12955','Jason','Duncan','Adrian','Islam','Osun','Obudu','2020-09-17','2004-01-01',8,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(423,'13059','Robert','Taylor','Adrian','Islam','Osun','Gbonyin','2022-09-17','2004-01-01',9,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(424,'13140','Jack','Mathis','Brandon','Islam','Osun','Shongom','2022-09-17','2004-01-01',10,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(425,'13181','Brandon','Kelly','Frank','Islam','Osun','Garki','2022-09-17','2004-01-01',11,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(426,'13341','Amy','Welch','William','Christianity','Osun','Kudan','2019-09-17','2000-01-01',12,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(427,'12866','Jonathan','McLean','Owen','Christianity','Osun','Biu','2019-09-17','2000-01-01',13,3,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(428,'13001','Evan','McGrath','Alexander','Christianity','Osun','Obudu','2019-09-17','2000-01-01',14,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(429,'12507','Richard','Springer','Simon','Christianity','Osun','Gbonyin','2019-09-17','2004-01-01',15,1,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(430,'13387','Tim','Walker','Dan','Christianity','Osun','Shongom','2019-09-17','2004-01-01',16,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(431,'13251','Colin','Mackenzie','Frank','Christianity','Osun','Garki','2019-09-17','2004-01-01',17,3,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(432,'12924','Blake','Vaughan','Benjamin','Christianity','Osun','Kudan','2022-09-17','2000-01-01',18,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(433,'13087','Stewart','Oliver','Keith','Christianity','Osun','Ijero','2022-09-17','2000-01-01',19,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(434,'13212F','Oliver','Davies','Piers','Christianity','Osun','Aboh Mbaise','2020-09-17','2004-01-01',20,2,2,3,4,0,'',NULL);
INSERT INTO cadets VALUES(435,'13349','Alexander','Bell','Gordon','Christianity','Osun','Guri','2022-09-17','2000-01-01',21,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(436,'12860','Harry','Wallace','Sebastian','Islam','Oyo','Chibok','2020-09-17','2004-01-01',22,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(437,'12958','Dan','Henderson','Carl','Islam','Oyo','Odukpani','2020-09-17','2000-01-01',23,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(438,'13062','Stewart','Sanderson','Robert','Islam','Oyo','Ido Osi','2022-09-17','2000-01-01',1,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(439,'13141','Luke','Payne','Max','Islam','Oyo','Yamaltu/Deba','2022-09-17','2000-01-01',2,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(440,'13182','Cameron','Walsh','Keith','Islam','Oyo','Gumel','2022-09-17','2000-01-01',3,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(441,'13342','Julia','Black','Kevin','Christianity','Oyo','Lere','2019-09-17','2001-01-01',4,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(442,'12869','Thomas','Duncan','Liam','Christianity','Oyo','Chibok','2019-09-17','2001-01-01',5,2,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(443,'13004F','William','Poole','Kevin','Christianity','Oyo','Odukpani','2019-09-17','2001-01-01',6,3,2,2,3,0,'',NULL);
INSERT INTO cadets VALUES(444,'12480','Liam','Vaughan','Warren','Christianity','Oyo','Ido Osi','2019-09-17','2004-01-01',7,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(445,'13389F','Steven','Underwood','Tim','Christianity','Oyo','Yamaltu/Deba','2019-09-17','2000-01-01',8,1,2,2,5,0,'',NULL);
INSERT INTO cadets VALUES(446,'13253','Stephen','Mills','Joseph','Christianity','Oyo','Gumel','2019-09-17','2000-01-01',9,2,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(447,'12929','Adrian','Wilson','Stephen','Christianity','Oyo','Lere','2022-09-17','2000-01-01',10,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(448,'13090','Carl','Thomson','Matt','Christianity','Oyo','Ikere','2022-09-17','2000-01-01',11,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(449,'13213','Dan','Rampling','Sebastian','Christianity','Oyo','Ahiazu Mbaise','2020-09-17','2000-01-01',12,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(450,'13363','Christian','Manning','Christian','Christianity','Oyo','Gwaram','2022-09-17','2000-01-01',13,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(451,'12864','Austin','Bailey','Brandon','Islam','Plateau','Damboa','2020-09-17','2000-01-01',14,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(452,'12960','Luke','Mathis','Peter','Islam','Plateau','Ogoja','2020-09-17','2000-01-01',15,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(453,'13066','Dan','Bailey','Phil','Islam','Plateau','Ijero','2022-09-17','2001-01-01',16,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(454,'13142','Joe','Clark','Phil','Islam','Plateau','Aboh Mbaise','2022-09-17','2001-01-01',17,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(455,'13258','William','Dickens','Alexander','Islam','Plateau','Guri','2022-09-17','2001-01-01',18,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(456,'13345','Megan','Lewis','Michael','Christianity','Plateau','Makarfi','2019-09-17','2001-01-01',19,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(457,'12870','Eric','Watson','Blake','Christianity','Plateau','Damboa','2019-09-17','2001-01-01',20,1,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(458,'13007','Sam','MacLeod','Julian','Christianity','Plateau','Ogoja','2019-09-17','2001-01-01',21,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(459,'12456','Stewart','Murray','Austin','Christianity','Plateau','Ijero','2019-09-17','2000-01-01',22,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(460,'13219','Owen','King','Anthony','Christianity','Plateau','Aboh Mbaise','2019-09-17','2000-01-01',23,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(461,'13255','Jason','Walker','Evan','Christianity','Plateau','Guri','2019-09-17','2000-01-01',1,1,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(462,'12930','Evan','Coleman','Trevor','Christianity','Plateau','Makarfi','2022-09-17','2001-01-01',2,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(463,'13096','Jason','Ince','Harry','Christianity','Plateau','Ikole','2022-09-17','2001-01-01',3,3,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(464,'13214','Dan','Pullman','Liam','Christianity','Plateau','Ehime Mbano','2020-09-17','2000-01-01',4,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(465,'13369','Ian','Marshall','Jason','Christianity','Plateau','Gwiwa','2022-09-17','2001-01-01',5,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(466,'12867','John','Allan','Keith','Islam','Rivers','Dikwa','2020-09-17','2000-01-01',6,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(467,'12962','Harry','Morrison','Piers','Islam','Rivers','Yakurr','2020-09-17','2000-01-01',7,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(468,'13074F','Adrian','Allan','Jacob','Islam','Rivers','Ikere','2022-09-17','2001-01-01',8,4,2,1,3,0,'',NULL);
INSERT INTO cadets VALUES(469,'13143','Kevin','Wilkins','Evan','Islam','Rivers','Ahiazu Mbaise','2022-09-17','2001-01-01',9,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(470,'13259','Stephen','Black','Michael','Islam','Rivers','Gwaram','2022-09-17','2001-01-01',10,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(471,'13348','Megan','Bailey','Frank','Christianity','Rivers','Sabon Gari','2019-09-17','2001-01-01',11,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(472,'12873','Ian','Carr','Steven','Christianity','Rivers','Dikwa','2019-09-17','2001-01-01',12,4,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(473,'13008','Paul','Howard','Carl','Christianity','Rivers','Yakurr','2019-09-17','2001-01-01',13,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(474,'13260','Harry','Paige','Eric','Christianity','Rivers','Ikere','2019-09-17','2000-01-01',14,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(475,'12345','Peter','Russell','Peter','Christianity','Rivers','Ahiazu Mbaise','2019-09-17','2000-01-01',15,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(476,'13256','Harry','MacLeod','John','Christianity','Rivers','Gwaram','2019-09-17','2000-01-01',16,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(477,'12938','Colin','Paige','Alan','Christianity','Rivers','Sabon Gari','2022-09-17','2002-01-01',17,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(478,'13099','Jack','Ellison','Alan','Christianity','Rivers','Ilejemeje','2022-09-17','2002-01-01',18,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(479,'13215','Blake','Avery','Warren','Christianity','Rivers','Ezinihitte','2020-09-17','2000-01-01',19,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(480,'13371','Stewart','Kelly','William','Christianity','Rivers','Hadejia','2022-09-17','2002-01-01',20,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(481,'12871','Ryan','Walsh','Christian','Islam','Sokoto','Gubio','2020-09-17','2000-01-01',21,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(482,'12967','Max','Pullman','Simon','Islam','Sokoto','Yala','2020-09-17','2001-01-01',22,2,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(483,'13078','Victor','Russell','Liam','Islam','Sokoto','Ikole','2022-09-17','2002-01-01',23,3,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(484,'13144','Warren','Dickens','Joseph','Islam','Sokoto','Ehime Mbano','2022-09-17','2002-01-01',1,4,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(485,'13262','David','Wallace','Stephen','Islam','Sokoto','Gwiwa','2022-09-17','2002-01-01',2,1,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(486,'13350','Irene','Davidson','Benjamin','Christianity','Sokoto','Sanga','2019-09-17','2002-01-01',3,2,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(487,'12876','Michael','Black','Trevor','Christianity','Sokoto','Gubio','2019-09-17','2002-01-01',4,3,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(488,'13010','Richard','King','Piers','Christianity','Sokoto','Yala','2019-09-17','2002-01-01',5,4,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(489,'13266F','Jonathan','McDonald','Kevin','Christianity','Sokoto','Ikole','2019-09-17','2000-01-01',6,1,2,2,4,0,'',NULL);
INSERT INTO cadets VALUES(490,'13221','Christian','Nash','Max','Christianity','Sokoto','Ehime Mbano','2019-09-17','2001-01-01',7,2,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(491,'12352','Dan','Walsh','Connor','Christianity','Sokoto','Gwiwa','2019-09-17','2001-01-01',8,3,1,3,1,0,'',NULL);
INSERT INTO cadets VALUES(492,'12941','Owen','Abraham','Jason','Christianity','Sokoto','Sanga','2022-09-17','2002-01-01',9,4,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(493,'13106','Isaac','Bond','Oliver','Christianity','Sokoto','Irepodun/Ifelodun','2022-09-17','2002-01-01',10,1,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(494,'13216','Owen','Ferguson','Warren','Christianity','Sokoto','Ideato North','2019-09-17','2000-01-01',11,2,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(495,'13375','Anthony','Ince','Trevor','Christianity','Sokoto','Jahun','2022-09-17','2002-01-01',12,3,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(496,'12875','David','North','Christian','Islam','Taraba','Guzamala','2020-09-17','2001-01-01',13,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(497,'12969','Benjamin','Young','Dominic','Islam','Taraba','Aniocha North','2020-09-17','2001-01-01',14,1,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(498,'13082','Thomas','Carr','Evan','Islam','Taraba','Ilejemeje','2022-09-17','2003-01-01',15,2,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(499,'13145','Simon','Taylor','Adam','Islam','Taraba','Ezinihitte','2022-09-17','2003-01-01',16,3,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(500,'13265','Adam','Arnold','Connor','Islam','Taraba','Hadejia','2022-09-17','2003-01-01',17,4,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(501,'13352','Rose','Johnston','Trevor','Christianity','Taraba','Soba','2019-09-17','2002-01-01',18,1,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(502,'12880F','Joe','Cameron','Isaac','Christianity','Taraba','Guzamala','2019-09-17','2002-01-01',19,2,2,2,2,0,'',NULL);
INSERT INTO cadets VALUES(503,'13011','Evan','Martin','Phil','Christianity','Taraba','Aniocha North','2019-09-17','2002-01-01',20,3,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(504,'13268','Anthony','Sutherland','Steven','Christianity','Taraba','Ilejemeje','2019-09-17','2001-01-01',21,4,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(505,'13222','John','Peake','Tim','Christianity','Taraba','Ezinihitte','2019-09-17','2001-01-01',22,1,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(506,'12370','Piers','Wright','Evan','Christianity','Taraba','Hadejia','2019-09-17','2001-01-01',23,2,1,3,1,0,'',NULL);
INSERT INTO cadets VALUES(507,'12948','Liam','Anderson','Jack','Christianity','Taraba','Soba','2022-09-17','2003-01-01',1,3,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(508,'13108','Neil','Paige','Gavin','Christianity','Taraba','Ise/Orun','2022-09-17','2003-01-01',2,4,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(509,'13217','Justin','Reid','Alan','Christianity','Taraba','Ideato South','2019-09-17','2000-01-01',3,1,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(510,'13381','Michael','Short','Adrian','Christianity','Taraba','Kafin Hausa','2022-09-17','2003-01-01',4,2,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(511,'12878','Oliver','Slater','Richard','Islam','Yobe','Gwoza','2020-09-17','2001-01-01',5,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(512,'12971','Matt','Davidson','Colin','Islam','Yobe','Aniocha South','2020-09-17','2001-01-01',6,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(513,'13083','Liam','Hodges','Trevor','Islam','Yobe','Irepodun/Ifelodun','2022-09-17','2003-01-01',7,1,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(514,'13146','Liam','Marshall','Joe','Islam','Yobe','Ideato North','2022-09-17','2003-01-01',8,2,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(515,'13269','Dominic','Wilson','Thomas','Islam','Yobe','Jahun','2023-09-17','2003-01-01',9,3,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(516,'13354','Anne','Fisher','Benjamin','Christianity','Yobe','Zangon Kataf','2019-09-17','2002-01-01',10,4,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(517,'12889','Peter','Wilson','Peter','Christianity','Yobe','Gwoza','2019-09-17','2002-01-01',11,1,1,2,2,0,'',NULL);
INSERT INTO cadets VALUES(518,'13070','Max','Newman','Blake','Christianity','Yobe','Aniocha South','2019-09-17','2002-01-01',12,2,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(519,'13272','Victor','Simpson','James','Christianity','Yobe','Irepodun/Ifelodun','2019-09-17','2001-01-01',13,3,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(520,'13223','Jake','Hodges','Simon','Christianity','Yobe','Ideato North','2019-09-17','2001-01-01',14,4,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(521,'12384','John','Mackay','Lucas','Christianity','Yobe','Jahun','2019-09-17','2001-01-01',15,1,1,3,1,0,'',NULL);
INSERT INTO cadets VALUES(522,'12950','Cameron','Pullman','Victor','Christianity','Yobe','Zangon Kataf','2023-09-17','2004-01-01',16,2,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(523,'13113F','Sebastian','Russell','Eric','Christianity','Yobe','Moba','2023-09-17','2004-01-01',17,3,2,3,3,0,'',NULL);
INSERT INTO cadets VALUES(524,'13218','Simon','Fraser','Luke','Christianity','Yobe','Ihitte/Uboma','2019-09-17','2000-01-01',18,4,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(525,'13382','Sebastian','MacDonald','Brian','Christianity','Yobe','Kaugama','2023-09-17','2004-01-01',19,1,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(526,'13403F','Abigail','Alexanda','Simon','Christianity','Yobe','Kiri Kasama','2023-09-17','2004-01-01',20,2,2,3,1,0,'',NULL);
INSERT INTO cadets VALUES(527,'12881','Piers','Johnston','Benjamin','Islam','Zamfara','Hawul','2020-09-17','2001-01-01',21,3,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(528,'12974','Alexander','Edmunds','Alexander','Islam','Zamfara','Bomadi','2021-09-17','2001-01-01',22,4,1,1,3,0,'',NULL);
INSERT INTO cadets VALUES(529,'13088','Sam','Johnston','David','Islam','Zamfara','Ise/Orun','2023-09-17','2004-01-01',23,1,1,1,4,0,'',NULL);
INSERT INTO cadets VALUES(530,'13147','Harry','Ince','Dylan','Islam','Zamfara','Ideato South','2023-09-17','2004-01-01',1,2,1,1,5,0,'',NULL);
INSERT INTO cadets VALUES(531,'13270','Anthony','Sutherland','Julian','Islam','Zamfara','Kafin Hausa','2023-09-17','2004-01-01',2,3,1,1,1,0,'',NULL);
INSERT INTO cadets VALUES(532,'13355','Faith','Abraham','Julian','Christianity','Zamfara','Zaria','2019-09-17','2003-01-01',3,4,1,1,2,0,'',NULL);
INSERT INTO cadets VALUES(533,'12894','David','Quinn','Edward','Christianity','Zamfara','Hawul','2019-09-17','2003-01-01',4,1,1,2,3,0,'',NULL);
INSERT INTO cadets VALUES(534,'13014','James','Wallace','Benjamin','Christianity','Zamfara','Bomadi','2020-09-17','2003-01-01',5,2,1,2,4,0,'',NULL);
INSERT INTO cadets VALUES(535,'13275','Paul','Welch','Warren','Christianity','Zamfara','Ise/Orun','2019-09-17','2001-01-01',6,3,1,2,5,0,'',NULL);
INSERT INTO cadets VALUES(536,'12346','Simon','Rutherford','Ryan','Christianity','Zamfara','Ideato South','2019-09-17','2002-01-01',7,4,1,2,1,0,'',NULL);
INSERT INTO cadets VALUES(537,'12394','Cameron','Reid','Jonathan','Christianity','Zamfara','Kafin Hausa','2019-09-17','2002-01-01',8,1,1,3,2,0,'',NULL);
INSERT INTO cadets VALUES(538,'12953','Alexander','Dickens','Peter','Christianity','Zamfara','Zaria','2023-09-17','2004-01-01',9,2,1,3,3,0,'',NULL);
INSERT INTO cadets VALUES(539,'13114','Steven','Sharp','Frank','Christianity','Zamfara','Oye','2023-09-17','2004-01-01',10,3,1,3,4,0,'',NULL);
INSERT INTO cadets VALUES(540,'13257','Evan','Welch','Christian','Christianity','Zamfara','Ikeduru','2019-09-17','2001-01-01',11,4,1,3,5,0,'',NULL);
INSERT INTO cadets VALUES(541,'13397','Cameron','Kelly','Dylan','Christianity','Zamfara','Kazaure','2024-01-27','2010-11-27',12,1,1,3,1,0,'',NULL);
CREATE TABLE medicals (
	id INTEGER NOT NULL, 
	date_reported_sick DATE NOT NULL, 
	history VARCHAR NOT NULL, 
	examination VARCHAR NOT NULL, 
	diagnosis VARCHAR NOT NULL, 
	"plan" VARCHAR NOT NULL, 
	prescription VARCHAR NOT NULL, 
	excuse_duty VARCHAR NOT NULL, 
	excuse_duty_days INTEGER, 
	admission_count INTEGER NOT NULL, 
	cadet_id INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(cadet_id) REFERENCES cadets (id)
);
INSERT INTO medicals VALUES(1,'2024-05-20','rutrum odio pretium. Phasellus pulvinar ex lacus','non euismod ligula vestibulum vitae. ','In hac habitasse platea dictumst. Mauris lobortis facilisis tellus a condimentum. Praesent euismod blandit lacinia. Maecenas massa orci, luctus eget lectus id, faucibus luctus massa. Nullam a tortor tristique, euismod ligula efficitur, mattis lacus. Etiam pellentesque condimentum cursus. Vivamus porttitor justo in ligula aliquet maximus. Morbi nec mi fermentum, ultrices est quis, accumsan tellus. ','Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.','Nam egestas euismod lorem, sit amet varius leo ultrices ut. ','confinement',43,1,1);
INSERT INTO medicals VALUES(2,'2024-05-21','fever, headache, stomach ache','bP 90/130','Possible malaria','run tests','paracetamol','nil',0,2,1);
CREATE TABLE courses (
	id INTEGER NOT NULL, 
	course_code VARCHAR(10), 
	course_title VARCHAR(255) NOT NULL, 
	units INTEGER NOT NULL, 
	status VARCHAR(8) NOT NULL, 
	department_id INTEGER NOT NULL, 
	cadet_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(department_id) REFERENCES departments (id), 
	FOREIGN KEY(cadet_id) REFERENCES cadets (id)
);
INSERT INTO courses VALUES(1,'dss111','fundamentals of defence studies',2,'core',1,NULL);
INSERT INTO courses VALUES(2,'dss113','introduction to war studies',2,'core',1,NULL);
INSERT INTO courses VALUES(3,'his111','introduction to history',2,'elective',1,NULL);
INSERT INTO courses VALUES(4,'pds110','introduction to political science',2,'elective',1,NULL);
INSERT INTO courses VALUES(5,'pds117','elements of defence administration',2,'elective',1,NULL);
INSERT INTO courses VALUES(6,'pds135','introduction to peace studies',2,'elective',1,NULL);
INSERT INTO courses VALUES(7,'psy111','introduction to military psychology',2,'elective',1,NULL);
INSERT INTO courses VALUES(8,'gst111','french/arabic for beginners I',2,'core',1,NULL);
INSERT INTO courses VALUES(9,'gst112','use of english I',2,'core',1,NULL);
INSERT INTO courses VALUES(10,'dss120','introduction to security studies',2,'core',1,NULL);
INSERT INTO courses VALUES(11,'dss121','introduction to international relations',2,'core',1,NULL);
INSERT INTO courses VALUES(12,'dss122','introduction to comparative politics',2,'core',1,NULL);
INSERT INTO courses VALUES(13,'dss123','introduction to peace studies and conflict resolution',2,'core',1,NULL);
INSERT INTO courses VALUES(14,'dss124','elements of military leadership',2,'core',1,NULL);
INSERT INTO courses VALUES(15,'pds124','introduction to regional integration',2,'elective',1,NULL);
INSERT INTO courses VALUES(16,'gst121','french for beginners II',2,'required',1,NULL);
INSERT INTO courses VALUES(17,'gst123','use of library, study skills and ICT',2,'required',1,NULL);
INSERT INTO courses VALUES(18,'dss211','theories of security studies',2,'core',1,NULL);
INSERT INTO courses VALUES(19,'dss212','theories of peace and conflict studies',2,'core',1,NULL);
INSERT INTO courses VALUES(20,'dss213','theoris of war',2,'core',1,NULL);
INSERT INTO courses VALUES(21,'dss214','nigerian national security',2,'core',1,NULL);
INSERT INTO courses VALUES(22,'dss215','defence economics',2,'core',1,NULL);
INSERT INTO courses VALUES(23,'dss216','science, technology and defence',2,'core',1,NULL);
INSERT INTO courses VALUES(24,'dss217','defence administration',2,'core',1,NULL);
INSERT INTO courses VALUES(25,'gst212','environment and sustainable development',2,'core',1,NULL);
INSERT INTO courses VALUES(26,'gst213','sociology of nigerian people and culture I',2,'core',1,NULL);
INSERT INTO courses VALUES(27,'gst214','history and philosophy of science',2,'core',1,NULL);
INSERT INTO courses VALUES(28,'dss221','theories of military leadership',2,'core',1,NULL);
INSERT INTO courses VALUES(29,'dss222','ict and defence',2,'core',1,NULL);
INSERT INTO courses VALUES(30,'dss223','human security',2,'core',1,NULL);
INSERT INTO courses VALUES(31,'dss225','nigerian defence foreign policy',2,'core',1,NULL);
INSERT INTO courses VALUES(32,'pds223','nigerian government and politics',2,'elective',1,NULL);
INSERT INTO courses VALUES(33,'geo221','military mapping',2,'elective',1,NULL);
INSERT INTO courses VALUES(34,'gst221','french/arabic for beginners',2,'core',1,NULL);
INSERT INTO courses VALUES(35,'gst222','peace studies and conflict resolution',2,'core',1,NULL);
INSERT INTO courses VALUES(36,'dss311','research methodology',2,'core',1,NULL);
INSERT INTO courses VALUES(37,'dss312','confilit, security and development',2,'core',1,NULL);
INSERT INTO courses VALUES(38,'dss313','military operations and tactics',2,'core',1,NULL);
INSERT INTO courses VALUES(39,'dss314','terrorism and political violence',2,'core',1,NULL);
INSERT INTO courses VALUES(40,'dss315','military aid to civil authority',2,'elective',1,NULL);
INSERT INTO courses VALUES(41,'dss316','law of armed conflict',2,'elective',1,NULL);
INSERT INTO courses VALUES(42,'gst311','entrepreneurship studies',2,'core',1,NULL);
INSERT INTO courses VALUES(43,'gst312','general psychology',2,'core',1,NULL);
INSERT INTO courses VALUES(44,'gst313','economic and management sciences I',2,'core',1,NULL);
INSERT INTO courses VALUES(45,'gst314','history of political thought II',2,'core',1,NULL);
INSERT INTO courses VALUES(46,'gst315','history and philosopy of science',2,'core',1,NULL);
INSERT INTO courses VALUES(47,'dss320','campaign planning and operational estimates',2,'core',1,NULL);
INSERT INTO courses VALUES(48,'dss321','ethics of military operations',2,'core',1,NULL);
INSERT INTO courses VALUES(49,'dss322','military operations other than war',2,'core',1,NULL);
INSERT INTO courses VALUES(50,'dss323','military alliances and security regiment',2,'core',1,NULL);
INSERT INTO courses VALUES(51,'dss324','perspectives in military doctrine',2,'core',1,NULL);
INSERT INTO courses VALUES(52,'dss325','international law and diplomacy',2,'elective',1,NULL);
INSERT INTO courses VALUES(53,'dss326','defence diplomacy',2,'core',1,NULL);
INSERT INTO courses VALUES(54,'gst321','french for beginners VI',2,'core',1,NULL);
INSERT INTO courses VALUES(55,'gst322','military psychology',2,'core',1,NULL);
INSERT INTO courses VALUES(56,'gst323','economic and management sciences II',2,'core',1,NULL);
INSERT INTO courses VALUES(57,'gst325','use of english',2,'core',1,NULL);
INSERT INTO courses VALUES(58,'dss410','comparative derence policy',2,'core',1,NULL);
INSERT INTO courses VALUES(59,'dss411','civil military relations',2,'core',1,NULL);
INSERT INTO courses VALUES(60,'dss412','arms control and disarmament',2,'core',1,NULL);
INSERT INTO courses VALUES(61,'dss413','joint and combined military operations',2,'core',1,NULL);
INSERT INTO courses VALUES(62,'dss414','counter-terrorism and counter-insurgency operations',2,'core',1,NULL);
INSERT INTO courses VALUES(63,'dss415','inter-agency collaboration',2,'core',1,NULL);
INSERT INTO courses VALUES(64,'dss416','defence transformation',2,'elective',1,NULL);
INSERT INTO courses VALUES(65,'dss417','military industrial complex',2,'elective',1,NULL);
INSERT INTO courses VALUES(66,'dss420','strategic communication',2,'core',1,NULL);
INSERT INTO courses VALUES(67,'dss421','military logistics and supply chain',2,'core',1,NULL);
INSERT INTO courses VALUES(68,'dss422','security sector reforms',2,'core',1,NULL);
INSERT INTO courses VALUES(69,'dss423','defence order of battle',2,'core',1,NULL);
INSERT INTO courses VALUES(70,'dss434','international peacekeeping',1,'core',1,NULL);
INSERT INTO courses VALUES(71,'dss425','military intelligence',2,'elective',1,NULL);
INSERT INTO courses VALUES(72,'dss426','cybersecurity',2,'elective',1,NULL);
INSERT INTO courses VALUES(73,'dss499','final year project',6,'core',1,NULL);
INSERT INTO courses VALUES(74,'geo111','introduction to elements of physical geography I',2,'core',2,NULL);
INSERT INTO courses VALUES(75,'geo112','introduction to elements of human geography I',2,'core',2,NULL);
INSERT INTO courses VALUES(76,'geo113','elementary surveying',2,'core',2,NULL);
INSERT INTO courses VALUES(77,'geo114','introduction to practical geography',2,'core',2,NULL);
INSERT INTO courses VALUES(78,'geo115','map analysis',2,'core',2,NULL);
INSERT INTO courses VALUES(79,'ecn111','principles of economics I',3,'elective',2,NULL);
INSERT INTO courses VALUES(80,'ecn113','introduction to maths for economics/social sciences I',2,'elective',2,NULL);
INSERT INTO courses VALUES(81,'geo121','introduction to elements of physical geography II',2,'core',2,NULL);
INSERT INTO courses VALUES(82,'geo122','introduction to elements of human geography II',2,'CORE',2,NULL);
INSERT INTO courses VALUES(83,'geo123','local field studies',3,'core',2,NULL);
INSERT INTO courses VALUES(84,'geo124','introduction to environmental sciences',2,'core',2,NULL);
INSERT INTO courses VALUES(85,'geo125','map analysis',2,'core',2,NULL);
INSERT INTO courses VALUES(86,'ecn121','principles of economics II',2,'required',2,NULL);
INSERT INTO courses VALUES(87,'ecn123','introduction to maths or economics/social sciences II',2,'required',2,NULL);
INSERT INTO courses VALUES(88,'geo211','spatial organization of society',2,'core',2,NULL);
INSERT INTO courses VALUES(89,'geo212','introductory geomorphology',2,'core',2,NULL);
INSERT INTO courses VALUES(90,'geo213','elementary statistics for geographers I',2,'core',2,NULL);
INSERT INTO courses VALUES(91,'geo214','introductory cartography',2,'core',2,NULL);
INSERT INTO courses VALUES(92,'geo215','introduction to geographic information system',2,'core',2,NULL);
INSERT INTO courses VALUES(93,'geo216','geographic thought theory I',2,'core',2,NULL);
INSERT INTO courses VALUES(94,'geo217','air photo interpretation',2,'core',2,NULL);
INSERT INTO courses VALUES(95,'ecn214','structure of nigerian economy I',2,'required',2,NULL);
INSERT INTO courses VALUES(96,'geo222','introductory geomorphology and soil geography II',2,'core',2,NULL);
INSERT INTO courses VALUES(97,'geo223','elementary statistics for geographers II',2,'core',2,NULL);
INSERT INTO courses VALUES(98,'geo224','introduction to biogeography and climatology',2,'core',2,NULL);
INSERT INTO courses VALUES(99,'geo225','local field studies',3,'core',2,NULL);
INSERT INTO courses VALUES(100,'geo226','geography thought theory',2,'core',2,NULL);
INSERT INTO courses VALUES(101,'gst224','leadership and critical thinking skills',2,'required',2,NULL);
INSERT INTO courses VALUES(102,'gst225','africa in world politics',2,'required',2,NULL);
INSERT INTO courses VALUES(103,'ecn224','structure of the nigerian economy II',2,'elective',2,NULL);
INSERT INTO courses VALUES(104,'geo311','research methods',2,'core',2,NULL);
INSERT INTO courses VALUES(105,'geo312','advanced quantitative techniques I',2,'core',2,NULL);
INSERT INTO courses VALUES(106,'geo313','geomorphology',2,'core',2,NULL);
INSERT INTO courses VALUES(107,'geo314','economic geography',2,'core',2,NULL);
INSERT INTO courses VALUES(108,'geo315','population geography',2,'core',2,NULL);
INSERT INTO courses VALUES(109,'geo316','biogeography',2,'core',2,NULL);
INSERT INTO courses VALUES(110,'geo317','advance map interpretation and analysis',2,'core',2,NULL);
INSERT INTO courses VALUES(111,'geo331','settlement geography',2,'elective',2,NULL);
INSERT INTO courses VALUES(112,'geo332','transport geography',2,'elective',2,NULL);
INSERT INTO courses VALUES(113,'geo333','soil geography',2,'elective',2,NULL);
INSERT INTO courses VALUES(114,'geo334','vegetation studies',2,'elective',2,NULL);
INSERT INTO courses VALUES(115,'geo321','field course',3,'core',2,NULL);
INSERT INTO courses VALUES(116,'geo322','advanced quantitative techniques II',2,'core',2,NULL);
INSERT INTO courses VALUES(117,'geo323','regional geography of africa',2,'core',2,NULL);
INSERT INTO courses VALUES(118,'geo324','advanced cartography',2,'core',2,NULL);
INSERT INTO courses VALUES(119,'geo325','population geography II',2,'core',2,NULL);
INSERT INTO courses VALUES(120,'geo326','photogrammetry',2,'core',2,NULL);
INSERT INTO courses VALUES(121,'geo327','hydrology',2,'core',2,NULL);
INSERT INTO courses VALUES(122,'geo343','ecosystems',2,'elective',2,NULL);
INSERT INTO courses VALUES(123,'geo344','land evaluation',2,'elective',2,NULL);
INSERT INTO courses VALUES(124,'geo345','oceanography',2,'elective',2,NULL);
INSERT INTO courses VALUES(125,'geo411','systematic geography of nigeria',2,'core',2,NULL);
INSERT INTO courses VALUES(126,'geo412','contemporary philosophy and methodology in geography I',2,'core',2,NULL);
INSERT INTO courses VALUES(127,'geo413','geographic information system',2,'core',2,NULL);
INSERT INTO courses VALUES(128,'geo414','military geography',2,'core',2,NULL);
INSERT INTO courses VALUES(129,'geo415','remote sensing',2,'core',2,NULL);
INSERT INTO courses VALUES(130,'geo416','applied climatology',2,'core',2,NULL);
INSERT INTO courses VALUES(131,'geo417','the developed world',2,'core',2,NULL);
INSERT INTO courses VALUES(132,'geo418','arid land',2,'core',2,NULL);
INSERT INTO courses VALUES(133,'geo431','political geography',2,'elective',2,NULL);
INSERT INTO courses VALUES(134,'geo432','medical geography',2,'elective',2,NULL);
INSERT INTO courses VALUES(135,'geo433','humid regions',2,'elective',2,NULL);
INSERT INTO courses VALUES(136,'geo434','logistical geography',2,'elective',2,NULL);
INSERT INTO courses VALUES(137,'geo421','navigational techniques',2,'core',2,NULL);
INSERT INTO courses VALUES(138,'geo422','contemporary philosophy and methodology in geography II',2,'core',2,NULL);
INSERT INTO courses VALUES(139,'geo423','military terrain evaluation',2,'core',2,NULL);
INSERT INTO courses VALUES(140,'geo424','regional development and planning',2,'core',2,NULL);
INSERT INTO courses VALUES(141,'geo425','the developed world',2,'core',2,NULL);
INSERT INTO courses VALUES(142,'geo499','original research project',6,'core',2,NULL);
INSERT INTO courses VALUES(143,'hws111','introduction to history',2,'core',3,NULL);
INSERT INTO courses VALUES(144,'hws112','introduction to economic history',3,'core',3,NULL);
INSERT INTO courses VALUES(145,'hws113','nigeria before 1800 AD',3,'core',3,NULL);
INSERT INTO courses VALUES(146,'hws114','history of africa from 1500 - 1800 AD',3,'core',3,NULL);
INSERT INTO courses VALUES(147,'hws115','islamic revolutions in west africa',3,'core',3,NULL);
INSERT INTO courses VALUES(148,'hws117','europe to the age of revolution',3,'core',3,NULL);
INSERT INTO courses VALUES(149,'hws121','war and society in africa to 1900',2,'core',3,NULL);
INSERT INTO courses VALUES(150,'hws122','history of west africa 1500 - 1800 AD',3,'core',3,NULL);
INSERT INTO courses VALUES(151,'hws123','north africa from first conquest of egypt to 1500',3,'core',3,NULL);
INSERT INTO courses VALUES(152,'hws124','archaelogy of the nok, benin and oyo areas',3,'core',3,NULL);
INSERT INTO courses VALUES(153,'hws125','evolution of the theory and art of war',2,'core',3,NULL);
INSERT INTO courses VALUES(154,'hws126','blacks in diaspora',3,'core',3,NULL);
INSERT INTO courses VALUES(155,'hws211','nigeria 1800-1900',3,'core',3,NULL);
INSERT INTO courses VALUES(156,'hws212','economic history of nigeria in the 19th century',3,'core',3,NULL);
INSERT INTO courses VALUES(157,'hws213','africa and european imperialism',3,'core',3,NULL);
INSERT INTO courses VALUES(158,'hws214','history of southern africa from circa 1400-present',3,'core',3,NULL);
INSERT INTO courses VALUES(159,'hws216','history of the nigerian army',2,'core',3,NULL);
INSERT INTO courses VALUES(160,'hws217','europe from french revolution to the 2nd world war',3,'core',3,NULL);
INSERT INTO courses VALUES(161,'pds218','introduction to comparative politics I',2,'elective',3,NULL);
INSERT INTO courses VALUES(162,'hws221','history of latin america and caribbean since 1500 AD',3,'core',3,NULL);
INSERT INTO courses VALUES(163,'hws222','history of east and central africa since 1800 AD',3,'core',3,NULL);
INSERT INTO courses VALUES(164,'hws223','history of the USA since 1877',3,'core',3,NULL);
INSERT INTO courses VALUES(165,'hws224','history of the nigerian armed forces',2,'core',3,NULL);
INSERT INTO courses VALUES(166,'hws225','history of russia 19th century',3,'core',3,NULL);
INSERT INTO courses VALUES(167,'hws227','economic history of west africa in the 19th and 20th centuries',3,'core',3,NULL);
INSERT INTO courses VALUES(168,'pds228','introduction to comparative politics II',2,'elective',3,NULL);
INSERT INTO courses VALUES(169,'hws311','nigeria, 1900-1970',3,'core',3,NULL);
INSERT INTO courses VALUES(170,'hws312','research methodology I',3,'core',3,NULL);
INSERT INTO courses VALUES(171,'hws313','africa and the outside world since 1900',3,'core',3,NULL);
INSERT INTO courses VALUES(172,'hws314','history of the commonwealth',3,'core',3,NULL);
INSERT INTO courses VALUES(173,'hws315','war and peace in the 20th century',3,'core',3,NULL);
INSERT INTO courses VALUES(174,'hws317','problems and issues in africa historiography',3,'core',3,NULL);
INSERT INTO courses VALUES(175,'hws318','economic history of USA in the 19th century',3,'core',3,NULL);
INSERT INTO courses VALUES(176,'hws319','ussr from 1950-1950',3,'core',3,NULL);
INSERT INTO courses VALUES(177,'hws321','nigeria during the inter-war periods',3,'core',3,NULL);
INSERT INTO courses VALUES(178,'hws322','comparative industrial growth of usa, ussr, japan and china',3,'core',3,NULL);
INSERT INTO courses VALUES(179,'hws323','problems and prospects of regional economic development in west africa',3,'core',3,NULL);
INSERT INTO courses VALUES(180,'hws324','air power since 1914',2,'core',3,NULL);
INSERT INTO courses VALUES(181,'hws325','the nigerian civil war',2,'core',3,NULL);
INSERT INTO courses VALUES(182,'hws326','the military in colonial africa',2,'core',3,NULL);
INSERT INTO courses VALUES(183,'hws327','emerging issues in military history',2,'core',3,NULL);
INSERT INTO courses VALUES(184,'hws329','research method II',3,'core',3,NULL);
INSERT INTO courses VALUES(185,'hws411','nigeria 1970-present',3,'core',3,NULL);
INSERT INTO courses VALUES(186,'hws412','theory and art of war from 1945-present',2,'core',3,NULL);
INSERT INTO courses VALUES(187,'hws413','comparative parliamentary studies (nigeria, britain, france and india)',3,'core',3,NULL);
INSERT INTO courses VALUES(188,'hws414','war and society in the middle east',3,'core',3,NULL);
INSERT INTO courses VALUES(189,'hws415','naval warfare since trafalgar',2,'core',3,NULL);
INSERT INTO courses VALUES(190,'hws416','the military in independent africa',2,'core',3,NULL);
INSERT INTO courses VALUES(191,'hws418','land and labour in africa 1850-1950',3,'core',3,NULL);
INSERT INTO courses VALUES(192,'hws419','colonial wars in nigeria I',2,'elective',3,NULL);
INSERT INTO courses VALUES(193,'hws421','terrorism in world history',2,'core',3,NULL);
INSERT INTO courses VALUES(194,'hws422','economic history of nigeria in the 20th and 21st centuries',3,'core',3,NULL);
INSERT INTO courses VALUES(195,'hws423','oau/au-a study of african international relations',3,'core',3,NULL);
INSERT INTO courses VALUES(196,'hws424','international peacekeeping',2,'core',3,NULL);
INSERT INTO courses VALUES(197,'hws426','philosophy of history',3,'core',3,NULL);
INSERT INTO courses VALUES(198,'hws427','colonial wars in nigeria II',2,'elective',3,NULL);
INSERT INTO courses VALUES(199,'hws428','modern african political thoughts',3,'core',3,NULL);
INSERT INTO courses VALUES(200,'hws499','supervised project',6,'core',3,NULL);
INSERT INTO courses VALUES(201,'fre111','french phonetics',2,'core',4,NULL);
INSERT INTO courses VALUES(202,'fre112','french corrective grammar',2,'core',4,NULL);
INSERT INTO courses VALUES(203,'fre113','reading/listening comprehension',2,'core',4,NULL);
INSERT INTO courses VALUES(204,'fre114','introduction to french composition',2,'core',4,NULL);
INSERT INTO courses VALUES(205,'fre115','practical french I',2,'core',4,NULL);
INSERT INTO courses VALUES(206,'fre116','introduction to a 2nd foreign language',2,'core',4,NULL);
INSERT INTO courses VALUES(207,'fre121','french phonetics',2,'core',4,NULL);
INSERT INTO courses VALUES(208,'fre122','french grammar',2,'core',4,NULL);
INSERT INTO courses VALUES(209,'fre123','reading/listening comprehension',2,'core',4,NULL);
INSERT INTO courses VALUES(210,'fre124','advance french composition',2,'core',4,NULL);
INSERT INTO courses VALUES(211,'fre125','practical french',2,'core',4,NULL);
INSERT INTO courses VALUES(212,'fre126','introduction to a 2nd foreign language',2,'core',4,NULL);
INSERT INTO courses VALUES(213,'psy121','introduction to psychology',2,'core',4,NULL);
INSERT INTO courses VALUES(214,'fre211','translation theory and practice',2,'core',4,NULL);
INSERT INTO courses VALUES(215,'fre212','french grammatical structures I',2,'core',4,NULL);
INSERT INTO courses VALUES(216,'fre213','french phonetics and phonology I',2,'core',4,NULL);
INSERT INTO courses VALUES(217,'fre214','advanced practical french I',2,'core',4,NULL);
INSERT INTO courses VALUES(218,'fre215','introduction to french literary genre: prose',2,'core',4,NULL);
INSERT INTO courses VALUES(219,'fre216','second foreign lang',2,'core',4,NULL);
INSERT INTO courses VALUES(220,'pds213','introduction to international relations',2,'core',4,NULL);
INSERT INTO courses VALUES(221,'fre221','translation: "version" and "theme"',2,'core',4,NULL);
INSERT INTO courses VALUES(222,'fre222','french grammatical structures',2,'core',4,NULL);
INSERT INTO courses VALUES(223,'fre223','french phonetics and phonology II',2,'core',4,NULL);
INSERT INTO courses VALUES(224,'fre224','advanced practical french II',2,'core',4,NULL);
INSERT INTO courses VALUES(225,'fre225','french drama and poetry',2,'core',4,NULL);
INSERT INTO courses VALUES(226,'fre226','survey of french literature 16th and 17th centuries',2,'core',4,NULL);
INSERT INTO courses VALUES(227,'pds242','introduction to political analysis',2,'core',4,NULL);
INSERT INTO courses VALUES(228,'fre311','translation I',2,'core',4,NULL);
INSERT INTO courses VALUES(229,'fre312','advance studies in french language structure',2,'core',4,NULL);
INSERT INTO courses VALUES(230,'fre313','french phonetics and phonology',2,'core',4,NULL);
INSERT INTO courses VALUES(231,'fre314','french culture and civilisation',2,'core',4,NULL);
INSERT INTO courses VALUES(232,'fre315','comparative african literature written in english and french',2,'core',4,NULL);
INSERT INTO courses VALUES(233,'fre316','introduction to french military terminologies',2,'core',4,NULL);
INSERT INTO courses VALUES(234,'fre318','french literature of 19th century',2,'core',4,NULL);
INSERT INTO courses VALUES(235,'fre319','research methodology I',2,'core',4,NULL);
INSERT INTO courses VALUES(236,'fre321','translation II',2,'core',4,NULL);
INSERT INTO courses VALUES(237,'fre322','advance studies in french language structure II',2,'core',4,NULL);
INSERT INTO courses VALUES(238,'fre323','creative writing in french',2,'core',4,NULL);
INSERT INTO courses VALUES(239,'fre324','caribbean french literature',2,'core',4,NULL);
INSERT INTO courses VALUES(240,'fre325','introduction to african literature written in french',2,'core',4,NULL);
INSERT INTO courses VALUES(241,'fre326','the sociolinguistics of french',2,'core',4,NULL);
INSERT INTO courses VALUES(242,'fre327','advance french military terminologies',2,'core',4,NULL);
INSERT INTO courses VALUES(243,'fre328','french literature of the 19th century',2,'core',4,NULL);
INSERT INTO courses VALUES(244,'fre329','introduction to project writing/research methodology',2,'core',4,NULL);
INSERT INTO courses VALUES(245,'fre411','advance translation I',2,'core',4,NULL);
INSERT INTO courses VALUES(246,'fre412','linguistics applied to the teaching of french language',2,'core',4,NULL);
INSERT INTO courses VALUES(247,'fre413','caribbean francophone literature',2,'core',4,NULL);
INSERT INTO courses VALUES(248,'fre414','french literature of the 20th century: drama, prose and poetry',2,'core',4,NULL);
INSERT INTO courses VALUES(249,'fre415','advanced creative writing in french',2,'core',4,NULL);
INSERT INTO courses VALUES(250,'fre416','post-independence francophone-african literature',2,'core',4,NULL);
INSERT INTO courses VALUES(251,'fre421','advance translation II',2,'core',4,NULL);
INSERT INTO courses VALUES(252,'fre422','linguistics applied to the teaching of french language',2,'core',4,NULL);
INSERT INTO courses VALUES(253,'fre423','caribbean francophone literature',2,'core',4,NULL);
INSERT INTO courses VALUES(254,'fre424','french literature of the 20th century',2,'core',4,NULL);
INSERT INTO courses VALUES(255,'fre425','literary criticism in french',2,'core',4,NULL);
INSERT INTO courses VALUES(256,'fre426','post-independence francophone-african literature',2,'core',4,NULL);
INSERT INTO courses VALUES(257,'fre499','final year essay',6,'core',4,NULL);
INSERT INTO courses VALUES(258,'arb111','grammar',3,'core',5,NULL);
INSERT INTO courses VALUES(259,'arb112','introduction to arabic literature',3,'core',5,NULL);
INSERT INTO courses VALUES(260,'arb113','reading skills',2,'core',5,NULL);
INSERT INTO courses VALUES(261,'arb114','writing skills',2,'core',5,NULL);
INSERT INTO courses VALUES(262,'arb115','rhetoric',2,'core',5,NULL);
INSERT INTO courses VALUES(263,'arb116','introduction to a second foreign language',2,'core',5,NULL);
INSERT INTO courses VALUES(264,'arb121','introduction to arabic novel',2,'core',5,NULL);
INSERT INTO courses VALUES(265,'arb122','translation',2,'core',5,NULL);
INSERT INTO courses VALUES(266,'arb123','text from ancient arabic literature',2,'core',5,NULL);
INSERT INTO courses VALUES(267,'arb124','defence and security terms',2,'core',5,NULL);
INSERT INTO courses VALUES(268,'arb125','computer studies in arabic',2,'core',5,NULL);
INSERT INTO courses VALUES(269,'arb127','introduction to essay writing',2,'core',5,NULL);
INSERT INTO courses VALUES(270,'arb126','introduction to a second foreign language',2,'core',5,NULL);
INSERT INTO courses VALUES(271,'gst124','computer application/ICT',1,'elective',5,NULL);
INSERT INTO courses VALUES(272,'arb211','grammar',3,'core',5,NULL);
INSERT INTO courses VALUES(273,'arb212','arabic literature',3,'core',5,NULL);
INSERT INTO courses VALUES(274,'arb213','reading skills',2,'core',5,NULL);
INSERT INTO courses VALUES(275,'arb214','morphology',2,'core',5,NULL);
INSERT INTO courses VALUES(276,'arb215','introduction to nigerian arabic literature',2,'core',5,NULL);
INSERT INTO courses VALUES(277,'arb217','computer study in arabic',2,'core',5,NULL);
INSERT INTO courses VALUES(278,'arb216','second foreign language III',2,'core',5,NULL);
INSERT INTO courses VALUES(279,'arb221','grammar III',2,'core',5,NULL);
INSERT INTO courses VALUES(280,'arb222','rhetoric II',2,'core',5,NULL);
INSERT INTO courses VALUES(281,'arb223','translation II',2,'core',5,NULL);
INSERT INTO courses VALUES(282,'arb224','writing of nigerian arabic scholars',2,'core',5,NULL);
INSERT INTO courses VALUES(283,'arb225','strategic lexicography',2,'core',5,NULL);
INSERT INTO courses VALUES(284,'arb226','a novel',2,'core',5,NULL);
INSERT INTO courses VALUES(285,'arb227','essay writing',2,'core',5,NULL);
INSERT INTO courses VALUES(286,'arb311','grammar',2,'core',5,NULL);
INSERT INTO courses VALUES(287,'arb312','arabic literature in umayyad period',2,'core',5,NULL);
INSERT INTO courses VALUES(288,'arb313','rhetoric III',2,'core',5,NULL);
INSERT INTO courses VALUES(289,'arb314','a novel II',2,'core',5,NULL);
INSERT INTO courses VALUES(290,'arb315','arabic literature in west africa',2,'core',5,NULL);
INSERT INTO courses VALUES(291,'arb316','classical and modern arabic library',2,'core',5,NULL);
INSERT INTO courses VALUES(292,'arb317','morphology of noun',2,'core',5,NULL);
INSERT INTO courses VALUES(293,'arb318','text from classical arabic literature I',2,'core',5,NULL);
INSERT INTO courses VALUES(294,'arb319','media arabic',2,'core',5,NULL);
INSERT INTO courses VALUES(295,'arb321','arabic literature in abbasid period',2,'core',5,NULL);
INSERT INTO courses VALUES(296,'arb322','arabic literature in spain',2,'core',5,NULL);
INSERT INTO courses VALUES(297,'arb323','phonetics and phonology',2,'core',5,NULL);
INSERT INTO courses VALUES(298,'arb324','special author',2,'core',5,NULL);
INSERT INTO courses VALUES(299,'arb325','prosody I',2,'core',5,NULL);
INSERT INTO courses VALUES(300,'arb326','translation III',2,'core',5,NULL);
INSERT INTO courses VALUES(301,'arb327','method of research',2,'core',5,NULL);
INSERT INTO courses VALUES(302,'arb328','morphology of verb',2,'core',5,NULL);
INSERT INTO courses VALUES(303,'arb329','text from classical arabic literature II',2,'core',5,NULL);
INSERT INTO courses VALUES(304,'arb411','modern arabic poetry',2,'core',5,NULL);
INSERT INTO courses VALUES(305,'arb412','morphology',2,'core',5,NULL);
INSERT INTO courses VALUES(306,'arb413','selected topics in grammar',2,'core',5,NULL);
INSERT INTO courses VALUES(307,'arb414','prosody II',2,'core',5,NULL);
INSERT INTO courses VALUES(308,'arb415','a play',2,'core',5,NULL);
INSERT INTO courses VALUES(309,'arb416','introduction to classical arabic criticism',2,'core',5,NULL);
INSERT INTO courses VALUES(310,'arb417','a special author',2,'core',5,NULL);
INSERT INTO courses VALUES(311,'arb418','arabic literature in al-mahjar',2,'core',5,NULL);
INSERT INTO courses VALUES(312,'arb421','modern arabic prose',2,'core',5,NULL);
INSERT INTO courses VALUES(313,'arb422','modern arabic critism',2,'core',5,NULL);
INSERT INTO courses VALUES(314,'arb423','the works of nigerian arabic writers',2,'core',5,NULL);
INSERT INTO courses VALUES(315,'arb424','translation',2,'core',5,NULL);
INSERT INTO courses VALUES(316,'arb425','arabic for international purpose',2,'core',5,NULL);
INSERT INTO courses VALUES(317,'arb499','supervised project',6,'core',5,NULL);
INSERT INTO courses VALUES(318,'pol110','introduction to political science I',3,'core',6,NULL);
INSERT INTO courses VALUES(319,'pol111','nigerian legal system',2,'core',6,NULL);
INSERT INTO courses VALUES(320,'pol112','nigerian constitutional development',2,'core',6,NULL);
INSERT INTO courses VALUES(321,'pol113','introduction to peace studies',2,'core',6,NULL);
INSERT INTO courses VALUES(322,'pol114','citizen and the state',2,'core',6,NULL);
INSERT INTO courses VALUES(323,'pol120','introduction to political science II',3,'core',6,NULL);
INSERT INTO courses VALUES(324,'pol121','terrorism and world politics',2,'core',6,NULL);
INSERT INTO courses VALUES(325,'pol122','introduction to regional integration',2,'core',6,NULL);
INSERT INTO courses VALUES(326,'pol123','nigerian political culture',2,'core',6,NULL);
INSERT INTO courses VALUES(327,'pol124','politics in africa',2,'core',6,NULL);
INSERT INTO courses VALUES(328,'pol210','social statistics for political science I',3,'core',6,NULL);
INSERT INTO courses VALUES(329,'pol211','introduction to political theories',2,'core',6,NULL);
INSERT INTO courses VALUES(330,'pol212','nigerian government and politics',3,'core',6,NULL);
INSERT INTO courses VALUES(331,'pol213','history of political thought',2,'core',6,NULL);
INSERT INTO courses VALUES(332,'pol214','introduction to comparative politics I',2,'core',6,NULL);
INSERT INTO courses VALUES(333,'pol215','introduction to local government administration',2,'core',6,NULL);
INSERT INTO courses VALUES(334,'pol216','organisation of government',2,'core',6,NULL);
INSERT INTO courses VALUES(335,'pol220','social statistics for political science II',3,'core',6,NULL);
INSERT INTO courses VALUES(336,'pol221','introduction to political analysis',2,'core',6,NULL);
INSERT INTO courses VALUES(337,'pol222','political ideas',2,'core',6,NULL);
INSERT INTO courses VALUES(338,'pol223','introduction to public administration',2,'core',6,NULL);
INSERT INTO courses VALUES(339,'pol224','introduction to comparative politics II',2,'core',6,NULL);
INSERT INTO courses VALUES(340,'pol225','foundations of political economy',2,'core',6,NULL);
INSERT INTO courses VALUES(341,'pol226','africa in world politics',2,'elective',6,NULL);
INSERT INTO courses VALUES(342,'pol227','citizenship and the state',2,'elective',6,NULL);
INSERT INTO courses VALUES(343,'pol310','logic and methods of political inquiry I',3,'core',6,NULL);
INSERT INTO courses VALUES(344,'pol311','contemporary political analysis',3,'core',6,NULL);
INSERT INTO courses VALUES(345,'pol312','political bahaviour',3,'core',6,NULL);
INSERT INTO courses VALUES(346,'pol313','theories of international relations',3,'core',6,NULL);
INSERT INTO courses VALUES(347,'pol314','politics of international economic relations',2,'core',6,NULL);
INSERT INTO courses VALUES(348,'pol315','theories and pratice of public administration',3,'core',6,NULL);
INSERT INTO courses VALUES(349,'pol316','history of political thought (western)',3,'elective',6,NULL);
INSERT INTO courses VALUES(350,'pol317','theory and practice of marxism',3,'elective',6,NULL);
INSERT INTO courses VALUES(351,'pol320','logic and methods of political inquiry II',3,'core',6,NULL);
INSERT INTO courses VALUES(352,'pol321','african political thought',3,'core',6,NULL);
INSERT INTO courses VALUES(353,'pol322','international law and organizations',3,'core',6,NULL);
INSERT INTO courses VALUES(354,'pol323','comparative federalism',3,'core',6,NULL);
INSERT INTO courses VALUES(355,'pol324','imperialism and nationalism',3,'core',6,NULL);
INSERT INTO courses VALUES(356,'pol325','comparative public administration',3,'core',6,NULL);
INSERT INTO courses VALUES(357,'pol326','politics of development and underdevelopment',2,'core',6,NULL);
INSERT INTO courses VALUES(358,'pol327','gender and politics in nigeria',2,'elective',6,NULL);
INSERT INTO courses VALUES(359,'pol328','urban politics and government in nigeria',2,'elective',6,NULL);
INSERT INTO courses VALUES(360,'pol410','theories and practice of conflict management',3,'core',6,NULL);
INSERT INTO courses VALUES(361,'pol411','public opinion and pressure group',2,'core',6,NULL);
INSERT INTO courses VALUES(362,'pol412','civil-military relations',3,'core',6,NULL);
INSERT INTO courses VALUES(363,'pol413','development administration',3,'core',6,NULL);
INSERT INTO courses VALUES(364,'pol414','public policy analysis',3,'core',6,NULL);
INSERT INTO courses VALUES(365,'pol415','nigerian foreign policy I',2,'core',6,NULL);
INSERT INTO courses VALUES(366,'pol416','local government in nigeria',3,'core',6,NULL);
INSERT INTO courses VALUES(367,'pol417','politics and law in africa',3,'core',6,NULL);
INSERT INTO courses VALUES(368,'pol418','politics of integration in africa',3,'elective',6,NULL);
INSERT INTO courses VALUES(369,'pol420','third world and dependency',3,'core',6,NULL);
INSERT INTO courses VALUES(370,'pol421','revolution and society',3,'core',6,NULL);
INSERT INTO courses VALUES(371,'pol422','comparative public administration',2,'core',6,NULL);
INSERT INTO courses VALUES(372,'pol423','public personnel administration',3,'core',6,NULL);
INSERT INTO courses VALUES(373,'pol424','nigerian foreign policy II',2,'core',6,NULL);
INSERT INTO courses VALUES(374,'pol425','public financial administration',3,'core',6,NULL);
INSERT INTO courses VALUES(375,'pol426','state and economy',3,'core',6,NULL);
INSERT INTO courses VALUES(376,'pol499','research project',6,'core',6,NULL);
INSERT INTO courses VALUES(377,'pol427','race and ethnicity in international relations',3,'elective',6,NULL);
INSERT INTO courses VALUES(378,'pol428','race and ethnicity in international relations',3,'elective',6,NULL);
INSERT INTO courses VALUES(379,'psy112','history of psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(380,'psy113','psychology of learning I',2,'core',7,NULL);
INSERT INTO courses VALUES(381,'psy114','quantitative methods in psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(382,'bio111','general biology I',3,'core',7,NULL);
INSERT INTO courses VALUES(383,'bio112','experimental biology I',1,'core',7,NULL);
INSERT INTO courses VALUES(384,'pds112','introduction to defence and strategic studies I',2,'elective',7,NULL);
INSERT INTO courses VALUES(385,'psy122','basic concepts in experimental psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(386,'psy124','quantitative methods in psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(387,'bio121','general biology II',3,'core',7,NULL);
INSERT INTO courses VALUES(388,'bio122','experimental biology II',1,'core',7,NULL);
INSERT INTO courses VALUES(389,'pds126','introduction to defence and strategic studies II',2,'core',7,NULL);
INSERT INTO courses VALUES(390,'psy211','general experimental psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(391,'psy212','introduction to physiology psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(392,'psy213','developmental psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(393,'psy214','introduction to social psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(394,'psy215','industrial psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(395,'psy216','introduction to personality theories',2,'core',7,NULL);
INSERT INTO courses VALUES(396,'psy217','introduction to statistics in psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(397,'psy221','general experimental psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(398,'psy222','physiological psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(399,'psy223','developmental psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(400,'psy224','psychology of ethnicity and ethnic groups',2,'core',7,NULL);
INSERT INTO courses VALUES(401,'psy225','social perception',2,'core',7,NULL);
INSERT INTO courses VALUES(402,'psy226','experimental design',2,'core',7,NULL);
INSERT INTO courses VALUES(403,'psy227','principles of criminology and juvenile delinquency',2,'core',7,NULL);
INSERT INTO courses VALUES(404,'hist224','history of nigerian armed forces',2,'elective',7,NULL);
INSERT INTO courses VALUES(405,'psy311','statistical method in psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(406,'psy312','clinical psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(407,'psy313','personality assessment I',2,'core',7,NULL);
INSERT INTO courses VALUES(408,'psy314','cognitive psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(409,'psy315','psychological testing and test construction I',2,'core',7,NULL);
INSERT INTO courses VALUES(410,'psy316','environmental psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(411,'psy317','community psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(412,'psy318','cross-cultural psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(413,'psy319','psychology of guidance and counselling',2,'core',7,NULL);
INSERT INTO courses VALUES(414,'psy321','research method in psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(415,'psy322','clinical psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(416,'psy323','personality assessment II',2,'core',7,NULL);
INSERT INTO courses VALUES(417,'psy324','cognitive psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(418,'psy326','abnormal psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(419,'psy327','psychology of substance abuse',2,'core',7,NULL);
INSERT INTO courses VALUES(420,'psy328','psychology of personnel management',2,'elective',7,NULL);
INSERT INTO courses VALUES(421,'psy329','political psychology',2,'elective',7,NULL);
INSERT INTO courses VALUES(422,'psy411','military psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(423,'psy412','organisational psychology I',2,'core',7,NULL);
INSERT INTO courses VALUES(424,'psy413','advanced psychobiology I',2,'core',7,NULL);
INSERT INTO courses VALUES(425,'psy414','practicum in psychotherapy',2,'core',7,NULL);
INSERT INTO courses VALUES(426,'psy415','health psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(427,'psy416','forensic psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(428,'psy417','clinical psychology III',2,'core',7,NULL);
INSERT INTO courses VALUES(429,'psy418','consumer psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(430,'psy419','psychology of vocational behaviour',2,'core',7,NULL);
INSERT INTO courses VALUES(431,'psy421','military psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(432,'psy422','organisational psychology II',2,'core',7,NULL);
INSERT INTO courses VALUES(433,'psy423','advanced psychobiology II',2,'core',7,NULL);
INSERT INTO courses VALUES(434,'psy424','behaviour modification (practicum)',3,'core',7,NULL);
INSERT INTO courses VALUES(435,'psy425','survival psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(436,'psy499','research project',6,'core',7,NULL);
INSERT INTO courses VALUES(437,'psy426','psychology of social change',2,'core',7,NULL);
INSERT INTO courses VALUES(438,'psy427','current issues in psychology',2,'core',7,NULL);
INSERT INTO courses VALUES(439,'chm111','general chemistry I',3,'core',8,NULL);
INSERT INTO courses VALUES(440,'chm112','experimental chemistry I',1,'core',8,NULL);
INSERT INTO courses VALUES(441,'mat111','general mathematics I',3,'core',8,NULL);
INSERT INTO courses VALUES(442,'mat112','general mathematics I',3,'core',8,NULL);
INSERT INTO courses VALUES(443,'phy111','general physics I',3,'core',8,NULL);
INSERT INTO courses VALUES(444,'phy112','experimental physics I',1,'core',8,NULL);
INSERT INTO courses VALUES(445,'csc111','fundamentals of computer science',3,'core',8,NULL);
INSERT INTO courses VALUES(446,'eng121','material science',2,'core',8,NULL);
INSERT INTO courses VALUES(447,'chm121','general chemistry II',3,'core',8,NULL);
INSERT INTO courses VALUES(448,'chm122','experimental chemistry II',1,'core',8,NULL);
INSERT INTO courses VALUES(449,'mat121','general mathematics III',3,'core',8,NULL);
INSERT INTO courses VALUES(450,'phy121','general physics II',3,'core',8,NULL);
INSERT INTO courses VALUES(451,'phy122','experimental physics II',1,'core',8,NULL);
INSERT INTO courses VALUES(452,'csc121','fundamentals of computer science',1,'core',8,NULL);
INSERT INTO courses VALUES(453,'csc122','introduction to computer programming (basic)',3,'core',8,NULL);
INSERT INTO courses VALUES(454,'eng211','engineering mathematics I',3,'core',8,NULL);
INSERT INTO courses VALUES(455,'eng212','engineering drawing',2,'core',8,NULL);
INSERT INTO courses VALUES(456,'eng213','experimentation I',2,'core',8,NULL);
INSERT INTO courses VALUES(457,'eng214','workshop practice I',1,'core',8,NULL);
INSERT INTO courses VALUES(458,'eng215','applied electricity',2,'core',8,NULL);
INSERT INTO courses VALUES(459,'eng216','applied mechanics',2,'core',8,NULL);
INSERT INTO courses VALUES(460,'eng217','thermodynamics I',2,'core',8,NULL);
INSERT INTO courses VALUES(461,'eng219','fluid mechanics I',2,'core',8,NULL);
INSERT INTO courses VALUES(462,'cvl211','soil mechanics I',2,'core',8,NULL);
INSERT INTO courses VALUES(463,'cvl212','civil engineering materials',2,'core',8,NULL);
INSERT INTO courses VALUES(464,'cvl213','engineering survey and photogrammetric',2,'core',8,NULL);
INSERT INTO courses VALUES(465,'eng221','engineering mathematics II',3,'core',8,NULL);
INSERT INTO courses VALUES(466,'eng222','engineering drawing II',2,'core',8,NULL);
INSERT INTO courses VALUES(467,'eng223','experimentation II',2,'core',8,NULL);
INSERT INTO courses VALUES(468,'eng224','workshop pratice II',1,'core',8,NULL);
INSERT INTO courses VALUES(469,'eng225','strength of materials I',2,'core',8,NULL);
INSERT INTO courses VALUES(470,'eng226','applied electricity II',2,'core',8,NULL);
INSERT INTO courses VALUES(471,'cvl220','engineering survey and photogrammetry II',2,'core',8,NULL);
INSERT INTO courses VALUES(472,'cvl221','engineering geology I',2,'core',8,NULL);
INSERT INTO courses VALUES(473,'cvl222','soils mechanics II',2,'core',8,NULL);
INSERT INTO courses VALUES(474,'eng311','engineering mathematics III',3,'core',8,NULL);
INSERT INTO courses VALUES(475,'eng312','numerical analysis',2,'core',8,NULL);
INSERT INTO courses VALUES(476,'eng313','engineering communications',2,'core',8,NULL);
INSERT INTO courses VALUES(477,'cvl311','engineering geology II',2,'core',8,NULL);
INSERT INTO courses VALUES(478,'cvl312','structural analysis I',2,'core',8,NULL);
INSERT INTO courses VALUES(479,'cvl314','engineering hydrology',2,'core',8,NULL);
INSERT INTO courses VALUES(480,'cvl315','highway and transportation I',2,'core',8,NULL);
INSERT INTO courses VALUES(481,'cvl316','civil engineering practical I',2,'core',8,NULL);
INSERT INTO courses VALUES(482,'mec315','strength of materials II',2,'core',8,NULL);
INSERT INTO courses VALUES(483,'eng321','engineering mathematics IV',3,'core',8,NULL);
INSERT INTO courses VALUES(484,'cvl321','computer applications in civil engineering',2,'core',8,NULL);
INSERT INTO courses VALUES(485,'cvl322','structural analysis II',2,'core',8,NULL);
INSERT INTO courses VALUES(486,'cvl323','reinforced concrete design I',2,'core',8,NULL);
INSERT INTO courses VALUES(487,'cvl324','engineering hydraulics',2,'core',8,NULL);
INSERT INTO courses VALUES(488,'cvl325','highway and transportation II',2,'core',8,NULL);
INSERT INTO courses VALUES(489,'cvl326','civil engineering practical II',2,'core',8,NULL);
INSERT INTO courses VALUES(490,'cvl327','foundation engineering I',2,'core',8,NULL);
INSERT INTO courses VALUES(491,'cvl328','water supply and wastewater engineering I',2,'core',8,NULL);
INSERT INTO courses VALUES(492,'eng411','engineering law and management',2,'core',8,NULL);
INSERT INTO courses VALUES(493,'cvl411','structural analysis III',2,'core',8,NULL);
INSERT INTO courses VALUES(494,'cvl412','coundation engineering II',2,'core',8,NULL);
INSERT INTO courses VALUES(495,'cvl413','practical III',2,'core',8,NULL);
INSERT INTO courses VALUES(496,'cvl414','design of hydraulic structures',2,'core',8,NULL);
INSERT INTO courses VALUES(497,'cvl415','water supply and wastewater engineering II',2,'core',8,NULL);
INSERT INTO courses VALUES(498,'cvl416','design of steel structures I',2,'core',8,NULL);
INSERT INTO courses VALUES(499,'cvl417','environmental impact assessment',2,'core',8,NULL);
INSERT INTO courses VALUES(500,'cvl418','reinforced concrete design II',2,'core',8,NULL);
INSERT INTO courses VALUES(501,'cvl419','highway and transportation III',2,'core',8,NULL);
INSERT INTO courses VALUES(502,'cvl499','project',6,'core',8,NULL);
INSERT INTO courses VALUES(503,'cvl432','traffic engineering',2,'core',8,NULL);
INSERT INTO courses VALUES(504,'cvl434','building technology',2,'core',8,NULL);
INSERT INTO courses VALUES(505,'cvl435','hydrogeology',2,'core',8,NULL);
INSERT INTO courses VALUES(506,'eng421','engineering in society',2,'core',8,NULL);
INSERT INTO courses VALUES(507,'cvl421','structural analysis III',2,'core',8,NULL);
INSERT INTO courses VALUES(508,'cvl422','design of timber structures',2,'core',8,NULL);
INSERT INTO courses VALUES(509,'cvl423','solid waste management',2,'core',8,NULL);
INSERT INTO courses VALUES(510,'cvl424','construction management',2,'core',8,NULL);
INSERT INTO courses VALUES(511,'cvl425','maintenance management',2,'core',8,NULL);
INSERT INTO courses VALUES(512,'cvl426','design of steel structures II',2,'core',8,NULL);
INSERT INTO courses VALUES(513,'cvl428','advanced structural design',2,'core',8,NULL);
INSERT INTO courses VALUES(514,'cvl441','coastal and habour engineering',2,'elective',8,NULL);
INSERT INTO courses VALUES(515,'cvl442','airfield planning and design',2,'elective',8,NULL);
INSERT INTO courses VALUES(516,'cvl443','rail transportation',2,'elective',8,NULL);
INSERT INTO courses VALUES(517,'ele222','introduction to electronics II',2,'core',9,NULL);
INSERT INTO courses VALUES(518,'ele223','electrical circuit theory I',2,'core',9,NULL);
INSERT INTO courses VALUES(519,'ele311','electric circuit theory II',2,'core',9,NULL);
INSERT INTO courses VALUES(520,'ele312','electrical engineering materials',2,'core',9,NULL);
INSERT INTO courses VALUES(521,'ele313','electrical machines I',2,'core',9,NULL);
INSERT INTO courses VALUES(522,'ele314','electronic engineering I',2,'core',9,NULL);
INSERT INTO courses VALUES(523,'ele315','experimentation III',3,'core',9,NULL);
INSERT INTO courses VALUES(524,'ele316','electrical measurement and instrumentation',2,'core',9,NULL);
INSERT INTO courses VALUES(525,'ele317','communication principles I',2,'core',9,NULL);
INSERT INTO courses VALUES(526,'ele321','communication principles II',2,'core',9,NULL);
CREATE TABLE profile_pictures (
	id VARCHAR(255) NOT NULL, 
	filename VARCHAR(255) NOT NULL, 
	cadet_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(cadet_id) REFERENCES cadets (id)
);
CREATE TABLE service_scores (
	id INTEGER NOT NULL, 
	first_term_score FLOAT, 
	second_term_score FLOAT, 
	service_year INTEGER, 
	service_subject_id INTEGER, 
	cadet_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(service_subject_id) REFERENCES service_subjects (id), 
	FOREIGN KEY(cadet_id) REFERENCES cadets (id)
);
CREATE TABLE scores (
	id INTEGER NOT NULL, 
	first_semester_score FLOAT, 
	second_semester_score FLOAT, 
	academic_year INTEGER, 
	course_id INTEGER, 
	cadet_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(course_id) REFERENCES courses (id), 
	FOREIGN KEY(cadet_id) REFERENCES cadets (id)
);
