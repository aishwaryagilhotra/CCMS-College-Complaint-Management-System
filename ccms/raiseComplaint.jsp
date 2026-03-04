<%@ page import="java.sql.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    String studentName = (String) session.getAttribute("studentName");
    
    if(studentId == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Raise Complaint - CCMS</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>College Complaint Management System</h1>
        </div>
    </div>
    
    <div class="container">
        <div class="nav">
            <div class="nav-links">
                <a href="studentDashboard.jsp">Dashboard</a>
                <a href="raiseComplaint.jsp" class="active"> Raise Complaint</a>
                <a href="viewComplaints.jsp"> My Complaints</a>
            </div>
            <div class="welcome-text">
                Welcome, <%= studentName %> | <a href="logout" style="color: #e53e3e;">Logout</a>
            </div>
        </div>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error-message">
                Failed to raise complaint. Please try again.
            </div>
        <% } %>
        
        <div class="form-container" style="max-width: 600px;">
            <h2>Raise New Complaint</h2>
            
            <form action="complaint" method="post">
                <input type="hidden" name="action" value="raise">
                
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="">-- Select Category --</option>
                        <option value="Academic">Academic Issues</option>
                        <option value="Infrastructure">Infrastructure</option>
                        <option value="Faculty">Faculty Related</option>
                        <option value="Administration">Administration</option>
                        <option value="Library">Library</option>
                        <option value="Hostel">Hostel</option>
                        <option value="Canteen">Canteen</option>
                        <option value="Transport">Transport</option>
                        <option value="Examination">Examination</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" name="subject" maxlength="100" required placeholder="Brief subject of your complaint">
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="5" required placeholder="Please provide detailed description..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-success">Submit Complaint</button>
                <button type="reset" class="btn btn-primary" style="margin-top: 10px; background: #a0aec0;">Clear Form</button>
            </form>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="studentDashboard.jsp"> Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>