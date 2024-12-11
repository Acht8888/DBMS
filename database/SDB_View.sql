-- Teachers view their students
CREATE OR REPLACE VIEW TEACHER_1_STUDENTS AS
SELECT 
    t.teacher_id, 
    t.fname AS teacher_fname, 
    t.lname AS teacher_lname, 
    s.student_id, 
    s.fname AS student_fname, 
    s.lname AS student_lname, 
    s.gender,
    s.DOB,
    s.email,
    s.phone_number,
    s.address,
    s.GPA,
    s.status,
    s.enrollment_year,
    c.course_id, 
    c.class_id
FROM 
    Teacher t
JOIN 
    Class c ON t.teacher_id = c.teacher_id
JOIN 
    Attends a ON c.course_id = a.course_id AND c.class_id = a.class_id
JOIN 
    Student s ON a.student_id = s.student_id
WHERE 
    t.teacher_id = 1;
    
GRANT SELECT ON TEACHER_1_STUDENTS TO C##TEACHER_1;

-- Teachers view their timetable
CREATE OR REPLACE VIEW TEACHER_1_TIMETABLE AS
SELECT 
    t.teacher_id,
    t.fname || ' ' || t.lname AS teacher_name,
    co.course_id,
    co.course_name,
    c.class_id,
    ti.room,
    ti.building,
    ti.day_of_week,
    TO_CHAR(ti.start_time, 'HH24:MI:SS') AS start_time,
    TO_CHAR(ti.end_time, 'HH24:MI:SS') AS end_time
FROM 
    Teacher t
JOIN 
    Class c ON t.teacher_id = c.teacher_id
JOIN 
    Course co ON c.course_id = co.course_id
JOIN
    Time ti ON c.course_id = ti.course_id AND c.class_id = ti.class_id
WHERE 
    t.teacher_id = 1;
    
GRANT SELECT ON TEACHER_1_TIMETABLE TO C##TEACHER_1;

-- Teachers view their personal information
CREATE OR REPLACE VIEW TEACHER_1_INFO AS
SELECT * FROM Teacher WHERE teacher_id = 1;

GRANT SELECT ON TEACHER_1_INFO TO C##TEACHER_1;

-- Teachers view and update exam scores and grades
CREATE OR REPLACE VIEW TEACHER_1_VIEW_UPDATE_EXAM AS
SELECT 
    c.class_id,   
    co.course_id,   
    e.exam_id,
    s.student_id,
    s.fname || ' ' || s.lname AS student_name,
    e.exam_date,
    e.exam_type,
    e.grading_date,
    co.course_name,
    tk.score,
    tk.grade,
    tk.status
FROM 
    Teacher t
JOIN 
    Class c ON t.teacher_id = c.teacher_id
JOIN 
    Course co ON c.course_id = co.course_id
JOIN 
    Exam e ON co.course_id = e.exam_id AND t.teacher_id = e.teacher_id
JOIN
    Takes tk ON e.exam_id = tk.exam_id
JOIN
    Student s ON tk.student_id = s.student_id
WHERE 
    t.teacher_id = 1;

GRANT SELECT ON TEACHER_1_VIEW_UPDATE_EXAM TO C##TEACHER_1;
GRANT UPDATE(score, grade, status) ON TEACHER_1_VIEW_UPDATE_EXAM TO C##TEACHER_1;

-- Teachers view and update material of their courses
CREATE OR REPLACE VIEW TEACHER_1_VIEW_UPDATE_MATERIAL AS
SELECT
    co.course_id,
    co.course_name,
    m.material_id,
    m.type,
    m.title,
    m.upload_date,
    m.author
FROM
    Teacher t
JOIN
    Class c ON t.teacher_id = c.teacher_id
JOIN
    Course co ON c.course_id = co.course_id
JOIN
    Material m ON co.course_id = m.course_id
WHERE
    t.teacher_id = 1;

GRANT SELECT ON TEACHER_1_VIEW_UPDATE_MATERIAL TO C##TEACHER_1;
GRANT UPDATE ON TEACHER_1_VIEW_UPDATE_MATERIAL TO C##TEACHER_1;
GRANT SELECT, UPDATE, INSERT, DELETE ON Material TO C##TEACHER_1;

