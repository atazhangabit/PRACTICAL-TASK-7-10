-- =====================================================================
-- Practical Work 7-10: SQL Queries and JOIN
-- University Educational Process database (from Practical Works 1-2)
-- Environment: SQLite (DB Browser for SQLite / SQLiteStudio)
-- How to run: open university.db and run the queries below,
--             or run this whole file in an empty database.
-- =====================================================================

-- ---------- 1. CREATE TABLES ----------
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Schedule;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Classrooms;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
    department_id   INTEGER PRIMARY KEY,
    department_name TEXT NOT NULL,
    office_number   TEXT,
    phone           TEXT
);

CREATE TABLE Groups (
    group_id      INTEGER PRIMARY KEY,
    group_name    TEXT NOT NULL UNIQUE,
    study_year    INTEGER CHECK (study_year BETWEEN 1 AND 4),
    department_id INTEGER NOT NULL REFERENCES Departments(department_id)
);

CREATE TABLE Teachers (
    teacher_id    INTEGER PRIMARY KEY,
    first_name    TEXT NOT NULL,
    last_name     TEXT NOT NULL,
    email         TEXT UNIQUE,
    phone         TEXT,
    department_id INTEGER NOT NULL REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id     INTEGER PRIMARY KEY,
    course_name   TEXT NOT NULL,
    credits       INTEGER CHECK (credits > 0),
    department_id INTEGER NOT NULL REFERENCES Departments(department_id)
);

CREATE TABLE Classrooms (
    classroom_id INTEGER PRIMARY KEY,
    building     TEXT,
    room_number  TEXT NOT NULL,
    capacity     INTEGER CHECK (capacity > 0)
);

CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    birth_date TEXT NOT NULL,          -- YYYY-MM-DD
    email      TEXT UNIQUE,
    phone      TEXT,
    group_id   INTEGER NOT NULL REFERENCES Groups(group_id)
);

CREATE TABLE Schedule (
    schedule_id  INTEGER PRIMARY KEY,
    course_id    INTEGER NOT NULL REFERENCES Courses(course_id),
    teacher_id   INTEGER NOT NULL REFERENCES Teachers(teacher_id),
    group_id     INTEGER NOT NULL REFERENCES Groups(group_id),
    classroom_id INTEGER NOT NULL REFERENCES Classrooms(classroom_id),
    class_date   TEXT,                 -- YYYY-MM-DD
    start_time   TEXT,                 -- HH:MM
    end_time     TEXT,
    CHECK (start_time < end_time)
);

CREATE TABLE Enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id    INTEGER NOT NULL REFERENCES Students(student_id),
    course_id     INTEGER NOT NULL REFERENCES Courses(course_id),
    semester      INTEGER CHECK (semester > 0),
    academic_year TEXT,
    status        TEXT CHECK (status IN ('Active','Completed','Dropped'))
);

CREATE TABLE Grades (
    grade_id      INTEGER PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES Enrollments(enrollment_id),
    teacher_id    INTEGER NOT NULL REFERENCES Teachers(teacher_id),
    grade_value   INTEGER CHECK (grade_value BETWEEN 0 AND 100),
    grade_date    TEXT
);

-- ---------- 2. INSERT DATA ----------
INSERT INTO Departments VALUES
    (1, 'Information Systems', 'A-210', '+7 7122 30-11-01'),
    (2, 'Computer Engineering', 'A-215', '+7 7122 30-11-02'),
    (3, 'Mathematics', 'B-120', '+7 7122 30-11-03'),
    (4, 'Economics', 'C-301', '+7 7122 30-11-04'),
    (5, 'Foreign Languages', 'C-205', '+7 7122 30-11-05'),
    (6, 'Physics', 'B-305', '+7 7122 30-11-06'),
    (7, 'Petroleum Engineering', 'D-201', '+7 7122 30-11-07'),
    (8, 'Chemistry', 'D-204', '+7 7122 30-11-08'),
    (9, 'History of Kazakhstan', 'A-110', '+7 7122 30-11-09'),
    (10, 'Philosophy', 'A-112', '+7 7122 30-11-10'),
    (11, 'Accounting and Audit', 'C-310', '+7 7122 30-11-11'),
    (12, 'Ecology', 'D-306', '+7 7122 30-11-12'),
    (13, 'Physical Education', 'SC-02', '+7 7122 30-11-13'),
    (14, 'Law', 'A-305', '+7 7122 30-11-14'),
    (15, 'Pedagogy', 'A-320', '+7 7122 30-11-15');

