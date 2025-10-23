-- PROCEDURES AND FUNCTIONS

DELIMITER $$

CREATE PROCEDURE submit_feedback (
    IN p_session_id INT,
    IN p_reviewer_id INT,
    IN p_ratee_id INT,
    IN p_rating INT,
    IN p_comment TEXT
)
BEGIN
    DECLARE v_mentor INT;
    DECLARE v_mentee INT;
    DECLARE v_status VARCHAR(20);

    SELECT mentor_id, mentee_id, status
    INTO v_mentor, v_mentee, v_status
    FROM mentorship_sessions
    WHERE session_id = p_session_id;

    IF v_status <> 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Feedback allowed only after completion';
    END IF;

    IF p_reviewer_id NOT IN (v_mentor, v_mentee) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reviewer did not attend the session';
    END IF;

    INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
    VALUES (p_session_id, p_reviewer_id, p_ratee_id, p_rating, p_comment);

    UPDATE students s
    JOIN (
        SELECT ratee_id, AVG(rating) AS new_avg
        FROM feedback
        WHERE ratee_id = p_ratee_id
        GROUP BY ratee_id
    ) x ON s.student_id = x.ratee_id
    SET s.avg_rating = ROUND(x.new_avg, 2);
END$$

DELIMITER ;


-- Helper Function
DELIMITER //
CREATE FUNCTION get_avg_rating(p_student_id INT) RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
  DECLARE v_avg DECIMAL(5,2);
  SELECT IFNULL(AVG(rating),0) INTO v_avg FROM feedback WHERE ratee_id=p_student_id;
  RETURN ROUND(v_avg,2);
END//
DELIMITER ;


-- State Transition Safety 
DELIMITER //
CREATE TRIGGER trg_ms_transition BEFORE UPDATE ON mentorship_sessions
FOR EACH ROW
BEGIN
  -- prevent going from Completed back to other states
  IF OLD.status='Completed' AND NEW.status <> 'Completed' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Completed sessions are immutable';
  END IF;
END//
DELIMITER ;