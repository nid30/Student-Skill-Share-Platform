from flask import Flask, render_template, request, redirect, url_for, flash
from flask_mysql_connector import MySQL
from datetime import datetime
import config

app = Flask(__name__)
app.secret_key = "team3secretkey"

# ---------- MySQL Configuration ----------
app.config['MYSQL_USER'] = config.DB_CONFIG['user']
app.config['MYSQL_PASSWORD'] = config.DB_CONFIG['password']
app.config['MYSQL_DATABASE'] = config.DB_CONFIG['database']
app.config['MYSQL_HOST'] = config.DB_CONFIG['host']

mysql = MySQL(app)

# ---------- ROUTES ----------


@app.route('/')
def home():
    return render_template('home.html')

# ---- View Mentors ----


@app.route('/mentors')
def mentors():
    cursor = mysql.connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT s.student_id,
               CASE WHEN s.first_name='Bhagath' THEN 'Maya' ELSE s.first_name END AS first_name,
               CASE WHEN s.last_name='R' THEN 'Bhagath' ELSE s.last_name END AS last_name,
               s.department, s.year, s.avg_rating,
               GROUP_CONCAT(sk.name SEPARATOR ', ') AS skills
        FROM students s
        JOIN student_skills ss ON ss.student_id = s.student_id
        JOIN skills sk ON sk.skill_id = ss.skill_id
        WHERE s.year >= 3
        GROUP BY s.student_id
        ORDER BY s.avg_rating DESC;
    """)
    mentors = cursor.fetchall()
    cursor.close()
    return render_template('mentors.html', mentors=mentors)

# ---- Leaderboard ----


@app.route('/leaderboard')
def leaderboard():
    cursor = mysql.connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT s.student_id,
               CASE WHEN s.first_name='Bhagath' THEN 'Maya' ELSE s.first_name END AS first_name,
               CASE WHEN s.last_name='R' THEN 'Bhagath' ELSE s.last_name END AS last_name,
               s.department, ROUND(AVG(f.rating),2) AS avg_rating, COUNT(*) AS reviews
        FROM students s
        JOIN feedback f ON f.ratee_id = s.student_id
        GROUP BY s.student_id
        ORDER BY avg_rating DESC, reviews DESC
        LIMIT 10;
    """)
    leaders = cursor.fetchall()
    cursor.close()
    return render_template('leaderboard.html', leaders=leaders)

# ---- Feedback ----


@app.route('/feedback', methods=['GET', 'POST'])
def feedback():
    cursor = mysql.connection.cursor(dictionary=True)

    if request.method == 'POST':
        session_id = request.form['session_id']
        reviewer_id = request.form['rater_id']
        ratee_id = request.form['ratee_id']
        rating = request.form['rating']
        comment = request.form['comments']

        # Step 1: Insert feedback
        cursor.execute("""
            INSERT INTO feedback (session_id, reviewer_id, ratee_id, rating, comment)
            VALUES (%s, %s, %s, %s, %s)
        """, (session_id, reviewer_id, ratee_id, rating, comment))
        mysql.connection.commit()

        # Step 2: Automatically mark the session as Completed
        cursor.execute("""
            UPDATE mentorship_sessions
            SET status = 'Completed'
            WHERE session_id = %s
        """, (session_id,))
        mysql.connection.commit()

        # Step 3: Notify both users
        message = f"Session {session_id} has been marked as Completed with feedback."
        cursor.execute("""
            SELECT mentor_id, mentee_id FROM mentorship_sessions WHERE session_id = %s
        """, (session_id,))
        users = cursor.fetchone()
        if users:
            for uid in [users['mentor_id'], users['mentee_id']]:
                cursor.execute("""
                    INSERT INTO notifications (student_id, message, created_at, status)
                    VALUES (%s, %s, NOW(), 'Unread')
                """, (uid, message))
        mysql.connection.commit()

        cursor.close()
        flash("✅ Feedback submitted and session marked as Completed!", "success")
        return redirect(url_for('feedback'))

    # Optional: display completed sessions to choose from
    cursor.execute("""
        SELECT session_id, mentor_id, mentee_id
        FROM mentorship_sessions
        WHERE status IN ('Accepted', 'Pending')
        ORDER BY schedule_time ASC;
    """)
    sessions = cursor.fetchall()
    cursor.close()
    return render_template('feedback.html', sessions=sessions)

# ---- Schedule Session ----


@app.route('/schedule', methods=['GET', 'POST'])
def schedule():
    cursor = mysql.connection.cursor(dictionary=True)

    if request.method == 'POST':
        mentor_id = request.form['mentor_id']
        mentee_id = request.form['mentee_id']
        skill_id = request.form['skill_id']
        schedule_time = request.form['schedule_time']

        cursor.execute("""
            INSERT INTO mentorship_sessions (mentor_id, mentee_id, skill_id, status, request_time, schedule_time)
            VALUES (%s, %s, %s, 'Pending', NOW(), %s)
        """, (mentor_id, mentee_id, skill_id, schedule_time))
        mysql.connection.commit()

        cursor.execute("""
            INSERT INTO notifications (student_id, message, created_at, status)
            VALUES (%s, %s, NOW(), 'Unread')
        """, (mentor_id, f"A new mentorship session has been requested by student {mentee_id}."))
        mysql.connection.commit()

        cursor.close()
        flash("Session scheduled successfully and mentor notified!", "success")
        return redirect(url_for('schedule'))

    cursor.execute(
        "SELECT student_id, first_name, last_name FROM students WHERE year >= 3")
    mentors = cursor.fetchall()

    cursor.execute(
        "SELECT student_id, first_name, last_name FROM students WHERE year < 3")
    mentees = cursor.fetchall()

    cursor.execute("SELECT skill_id, name FROM skills")
    skills = cursor.fetchall()
    cursor.close()

    return render_template('schedule.html', mentors=mentors, mentees=mentees, skills=skills)

# ---- Notifications ----


@app.route('/notifications/<int:student_id>')
def notifications(student_id):
    cursor = mysql.connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT message, created_at, status
        FROM notifications
        WHERE student_id = %s
        ORDER BY created_at DESC
    """, (student_id,))
    notes = cursor.fetchall()

    cursor.execute("""
        UPDATE notifications SET status='Read' WHERE student_id=%s AND status='Unread'
    """, (student_id,))
    mysql.connection.commit()
    cursor.close()
    return render_template('notifications.html', notes=notes)

# ---- All Sessions ----


@app.route('/sessions')
def all_sessions():
    cursor = mysql.connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT m.session_id, m.status, m.schedule_time,
               mentor.first_name AS mentor_name,
               mentee.first_name AS mentee_name,
               sk.name AS skill
        FROM mentorship_sessions m
        JOIN students mentor ON mentor.student_id = m.mentor_id
        JOIN students mentee ON mentee.student_id = m.mentee_id
        JOIN skills sk ON sk.skill_id = m.skill_id
        ORDER BY 
            CASE WHEN m.status='Completed' THEN 2 ELSE 1 END,
            m.schedule_time ASC;
    """)
    sessions = cursor.fetchall()
    cursor.close()
    return render_template('all_sessions.html', sessions=sessions)


if __name__ == '__main__':
    app.run(debug=True)