INSERT INTO Groups VALUES
    (21, 'IS-23', 4, 1),
    (22, 'IS-24', 3, 1),
    (23, 'IS-25', 2, 1),
    (24, 'CE-23', 4, 2),
    (25, 'CE-24', 3, 2),
    (26, 'CE-25', 2, 2),
    (27, 'MATH-24', 3, 3),
    (28, 'ECON-23', 4, 4),
    (29, 'ECON-25', 2, 4),
    (30, 'PE-24', 3, 7),
    (31, 'PE-25', 2, 7),
    (32, 'ACC-24', 3, 11),
    (33, 'LAW-23', 4, 14),
    (34, 'ECO-25', 2, 12),
    (35, 'FL-24', 3, 5);

INSERT INTO Teachers VALUES
    (201, 'Gaukhar', 'Mustafina', 'g.mustafina@univ.edu.kz', '+7 7067 986 81 69', 1),
    (202, 'Nurlan', 'Akhmetov', 'n.akhmetov@univ.edu.kz', '+7 7067 620 85 34', 1),
    (203, 'Saule', 'Zhumabayeva', 's.zhumabayeva@univ.edu.kz', '+7 7033 923 75 70', 2),
    (204, 'Yerlan', 'Sadykov', 'y.sadykov@univ.edu.kz', '+7 7033 196 67 48', 3),
    (205, 'Gulnara', 'Bekova', 'g.bekova@univ.edu.kz', '+7 7028 192 78 98', 4),
    (206, 'Marat', 'Iskakov', 'm.iskakov@univ.edu.kz', '+7 7015 709 60 67', 5),
    (207, 'Dana', 'Nurpeisova', 'd.nurpeisova@univ.edu.kz', '+7 7030 738 11 77', 10),
    (208, 'Bolat', 'Tulegenov', 'b.tulegenov@univ.edu.kz', '+7 7018 160 14 34', 9),
    (209, 'Asel', 'Kassymova', 'a.kassymova@univ.edu.kz', '+7 7040 714 13 69', 1),
    (210, 'Timur', 'Ospanov', 't.ospanov@univ.edu.kz', '+7 7051 551 85 35', 2),
    (211, 'Zhanar', 'Abenova', 'z.abenova@univ.edu.kz', '+7 7076 339 91 47', 3),
    (212, 'Serik', 'Mukhanov', 's.mukhanov@univ.edu.kz', '+7 7073 104 94 20', 6),
    (213, 'Madina', 'Rakhimova', 'm.rakhimova@univ.edu.kz', '+7 7068 770 45 62', 7),
    (214, 'Ruslan', 'Karimov', 'r.karimov@univ.edu.kz', '+7 7020 824 42 50', 11),
    (215, 'Aliya', 'Dzhaksybekova', 'a.dzhaksybekova@univ.edu.kz', '+7 7039 625 46 13', 14),
    (216, 'Daulet', 'Utegenov', 'd.utegenov@univ.edu.kz', '+7 7018 676 23 61', 13),
    (217, 'Kamila', 'Saparova', 'k.saparova@univ.edu.kz', '+7 7023 966 47 59', 12);

