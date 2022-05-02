CREATE ROLE matrix;
ALTER ROLE matrix WITH PASSWORD 'password';
ALTER ROLE matrix WITH LOGIN;
CREATE DATABASE matrix_bdd ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' template=template0 OWNER matrix;
GRANT ALL PRIVILEGES ON DATABASE matrix_bdd TO matrix;