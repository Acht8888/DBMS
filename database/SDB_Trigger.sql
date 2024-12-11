-- Student-ContactInfo Insert Trigger --
CREATE OR REPLACE TRIGGER trg_student_insert_contact_info
BEFORE INSERT ON Student
FOR EACH ROW
DECLARE
    v_dummy INT;
BEGIN
    BEGIN
        SELECT 1 INTO v_dummy 
        FROM ContactInfo 
        WHERE email = :NEW.email 
          AND phone_number = :NEW.phone_number;       
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ContactInfo (email, phone_number)
            VALUES (:NEW.email, :NEW.phone_number);
    END;
END;

-- Student-ContactInfo Update Trigger --
CREATE OR REPLACE TRIGGER trg_student_update_contact_info
BEFORE UPDATE OF email, phone_number ON Student
FOR EACH ROW
BEGIN
    UPDATE ContactInfo 
    SET email = :NEW.email, phone_number = :NEW.phone_number
    WHERE email = :OLD.email AND phone_number = :OLD.phone_number;
END;

-- Student-ContactInfo Delete Trigger --
CREATE OR REPLACE TRIGGER trg_student_delete_contact_info
BEFORE DELETE ON Student
FOR EACH ROW
BEGIN
    DELETE FROM ContactInfo WHERE email = :OLD.email;
END;

-- Parent-ContactInfo Insert Trigger --
CREATE OR REPLACE TRIGGER trg_parent_insert_contact_info
BEFORE INSERT ON Parent
FOR EACH ROW
DECLARE
    v_dummy INT;
BEGIN
    BEGIN
        SELECT 1 INTO v_dummy 
        FROM ContactInfo 
        WHERE email = :NEW.email 
          AND phone_number = :NEW.phone_number;       
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ContactInfo (email, phone_number)
            VALUES (:NEW.email, :NEW.phone_number);
    END;
END;

-- Parent-ContactInfo Update Trigger --
CREATE OR REPLACE TRIGGER trg_parent_update_contact_info
BEFORE UPDATE OF email, phone_number ON Parent
FOR EACH ROW
BEGIN
    UPDATE ContactInfo 
    SET email = :NEW.email, phone_number = :NEW.phone_number
    WHERE email = :OLD.email AND phone_number = :OLD.phone_number;
END;

-- Parent-ContactInfo Delete Trigger --
CREATE OR REPLACE TRIGGER trg_parent_delete_contact_info
BEFORE DELETE ON Parent
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    DELETE FROM ContactInfo WHERE email = :OLD.email;
END;

-- Teacher-ContactInfo Insert Trigger --
CREATE OR REPLACE TRIGGER trg_teacher_insert_contact_info
BEFORE INSERT ON Teacher
FOR EACH ROW
DECLARE
    v_dummy INT;
BEGIN
    BEGIN
        SELECT 1 INTO v_dummy 
        FROM ContactInfo 
        WHERE email = :NEW.email 
          AND phone_number = :NEW.phone_number;       
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ContactInfo (email, phone_number)
            VALUES (:NEW.email, :NEW.phone_number);
    END;
END;

-- Teacher-ContactInfo Update Trigger --
CREATE OR REPLACE TRIGGER trg_teacher_update_contact_info
BEFORE UPDATE OF email, phone_number ON Teacher
FOR EACH ROW
BEGIN
    -- Update the email in ContactInfo table
    UPDATE ContactInfo 
    SET email = :NEW.email, phone_number = :NEW.phone_number
    WHERE email = :OLD.email AND phone_number = :OLD.phone_number;
END;

-- Teacher-ContactInfo Delete Trigger --
CREATE OR REPLACE TRIGGER trg_teacher_delete_contact_info
BEFORE DELETE ON Teacher
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    DELETE FROM ContactInfo WHERE email = :OLD.email;
END;

-- Student-Exam Takes Trigger --
-- Each time a new exam is added, every student enrolled in the corresponding 
-- course (according to Attends) is automatically added to the Takes table
CREATE OR REPLACE TRIGGER trg_exam_add_students_to_takes
AFTER INSERT ON Exam
FOR EACH ROW
BEGIN
    -- Loop through each student enrolled in the course from the Attends table
    FOR student_rec IN (SELECT student_id FROM Attends WHERE course_id = :NEW.course_id) LOOP
        INSERT INTO Takes (student_id, exam_id)
        VALUES (student_rec.student_id, :NEW.exam_id);
    END LOOP;
END;