INSERT INTO Courses VALUES
    (301, 'Database Design and Data Management', 5, 1),
    (302, 'Algorithms and Data Structures', 5, 2),
    (303, 'Calculus I', 5, 3),
    (304, 'Microeconomics', 5, 4),
    (305, 'Professional English', 3, 5),
    (306, 'Philosophy', 5, 10),
    (307, 'Modern History of Kazakhstan', 5, 9),
    (308, 'Web Programming', 5, 1),
    (309, 'Computer Networks', 5, 2),
    (310, 'Linear Algebra', 5, 3),
    (311, 'General Physics', 5, 6),
    (312, 'Drilling Technology', 6, 7),
    (313, 'Financial Accounting', 5, 11),
    (314, 'Constitutional Law', 4, 14),
    (315, 'Physical Education', 2, 13),
    (316, 'Environmental Monitoring', 4, 12);

INSERT INTO Classrooms VALUES
    (401, 'Main Building', 'A-101', 120),
    (402, 'Main Building', 'A-102', 60),
    (403, 'Main Building', 'A-205', 30),
    (404, 'Main Building', 'A-207', 30),
    (405, 'Building B', 'B-110', 25),
    (406, 'Building B', 'B-112', 25),
    (407, 'Building B', 'B-214', 25),
    (408, 'Building B', 'B-301', 40),
    (409, 'Building C', 'C-104', 80),
    (410, 'Building C', 'C-210', 30),
    (411, 'Building C', 'C-212', 30),
    (412, 'Building D', 'D-101', 50),
    (413, 'Building D', 'D-205', 20),
    (414, 'Building D', 'D-310', 24),
    (415, 'Sports Complex', 'SC-01', 200);

