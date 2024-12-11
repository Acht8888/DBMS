-- Parent-Student HasParent Procedure --
CREATE OR REPLACE TYPE student_id_array AS TABLE OF INT;
CREATE OR REPLACE PROCEDURE insert_parent_with_students (
    p_parent_id INT,
    p_fname VARCHAR2,
    p_lname VARCHAR2,
    p_gender CHAR,
    p_dob DATE,
    p_relationship VARCHAR2,
    p_email VARCHAR2,
    p_phone_number VARCHAR2,
    p_address VARCHAR2,
    p_student_ids student_id_array
) AS
BEGIN
    INSERT INTO Parent (parent_id, fname, lname, gender, dob, relationship, email, phone_number, address)
    VALUES (p_parent_id, p_fname, p_lname, p_gender, p_dob, p_relationship, p_email, p_phone_number, p_address);
    FOR i IN 1 .. p_student_ids.COUNT LOOP
        INSERT INTO HasParent (parent_id, student_id) VALUES (p_parent_id, p_student_ids(i));
    END LOOP;
    COMMIT;
END;

DECLARE
    student_ids student_id_array := student_id_array(1, 2);
BEGIN
    insert_parent_with_students(1, 'Nguyen', 'Van H', 'M', TO_DATE('1975-03-12', 'YYYY-MM-DD'), 
    'Father', 'nguyenvanh@gmail.com', '0912345671', '123 Duong A, Ha Noi', student_ids);
END;

DROP PROCEDURE insert_parent_with_students;
DROP TYPE student_id_array;