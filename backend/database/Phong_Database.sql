CREATE TABLE Users (
    username VARCHAR2(50) PRIMARY KEY,
    password VARCHAR2(100) NOT NULL,
    user_role VARCHAR2(20) CHECK (user_role IN ('admin', 'student', 'teacher')) 
);

INSERT INTO Users (username, password, user_role) VALUES ('duchuy', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('phong', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('duy', '123', 'admin');
INSERT INTO users (username, password, user_role) VALUES ('teacher1', '123', 'teacher');
INSERT INTO users (username, password, user_role) VALUES ('teacher2', '123', 'teacher');
INSERT INTO users (username, password, user_role) VALUES ('teacher3', '123', 'teacher');
INSERT INTO users (username, password, user_role) VALUES ('teacher4', '123', 'teacher');
INSERT INTO users (username, password, user_role) VALUES ('teacher5', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('student1', 'password123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('student2', 'password123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('student3', 'password123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('student4', 'password123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('student5', 'password123', 'student');



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
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES ('student1', 1, 'Nguyen', 'Van A', 'M', TO_DATE('2005-05-15', 'YYYY-MM-DD'), 'nguyenvana@gmail.com', '090911200', '123 Duong A, Ha Noi', 3.5, 'active', 2024);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES ('student2', 2, 'Tran', 'Thi B', 'F', TO_DATE('2006-08-20', 'YYYY-MM-DD'), 'tranthib@gmail.com', '0987654321', '456 Duong B, TP. Ho Chi Minh', 3.8, 'active', 2024);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES ('student3', 3, 'Le', 'Hoang C', 'M', TO_DATE('2005-02-10', 'YYYY-MM-DD'), 'lehoangc@gmail.com', '0912345678', '789 Duong C, Da Nang', 3.2, 'active', 2023);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES ('student4', 4, 'Pham', 'Minh D', 'M', TO_DATE('2004-12-25', 'YYYY-MM-DD'), 'phammanhd@gmail.com', '0943216789', '12 Duong D, Hai Phong', 2.9, 'graduated', 2022);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES ('student5', 5, 'Hoang', 'Thu E', 'F', TO_DATE('2005-11-30', 'YYYY-MM-DD'), 'hoangthue@gmail.com', '0934567890', '34 Duong E, Can Tho', 3.6, 'active', 2023);



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
    CONSTRAINT fk_teacher_contact_info FOREIGN KEY (email, phone_number) 
        REFERENCES ContactInfo(email, phone_number) 
);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES ('teacher1', 1, 'Nguyen', 'Van T', 'M', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'nguyenvant@gmail.com', '0912345677', '123 Duong A, Ha Noi', 10);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES ('teacher2', 2, 'Tran', 'Thi H', 'F', TO_DATE('1985-08-20', 'YYYY-MM-DD'), 'tranthi.h@gmail.com', '0987654320', '456 Duong B, TP. Ho Chi Minh', 7);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES ('teacher3', 3, 'Le', 'Quang V', 'M', TO_DATE('1978-12-30', 'YYYY-MM-DD'), 'lequangv@gmail.com', '0912345679', '789 Duong C, Da Nang', 15);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES ('teacher4', 4, 'Pham', 'Kim X', 'F', TO_DATE('1990-04-18', 'YYYY-MM-DD'), 'phamkimx@gmail.com', '0943216788', '12 Duong D, Hai Phong', 3);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES ('teacher5', 5, 'Hoang', 'Thi D', 'M', TO_DATE('1982-11-11', 'YYYY-MM-DD'), 'hoangthe.d@gmail.com', '0934567899', '34 Duong E, Can Tho', 12);


CREATE TABLE ContactInfo (
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    PRIMARY KEY (email, phone_number)
);
INSERT INTO ContactInfo (email, phone_number) VALUES ('nguyenvant@gmail.com', '0912345677');
INSERT INTO ContactInfo (email, phone_number) VALUES ('tranthi.h@gmail.com', '0987654320');
INSERT INTO ContactInfo (email, phone_number) VALUES ('lequangv@gmail.com', '0912345679');
INSERT INTO ContactInfo (email, phone_number) VALUES ('phamkimx@gmail.com', '0943216788');
INSERT INTO ContactInfo (email, phone_number) VALUES ('hoangthe.d@gmail.com', '0934567899');
INSERT INTO ContactInfo (email, phone_number)VALUES ('nguyenvana@gmail.com', '090911200');
INSERT INTO ContactInfo (email, phone_number) VALUES ('tranthib@gmail.com', '0987654321');
INSERT INTO ContactInfo (email, phone_number) VALUES ('lehoangc@gmail.com', '0912345678');
INSERT INTO ContactInfo (email, phone_number) VALUES ('phammanhd@gmail.com', '0943216789');
INSERT INTO ContactInfo (email, phone_number) VALUES ('hoangthue@gmail.com', '0934567890');
-- Insert contact info for parents
INSERT INTO ContactInfo (email, phone_number)VALUES ('nguyenvanh@gmail.com', '0912345671');
INSERT INTO ContactInfo (email, phone_number)VALUES ('tranthil@gmail.com', '0987654322');
INSERT INTO ContactInfo (email, phone_number)VALUES ('levanm@gmail.com', '0912345673');
INSERT INTO ContactInfo (email, phone_number)VALUES ('phamthin@gmail.com', '0943216790');
INSERT INTO ContactInfo (email, phone_number)VALUES ('hoangvano@gmail.com', '0934567891');

DELETE FROM contactinfo WHERE email = 'nguyenvana@gmail.com';




commit;


CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR2(100) NOT NULL UNIQUE,
    course_description VARCHAR2(255)
);

-- Insert Course --
INSERT INTO Course (course_id, course_name, course_description)
VALUES (1, 'Mathematics', 'Introduction to basic mathematical concepts and principles.');
INSERT INTO Course (course_id, course_name, course_description)
VALUES (2, 'Physics', 'Fundamentals of physics, including motion, energy, and force.');
INSERT INTO Course (course_id, course_name, course_description)
VALUES (3, 'Chemistry', 'Basic concepts of chemistry, including elements, compounds, and reactions.');
INSERT INTO Course (course_id, course_name, course_description)
VALUES (4, 'History', 'Overview of world history, focusing on major civilizations and events.');
INSERT INTO Course (course_id, course_name, course_description)
VALUES (5, 'English Literature', 'Introduction to English literature, including classic and modern works.');


CREATE TABLE HealthRecord (
    student_id INT NOT NULL,
    record_id INT NOT NULL,
    medical_note VARCHAR2(500),
    allergy VARCHAR2(255),
    PRIMARY KEY (student_id, record_id),
    CONSTRAINT fk_health_record_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE
);
INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy)
VALUES (1, 1, 'History of heart disease, requires regular check-ups.', 'Pollen allergy');
INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy)
VALUES (2, 2, 'Mild shortness of breath during exercise, respiratory monitoring recommended.', 'Seafood allergy');
INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy)
VALUES (3, 3, 'No serious health issues.', 'None');
INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy)
VALUES (4, 4, 'Asthma since childhood, carries inhaler.', 'Dust allergy');
INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy)
VALUES (5, 5, 'Occasional stomach pain, requires dietary accommodations.', 'None');

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
);
-- Insert Has Parent --
INSERT INTO HasParent (parent_id, student_id)
VALUES (1, 1);
INSERT INTO HasParent (parent_id, student_id)
VALUES (2, 2);
INSERT INTO HasParent (parent_id, student_id)
VALUES (3, 3);
INSERT INTO HasParent (parent_id, student_id)
VALUES (4, 4);
INSERT INTO HasParent (parent_id, student_id)
VALUES (5, 5);



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
VALUES (1, 1, 1);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (1, 2, 2);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (2, 1, 2);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (2, 2, 3);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (3, 1, 3);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (3, 2, 4);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (4, 1, 4);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (4, 2, 5);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (5, 1, 5);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (5, 2, 1);

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
drop table ATTends;
-- Insert Attends --
INSERT INTO Attends (student_id, course_id, class_id) VALUES (1, 1, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2, 1, 2);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (3, 1, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2, 2, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (3, 2, 2);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (4, 2, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (3, 3, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (4, 3, 2);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (5, 3, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (4, 4, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (5, 4, 2);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (1, 4, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (5, 5, 1);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (1, 5, 2);
INSERT INTO Attends (student_id, course_id, class_id) VALUES (2, 5, 1);

CREATE TABLE Prerequisite (
    course_id INT NOT NULL,
    prerequisite_course_id INT,
    PRIMARY KEY (course_id, prerequisite_course_id),
    CONSTRAINT fk_prerequisite_course_id FOREIGN KEY (course_id) 
        REFERENCES Course(course_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_prerequisite_prerequisite_course_id FOREIGN KEY (prerequisite_course_id) 
        REFERENCES Course(course_id) 
        ON DELETE CASCADE
);
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES (1, 2);
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES (1, 3);
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES (2, 3);
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES (2, 4);
INSERT INTO Prerequisite (course_id, prerequisite_course_id)
VALUES (3, 5);

CREATE TABLE Classroom (
    building VARCHAR2(50),
    room VARCHAR2(50),
    capacity INT CHECK (capacity > 0),
    PRIMARY KEY (building, room)
);
-- Insert Classroom --
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building A', '1', 30);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building B', '2', 25);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building C', '3', 40);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building D', '4', 15);

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
VALUES (1, 1, 'Textbook', 'Mathematics Essentials', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'John Doe');
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (2, 2, 'Video', 'Understanding Physics Concepts', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Jane Smith');
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (3, 3, 'Article', 'The Basics of Chemistry', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'Dr. Emily Chen');
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (4, 4, 'Presentation', 'History Through the Ages', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Prof. Alan Brown');
INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
VALUES (5, 5, 'Other', 'Classic Literature: A Study Guide', TO_DATE('2023-05-18', 'YYYY-MM-DD'), 'Sara Johnson');
 INSERT INTO Material (material_id, course_id, type, title, author, upload_date)
 VALUES (6, 5, 'Other', 'ABC', 'ABC',TO_DATE('2023-05-18', 'YYYY-MM-DD'));
commit;

CREATE TABLE Exam (
    exam_id INT PRIMARY KEY,
    exam_date DATE,
    exam_type VARCHAR2(20) CHECK (exam_type IN ('midterm','final','quiz')),
    grading_date DATE,
    teacher_id INT NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_exam_teacher_id FOREIGN KEY (teacher_id) 
        REFERENCES Teacher(teacher_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_exam_course_id FOREIGN KEY (course_id) 
        REFERENCES Course(course_id) 
        ON DELETE CASCADE,
    CONSTRAINT chk_exam_date CHECK (grading_date > exam_date)
);
INSERT INTO Exam (exam_id, exam_date, exam_type, grading_date, teacher_id, course_id)
VALUES (1, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'midterm', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 1, 1);
INSERT INTO Exam (exam_id, exam_date, exam_type, grading_date, teacher_id, course_id)
VALUES (2, TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'final', TO_DATE('2024-05-25', 'YYYY-MM-DD'), 2, 2);
INSERT INTO Exam (exam_id, exam_date, exam_type, grading_date, teacher_id, course_id)
VALUES (3, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'quiz', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 3, 3);
INSERT INTO Exam (exam_id, exam_date, exam_type, grading_date, teacher_id, course_id)
VALUES (4, TO_DATE('2024-02-18', 'YYYY-MM-DD'), 'midterm', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 4, 4);
INSERT INTO Exam (exam_id, exam_date, exam_type, grading_date, teacher_id, course_id)
VALUES (5, TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'final', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 5, 5);

CREATE TABLE Takes (
    status VARCHAR2(20) CHECK (status IN ('Pending', 'Completed', 'Absent', 'Graded')),
    grade VARCHAR2(10) CHECK (grade IN ('A', 'B', 'C', 'D', 'E', 'F')),
    score INT CHECK (score BETWEEN 0 AND 100),
    student_id INT NOT NULL,
    exam_id INT NOT NULL,
    PRIMARY KEY (student_id, exam_id),
    CONSTRAINT fk_takes_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_takes_exam_id FOREIGN KEY (exam_id) 
        REFERENCES Exam(exam_id) 
        ON DELETE CASCADE
);

CREATE TABLE Schedules (
    class_id INT NOT NULL,
    course_id INT NOT NULL,
    room VARCHAR2(50) NOT NULL,
    building VARCHAR2(50) NOT NULL,
    PRIMARY KEY (class_id, course_id, room, building),
    CONSTRAINT fk_schedules_class FOREIGN KEY (class_id, course_id) 
        REFERENCES Class(class_id, course_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_schedules_classroom FOREIGN KEY (room, building) 
        REFERENCES Classroom(room, building)
        ON DELETE CASCADE
);
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (1, 1, '1', 'Building A');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (2, 1, '2', 'Building B');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (1, 2, '2', 'Building B');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (2, 2, '3', 'Building C');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (1, 3, '3', 'Building C');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (2, 3, '4', 'Building D');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (1, 4, '4', 'Building D');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (2, 4, '1', 'Building A');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (1, 5, '1', 'Building A');
INSERT INTO Schedules (class_id, course_id, room, building)
VALUES (2, 5, '2', 'Building B');

CREATE TABLE Time (
    class_id INT NOT NULL,
    course_id INT NOT NULL,
    room VARCHAR2(50) NOT NULL,
    building VARCHAR2(50) NOT NULL,
    day_of_week CHAR(9) CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    PRIMARY KEY (class_id, course_id, room, building, day_of_week, start_time, end_time),  
    CONSTRAINT fk_time_schedules FOREIGN KEY (course_id, class_id, room, building) 
        REFERENCES Schedules(course_id, class_id, room, building) 
        ON DELETE CASCADE,
    CONSTRAINT chk_time_order CHECK (end_time > start_time),
    CONSTRAINT uq_time UNIQUE (room, building, day_of_week, start_time, end_time)
);
-- Insert Time --
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (1, 1, '1', 'Building A', 'Monday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (2, 1, '2', 'Building B', 'Tuesday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (1, 2, '2', 'Building B', 'Wednesday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (2, 2, '3', 'Building C', 'Thursday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (1, 3, '3', 'Building C', 'Friday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (2, 3, '4', 'Building D', 'Saturday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (1, 4, '4', 'Building D', 'Monday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (2, 4, '1', 'Building A', 'Tuesday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (1, 5, '1', 'Building A', 'Wednesday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO Time (class_id, course_id, room, building, day_of_week, start_time, end_time)
VALUES (2, 5, '2', 'Building B', 'Thursday', TO_TIMESTAMP('2024-10-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));

CREATE TABLE Specialization(
    teacher_id INT NOT NULL,
    subject VARCHAR2(100) NOT NULL,
    PRIMARY KEY (teacher_id, subject),
    CONSTRAINT fk_specialization_teacher_id FOREIGN KEY (teacher_id)
        REFERENCES Teacher(teacher_id)
        ON DELETE CASCADE
);
-- Insert Specialization --
INSERT INTO Specialization (teacher_id, subject)
VALUES (1, 'Mathematics');
INSERT INTO Specialization (teacher_id, subject)
VALUES (2, 'Physics');
INSERT INTO Specialization (teacher_id, subject)
VALUES (3, 'Chemistry');
INSERT INTO Specialization (teacher_id, subject)
VALUES (4, 'Statistics');
INSERT INTO Specialization (teacher_id, subject)
VALUES (5, 'Literature');


CREATE TABLE Parent (
    parent_id INT PRIMARY KEY,
    fname VARCHAR2(30) NOT NULL,
    lname VARCHAR2(30) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    relationship VARCHAR2(100) CHECK(relationship IN ('Father','Mother','Guardian')),
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    address VARCHAR2(255),
    CONSTRAINT fk_parent_contact_info FOREIGN KEY (email, phone_number) 
        REFERENCES ContactInfo(email, phone_number) 
);

-- Insert Parent --
INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (1, 'Nguyen', 'Van H', 'M', TO_DATE('1975-03-12', 'YYYY-MM-DD'), 'Father', 'nguyenvanh@gmail.com', '0912345671', '123 Duong A, Ha Noi');
INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (2, 'Tran', 'Thi L', 'F', TO_DATE('1980-07-05', 'YYYY-MM-DD'), 'Mother', 'tranthil@gmail.com', '0987654322', '456 Duong B, TP. Ho Chi Minh');
INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (3, 'Le', 'Van M', 'M', TO_DATE('1978-09-22', 'YYYY-MM-DD'), 'Father', 'levanm@gmail.com', '0912345673', '789 Duong C, Da Nang');
INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (4, 'Pham', 'Thi N', 'F', TO_DATE('1982-11-18', 'YYYY-MM-DD'), 'Mother', 'phamthin@gmail.com', '0943216790', '12 Duong D, Hai Phong');
INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (5, 'Hoang', 'Van O', 'M', TO_DATE('1977-04-30', 'YYYY-MM-DD'), 'Guardian', 'hoangvano@gmail.com', '0934567891', '34 Duong E, Can Tho');



SELECT 
    s.student_id, s.fname, s.lname, s.gender, s.DOB, s.email, 
    s.phone_number, s.address, s.GPA, s.status, s.enrollment_year,
    c.course_id, c.class_id, co.course_name
FROM 
    Student s
JOIN 
    Attends a ON s.student_id = a.student_id
JOIN 
    Class c ON a.course_id = c.course_id AND a.class_id = c.class_id
JOIN 
    Course co ON c.course_id = co.course_id
WHERE 
    c.teacher_id = 1
                    
commit;