INSERT INTO Students VALUES
    (1001, 'Aruzhan', 'Nurlanova', '2005-01-28', 'aruzhan.nurlanova@stud.univ.edu.kz', '+7 7010 318 36 16', 21),
    (1002, 'Nursultan', 'Serikov', '2006-07-23', 'nursultan.serikov@stud.univ.edu.kz', '+7 7060 529 19 82', 22),
    (1003, 'Dias', 'Abdrakhmanov', '2006-04-25', 'dias.abdrakhmanov@stud.univ.edu.kz', '+7 7044 444 21 49', 23),
    (1004, 'Aisha', 'Kenzhebayeva', '2005-01-14', 'aisha.kenzhebayeva@stud.univ.edu.kz', '+7 7025 237 41 22', 24),
    (1005, 'Yerkebulan', 'Tokhtarov', '2006-01-15', 'yerkebulan.tokhtarov@stud.univ.edu.kz', '+7 7072 281 97 81', 25),
    (1006, 'Dilnaz', 'Muratova', '2007-08-17', 'dilnaz.muratova@stud.univ.edu.kz', '+7 7034 849 26 63', 26),
    (1007, 'Alikhan', 'Baimukhanov', '2005-07-04', 'alikhan.baimukhanov@stud.univ.edu.kz', '+7 7060 530 37 10', 27),
    (1008, 'Tomiris', 'Yesenova', '2005-10-10', 'tomiris.yesenova@stud.univ.edu.kz', '+7 7012 315 33 60', 28),
    (1009, 'Sanzhar', 'Zhaksylykov', '2006-11-19', 'sanzhar.zhaksylykov@stud.univ.edu.kz', '+7 7022 143 28 37', 29),
    (1010, 'Ayaulym', 'Kairatova', '2006-05-01', 'ayaulym.kairatova@stud.univ.edu.kz', '+7 7052 950 47 59', 30),
    (1011, 'Bekzat', 'Amanov', '2007-02-03', 'bekzat.amanov@stud.univ.edu.kz', '+7 7036 696 91 41', 31),
    (1012, 'Zarina', 'Sultanova', '2006-10-12', 'zarina.sultanova@stud.univ.edu.kz', '+7 7057 737 68 26', 32),
    (1013, 'Arman', 'Bekov', '2004-08-27', 'arman.bekov@stud.univ.edu.kz', '+7 7027 987 59 33', 33),
    (1014, 'Inkar', 'Omarova', '2006-03-10', 'inkar.omarova@stud.univ.edu.kz', '+7 7039 937 88 41', 34),
    (1015, 'Temirlan', 'Kuanyshev', '2005-04-06', 'temirlan.kuanyshev@stud.univ.edu.kz', '+7 7035 803 59 71', 35),
    (1016, 'Moldir', 'Askarova', '2004-02-14', 'moldir.askarova@stud.univ.edu.kz', '+7 7016 206 23 14', 21),
    (1017, 'Adil', 'Dosmukhamedov', '2005-05-08', 'adil.dosmukhamedov@stud.univ.edu.kz', '+7 7060 363 63 86', 22),
    (1018, 'Akbota', 'Ibrayeva', '2007-05-17', 'akbota.ibrayeva@stud.univ.edu.kz', '+7 7032 837 18 26', 23),
    (1019, 'Nurasyl', 'Shaikenov', '2005-08-18', 'nurasyl.shaikenov@stud.univ.edu.kz', '+7 7019 386 37 36', 24),
    (1020, 'Diana', 'Alieva', '2005-01-03', 'diana.alieva@stud.univ.edu.kz', '+7 7044 521 67 41', 25),
    (1021, 'Miras', 'Zhunusov', '2007-01-06', 'miras.zhunusov@stud.univ.edu.kz', '+7 7046 477 77 83', 26),
    (1022, 'Aidana', 'Kaliyeva', '2006-02-12', 'aidana.kaliyeva@stud.univ.edu.kz', '+7 7027 561 52 94', 27),
    (1023, 'Daniyar', 'Berikov', '2004-12-17', 'daniyar.berikov@stud.univ.edu.kz', '+7 7027 704 14 12', 28),
    (1024, 'Kamilla', 'Temirova', '2007-06-23', 'kamilla.temirova@stud.univ.edu.kz', '+7 7049 134 12 86', 29),
    (1025, 'Askar', 'Seitkali', '2005-02-16', 'askar.seitkali@stud.univ.edu.kz', '+7 7018 848 49 50', 30),
    (1026, 'Sabina', 'Mukhametova', '2007-02-03', 'sabina.mukhametova@stud.univ.edu.kz', '+7 7067 659 57 15', 31),
    (1027, 'Olzhas', 'Orynbassarov', '2005-12-23', 'olzhas.orynbassarov@stud.univ.edu.kz', '+7 7026 912 53 55', 32),
    (1028, 'Malika', 'Nazarbekova', '2005-11-16', 'malika.nazarbekova@stud.univ.edu.kz', '+7 7019 992 63 13', 33),
    (1029, 'Rauan', 'Kuandykov', '2007-10-01', 'rauan.kuandykov@stud.univ.edu.kz', '+7 7058 488 84 11', 34),
    (1030, 'Assem', 'Yerzhanova', '2005-02-03', 'assem.yerzhanova@stud.univ.edu.kz', '+7 7021 754 24 42', 35);

