FROM postgres:12.1
ADD CreateDB.sql /docker-entrypoint-initdb.d/