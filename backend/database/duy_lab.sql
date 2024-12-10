CREATE TABLE Users (
    username VARCHAR2(100) PRIMARY KEY,
    password VARCHAR2(100) NOT NULL,
    user_role VARCHAR2(20) CHECK (user_role IN ('admin', 'student', 'teacher')) 
);

INSERT INTO Users (username, password, user_role) VALUES ('huy', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('phong', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('duy', '123', 'admin');

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
VALUES ('duchuy', 2212345, 'Tran', 'Duy Duc Huy', 'M', TO_DATE('2004-06-30', 'YYYY-MM-DD'), 'huy@gmail.com', '0123456789', '123 Duong A, Ho Chi Minh', 3.0, 'active', 2022);


