200-- Insert Students --
INSERT INTO Student (student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES (1, 'Nguyen', 'Van A', 'M', TO_DATE('2005-05-15', 'YYYY-MM-DD'), 'nguyenvana@gmail.com', '0123456789', '123 Duong A, Ha Noi', 3.5, 'active', 2024);
INSERT INTO Student (student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES (2, 'Tran', 'Thi B', 'F', TO_DATE('2006-08-20', 'YYYY-MM-DD'), 'tranthib@gmail.com', '0987654321', '456 Duong B, TP. Ho Chi Minh', 3.8, 'active', 2024);
INSERT INTO Student (student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES (3, 'Le', 'Hoang C', 'M', TO_DATE('2005-02-10', 'YYYY-MM-DD'), 'lehoangc@gmail.com', '0912345678', '789 Duong C, Da Nang', 3.2, 'active', 2023);
INSERT INTO Student (student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES (4, 'Pham', 'Minh D', 'M', TO_DATE('2004-12-25', 'YYYY-MM-DD'), 'phammanhd@gmail.com', '0943216789', '12 Duong D, Hai Phong', 2.9, 'graduated', 2022);
INSERT INTO Student (student_id, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)
VALUES (5, 'Hoang', 'Thu E', 'F', TO_DATE('2005-11-30', 'YYYY-MM-DD'), 'hoangthue@gmail.com', '0934567890', '34 Duong E, Can Tho', 3.6, 'active', 2023);
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
-- Insert Teacher --
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (1, 'Nguyen', 'Van T', 'M', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'nguyenvant@gmail.com', '0912345677', '123 Duong A, Ha Noi', 10);
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (2, 'Tran', 'Thi H', 'F', TO_DATE('1985-08-20', 'YYYY-MM-DD'), 'tranthi.h@gmail.com', '0987654320', '456 Duong B, TP. Ho Ch� Minh', 7);
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (3, 'Le', 'Quang V', 'M', TO_DATE('1978-12-30', 'YYYY-MM-DD'), 'lequangv@gmail.com', '0912345679', '789 Duong C, Da Nang', 15);
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (4, 'Pham', 'Kim X', 'F', TO_DATE('1990-04-18', 'YYYY-MM-DD'), 'phamkimx@gmail.com', '0943216788', '12 Duong D, Hai Ph�ng', 3);
INSERT INTO Teacher (teacher_id, fname, lname, gender, dob, email, phone_number, address, years_of_exp)
VALUES (5, 'Hoang', 'Thi D', 'M', TO_DATE('1982-11-11', 'YYYY-MM-DD'), 'hoangthe.d@gmail.com', '0934567899', '34 Duong E, Can Tho', 12);
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
-- Insert Classroom --
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building A', '1', 30);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building B', '2', 25);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building C', '3', 40);
INSERT INTO Classroom (building, room, capacity)
VALUES ('Building D', '4', 15);
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