DROP TABLE IF EXISTS books1;
CREATE TABLE books1 (
    book_number INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    isbn TEXT NOT NULL UNIQUE,
    publication_date DATE NOT NULL,
    pages INTEGER
);
INSERT INTO books1
VALUES (1, 'Harry Potter and the Philosopher''s Stone', '0-7475-3269-9',TO_DATE('1997-06-26', 'YYYY-MM-DD'),223), 
(2, 'Harry Potter and the Chamber of Secrets','0-7475-3849-2',TO_DATE('1998-07-02', 'YYYY-MM-DD'),251),
(3, 'Harry Potter and the Prisoner of Azkaban', '0-7475-4215-5',TO_DATE('1999-07-08', 'YYYY-MM-DD'),317), 
(4, 'Harry Potter and the Goblet of Fire', '0-7475-4624-X',TO_DATE('2000-07-08', 'YYYY-MM-DD'),636),
(5, 'Harry Potter and the Order of the Phoenix', '0-7475-5100-6',TO_DATE('2003-06-21', 'YYYY-MM-DD'),766), 
(6, 'Harry Potter and the Half-Blood Prince', '0-7475-8108-8',TO_DATE('2005-07-16', 'YYYY-MM-DD'),607),
(7, 'Harry Potter and the Deathly Hallows','0-545-01022-5',TO_DATE('2007-07-21', 'YYYY-MM-DD'),607), 
(8, 'Harry Potter and the Bunnies of Doom','1-234-56789-0',TO_DATE('2010-01-15', 'YYYY-MM-DD'), NULL);
DELETE FROM books1 WHERE book_number = 8;
SELECT * FROM books1;
DROP TABLE IF EXISTS books2;
CREATE TABLE books2(
    us_book_number INTEGER PRIMARY KEY,
    us_publication_date DATE NOT NULL,
    us_pages INTEGER
);
INSERT INTO books2 SELECT * FROM public.project3_us_books;
SELECT * FROM books2;
DROP TABLE IF EXISTS books;
CREATE TABLE books(
    book_number INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    isbn TEXT NOT NULL,
    publication_date DATE NOT NULL,
    pages INTEGER,
    us_title TEXT,
    us_publication_date DATE,
    us_pages INTEGER
);
INSERT INTO books SELECT o.book_number, o.title, o.isbn, o.publication_date,
o.pages, NULL, t.us_publication_date, t.us_pages
FROM books1 AS o, books2 AS t
WHERE o.book_number = t.us_book_number;
UPDATE books SET us_title = title;
UPDATE books SET us_title = 'Harry Potter and the Sorcerer''s Stone' WHERE book_number = 1;
SELECT * FROM books ORDER BY book_number ASC;