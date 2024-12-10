CREATE TABLE Users (
    username VARCHAR2(100) PRIMARY KEY,
    password VARCHAR2(100) NOT NULL,
    user_role VARCHAR2(20) CHECK (user_role IN ('admin', 'student', 'teacher')) 
);

INSERT INTO Users (username, password, user_role) VALUES ('huy', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('mai_lan', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('long_van', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('hoa_pham', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('tuan_hoang', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('anh_vu', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('tien_bui', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('phuong_do', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('minh_ngoc', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('hoang_ly', '123', 'student');

INSERT INTO Users (username, password, user_role) VALUES ('phong', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('duy', '123', 'admin');
COMMIT;

CREATE TABLE Student (
    username VARCHAR2(50),
    student_id INT PRIMARY KEY,
    fname VARCHAR2(30) NOT NULL,
    lname VARCHAR2(30) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    address VARCHAR2(255),
    gpa DECIMAL(3, 2) CHECK (gpa BETWEEN 0 AND 4.0),
    status VARCHAR(20) CHECK (status IN ('active', 'inactive', 'graduated', 'suspended')),
    enrollment_year INT,
    CONSTRAINT chk_student_enrollment_year CHECK (enrollment_year >= EXTRACT(YEAR FROM dob) + 18),
    CONSTRAINT fk_user FOREIGN KEY (username) REFERENCES Users(username)
);

INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('huy', 2212345, 'Tran', 'Duy Duc Huy', 'M', TO_DATE('2004-06-30', 'YYYY-MM-DD'), 'huy@gmail.com', '0123456789', '123 Duong A, Ho Chi Minh', 3.00, 'active', 2022);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('mai_lan', 2212346, 'Nguyen', 'Thi Mai Lan', 'F', TO_DATE('2003-04-15', 'YYYY-MM-DD'), 'mai.lan@example.com', '0123456790', '456 Duong B, Hanoi', 3.75, 'active', 2021);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('long_van', 2212347, 'Le', 'Van Long', 'M', TO_DATE('2002-09-10', 'YYYY-MM-DD'), 'long.van@example.com', '0123456791', '789 Duong C, Da Nang', 2.85, 'inactive', 2020);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('hoa_pham', 2212348, 'Pham', 'Thi Hoa', 'F', TO_DATE('2005-12-05', 'YYYY-MM-DD'), 'hoa.pham@example.com', '0123456792', '321 Duong D, Hai Phong', 3.50, 'active', 2023);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('tuan_hoang', 2212349, 'Hoang', 'Minh Tuan', 'M', TO_DATE('2001-07-20', 'YYYY-MM-DD'), 'tuan.hoang@example.com', '0123456793', '654 Duong E, Can Tho', 3.20, 'graduated', 2019);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('anh_vu', 2212350, 'Vu', 'Thi Anh', 'F', TO_DATE('2000-11-25', 'YYYY-MM-DD'), 'anh.vu@example.com', '0123456794', '987 Duong F, Hue', 3.90, 'active', 2018);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('tien_bui', 2212351, 'Bui', 'Van Tien', 'M', TO_DATE('1999-03-12', 'YYYY-MM-DD'), 'tien.bui@example.com', '0123456795', '159 Duong G, Vung Tau', 2.95, 'suspended', 2017);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('phuong_do', 2212352, 'Do', 'Mai Phuong', 'F', TO_DATE('2004-01-18', 'YYYY-MM-DD'), 'phuong.do@example.com', '0123456796', '753 Duong H, Nha Trang', 3.60, 'active', 2022);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('minh_ngoc', 2212353, 'Ngoc', 'Thi Minh', 'F', TO_DATE('2003-05-30', 'YYYY-MM-DD'), 'minh.ngoc@example.com', '0123456797', '852 Duong I, Can Gio', 3.40, 'inactive', 2021);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('hoang_ly', 2212354, 'Ly', 'Van Hoang', 'M', TO_DATE('2002-09-05', 'YYYY-MM-DD'), 'hoang.ly@example.com', '0123456798', '951 Duong J, Bien Hoa', 3.10, 'active', 2020);
COMMIT;
