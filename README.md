# CCMS-College-Complaint-Management-System
A comprehensive web-based complaint management system for colleges built with Java JSP, Servlets, and MySQL. This system allows students to register, raise complaints, and track their status, while administrators can manage and resolve complaints efficiently.


# Features
**For Students**
- Register/Login
- Raise new complaints
- View complaint status
- Edit pending complaints

**For Admin**
- Login
- View all complaints
- Filter by category
- Update complaint status
- Delete complaints

# Project Structure

ccms/
│
├style.css
│
├── WEB-INF/
│   ├── web.xml
│   └── lib/
│       └── mysql-connector-java-8.0.33.jar
│
├── login.jsp
├── register.jsp
├── studentDashboard.jsp
├── raiseComplaint.jsp
├── viewComplaints.jsp
├── editComplaint.jsp
├── adminDashboard.jsp
├── error.jsp
│
├── LoginServlet.java
├── RegisterServlet.java
├── ComplaintServlet.java
├── AdminServlet.java
└── LogoutServlet.java

# Install Prerequisites
1. Java JDK 17+
2. Tomcat 10.1
3. MySQL 8.0+
4. MySQL Connector JAR
