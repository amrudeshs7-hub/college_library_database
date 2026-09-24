-- =========================================================
-- COLLEGE LIBRARY DATABASE PROJECT
-- Database: college_library
-- =========================================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS college_library;

USE college_library;


-- =========================================================
-- 2. CREATE BOOKS TABLE
-- =========================================================

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(60) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    total_copies INT NOT NULL CHECK (total_copies > 0),
    available_copies INT NOT NULL CHECK (available_copies >= 0)
);


-- =========================================================
-- 3. CREATE MEMBERS TABLE
-- =========================================================

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    course VARCHAR(50) NOT NULL,
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(120) UNIQUE
);


-- =========================================================
-- 4. CREATE TRANSACTIONS TABLE
-- =========================================================

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('ISSUED', 'RETURNED') NOT NULL DEFAULT 'ISSUED',

    FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
);


-- =========================================================
-- 5. INSERT BOOK RECORDS
-- =========================================================

INSERT INTO books
(title, author, category, isbn, total_copies, available_copies)
VALUES
('Python Programming', 'Mark Lutz', 'Programming',
 '9781449355739', 5, 4),

('Database System Concepts', 'Silberschatz', 'Database',
 '9780078022159', 4, 4),

('Clean Code', 'Robert C. Martin', 'Programming',
 '9780132350884', 3, 2),

('Data Science from Scratch', 'Joel Grus', 'Data Science',
 '9781492041139', 2, 2);


-- =========================================================
-- 6. INSERT MEMBER RECORDS
-- =========================================================

INSERT INTO members
(name, course, semester, phone, email)
VALUES
('Arun Kumar', 'BCA', 5, '9876543210',
 'arun@example.com'),

('Meera S', 'BCA', 5, '9876543211',
 'meera@example.com'),

('Rahul P', 'BCA', 3, '9876543212',
 'rahul@example.com');


-- =========================================================
-- 7. INSERT TRANSACTION RECORDS
-- =========================================================

INSERT INTO transactions
(book_id, member_id, issue_date, due_date, return_date, status)
VALUES
(1, 1, '2026-09-10', '2026-09-24', NULL, 'ISSUED'),

(3, 2, '2026-09-12', '2026-09-26', NULL, 'ISSUED'),

(2, 3, '2026-09-01', '2026-09-15',
 '2026-09-14', 'RETURNED');


-- =========================================================
-- 8. DISPLAY ALL BOOKS
-- =========================================================

SELECT * FROM books;


-- =========================================================
-- 9. DISPLAY ALL MEMBERS
-- =========================================================

SELECT * FROM members;


-- =========================================================
-- 10. DISPLAY ALL TRANSACTIONS
-- =========================================================

SELECT * FROM transactions;


-- =========================================================
-- 11. SELECT AVAILABLE BOOKS
-- =========================================================

SELECT
    book_id,
    title,
    author,
    available_copies
FROM books;


-- =========================================================
-- 12. SEARCH BOOK BY CATEGORY
-- =========================================================

SELECT *
FROM books
WHERE category = 'Programming';


-- =========================================================
-- 13. SORT BOOKS BY TITLE
-- =========================================================

SELECT
    title,
    author
FROM books
ORDER BY title ASC;


-- =========================================================
-- 14. SEARCH BOOK USING LIKE
-- =========================================================

SELECT
    book_id,
    title,
    author
FROM books
WHERE title LIKE '%Python%';


-- =========================================================
-- 15. SEARCH BY AUTHOR
-- =========================================================

SELECT
    book_id,
    title,
    author
FROM books
WHERE author LIKE '%Martin%';


-- =========================================================
-- 16. SEARCH BY CATEGORY
-- =========================================================

SELECT
    book_id,
    title,
    category
FROM books
WHERE category = 'Database';


-- =========================================================
-- 17. BOOKS WITH 2 TO 5 COPIES
-- =========================================================

SELECT
    title,
    total_copies
FROM books
WHERE total_copies BETWEEN 2 AND 5;


-- =========================================================
-- 18. COUNT TOTAL BOOK TITLES
-- =========================================================

SELECT COUNT(*) AS total_books
FROM books;


-- =========================================================
-- 19. TOTAL NUMBER OF COPIES
-- =========================================================

SELECT SUM(total_copies) AS total_copies
FROM books;


-- =========================================================
-- 20. AVERAGE NUMBER OF COPIES
-- =========================================================

SELECT AVG(total_copies) AS average_copies
FROM books;


-- =========================================================
-- 21. MAXIMUM NUMBER OF COPIES
-- =========================================================

SELECT MAX(total_copies) AS maximum_copies
FROM books;


-- =========================================================
-- 22. MINIMUM NUMBER OF COPIES
-- =========================================================

SELECT MIN(total_copies) AS minimum_copies
FROM books;


-- =========================================================
-- 23. GROUP BY CATEGORY
-- =========================================================

SELECT
    category,
    COUNT(*) AS number_of_titles
FROM books
GROUP BY category
ORDER BY number_of_titles DESC;


-- =========================================================
-- 24. GROUP BY TRANSACTION STATUS
-- =========================================================

SELECT
    status,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY status;


-- =========================================================
-- 25. INNER JOIN
-- SHOW MEMBER + BOOK + TRANSACTION
-- =========================================================

SELECT
    t.transaction_id,
    m.name AS member_name,
    b.title AS book_title,
    t.issue_date,
    t.due_date,
    t.status
FROM transactions t
INNER JOIN members m
    ON t.member_id = m.member_id
INNER JOIN books b
    ON t.book_id = b.book_id;


-- =========================================================
-- 26. BOOK AVAILABILITY
-- =========================================================

SELECT
    book_id,
    title,
    total_copies,
    available_copies,
    CASE
        WHEN available_copies > 0
            THEN 'AVAILABLE'
        ELSE 'NOT AVAILABLE'
    END AS availability
FROM books;


-- =========================================================
-- 27. OVERDUE BOOKS
-- =========================================================

SELECT
    t.transaction_id,
    m.name AS member_name,
    b.title AS book_title,
    t.due_date,
    DATEDIFF(CURRENT_DATE, t.due_date) AS days_overdue
FROM transactions t
INNER JOIN members m
    ON t.member_id = m.member_id
INNER JOIN books b
    ON t.book_id = b.book_id
WHERE t.status = 'ISSUED'
AND t.due_date < CURRENT_DATE;


-- =========================================================
-- 28. INSERT NEW MEMBER
-- =========================================================

INSERT INTO members
(name, course, semester, phone, email)
VALUES
('Anjali R', 'BCA', 5, '9876543213',
 'anjali@example.com');


-- =========================================================
-- 29. UPDATE MEMBER
-- =========================================================

UPDATE members
SET phone = '9999999999'
WHERE member_id = 1;


-- =========================================================
-- 30. RETURN A BOOK
-- =========================================================

UPDATE transactions
SET
    return_date = CURRENT_DATE,
    status = 'RETURNED'
WHERE transaction_id = 1;


-- =========================================================
-- 31. DELETE MEMBER
-- =========================================================

-- Use only if the member has no dependent transactions.
-- DELETE FROM members
-- WHERE member_id = 4;


-- =========================================================
-- 32. CHECK FINAL DATA
-- =========================================================

SELECT * FROM books;

SELECT * FROM members;

SELECT * FROM transactions;