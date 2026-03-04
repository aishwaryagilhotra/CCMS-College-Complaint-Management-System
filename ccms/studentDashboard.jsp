<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    String studentName = (String) session.getAttribute("studentName");
    String studentCourse = (String) session.getAttribute("studentCourse");
    Integer studentYear = (Integer) session.getAttribute("studentYear");
    
    if(studentId == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    
    List<Map<String, Object>> complaints = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
        
        String sql = "SELECT * FROM complaints WHERE student_id = ? ORDER BY date_submitted DESC";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, studentId);
        
        ResultSet rs = ps.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> complaint = new HashMap<>();
            complaint.put("complaint_id", rs.getInt("complaint_id"));
            complaint.put("category", rs.getString("category"));
            complaint.put("subject", rs.getString("subject"));
            complaint.put("description", rs.getString("description"));
            complaint.put("status", rs.getString("status"));
            complaint.put("date_submitted", rs.getDate("date_submitted"));
            complaints.add(complaint);
        }
        
        rs.close();
        ps.close();
        con.close();
        
    } catch(Exception e) {
        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard - CCMS</title>
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
                <a href="studentDashboard.jsp" class="active">Dashboard</a>
                <a href="raiseComplaint.jsp">Raise Complaint</a>
                <a href="viewComplaints.jsp">My Complaints</a>
            </div>
            <div class="welcome-text">
                Welcome, <%= studentName %> | <a href="logout" style="color: #e53e3e;">Logout</a>
            </div>
        </div>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="success-message">
                 Complaint raised successfully!
            </div>
        <% } %>
        
        <div class="dashboard-content">
            <div class="profile-card">
                <h3> Student Profile</h3>
                <div class="profile-info">
                    <p><strong>Name:</strong> <%= studentName %></p>
                    <p><strong>ID:</strong> STU<%= String.format("%04d", studentId) %></p>
                    <p><strong>Course:</strong> <%= studentCourse %></p>
                    <p><strong>Year:</strong> <%= studentYear %></p>
                </div>
            </div>
            
            <div class="profile-card">
                <h3> Recent Complaints</h3>
                <a href="raiseComplaint.jsp" class="btn btn-success" style="margin-bottom: 20px; display: inline-block; width: auto;">Raise New Complaint</a>
                
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Category</th>
                            <th>Subject</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(complaints.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="no-data">No complaints found</td>
                            </tr>
                        <% } else { %>
                            <% for(int i = 0; i < Math.min(5, complaints.size()); i++) { 
                                Map<String, Object> c = complaints.get(i);
                            %>
                                <tr>
                                    <td>#<%= String.format("%04d", c.get("complaint_id")) %></td>
                                    <td><span class="category-badge"><%= c.get("category") %></span></td>
                                    <td><%= c.get("subject") %></td>
                                    <td>
                                        <span class="status-badge status-<%= c.get("status").toString().replace(" ", "-") %>">
                                            <%= c.get("status") %>
                                        </span>
                                    </td>
                                    <td><%= c.get("date_submitted") %></td>
                                    <td>
                                        <% if("Pending".equals(c.get("status"))) { %>
                                            <a href="editComplaint.jsp?id=<%= c.get("complaint_id") %>" class="btn-edit">Edit</a>
                                        <% } else { %>
                                            <span style="color: #999;">-</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
                
                <% if(complaints.size() > 5) { %>
                    <div style="text-align: right; margin-top: 15px;">
                        <a href="viewComplaints.jsp">View All Complaints →</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>