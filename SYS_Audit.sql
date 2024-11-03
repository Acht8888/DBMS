-- FGA --
BEGIN
    DBMS_FGA.ADD_POLICY(
        object_schema   => 'C##BTL',
        object_name     => 'Teacher', 
        policy_name     => 'audit_teacher_all_columns',
        audit_condition => NULL,
        audit_column    => NULL,
        enable          => TRUE,
        statement_types => 'SELECT,INSERT,UPDATE,DELETE'
    );
END;
BEGIN
    DBMS_FGA.DISABLE_POLICY(
        object_schema => 'C##BTL',
        object_name   => 'Teacher',
        policy_name   => 'audit_teacher_all_columns'
    );
END;
SELECT * FROM DBA_FGA_AUDIT_TRAIL;

AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY C##TEACHER_1 BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY c##student_1 BY ACCESS;

SELECT username, extended_timestamp, owner, obj_name, action, action_name, returncode
FROM DBA_AUDIT_TRAIL
WHERE owner = 'C##BTL'
ORDER BY timestamp DESC;

 -- Use caution with this command
DELETE FROM SYS.AUD$;
COMMIT;