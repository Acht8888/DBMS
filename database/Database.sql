-- System privileges granted to users --
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE LIKE '%C##%';
-- System privileges granted to roles --
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE LIKE '%C##%';
-- Roles granted to users and roles --
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE LIKE '%C##%';
-- List all the users --
SELECT * FROM DBA_USERS WHERE USERNAME LIKE '%C##%';
-- List all the roles --
SELECT * FROM DBA_ROLES WHERE ROLE LIKE '%C##%';

-- Create roles --
CREATE ROLE c##admin_role;
CREATE ROLE c##teacher_role;
CREATE ROLE c##student_role;
CREATE ROLE c##parent_role;

-- Grant permissions to roles
-- admin_role
GRANT ALL PRIVILEGES TO c##admin_role;
GRANT ALL PRIVILEGES TO c##btl;

-- teacher_role
GRANT SELECT ON c##btl.teacher TO c##teacher_role;
GRANT CREATE SESSION TO c##teacher_role;
-- student_role
GRANT SELECT ON c##btl.student TO c##student_role;
GRANT CREATE SESSION TO c##student_role;

-- Create C##BTL --
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'c##btl';
CREATE USER c##btl IDENTIFIED BY "1234";
GRANT c##admin_role TO c##btl;
ALTER USER c##btl quota unlimited on USERS;
REVOKE ALL PRIVILEGES FROM c##btl;

-- Teacher_1 --
-- GRANT INSERT, UPDATE, DELETE, SELECT ON schema_name.* TO teacher_username; --
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'c##teacher_1';
CREATE USER c##teacher_1 IDENTIFIED BY "1234";
GRANT c##teacher_role TO c##teacher_1;
REVOKE ALL PRIVILEGES FROM c##teacher_1;
DROP USER c##teacher_1 CASCADE;

-- Student_1 --
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'c##student_1';
CREATE USER c##student_1 IDENTIFIED BY "1234";
GRANT c##student_role TO c##student_1;
REVOKE ALL PRIVILEGES FROM c##teacher_1;
DROP USER c##teacher_1 CASCADE;

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
SELECT * FROM DBA_FGA_AUDIT_TRAIL;

-- Class --
CREATE USER c##class IDENTIFIED BY "1234";
GRANT c##admin_role TO c##btl;
GRANT CREATE SESSION TO c##class;