<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    String studentName = (String) session.getAttribute("studentName");
    
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
    <title>My Complaints - CCMS</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <h1> College Complaint Management System</h1>
        </div>
    </div>
    
    <div class="container">
        <div class="nav">
            <div class="nav-links">
                <a href="studentDashboard.jsp"> Dashboard</a>
                <a href="raiseComplaint.jsp"> Raise Complaint</a>
                <a href="viewComplaints.jsp" class="active"> My Complaints</a>
            </div>
            <div class="welcome-text">
                Welcome, <%= studentName %> | <a href="logout" style="color: #e53e3e;">Logout</a>
            </div>
        </div>
        
        <div class="profile-card">
            <h3>My Complaint History</h3>
            
            <a href="raiseComplaint.jsp" class="btn btn-success" style="margin-bottom: 20px; display: inline-block; width: auto;">Raise New Complaint</a>
            
            <% if(complaints.isEmpty()) { %>
                <div class="no-data">
                    <p>You haven't raised any complaints yet</p>
                    <a href="raiseComplaint.jsp">Raise your first complaint</a>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Category</th>
                            <th>Subject</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Map<String, Object> c : complaints) { %>
                            <tr>
                                <td>#<%= String.format("%04d", c.get("complaint_id")) %></td>
                                <td><span class="category-badge"><%= c.get("category") %></span></td>
                                <td><strong><%= c.get("subject") %></strong></td>
                                <td><%= c.get("description") %></td>
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
                                        <span style="color: #999;">Locked</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <div style="text-align: center; margin-top: 25px;">
                <a href="studentDashboard.jsp">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>