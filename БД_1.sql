-- Создание базы данных
CREATE DATABASE university;

-- Использование созданной базы данных
USE university;

-- Создание таблицы Студенты
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    birth_date DATE NOT NULL,
    contact_info VARCHAR(100),
    enrollment_date DATE NOT NULL
);

-- Создание таблицы Преподаватели
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    birth_date DATE NOT NULL,
    contact_info VARCHAR(100),
    hire_date DATE NOT NULL
);

-- Создание таблицы Курсы
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    teacher_id INT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

-- Создание таблицы Записи о курсах
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Создание таблицы Оценки
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    grade FLOAT CHECK (grade >= 1 AND grade <= 5) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);
SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Название_предмета';
SELECT c.course_name
FROM Courses c
JOIN Teachers t ON c.teacher_id = t.teacher_id
WHERE t.first_name = 'Имя' AND t.last_name = 'Фамилия';
SELECT AVG(g.grade) AS average_grade
FROM Grades g
JOIN Enrollments e ON g.enrollment_id = e.enrollment_id
JOIN Students s ON e.student_id = s.student_id
WHERE s.first_name = 'Имя' AND s.last_name = 'Фамилия';
SELECT t.first_name, t.last_name, AVG(g.grade) AS average_grade
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY t.teacher_id
ORDER BY average_grade DESC;
SELECT t.first_name, t.last_name
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE c.teacher_id IS NOT NULL AND c.course_id IN (
    SELECT course_id
    FROM Courses
    WHERE YEAR(hire_date) >= YEAR(CURDATE()) - 1
)
GROUP BY t.teacher_id
HAVING COUNT(c.course_id) > 3;
SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY s.student_id
HAVING AVG(CASE WHEN c.course_name LIKE '%математика%' THEN g.grade END) > 4
   AND AVG(CASE WHEN c.course_name LIKE '%гуманитарный%' THEN g.grade END) < 3;
SELECT c.course_name, COUNT(g.grade) AS count_of_twos
FROM Grades g
JOIN Enrollments e ON g.enrollment_id = e.enrollment_id
JOIN Courses c ON e.course_id = c.course_id
WHERE g.grade = 2 AND e.enrollment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.course_name
ORDER BY count_of_twos DESC;
SELECT s.first_name, s.last_name, t.first_name AS teacher_first_name, t.last_name AS teacher_last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Teachers t ON c.teacher_id = t.teacher_id
WHERE g.grade = 5;
SELECT YEAR(e.enrollment_date) AS year, AVG(g.grade) AS average_grade
FROM Enrollments e
JOIN Grades g ON e.enrollment_id = g.enrollment_id
WHERE e.student_id = (SELECT student_id FROM Students WHERE first_name = 'Имя' AND last_name = 'Фамилия')
GROUP BY YEAR(e.enrollment_date)
ORDER BY year;
SELECT e.course_id, AVG(g.grade) AS average_grade
FROM Enrollments e
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY e.course_id
HAVING average_grade > (SELECT AVG(g2.grade)
                         FROM Enrollments e2
                         JOIN Grades g2 ON e2.enrollment_id = g2.enrollment_id
                         WHERE e2.course_id = e.course_id);
INSERT INTO Students (first_name, last_name, middle_name, birth_date, contact_info, enrollment_date)
VALUES ('Иван', 'Иванов', 'Иванович', '2003-12-12', '000000', '2025-02-03');

SELECT s.first_name, s.last_name, AVG(g.grade) AS average_grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;
SELECT t.first_name, t.last_name, AVG(g.grade) AS average_grade
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY t.teacher_id
ORDER BY average_grade DESC;
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Название_предмета';
SELECT c.course_name
FROM Courses c
JOIN Teachers t ON c.teacher_id = t.teacher_id
WHERE t.first_name = 'Имя' AND t.last_name = 'Фамилия';

SELECT AVG(g.grade) AS average_grade
FROM Grades g
JOIN Enrollments e ON g.enrollment_id = e.enrollment_id
JOIN Students s ON e.student_id = s.student_id
WHERE s.first_name = 'Имя' AND s.last_name = 'Фамилия';

SELECT t.first_name, t.last_name, AVG(g.grade) AS average_grade
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY t.teacher_id
ORDER BY average_grade DESC;

SELECT t.first_name, t.last_name
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE YEAR(t.hire_date) >= YEAR(CURDATE()) - 1
GROUP BY t.teacher_id
HAVING COUNT(c.course_id) > 3;

SELECT t.first_name, t.last_name
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE YEAR(c.hire_date) >= YEAR(CURDATE()) - 1
GROUP BY t.teacher_id
HAVING COUNT(c.course_id) > 3;

SELECT t.first_name, t.last_name
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE YEAR(t.hire_date) >= YEAR(CURDATE()) - 1
GROUP BY t.teacher_id
HAVING COUNT(c.course_id) > 3;

SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY s.student_id
HAVING AVG(CASE WHEN c.course_name LIKE '%математика%' THEN g.grade END) > 4
   AND AVG(CASE WHEN c.course_name LIKE '%гуманитарный%' THEN g.grade END) < 3;

