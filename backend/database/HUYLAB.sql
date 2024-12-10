CREATE TABLE Users (
    username VARCHAR2(50) PRIMARY KEY,
    password VARCHAR2(100) NOT NULL,
    user_role VARCHAR2(20) CHECK (user_role IN ('admin', 'student', 'teacher')) 
);

INSERT INTO Users (username, password, user_role) VALUES ('duchuy', '123', 'student');
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
commit;

CREATE TABLE HealthRecord (
    student_id INT NOT NULL,
    record_id INT NOT NULL,
    medical_note VARCHAR2(500),
    allergy VARCHAR2(255),
    PRIMARY KEY (student_id, record_id),
    CONSTRAINT fk_health_record_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE
);commit;

INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy) 
VALUES (2212345, 1, 'Student has high blood pressure, needs regular monitoring', 'No allergies');commit;

INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy) 
VALUES (2212345, 2, 'Suffering from a cold, needs 5 days of treatment', 'Allergic to penicillin');commit;

CREATE TABLE Parent (
    parent_id INT PRIMARY KEY,
    fname VARCHAR2(30) NOT NULL,
    lname VARCHAR2(30) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    relationship VARCHAR2(100) CHECK(relationship IN ('Father','Mother','Guardian')),
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    address VARCHAR2(255) 
);commit;

INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (1, 'Nguyen', 'Van H', 'M', TO_DATE('1975-03-12', 'YYYY-MM-DD'), 'Father', 'nguyenvanh@gmail.com', '0912345671', '123 Duong A, Ho Chi Minh');commit;
INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (2, 'Tran', 'Thi L', 'F', TO_DATE('1980-07-05', 'YYYY-MM-DD'), 'Mother', 'tranthil@gmail.com', '0987654322', '123 Duong A, Ho Chi Minh');commit;

CREATE TABLE HasParent (
    parent_id INT,
    student_id INT,
    PRIMARY KEY (parent_id, student_id),
    CONSTRAINT fk_has_parent_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_has_parent_parent_id FOREIGN KEY (parent_id) 
        REFERENCES Parent(parent_id) 
        ON DELETE CASCADE
);commit;

INSERT INTO HasParent (parent_id, student_id)
VALUES (1, 2212345);commit;
INSERT INTO HasParent (parent_id, student_id)
VALUES (2, 2212345);commit;

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR2(100) NOT NULL UNIQUE,
    course_description VARCHAR2(255)
);commit;

INSERT INTO Course (course_id, course_name, course_description)
VALUES (1, 'Mathematics', 'Introduction to basic mathematical concepts and principles.');commit;
INSERT INTO Course (course_id, course_name, course_description)
VALUES (2, 'Physics', 'Fundamentals of physics, including motion, energy, and force.');commit;
INSERT INTO Course (course_id, course_name, course_description)
VALUES (3, 'Chemistry', 'Basic concepts of chemistry, including elements, compounds, and reactions.');commit;
INSERT INTO Course (course_id, course_name, course_description)
VALUES (4, 'History', 'Overview of world history, focusing on major civilizations and events.');commit;
INSERT INTO Course (course_id, course_name, course_description)
VALUES (5, 'English Literature', 'Introduction to English literature, including classic and modern works.');commit;

CREATE TABLE Attends (
    student_id INT NOT NULL,
    course_id INT NOT NULL, 
    class_id INT NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_attends_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_attends_class FOREIGN KEY (course_id, class_id) 
        REFERENCES Class(course_id, class_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_attends_course FOREIGN KEY (course_id) 
        REFERENCES Course(course_id)
        ON DELETE CASCADE
);

INSERT INTO Attends (student_id, course_id, class_id) VALUES (2212345, 1, 1);commit;
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2212345, 2, 2);commit;
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2212345, 3, 1);commit;
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2212345, 4, 2);commit;
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2212345, 5, 1);commit;
delete from attends;

CREATE TABLE Class (
    course_id INT NOT NULL,
    class_id INT NOT NULL,
    teacher_id INT NOT NULL,
    PRIMARY KEY (course_id, class_id),
    CONSTRAINT fk_class_course_id FOREIGN KEY (course_id) 
        REFERENCES Course(course_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_class_teacher_id FOREIGN KEY (teacher_id) 
        REFERENCES Teacher(teacher_id)
        ON DELETE CASCADE
);

INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (1, 1, 1);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (1, 2, 2);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (2, 1, 2);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (2, 2, 3);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (3, 1, 3);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (3, 2, 4);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (4, 1, 4);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (4, 2, 5);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (5, 1, 5);commit;
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (5, 2, 1);commit;

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    fname VARCHAR2(50) NOT NULL,
    lname VARCHAR2(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    address VARCHAR2(255),
    years_of_exp INT CHECK (years_of_exp >= 0) 
);

INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (1, 'Nguyen', 'Van T', 'M', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'nguyenvant@gmail.com', '0912345677', '123 Duong A, Ha Noi', 10);commit;
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (2, 'Tran', 'Thi H', 'F', TO_DATE('1985-08-20', 'YYYY-MM-DD'), 'tranthi.h@gmail.com', '0987654320', '456 Duong B, TP. Ho Ch� Minh', 7);commit;
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (3, 'Le', 'Quang V', 'M', TO_DATE('1978-12-30', 'YYYY-MM-DD'), 'lequangv@gmail.com', '0912345679', '789 Duong C, Da Nang', 15);commit;
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (4, 'Pham', 'Kim X', 'F', TO_DATE('1990-04-18', 'YYYY-MM-DD'), 'phamkimx@gmail.com', '0943216788', '12 Duong D, Hai Ph�ng', 3);commit;
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (5, 'Hoang', 'Thi D', 'M', TO_DATE('1982-11-11', 'YYYY-MM-DD'), 'hoangthe.d@gmail.com', '0934567899', '34 Duong E, Can Tho', 12);commit;

CREATE TABLE Material (
    material_id INT NOT NULL,
    course_id INT NOT NULL,
    type VARCHAR2(100) CHECK (type IN ('Textbook', 'Video', 'Article', 'Presentation', 'Other')),
    title VARCHAR2(255),
    upload_date DATE,
    author VARCHAR2(100),
    PRIMARY KEY (course_id, material_id),
    CONSTRAINT fk_material_id FOREIGN KEY (course_id)
        REFERENCES Course(course_id)
        ON DELETE CASCADE
);

INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (1, 1, 'Textbook', 'Mathematics Essentials', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'John Doe');commit;
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (2, 2, 'Video', 'Understanding Physics Concepts', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Jane Smith');commit;
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (3, 3, 'Article', 'The Basics of Chemistry', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'Dr. Emily Chen');commit;
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (4, 4, 'Presentation', 'History Through the Ages', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Prof. Alan Brown');commit;
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (5, 5, 'Other', 'Classic Literature: A Study Guide', TO_DATE('2023-05-18', 'YYYY-MM-DD'), 'Sara Johnson');commit;
-- Insert Exam --




