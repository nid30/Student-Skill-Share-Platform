--DML STATEMENTS

-- students

INSERT INTO students (student_id, first_name, last_name, profile_bio, year, department, contact, avg_rating)
VALUES
(1, 'Asha',   'Rao',    'CSE student passionate about backend and databases.',  3, 'CSE', 'asha@pes.edu',   0.00),
(2, 'Vikram', 'Shetty', 'ECE senior who loves mentoring and public speaking.',  4, 'ECE', 'vikram@pes.edu', 0.00),
(3, 'Meera',  'Kumar',  'CSE sophomore exploring full-stack web development.',  2, 'CSE', 'meera@pes.edu',  0.00),
(4, 'Arjun',  'Nair',   'Mechanical student improving communication skills.',   1, 'ME',  'arjun@pes.edu',  0.00),
(5, 'Nidhi',  'Nag',    'CSE senior specializing in cloud and algorithms.',     4, 'CSE', 'nidhi@pes.edu',  0.00),
(6, 'Bhagath','R',      'ECE junior skilled in IoT systems and data structures.',3,'ECE', 'bhagath@pes.edu',0.00),
(7, 'Riya',   'Menon',  'CSE 4th-year student mentoring juniors in ReactJS.',   4, 'CSE', 'riya@pes.edu',   0.00),
(8, 'Dev',    'Patel',  'ME student learning MATLAB and robotics.',              2, 'ME',  'dev@pes.edu',    0.00),
(9, 'Sneha',  'Gupta',  'ECE 3rd-year interested in hardware projects.',         3, 'ECE', 'sneha@pes.edu',  0.00),
(10,'Karan',  'Shah',   'CSE 2nd-year interested in DBMS and data analysis.',    2, 'CSE', 'karan@pes.edu',  0.00);



-- skills

INSERT INTO skills (name, category)
VALUES
('Operating Systems', 'Programming'),
('Cloud Computing',   'Programming'),
('IoT Systems',       'Hardware'),
('ReactJS',           'Web Development'),
('NodeJS',            'Web Development'),
('Robotics',          'Hardware');



-- student_skills

-- Asha (1)
INSERT INTO student_skills VALUES (1,1),(1,2),(1,8),(1,9);
-- Vikram (2)
INSERT INTO student_skills VALUES (2,1),(2,5);
-- Meera (3)
INSERT INTO student_skills VALUES (3,2),(3,8);
-- Arjun (4)
INSERT INTO student_skills VALUES (4,5),(4,4);
-- Nidhi (5)
INSERT INTO student_skills VALUES (5,1),(5,2),(5,3),(5,6);
-- Bhagath (6)
INSERT INTO student_skills VALUES (6,1),(6,2),(6,7);
-- Riya (7)
INSERT INTO student_skills VALUES (7,8),(7,9);
-- Dev (8)
INSERT INTO student_skills VALUES (8,4),(8,10);
-- Sneha (9)
INSERT INTO student_skills VALUES (9,7),(9,1);
-- Karan (10)
INSERT INTO student_skills VALUES (10,2),(10,1);



-- feedback

-- Session 1 (Asha mentor, Meera mentee)
INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
VALUES (1,3,1,5,'Asha explained DBMS concepts clearly.'),
       (1,1,3,4,'Meera was attentive and quick to learn.');

-- Session 2 (Vikram mentor, Arjun mentee)
INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
VALUES (2,4,2,5,'Vikram helped me gain stage confidence.'),
       (2,2,4,4,'Arjun improved well during the session.');

-- Session 3 (Nidhi mentor, Asha mentee)
INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
VALUES (3,1,5,5,'Nidhi taught cloud computing excellently.'),
       (3,5,1,4,'Asha participated actively.');

-- Session 4 (Bhagath mentor, Meera mentee)
INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
VALUES (4,3,6,5,'Bhagath was patient and clear about IoT basics.'),
       (4,6,3,4,'Meera understood circuits well.');

-- Session 5 (Riya mentor, Karan mentee)
INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
VALUES (5,10,7,5,'Riya explained React fundamentals thoroughly.'),
       (5,7,10,4,'Karan asked insightful questions.');

-- Session 6 (Asha mentor, Karan mentee)
INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
VALUES (6,10,1,5,'Asha is a great DBMS mentor again!'),
       (6,1,10,4,'Karan was well-prepared.');



-- mentorship_sessions

INSERT INTO mentorship_sessions
  (mentor_id, mentee_id, skill_id, status, request_time, schedule_time)
VALUES
  (1,3,2,'Completed','2025-09-01 10:00:00','2025-09-02 17:00:00'),
  (2,4,4,'Completed','2025-09-03 11:00:00','2025-09-04 17:30:00'),
  (5,1,16,'Completed','2025-09-10 15:00:00','2025-09-12 15:00:00'),
  (6,3,17,'Completed','2025-09-15 09:00:00','2025-09-16 09:30:00'),
  (7,10,18,'Completed','2025-09-17 14:00:00','2025-09-18 14:30:00'),
  (1,10,2,'Completed','2025-09-20 12:00:00','2025-09-21 12:00:00'),
  (5,9,16,'Accepted','2025-09-22 09:00:00','2025-09-25 09:30:00'),
  (2,8,4,'Pending','2025-09-26 11:00:00',NULL),
  (6,9,17,'Rejected','2025-09-27 15:00:00',NULL),
  (7,3,18,'Cancelled','2025-09-28 16:00:00',NULL);