CREATE ROLE test_conn ENCRYPTED PASSWORD 'test_conn' LOGIN;
CREATE DATABASE test_conn OWNER = test_conn;
GRANT ALL ON DATABASE test_conn TO test_conn;

\c test_conn;

CREATE TABLE IF NOT EXISTS test(
    id   NUMERIC(6) PRIMARY KEY,
    name CHAR(10)
);
ALTER TABLE test OWNER TO test_conn;

BEGIN;
DELETE FROM test;
INSERT INTO test VALUES(1, 'test');
COMMIT;