SELECT c.course_name, COUNT(g.grade) AS count_of_twos
FROM Grades g
JOIN Enrollments e ON g.enrollment_id = e.enrollment_id
JOIN Courses c ON e.course_id = c.course_id
WHERE g.grade = 2
AND e.enrollment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.course_name
ORDER BY count_of_twos DESC;

SELECT s.first_name, s.last_name, t.first_name AS teacher_first_name, t.last_name AS teacher_last_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrollment_id = g.enrollment_id
JOIN Courses c ON e.course_id = c.course_id
JOIN Teachers t ON c.teacher_id = t.teacher_id
WHERE g.grade = 5;

SELECT YEAR(e.enrollment_date) AS year, AVG(g.grade) AS average_grade
FROM Enrollments e
JOIN Grades g ON e.enrollment_id = g.enrollment_id
WHERE e.student_id = (SELECT student_id FROM Students WHERE first_name = 'Имя' AND last_name = 'Фамилия')
GROUP BY YEAR(e.enrollment_date)
ORDER BY year;

SELECT e.course_id, AVG(g.grade) AS average_grade
FROM Enrollments e
JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY e.course_id
HAVING average_grade > (SELECT AVG(g2.grade)
                         FROM Enrollments e2
                         JOIN Grades g2 ON e2.enrollment_id = g2.enrollment_id
                         WHERE e2.course_id = e.course_id);



INSERT INTO Students (first_name, last_name, middle_name, birth_date, contact_info, enrollment_date)
VALUES ('Анна', 'Смирнова', 'Ивановна', '2001-05-15', 'anna@example.com', '2023-09-01');



## Документация по структуре базы данных

### Общая информация

Данная база данных предназначена для учета студентов, преподавателей, курсов и оценок в учебном заведении. Она включает в себя несколько таблиц, каждая из которых соответствует определенной сущности. Основные таблицы: Students, Teachers, Courses, Enrollments и Grades.

### Описание таблиц

#### 1. Таблица Students
- Описание: Хранит информацию о студентах.
- Атрибуты:
  - student_id (INT, PRIMARY KEY, AUTOINCREMENT): Уникальный идентификатор студента.
  - `firstname (VARCHAR(50), NOT NULL): Имя студента.
  - lastname` (VARCHAR(50), NOT NULL): Фамилия студента.
  - `middlename (VARCHAR(50)): Отчество студента.
  - birthdate` (DATE, NOT NULL): Дата рождения студента.
  - `contactinfo (VARCHAR(100)): Контактные данные студента.
  - enrollmentdate` (DATE, NOT NULL): Дата зачисления студента.

#### 2. Таблица `Teachers`
- **Описание**: Хранит информацию о преподавателях.
- **Атрибуты**:
  - `teacherid (INT, PRIMARY KEY, AUTO_INCREMENT): Уникальный идентификатор преподавателя.
  - firstname` (VARCHAR(50), NOT NULL): Имя преподавателя.
  - `lastname (VARCHAR(50), NOT NULL): Фамилия преподавателя.
  - middlename` (VARCHAR(50)): Отчество преподавателя.
  - `birthdate (DATE, NOT NULL): Дата рождения преподавателя.
  - contactinfo` (VARCHAR(100)): Контактные данные преподавателя.
  - `hiredate (DATE, NOT NULL): Дата приема на работу преподавателя.

#### 3. Таблица Courses
- **Описание**: Хранит информацию о курсах.
- **Атрибуты**:
  - courseid` (INT, PRIMARY KEY, AUTOINCREMENT): Уникальный идентификатор курса.
  - course_name (VARCHAR(100), NOT NULL, UNIQUE): Название курса.
  - description (TEXT): Описание курса.
  - teacher_id (INT, NOT NULL): Идентификатор преподавателя, который ведет курс (внешний ключ).

#### 4. Таблица Enrollments
- Описание: Хранит записи о зачислении студентов на курсы.
- Атрибуты:
  - enrollment_id (INT, PRIMARY KEY, AUTOINCREMENT): Уникальный идентификатор записи о зачислении.
  - `studentid (INT, NOT NULL): Идентификатор студента (внешний ключ).
  - courseid` (INT, NOT NULL): Идентификатор курса (внешний ключ).
  - `enrollmentdate (DATE, NOT NULL): Дата зачисления на курс.

#### 5. Таблица Grades
- **Описание**: Хранит информацию об оценках студентов.
- **Атрибуты**:
  - gradeid` (INT, PRIMARY KEY, AUTOINCREMENT): Уникальный идентификатор оценки.
  - enrollment_id (INT, NOT NULL): Идентификатор записи о зачислении (внешний ключ).
  - grade (FLOAT, CHECK (grade >= 1 AND grade <= 5), NOT NULL): Оценка, которая должна находиться в диапазоне от 1 до 5.
  - date (DATE, NOT NULL): Дата выставления оценки.

### Отношения между таблицами

- Students и Enrollments: Один студент может быть зачислен на несколько курсов (отношение один-ко-многим).
- Teachers и Courses: Один преподаватель может вести несколько курсов, но каждый курс ведет только один преподаватель (отношение один-ко-многим).
- Courses и Enrollments: Один курс может иметь множество студентов, но одна запись о зачислении относится только к одному курсу (отношение один-ко-многим).
- Enrollments и Grades: На каждый курс может быть выставлено несколько оценок, но каждая оценка относится только к одной записи о зачислении (отношение один-ко-многим).









