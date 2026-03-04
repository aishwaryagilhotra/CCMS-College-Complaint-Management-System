<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    String studentName = (String) session.getAttribute("studentName");
    
    if(studentId == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    
    String complaintId = request.getParameter("id");
    if(complaintId == null) {
        response.sendRedirect("studentDashboard.jsp");
        return;
    }
    
    Map<String, Object> complaint = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
        
        String sql = "SELECT * FROM complaints WHERE complaint_id = ? AND student_id = ? AND status = 'Pending'";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(complaintId));
        ps.setInt(2, studentId);
        
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            complaint = new HashMap<>();
            complaint.put("complaint_id", rs.getInt("complaint_id"));
            complaint.put("category", rs.getString("category"));
            complaint.put("subject", rs.getString("subject"));
            complaint.put("description", rs.getString("description"));
        }
        
        rs.close();
        ps.close();
        con.close();
        
    } catch(Exception e) {
        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
    }
    
    if(complaint == null) {
        response.sendRedirect("studentDashboard.jsp?error=invalid");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Complaint - CCMS</title>
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
                <a href="raiseComplaint.jsp">Raise Complaint</a>
                <a href="viewComplaints.jsp">My Complaints</a>
            </div>
            <div class="welcome-text">
                Welcome, <%= studentName %> | <a href="logout" style="color: #e53e3e;">Logout</a>
            </div>
        </div>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error-message">
                Failed to update complaint. Please try again.
            </div>
        <% } %>
        
        <div class="form-container" style="max-width: 600px;">
            <h2>Edit Complaint #<%= String.format("%04d", complaint.get("complaint_id")) %></h2>
            
            <div style="background: #feebc8; color: #c05621; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                You can only edit complaints with "Pending" status
            </div>
            
            <form action="complaint" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="complaintId" value="<%= complaint.get("complaint_id") %>">
                
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="Academic" <%= "Academic".equals(complaint.get("category")) ? "selected" : "" %>>Academic Issues</option>
                        <option value="Infrastructure" <%= "Infrastructure".equals(complaint.get("category")) ? "selected" : "" %>>Infrastructure</option>
                        <option value="Faculty" <%= "Faculty".equals(complaint.get("category")) ? "selected" : "" %>>Faculty Related</option>
                        <option value="Administration" <%= "Administration".equals(complaint.get("category")) ? "selected" : "" %>>Administration</option>
                        <option value="Library" <%= "Library".equals(complaint.get("category")) ? "selected" : "" %>>Library</option>
                        <option value="Hostel" <%= "Hostel".equals(complaint.get("category")) ? "selected" : "" %>>Hostel</option>
                        <option value="Canteen" <%= "Canteen".equals(complaint.get("category")) ? "selected" : "" %>>Canteen</option>
                        <option value="Transport" <%= "Transport".equals(complaint.get("category")) ? "selected" : "" %>>Transport</option>
                        <option value="Examination" <%= "Examination".equals(complaint.get("category")) ? "selected" : "" %>>Examination</option>
                        <option value="Other" <%= "Other".equals(complaint.get("category")) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" name="subject" value="<%= complaint.get("subject") %>" maxlength="100" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="5" required><%= complaint.get("description") %></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary" style="background: #ecc94b; color: #744210;">✅ Update Complaint</button>
                <a href="viewComplaints.jsp" class="btn btn-primary" style="background: #a0aec0; margin-top: 10px; display: inline-block; text-align: center;">↩️ Cancel</a>
            </form>
        </div>
    </div>
</body>
</html>