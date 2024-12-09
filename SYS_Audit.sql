AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY C##TEACHER_1 BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY c##STUDENT_1 BY ACCESS;

SELECT username, extended_timestamp, owner, obj_name, action, action_name, returncode
FROM DBA_AUDIT_TRAIL
WHERE owner = 'C##BTL'
ORDER BY timestamp DESC;

 -- Use caution with this command
DELETE FROM SYS.AUD$;
COMMIT;