INSERT INTO Schedule VALUES
    (501, 308, 209, 21, 407, '2026-10-14', '08:30', '09:50'),
    (502, 301, 201, 22, 405, '2026-10-14', '10:00', '11:20'),
    (503, 302, 203, 23, 406, '2026-10-14', '11:30', '12:50'),
    (504, 309, 210, 24, 407, '2026-10-14', '14:00', '15:20'),
    (505, 302, 203, 25, 406, '2026-10-14', '15:30', '16:50'),
    (506, 310, 211, 26, 411, '2026-10-14', '08:30', '09:50'),
    (507, 310, 211, 27, 402, '2026-10-14', '10:00', '11:20'),
    (508, 313, 214, 28, 409, '2026-10-14', '11:30', '12:50'),
    (509, 304, 205, 29, 412, '2026-10-14', '14:00', '15:20'),
    (510, 312, 213, 30, 414, '2026-10-14', '15:30', '16:50'),
    (511, 311, 212, 31, 408, '2026-10-14', '08:30', '09:50'),
    (512, 313, 214, 32, 411, '2026-10-14', '10:00', '11:20'),
    (513, 314, 215, 33, 402, '2026-10-14', '11:30', '12:50'),
    (514, 316, 217, 34, 409, '2026-10-14', '14:00', '15:20'),
    (515, 305, 206, 35, 410, '2026-10-14', '15:30', '16:50'),
    (516, 308, 209, 21, 407, '2026-10-15', '10:00', '11:20'),
    (517, 301, 201, 22, 405, '2026-10-15', '11:30', '12:50'),
    (518, 302, 203, 23, 406, '2026-10-15', '14:00', '15:20'),
    (519, 309, 210, 24, 407, '2026-10-15', '15:30', '16:50'),
    (520, 302, 203, 25, 406, '2026-10-15', '08:30', '09:50'),
    (521, 310, 211, 26, 411, '2026-10-15', '10:00', '11:20'),
    (522, 310, 211, 27, 402, '2026-10-15', '11:30', '12:50'),
    (523, 313, 214, 28, 409, '2026-10-15', '14:00', '15:20'),
    (524, 304, 205, 29, 412, '2026-10-15', '15:30', '16:50'),
    (525, 312, 213, 30, 414, '2026-10-15', '08:30', '09:50'),
    (526, 311, 212, 31, 408, '2026-10-15', '10:00', '11:20'),
    (527, 313, 214, 32, 411, '2026-10-15', '11:30', '12:50'),
    (528, 314, 215, 33, 402, '2026-10-15', '14:00', '15:20'),
    (529, 316, 217, 34, 409, '2026-10-15', '15:30', '16:50'),
    (530, 305, 206, 35, 410, '2026-10-15', '08:30', '09:50');

