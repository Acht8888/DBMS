CREATE TABLE ContactInfo (
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone_number VARCHAR2(15) UNIQUE NOT NULL,
    PRIMARY KEY (email, phone_number)
);

CREATE TABLE Student (
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
    CONSTRAINT chk_student_enrollment_year CHECK (enrollment_year >= EXTRACT(YEAR FROM dob) + 18)
);

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
);

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

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR2(100) NOT NULL UNIQUE,
    course_description VARCHAR2(255)
);

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

CREATE TABLE Classroom (
    building VARCHAR2(50),
    room VARCHAR2(50),
    capacity INT CHECK (capacity > 0),
    PRIMARY KEY (building, room)
);

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

CREATE TABLE Specialization(
    teacher_id INT NOT NULL,
    subject VARCHAR2(100) NOT NULL,
    PRIMARY KEY (teacher_id, subject),
    CONSTRAINT fk_specialization_teacher_id FOREIGN KEY (teacher_id)
        REFERENCES Teacher(teacher_id)
        ON DELETE CASCADE
);