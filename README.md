# Student Skill-Share & Mentorship Platform 

A web-based platform designed to connect junior and senior students at PESU for mentorship and skill-sharing. This project aims to foster a collaborative and supportive environment within the university, allowing students to easily find and connect with peers for academic and technical guidance.

##  Key Features

-   **User Profiles:** Students can create detailed profiles listing their major, year, courses taken, and skills they possess or wish to learn.
-   **Advanced Mentor Search:** A powerful search engine to find mentors based on criteria like skills, department, or academic year.
-   **Request & Scheduling System:** Mentees can send mentorship requests to seniors. Once accepted, they can schedule sessions through the platform.
-   **Automated Notifications:** Utilizes database triggers to send automated email or in-app notifications for session requests, acceptances, and cancellations.
-   **Feedback and Rating:** A two-way feedback system where both mentors and mentees can rate and review each other after a session. A mentor's average rating is automatically updated.
-   **Analytics Dashboard:** Features leaderboards for top-rated mentors and a personal dashboard for users to view their mentorship history.

##  Technologies Used

-   **Backend:** Python (likely using a framework like Flask or Django)
-   **Database:** SQL
-   **Frontend:** HTML, CSS

##  Setup and Installation

To get a local copy up and running, follow these simple steps.

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/your-repository-name.git](https://github.com/your-username/your-repository-name.git)
    cd your-repository-name
    ```
2.  **Create and activate a virtual environment:**
    ```sh
    # For Windows
    python -m venv venv
    .\venv\Scripts\activate

    # For macOS/Linux
    python3 -m venv venv
    source venv/bin/activate
    ```
3.  **Install the required dependencies:**
    ```sh
    pip install -r requirements.txt
    ```
4.  **Set up the database:**
    -   Ensure you have a running SQL server.
    -   Import the schemas and commands from the `SQL Files` directory to set up the necessary tables and procedures.
5.  **Run the application:**
    ```sh
    python app.py
    ```

##  Folder Structure
├── SQL Files/        # Contains all .sql files for database schema, triggers, etc.
├── static/           # Contains static assets like CSS and JavaScript files.
    └── style.css
├── templates/        # Contains all HTML templates. 
    └──all_sessions.html
    └──base.html
    └──home.html 
    └──leaderboard.html    
    └──mentors.html  
    └──notifications.html    
    └──schedule.html
├── app.py            # Main application file 
├── config.py         # Configuration settings.
├── requirements.txt  # List of Python dependencies.
└── README.md         # Project documentation.
