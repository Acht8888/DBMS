SELECT * FROM C##BTL.TEACHER_1_STUDENTS;
SELECT * FROM C##BTL.TEACHER_1_TIMETABLE;
SELECT * FROM C##BTL.TEACHER_1_INFO;
SELECT * FROM C##BTL.TEACHER_1_VIEW_UPDATE_EXAM;

BEGIN
    UPDATE C##BTL.TEACHER_1_VIEW_UPDATE_EXAM
    SET score = 90, grade = 'A'
    WHERE student_id = 1;
    COMMIT;
END;

SELECT * FROM C##BTL.TEACHER_VIEW_ALL_CLASSROOM;
SELECT * FROM C##BTL.TEACHER_1_VIEW_UPDATE_MATERIAL;

INSERT INTO C##BTL.Material (material_id, course_id, type, title, upload_date, author)
VALUES (6, 1, 'Textbook', '1 + 1 = 2', TO_DATE('2023-07-18', 'YYYY-MM-DD'), 'Mark John');

DELETE 
FROM C##BTL.Material 
WHERE material_id = 6;

SELECT * FROM C##BTL.TEACHER_1_SPECIALIZATION;