-- Teachers view their specialization
CREATE OR REPLACE VIEW TEACHER_1_SPECIALIZATION AS
SELECT 
    t.teacher_id,
    t.fname AS first_name,
    t.lname AS last_name,
    s.subject AS specialization_subject
FROM 
    Teacher t
JOIN 
    Specialization s ON t.teacher_id = s.teacher_id
WHERE 
    t.teacher_id = 1;

    
GRANT SELECT ON TEACHER_1_SPECIALIZATION TO C##TEACHER_1;

-- Students view grade and score of their course
CREATE OR REPLACE VIEW STUDENT_VIEW_GRADE_SCORE AS
SELECT
    s.student_id,
    s.fname || ' ' || s.lname AS student_name,
    e.exam_type,
    e.exam_date,
    tk.grade,
    tk.score
FROM
    Student s
JOIN
    Takes tk ON s.student_id = tk.student_id
JOIN
    Exam e ON tk.exam_id = e.exam_id
WHERE
    s.student_id = 1;

GRANT SELECT ON STUDENT_VIEW_GRADE_SCORE TO C##STUDENT_1;

-- Students view their health record
CREATE OR REPLACE VIEW STUDENT_1_HEALTHRECORD AS
SELECT  
    s.student_id,
    s.fname || ' ' || s.lname AS student_name,
    he.record_id,
    he.medical_note,
    he.allergy
FROM
    Student s
JOIN
    Healthrecord he ON s.student_id = he.student_id
WHERE
    s.student_id = 1;

GRANT SELECT ON STUDENT_1_HEALTHRECORD TO C##STUDENT_1;

-- Students view their parents
CREATE OR REPLACE VIEW STUDENT_1_VIEW_PARENT AS
SELECT 
    pa.parent_id,
    pa.fname || ' ' || pa.lname AS parent_name,
    pa.gender,
    pa.dob,
    pa.relationship,
    pa.email,
    pa.phone_number,
    pa.address
FROM
    Student s
JOIN
    Hasparent hp ON s.student_id = hp.student_id
JOIN
    Parent pa ON hp.parent_id = pa.parent_id
WHERE 
    s.student_id =1;
    
GRANT SELECT ON STUDENT_1_VIEW_PARENT TO C##STUDENT_1;

-- Students view courses
CREATE OR REPLACE VIEW STUDENT_VIEW_COURSE AS
SELECT
    course_id,
    course_name,
    course_description
FROM 
    Course;
    
GRANT SELECT ON STUDENT_VIEW_COURSE TO C##STUDENT_1;

-- Students view their courses' material
CREATE OR REPLACE VIEW STUDENT_1_VIEW_MATERIAL AS
SELECT
    co.course_id,
    co.course_name,
    m.material_id,
    m.type,
    m.title,
    m.upload_date,
    m.author
FROM
    Student s
JOIN
    Attends at ON s.student_id = at.student_id
JOIN
    Course co ON at.course_id = co.course_id
JOIN
    Material m ON co.course_id = m.course_id
WHERE
    s.student_id = 1;

GRANT SELECT ON STUDENT_1_VIEW_MATERIAL TO C##STUDENT_1;

-- Students timetable
CREATE OR REPLACE VIEW STUDENT_1_TIMETABLE AS
SELECT 
    a.class_id,
    co.course_id,
    co.course_name,
    ti.room,
    ti.building,
    ti.day_of_week,
    TO_CHAR(ti.start_time, 'HH24:MI:SS') AS start_time,
    TO_CHAR(ti.end_time, 'HH24:MI:SS') AS end_time
FROM 
    Student s
JOIN 
    Attends a ON s.student_id = a.student_id
JOIN
    Course co ON a.course_id = co.course_id
JOIN
    Time ti ON co.course_id = ti.course_id AND a.class_id = ti.class_id
WHERE 
    s.student_id = 1;

GRANT SELECT ON STUDENT_1_TIMETABLE TO C##STUDENT_1;    
    