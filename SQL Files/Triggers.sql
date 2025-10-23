-- TRIGGERS

-- TRIGGER: When a session request is created → notify mentor
DELIMITER //
CREATE TRIGGER trg_ms_request AFTER INSERT ON mentorship_sessions
FOR EACH ROW
BEGIN
  INSERT INTO notifications (student_id, message)
  VALUES (NEW.mentor_id, CONCAT('New mentorship request from student #', NEW.mentee_id,
          ' for skill #', NEW.skill_id, '. Session #', NEW.session_id));
END//
DELIMITER ;

-- TRIGGER: When status changes → notify counterpart
DELIMITER //
CREATE TRIGGER trg_ms_status AFTER UPDATE ON mentorship_sessions
FOR EACH ROW
BEGIN
  IF NEW.status <> OLD.status THEN
    IF NEW.status IN ('Accepted','Rejected') THEN
      INSERT INTO notifications (student_id, message)
      VALUES (NEW.mentee_id, CONCAT('Your request (Session #', NEW.session_id, ') was ', NEW.status, '.'));
    ELSEIF NEW.status = 'Cancelled' THEN
      -- Notify both
      INSERT INTO notifications (student_id, message)
      VALUES (NEW.mentor_id, CONCAT('Session #', NEW.session_id, ' was cancelled.')),
             (NEW.mentee_id, CONCAT('Session #', NEW.session_id, ' was cancelled.'));
    END IF;
  END IF;
END//
DELIMITER ;