INSERT INTO Enrollments VALUES
    (601, 1001, 301, 6, '2025-2026', 'Completed'),
    (602, 1001, 302, 6, '2025-2026', 'Completed'),
    (603, 1001, 308, 7, '2026-2027', 'Active'),
    (604, 1002, 302, 4, '2025-2026', 'Completed'),
    (605, 1002, 310, 4, '2025-2026', 'Completed'),
    (606, 1002, 301, 5, '2026-2027', 'Active'),
    (607, 1003, 303, 2, '2025-2026', 'Completed'),
    (608, 1003, 305, 2, '2025-2026', 'Completed'),
    (609, 1003, 302, 3, '2026-2027', 'Active'),
    (610, 1004, 302, 6, '2025-2026', 'Completed'),
    (611, 1004, 305, 6, '2025-2026', 'Completed'),
    (612, 1004, 309, 7, '2026-2027', 'Active'),
    (613, 1005, 303, 4, '2025-2026', 'Completed'),
    (614, 1005, 311, 4, '2025-2026', 'Completed'),
    (615, 1005, 302, 5, '2026-2027', 'Active'),
    (616, 1006, 303, 2, '2025-2026', 'Completed'),
    (617, 1006, 307, 2, '2025-2026', 'Completed'),
    (618, 1006, 310, 3, '2026-2027', 'Active'),
    (619, 1007, 303, 4, '2025-2026', 'Completed'),
    (620, 1007, 311, 4, '2025-2026', 'Completed'),
    (621, 1007, 310, 5, '2026-2027', 'Active'),
    (622, 1008, 304, 6, '2025-2026', 'Completed'),
    (623, 1008, 305, 6, '2025-2026', 'Completed'),
    (624, 1008, 313, 7, '2026-2027', 'Active'),
    (625, 1009, 303, 2, '2025-2026', 'Completed'),
    (626, 1009, 307, 2, '2025-2026', 'Completed'),
    (627, 1009, 304, 3, '2026-2027', 'Active'),
    (628, 1010, 311, 4, '2025-2026', 'Completed'),
    (629, 1010, 303, 4, '2025-2026', 'Completed'),
    (630, 1010, 312, 5, '2026-2027', 'Active'),
    (631, 1011, 307, 2, '2025-2026', 'Completed'),
    (632, 1011, 315, 2, '2025-2026', 'Completed'),
    (633, 1011, 311, 3, '2026-2027', 'Active'),
    (634, 1012, 304, 4, '2025-2026', 'Completed'),
    (635, 1012, 305, 4, '2025-2026', 'Completed'),
    (636, 1012, 313, 5, '2026-2027', 'Active'),
    (637, 1013, 306, 6, '2025-2026', 'Completed'),
    (638, 1013, 305, 6, '2025-2026', 'Completed'),
    (639, 1013, 314, 7, '2026-2027', 'Active'),
    (640, 1014, 307, 2, '2025-2026', 'Completed'),
    (641, 1014, 315, 2, '2025-2026', 'Completed'),
    (642, 1014, 316, 3, '2026-2027', 'Active'),
    (643, 1015, 306, 4, '2025-2026', 'Completed'),
    (644, 1015, 307, 4, '2025-2026', 'Completed'),
    (645, 1015, 305, 5, '2026-2027', 'Active'),
    (646, 1016, 301, 6, '2025-2026', 'Completed'),
    (647, 1016, 302, 6, '2025-2026', 'Completed'),
    (648, 1016, 308, 7, '2026-2027', 'Active'),
    (649, 1017, 302, 4, '2025-2026', 'Completed'),
    (650, 1017, 310, 4, '2025-2026', 'Completed'),
    (651, 1017, 301, 5, '2026-2027', 'Active'),
    (652, 1018, 303, 2, '2025-2026', 'Completed'),
    (653, 1018, 305, 2, '2025-2026', 'Completed'),
    (654, 1018, 302, 3, '2026-2027', 'Active'),
    (655, 1019, 302, 6, '2025-2026', 'Completed'),
    (656, 1019, 305, 6, '2025-2026', 'Completed'),
    (657, 1019, 309, 7, '2026-2027', 'Active'),
    (658, 1020, 303, 4, '2025-2026', 'Completed'),
    (659, 1020, 311, 4, '2025-2026', 'Completed'),
    (660, 1020, 302, 5, '2026-2027', 'Active'),
    (661, 1021, 303, 2, '2025-2026', 'Completed'),
    (662, 1021, 307, 2, '2025-2026', 'Completed'),
    (663, 1021, 310, 3, '2026-2027', 'Active'),
    (664, 1022, 303, 4, '2025-2026', 'Completed'),
    (665, 1022, 311, 4, '2025-2026', 'Completed'),
    (666, 1022, 310, 5, '2026-2027', 'Active'),
    (667, 1023, 304, 6, '2025-2026', 'Completed'),
    (668, 1023, 305, 6, '2025-2026', 'Completed'),
    (669, 1023, 313, 7, '2026-2027', 'Active'),
    (670, 1024, 303, 2, '2025-2026', 'Completed'),
    (671, 1024, 307, 2, '2025-2026', 'Completed'),
    (672, 1024, 304, 3, '2026-2027', 'Active'),
    (673, 1025, 311, 4, '2025-2026', 'Completed'),
    (674, 1025, 303, 4, '2025-2026', 'Completed'),
    (675, 1025, 312, 5, '2026-2027', 'Active'),
    (676, 1026, 307, 2, '2025-2026', 'Completed'),
    (677, 1026, 315, 2, '2025-2026', 'Completed'),
    (678, 1026, 311, 3, '2026-2027', 'Active'),
    (679, 1027, 304, 4, '2025-2026', 'Completed'),
    (680, 1027, 305, 4, '2025-2026', 'Completed'),
    (681, 1027, 313, 5, '2026-2027', 'Active'),
    (682, 1028, 306, 6, '2025-2026', 'Completed'),
    (683, 1028, 305, 6, '2025-2026', 'Completed'),
    (684, 1028, 314, 7, '2026-2027', 'Dropped'),
    (685, 1029, 307, 2, '2025-2026', 'Completed'),
    (686, 1029, 315, 2, '2025-2026', 'Completed'),
    (687, 1029, 316, 3, '2026-2027', 'Active'),
    (688, 1030, 306, 4, '2025-2026', 'Completed'),
    (689, 1030, 307, 4, '2025-2026', 'Completed'),
    (690, 1030, 305, 5, '2026-2027', 'Active');

