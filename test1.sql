-- Create the Students table check sql
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    fname VARCHAR2(50) NOT NULL,
    lname VARCHAR2(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    email VARCHAR2(100) UNIQUE,
    phone_number VARCHAR2(15),
    address VARCHAR2(255),
    gpa DECIMAL(3, 2) CHECK (gpa BETWEEN 0 AND 4.0),
    status VARCHAR(20) CHECK (status IN ('active', 'inactive', 'graduated', 'suspended')),
    enrollment_year INT
);


CREATE TABLE Classroom (
    building VARCHAR2(50),
    room VARCHAR2(50),
    capacity INT CHECK (capacity > 0),
    PRIMARY KEY (building, room)
);

CREATE TABLE Material (
    material_id INT,
    course_id INT,
    type VARCHAR2(10),
    title VARCHAR2(10),
    PRIMARY KEY (course_id, material_id),
    CONSTRAINT fk_material_id FOREIGN KEY (course_id)
        REFERENCES Course(course_id)
        ON DELETE CASCADE
)

CREATE TABLE Takes (
    grade VARCHAR2(10),
    score INT,
    student_id INT,
    exam_id INT,
    CONSTRAINT fk_takes_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_takes_exam_id FOREIGN KEY (exam_id) 
        REFERENCES Exam(exam_id) 
        ON DELETE CASCADE
)

CREATE TABLE Exam (
    exam_id INT PRIMARY KEY,
    exam_date DATE,
    exam_type VARCHAR2(20) CHECK (exam_type IN ('midterm','final','quiz')),
    grading_date DATE,
    teacher_id INT,
    course_id INT,
    CONSTRAINT fk_exam_teacher_id FOREIGN KEY (teacher_id) 
        REFERENCES Teacher(teacher_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_exam_course_id FOREIGN KEY (course_id) 
        REFERENCES Course(course_id) 
        ON DELETE CASCADE
)

CREATE TABLE HealthRecord (
    student_id INT,
    record_id INT,
    medical_note VARCHAR2(500),
    allergy VARCHAR2(255),
    PRIMARY KEY (student_id, record_id),
    CONSTRAINT fk_health_record_student FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE
);

CREATE TABLE Parent (
    parent_id INT PRIMARY KEY,
    fname VARCHAR2(50) NOT NULL,
    lname VARCHAR2(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    relationship VARCHAR2(100),
    email VARCHAR2(100) UNIQUE,
    phone_number VARCHAR2(15),
    address VARCHAR2(255)
);

CREATE TABLE HasParent (
    parent_id INT,
    student_id INT,
    PRIMARY KEY (parent_id, student_id),
    CONSTRAINT fk_has_parent_student FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_has_parent_parent FOREIGN KEY (parent_id) 
        REFERENCES Parent(parent_id) 
        ON DELETE CASCADE
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    cname VARCHAR2(100) NOT NULL,
    cdescription VARCHAR2(100)
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

CREATE TABLE Enrolls (
    course_id INT NOT NULL,
    student_id INT NOT NULL,
    PRIMARY KEY (course_id, student_id),
    CONSTRAINT fk_enrolls_course_id FOREIGN KEY (course_id) 
        REFERENCES Course(course_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_enrolls_student_id FOREIGN KEY (student_id) 
        REFERENCES Student(student_id)
        ON DELETE CASCADE
);

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    fname VARCHAR2(50) NOT NULL,
    lname VARCHAR2(50) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    dob DATE,
    email VARCHAR2(100) UNIQUE,
    phone_number VARCHAR2(15),
    address VARCHAR2(255),
    years_of_exp INT CHECK (years_of_exp >= 0)
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

CREATE TABLE Specialization(
    teacher_id INT NOT NULL PRIMARY KEY,
    subject VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_specialization_teacher_id FOREIGN KEY (teacher_id)
        REFERENCES Teacher(teacher_id)
        ON DELETE CASCADE
);

INSERT INTO Student (student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES (1, 'John', 'Doe', 'M', TO_DATE('2002-05-15', 'YYYY-MM-DD'), 'john.doe@example.com', '555-1234', '123 Main St, City, Country', 3.75, 'active', 2020);

INSERT INTO HealthRecord (student_id, record_id, medical_note, allergy)
VALUES (1, 1, 'Routine check-up, no issues found.', 'None');

INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
VALUES (1, 'John', 'Smith', 'M', TO_DATE('1980-03-25', 'YYYY-MM-DD'), 'Father', 'john.smith@example.com', '555-9876', '456 Elm St, City, Country');

INSERT INTO HasParent (parent_id, student_id)
VALUES (1, 1);

INSERT INTO Course (course_id, cname, cdescription) VALUES (1, 'Mathematics 101', 'Introduction to Algebra and Geometry');
INSERT INTO Course (course_id, cname, cdescription) VALUES (2, 'Physics 201', 'Classical Mechanics and Electromagnetism');
INSERT INTO Course (course_id, cname, cdescription) VALUES (3, 'Computer Science 101', 'Basics of Programming and Algorithms');
INSERT INTO Course (course_id, cname, cdescription) VALUES (4, 'History 101', 'World History from Prehistory to the Renaissance');
INSERT INTO Course (course_id, cname, cdescription) VALUES (5, 'Chemistry 101', 'Introduction to Organic and Inorganic Chemistry');

INSERT INTO Prerequisite (course_id, prerequisite_course_id) VALUES (2, 1);
INSERT INTO Prerequisite (course_id, prerequisite_course_id) VALUES (3, 1);
INSERT INTO Prerequisite (course_id, prerequisite_course_id) VALUES (5, 1);
INSERT INTO Prerequisite (course_id, prerequisite_course_id) VALUES (5, 2);

INSERT INTO Enrolls (course_id, student_id) VALUES (3, 1);
INSERT INTO Enrolls (course_id, student_id) VALUES (5, 1);

INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (1, 'John', 'Doe', 'M', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'john.doe@example.com', '123-456-7890', '123 Main St, Cityville', 10);
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (2, 'Jane', 'Smith', 'F', TO_DATE('1985-08-25', 'YYYY-MM-DD'), 'jane.smith@example.com', '+1-987-654-3210', '456 Elm St, Townsville', 8);

INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (1, 1, 1);
INSERT INTO Class (course_id, class_id, teacher_id)
VALUES (1, 2, 2);

INSERT INTO Classroom (building, room, capacity)
VALUES ('A', '101', 3);
INSERT INTO Classroom (building, room, capacity)
VALUES ('B', '202', 50);
INSERT INTO Classroom (building, room, capacity)
VALUES ('C', '303', 25);

DELETE FROM Student
WHERE student_id = '123456789';

DELETE FROM Parent
WHERE parent_id = '987654321';