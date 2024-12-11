CREATE OR REPLACE FUNCTION get_student_grade (p_student_id IN NUMBER, p_subject_id IN NUMBER)
RETURN NUMBER
IS
    v_grade NUMBER;
BEGIN
    SELECT grade
    INTO v_grade
    FROM TAKES
    WHERE student_id = p_student_id AND subject_id = p_subject_id;

    RETURN v_grade;
END;