INSERT INTO Grades VALUES
    (701, 601, 201, 86, '2026-06-04'),
    (702, 602, 203, 97, '2026-06-05'),
    (703, 604, 203, 89, '2026-06-03'),
    (704, 605, 211, 93, '2026-06-01'),
    (705, 607, 204, 79, '2026-06-05'),
    (706, 608, 206, 90, '2026-06-07'),
    (707, 610, 203, 53, '2026-06-05'),
    (708, 611, 206, 91, '2026-06-08'),
    (709, 613, 204, 83, '2026-06-04'),
    (710, 614, 212, 99, '2026-06-02'),
    (711, 616, 204, 70, '2026-06-05'),
    (712, 617, 208, 91, '2026-06-09'),
    (713, 619, 204, 85, '2026-06-06'),
    (714, 620, 212, 72, '2026-06-04'),
    (715, 622, 205, 72, '2026-06-05'),
    (716, 623, 206, 74, '2026-06-06'),
    (717, 625, 204, 73, '2026-06-05'),
    (718, 626, 208, 91, '2026-06-09'),
    (719, 628, 212, 64, '2026-06-04'),
    (720, 629, 204, 67, '2026-06-06'),
    (721, 631, 208, 77, '2026-06-08'),
    (722, 632, 216, 84, '2026-06-06'),
    (723, 634, 205, 91, '2026-06-06'),
    (724, 635, 206, 99, '2026-06-07'),
    (725, 637, 207, 64, '2026-06-09'),
    (726, 638, 206, 98, '2026-06-08'),
    (727, 640, 208, 96, '2026-06-08'),
    (728, 641, 216, 96, '2026-06-06'),
    (729, 643, 207, 85, '2026-06-08'),
    (730, 644, 208, 61, '2026-06-09'),
    (731, 646, 201, 69, '2026-06-04'),
    (732, 647, 203, 88, '2026-06-05'),
    (733, 649, 203, 100, '2026-06-03'),
    (734, 650, 211, 72, '2026-06-01'),
    (735, 652, 204, 76, '2026-06-05'),
    (736, 653, 206, 90, '2026-06-07'),
    (737, 655, 203, 71, '2026-06-05'),
    (738, 656, 206, 82, '2026-06-08'),
    (739, 658, 204, 92, '2026-06-04'),
    (740, 659, 212, 85, '2026-06-02'),
    (741, 661, 204, 86, '2026-06-05'),
    (742, 662, 208, 88, '2026-06-09'),
    (743, 664, 204, 100, '2026-06-06'),
    (744, 665, 212, 95, '2026-06-04'),
    (745, 667, 205, 81, '2026-06-05'),
    (746, 668, 206, 73, '2026-06-06'),
    (747, 670, 204, 73, '2026-06-05'),
    (748, 671, 208, 65, '2026-06-09'),
    (749, 673, 212, 80, '2026-06-04'),
    (750, 674, 204, 82, '2026-06-06'),
    (751, 676, 208, 62, '2026-06-08'),
    (752, 677, 216, 95, '2026-06-06'),
    (753, 679, 205, 91, '2026-06-06'),
    (754, 680, 206, 64, '2026-06-07'),
    (755, 682, 207, 71, '2026-06-09'),
    (756, 683, 206, 68, '2026-06-08'),
    (757, 685, 208, 93, '2026-06-08'),
    (758, 686, 216, 91, '2026-06-06'),
    (759, 688, 207, 74, '2026-06-08'),
    (760, 689, 208, 95, '2026-06-09'),
    (761, 603, 209, 95, '2026-10-10'),
    (762, 606, 201, 65, '2026-10-05'),
    (763, 609, 203, 88, '2026-10-06'),
    (764, 612, 210, 87, '2026-10-07'),
    (765, 615, 203, 90, '2026-10-08'),
    (766, 618, 211, 71, '2026-10-09'),
    (767, 621, 211, 74, '2026-10-10'),
    (768, 624, 214, 97, '2026-10-05'),
    (769, 627, 205, 79, '2026-10-06'),
    (770, 630, 213, 94, '2026-10-07'),
    (771, 633, 212, 68, '2026-10-08'),
    (772, 636, 214, 74, '2026-10-09'),
    (773, 639, 215, 64, '2026-10-10'),
    (774, 642, 217, 89, '2026-10-05'),
    (775, 645, 206, 88, '2026-10-06');

