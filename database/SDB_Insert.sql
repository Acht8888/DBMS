-- Insert Users --
INSERT INTO Users (username, password, user_role) VALUES ('huy', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('phong', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('duy', '123', 'admin');
INSERT INTO Users (username, password, user_role) VALUES ('mai_lan', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('long_van', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('hoa_pham', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('tuan_hoang', '123', 'student');
INSERT INTO Users (username, password, user_role) VALUES ('teacher1', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('teacher2', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('teacher3', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('teacher4', '123', 'teacher');
INSERT INTO Users (username, password, user_role) VALUES ('teacher5', '123', 'teacher');
COMMIT;

-- Insert Students --
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('huy', 1, 'Tran', 'Duy Duc Huy', 'M', TO_DATE('2004-06-30', 'YYYY-MM-DD'), 'huy@gmail.com', '0123456789', '123 Duong A, Ho Chi Minh', 3.00, 'active', 2022);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('mai_lan', 2, 'Nguyen', 'Thi Mai Lan', 'F', TO_DATE('2003-04-15', 'YYYY-MM-DD'), 'mai.lan@example.com', '0123456790', '456 Duong B, Hanoi', 3.75, 'active', 2021);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('long_van', 3, 'Le', 'Van Long', 'M', TO_DATE('2002-09-10', 'YYYY-MM-DD'), 'long.van@example.com', '0123456791', '789 Duong C, Da Nang', 2.85, 'inactive', 2020);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('hoa_pham', 4, 'Pham', 'Thi Hoa', 'F', TO_DATE('2005-12-05', 'YYYY-MM-DD'), 'hoa.pham@example.com', '0123456792', '321 Duong D, Hai Phong', 3.50, 'active', 2023);
INSERT INTO Student (username, student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year) 
VALUES ('tuan_hoang', 5, 'Hoang', 'Minh Tuan', 'M', TO_DATE('2001-07-20', 'YYYY-MM-DD'), 'tuan.hoang@example.com', '0123456793', '654 Duong E, Can Tho', 3.20, 'graduated', 2019);
COMMIT;

-- Insert Teacher --
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp) 
VALUES ('teacher1', 1, 'Nguyen', 'Van A', 'M', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'a.nguyen@example.com', '0987654321', '123 Nguyen Trai, Hanoi', 15);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp) 
VALUES ('teacher2', 2, 'Le', 'Thi B', 'F', TO_DATE('1985-07-22', 'YYYY-MM-DD'), 'b.le@example.com', '0987654322', '456 Le Loi, Ho Chi Minh City', 10);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp) 
VALUES ('teacher3', 3, 'Pham', 'Van C', 'M', TO_DATE('1975-03-10', 'YYYY-MM-DD'), 'c.pham@example.com', '0987654323', '789 Pham Ngu Lao, Da Nang', 20);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp) 
VALUES ('teacher4', 4, 'Tran', 'Thi D', 'F', TO_DATE('1990-12-05', 'YYYY-MM-DD'), 'd.tran@example.com', '0987654324', '321 Tran Hung Dao, Hai Phong', 5);
INSERT INTO Teacher (username, teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp) 
VALUES ('teacher5', 5, 'Hoang', 'Van E', 'M', TO_DATE('1982-08-18', 'YYYY-MM-DD'), 'e.hoang@example.com', '0987654325', '654 Hoang Hoa Tham, Can Tho', 12);
COMMIT;

-- Insert Health Record --
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
COMMIT;

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
COMMIT;

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
COMMIT;

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
COMMIT;

-- Insert Presequisite --
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
COMMIT;

-- Insert Class --
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
COMMIT;

-- Insert Classroom --
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building A', '1', 30);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building B', '2', 25);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building C', '3', 40);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building D', '4', 15);
COMMIT;

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
COMMIT;

-- Insert Material --
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
COMMIT;

-- Insert Exam --
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
COMMIT;

-- Insert Schedules --
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
COMMIT;

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
COMMIT;

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
COMMIT;
