--DDL STATEMENTS

-- 0) Database Creation
CREATE DATABASE IF NOT EXISTS miniproject;
USE miniproject;

-- 1) Core tables Creation
CREATE TABLE students (
  student_id      INT AUTO_INCREMENT PRIMARY KEY,
  first_name      VARCHAR(50) NOT NULL,
  last_name       VARCHAR(50) NOT NULL,
  profile_bio     VARCHAR(500),
  year            INT NOT NULL CHECK (year BETWEEN 1 AND 4),
  department      VARCHAR(80) NOT NULL,
  contact         VARCHAR(120) NOT NULL UNIQUE,
  avg_rating      DECIMAL(3,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE skills (
  skill_id   INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(80) NOT NULL UNIQUE,
  category   VARCHAR(80) NOT NULL
);

CREATE TABLE student_skills (
  student_id INT NOT NULL,
  skill_id   INT NOT NULL,
  PRIMARY KEY (student_id, skill_id),
  CONSTRAINT fk_ss_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  CONSTRAINT fk_ss_skill   FOREIGN KEY (skill_id)   REFERENCES skills(skill_id)   ON DELETE CASCADE
);

CREATE TABLE mentorship_sessions (
  session_id     INT AUTO_INCREMENT PRIMARY KEY,
  mentor_id      INT NOT NULL,
  mentee_id      INT NOT NULL,
  skill_id       INT NOT NULL,
  request_time   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  schedule_time  DATETIME NULL,
  status         ENUM('Pending','Accepted','Rejected','Cancelled','Completed') NOT NULL DEFAULT 'Pending',
  CONSTRAINT fk_ms_mentor FOREIGN KEY (mentor_id) REFERENCES students(student_id),
  CONSTRAINT fk_ms_mentee FOREIGN KEY (mentee_id) REFERENCES students(student_id),
  CONSTRAINT fk_ms_skill  FOREIGN KEY (skill_id)  REFERENCES skills(skill_id),
  CONSTRAINT ck_ms_diff CHECK (mentor_id <> mentee_id)
);

CREATE TABLE feedback (
  feedback_id  INT AUTO_INCREMENT PRIMARY KEY,
  session_id   INT NOT NULL,
  reviewer_id  INT NOT NULL,
  ratee_id     INT NOT NULL,
  rating       INT NOT NULL,
  comment      TEXT,
  CONSTRAINT ck_rating CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT fk_fb_session FOREIGN KEY (session_id)  REFERENCES mentorship_sessions(session_id) ON DELETE CASCADE,
  CONSTRAINT fk_fb_reviewer FOREIGN KEY (reviewer_id) REFERENCES students(student_id),
  CONSTRAINT fk_fb_ratee FOREIGN KEY (ratee_id)     REFERENCES students(student_id),
  CONSTRAINT uq_session_reviewer UNIQUE (session_id, reviewer_id)
);

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id      INT NOT NULL,
  message         TEXT NOT NULL,
  ts              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status          ENUM('Unread','Read') NOT NULL DEFAULT 'Unread',
  CONSTRAINT fk_notif_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);