-- ---------- 3. QUERIES ----------

-- =====================================================================
-- PART 2. Introduction to SQL (Topic 8)
-- =====================================================================

-- 2.1 All records from the Students table
SELECT * FROM Students;

-- 2.2 Only student IDs, first names and last names
SELECT student_id, first_name, last_name
FROM Students;

-- 2.3 All records from the Groups table
SELECT * FROM Groups;

-- 2.4 Names of all subjects (our table is Courses)
SELECT course_name
FROM Courses;

-- =====================================================================
-- PART 3. SQL queries and aggregate functions (Topic 9)
-- =====================================================================

-- 3.1 Students of one group (WHERE) - group 21 = IS-23
SELECT *
FROM Students
WHERE group_id = 21;

-- 3.2 Students in alphabetical order (ORDER BY)
SELECT *
FROM Students
ORDER BY last_name ASC;

-- 3.3 Total number of students (COUNT)
SELECT COUNT(*) AS total_students
FROM Students;

-- 3.4 Number of students in each group (GROUP BY)
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY group_id;

-- 3.5 Maximum grade (MAX)
SELECT MAX(grade_value) AS max_grade
FROM Grades;

-- 3.6 Minimum grade (MIN)
SELECT MIN(grade_value) AS min_grade
FROM Grades;

-- 3.7 Average grade (AVG)
SELECT ROUND(AVG(grade_value), 2) AS average_grade
FROM Grades;

-- =====================================================================
-- PART 4. Joining tables using JOIN (Topic 10)
-- =====================================================================

-- 4.1 Students with their group name (Students + Groups)
SELECT
    Students.student_id,
    Students.first_name,
    Students.last_name,
    Groups.group_name
FROM Students
INNER JOIN Groups
    ON Students.group_id = Groups.group_id
ORDER BY Groups.group_name, Students.last_name;

-- 4.2 Students and their grades (Students + Enrollments + Grades)
-- Grades are linked to Students through Enrollments
SELECT
    s.first_name,
    s.last_name,
    g.grade_value,
    g.grade_date
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Grades g      ON e.enrollment_id = g.enrollment_id
ORDER BY s.last_name, g.grade_date;

-- 4.3 Student names, subjects and grades (Students + Enrollments + Courses + Grades)
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    g.grade_value
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c     ON e.course_id = c.course_id
INNER JOIN Grades g      ON e.enrollment_id = g.enrollment_id
ORDER BY s.last_name, c.course_name;

-- 4.4 INNER JOIN vs LEFT JOIN: enrollments with and without grades
SELECT
    e.enrollment_id,
    s.last_name,
    e.status,
    g.grade_value
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
LEFT JOIN Grades g    ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- 4.5 Row counts to compare JOIN results with the original tables
SELECT
    (SELECT COUNT(*) FROM Grades) AS grades_rows,
    (SELECT COUNT(*) FROM Enrollments) AS enrollment_rows,
    (SELECT COUNT(*) FROM Enrollments e INNER JOIN Grades g ON e.enrollment_id = g.enrollment_id) AS inner_join_rows,
    (SELECT COUNT(*) FROM Enrollments e LEFT JOIN Grades g ON e.enrollment_id = g.enrollment_id) AS left_join_rows;
