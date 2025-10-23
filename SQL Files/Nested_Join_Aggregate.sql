-- NESTED QUERIES, JOIN, AGGREGATE QUERIES

-- Leaderboard – Top Rated Mentors
SELECT s.student_id, s.first_name, s.last_name, s.department,
       ROUND(AVG(f.rating),2) AS avg_rating, COUNT(*) AS reviews
FROM students s
JOIN feedback f ON f.ratee_id = s.student_id
GROUP BY s.student_id
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC, reviews DESC
LIMIT 10;


-- Mentorship History 
SELECT m.session_id, m.status, m.request_time, m.schedule_time,
       sk.name AS skill, mentor.first_name AS mentor_fn, mentee.first_name AS mentee_fn
FROM mentorship_sessions m
JOIN skills sk     ON sk.skill_id = m.skill_id
JOIN students mentor ON mentor.student_id = m.mentor_id
JOIN students mentee ON mentee.student_id = m.mentee_id
WHERE m.mentor_id = 3 OR m.mentee_id = 3
ORDER BY m.request_time DESC;


-- Find Mentors Who Have These Skills 
-- input list: ('DBMS','Data Structures')
SELECT s.student_id, s.first_name, s.last_name
FROM students s
WHERE NOT EXISTS (
  SELECT k.name
  FROM skills k
  WHERE k.name IN ('DBMS','Data Structures')
  AND NOT EXISTS (
    SELECT 1 FROM student_skills ss
    WHERE ss.student_id=s.student_id AND ss.skill_id=k.skill_id
  )
);


-- Unread Notifications
SELECT student_id, COUNT(*) AS unread
FROM notifications
WHERE status='Unread'
GROUP BY student_id;