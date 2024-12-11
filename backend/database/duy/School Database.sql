CREATE TABLE Users (
    username VARCHAR2(50) PRIMARY KEY,
    password VARCHAR2(100) NOT NULL,
    user_role VARCHAR2(20) CHECK (user_role IN ('admin', 'student', 'teacher')) 
);

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
    CONSTRAINT fk_student_user FOREIGN KEY (username) REFERENCES Users(username) ON DELETE CASCADE
);

CREATE TABLE Teacher (
    username VARCHAR2(50),
    teacher_id INT PRIMARY KEY,
    fname VARCHAR2(50) NOT NULL,
    lname VARCHAR2(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    address VARCHAR2(255),
    years_of_exp INT CHECK (years_of_exp >= 0),
    CONSTRAINT fk_teacher_user FOREIGN KEY (username) REFERENCES Users(username)ON DELETE CASCADE
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR2(100) NOT NULL UNIQUE,
    course_description VARCHAR2(255)
);