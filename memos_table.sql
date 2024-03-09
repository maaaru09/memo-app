CREATE DATABASE my_memo;

\c my_memo;

CREATE TABLE memos (
    id SERIAL NOT NULL,
    title VARCHAR NOT NULL,
    content VARCHAR NOT NULL,
    PRIMARY KEY (id)
);
