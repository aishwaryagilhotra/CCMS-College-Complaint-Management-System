<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    String adminName = (String) session.getAttribute("adminName");
    
    if(role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    
    List<Map<String, Object>> complaints = new ArrayList<>();
    Map<String, Object> selectedComplaint = null;
    String viewId = request.getParameter("viewId");
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
        
        String category = request.getParameter("category");
        String search = request.getParameter("search");
        
        String sql;
        PreparedStatement ps;
        
        if(category != null && !category.isEmpty()) {
            sql = "SELECT c.*, s.name as student_name, s.email, s.course, s.year " +
                  "FROM complaints c JOIN students s ON c.student_id = s.student_id " +
                  "WHERE c.category = ? ORDER BY c.date_submitted DESC";
            ps = con.prepareStatement(sql);
            ps.setString(1, category);
        } else if(search != null && !search.isEmpty()) {
            sql = "SELECT c.*, s.name as student_name, s.email, s.course, s.year " +
                  "FROM complaints c JOIN students s ON c.student_id = s.student_id " +
                  "WHERE s.name LIKE ? ORDER BY c.date_submitted DESC";
            ps = con.prepareStatement(sql);
            ps.setString(1, "%" + search + "%");
        } else {
            sql = "SELECT c.*, s.name as student_name, s.email, s.course, s.year " +
                  "FROM complaints c JOIN students s ON c.student_id = s.student_id " +
                  "ORDER BY c.date_submitted DESC";
            ps = con.prepareStatement(sql);
        }
        
        ResultSet rs = ps.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> complaint = new HashMap<>();
            complaint.put("complaint_id", rs.getInt("complaint_id"));
            complaint.put("student_name", rs.getString("student_name"));
            complaint.put("email", rs.getString("email"));
            complaint.put("course", rs.getString("course"));
            complaint.put("year", rs.getInt("year"));
            complaint.put("category", rs.getString("category"));
            complaint.put("subject", rs.getString("subject"));
            complaint.put("description", rs.getString("description"));
            complaint.put("status", rs.getString("status"));
            complaint.put("date_submitted", rs.getDate("date_submitted"));
            complaints.add(complaint);
            
            if(viewId != null && Integer.parseInt(viewId) == rs.getInt("complaint_id")) {
                selectedComplaint = complaint;
            }
        }
        
        rs.close();
        ps.close();
        con.close();
        
    } catch(Exception e) {
        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
    }
    
    long pending = complaints.stream().filter(c -> "Pending".equals(c.get("status"))).count();
    long progress = complaints.stream().filter(c -> "In Progress".equals(c.get("status"))).count();
    long resolved = complaints.stream().filter(c -> "Resolved".equals(c.get("status"))).count();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - CCMS</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* Minimal additional styles for detail view */
        .detail-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #f0f4f8;
        }
        
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f5f9;
        }
        
        .detail-header h3 {
            font-size: 20px;
            color: #0f172a;
            font-weight: 600;
        }
        
        .close-btn {
            background: #f1f5f9;
            color: #475569;
            padding: 8px 20px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .close-btn:hover {
            background: #e2e8f0;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .detail-item {
            background: #f8fafc;
            padding: 20px;
            border-radius: 16px;
        }
        
        .detail-item.full-width {
            grid-column: span 2;
        }
        
        .detail-item label {
            display: block;
            color: #64748b;
            font-size: 13px;
            font-weight: 500;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        
        .detail-item .value {
            color: #0f172a;
            font-size: 16px;
            font-weight: 500;
        }
        
        .detail-item .description-text {
            background: white;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            font-size: 15px;
            line-height: 1.6;
            white-space: pre-wrap;
        }
        
        .view-link {
            color: #0284c7;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            padding: 4px 10px;
            border-radius: 20px;
            background: #f0f9ff;
        }
        
        .view-link:hover {
            background: #e0f2fe;
        }
        
        @media (max-width: 768px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }
            .detail-item.full-width {
                grid-column: span 1;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1> College Complaint Management System - Admin Panel</h1>
        </div>
    </div>
    
    <div class="container">
        <div class="nav">
            <div class="nav-links">
                <a href="adminDashboard.jsp" class="active"> Dashboard</a>
            </div>
            <div class="welcome-text">
                 Welcome, Admin <%= adminName %> | <a href="logout" style="color: #e53e3e;">Logout</a>
            </div>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <h3>Total Complaints</h3>
                <div class="number"><%= complaints.size() %></div>
            </div>
            <div class="stat-card">
                <h3>Pending</h3>
                <div class="number"><%= pending %></div>
            </div>
            <div class="stat-card">
                <h3>In Progress</h3>
                <div class="number"><%= progress %></div>
            </div>
            <div class="stat-card">
                <h3>Resolved</h3>
                <div class="number"><%= resolved %></div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="adminDashboard.jsp" method="get" class="filter-form">
                <label>Filter:</label>
                <select name="category">
                    <option value="">All Categories</option>
                    <option value="Academic">Academic</option>
                    <option value="Infrastructure">Infrastructure</option>
                    <option value="Faculty">Faculty</option>
                    <option value="Administration">Administration</option>
                    <option value="Library">Library</option>
                    <option value="Hostel">Hostel</option>
                    <option value="Canteen">Canteen</option>
                    <option value="Transport">Transport</option>
                    <option value="Examination">Examination</option>
                    <option value="Other">Other</option>
                </select>
                <button type="submit">Apply Filter</button>
            </form>
            
            <form action="adminDashboard.jsp" method="get" class="search-form">
                <label>Search:</label>
                <input type="text" name="search" placeholder="Enter student name...">
                <button type="submit"> Search</button>
            </form>
            
            <a href="adminDashboard.jsp" style="color: #667eea;">Reset</a>
        </div>
        
        <!-- Detail View Section (shown when a complaint is selected) -->
        <% if(selectedComplaint != null) { %>
        <div class="detail-section">
            <div class="detail-header">
                <h3> Complaint Details #<%= String.format("%04d", selectedComplaint.get("complaint_id")) %></h3>
                <a href="adminDashboard.jsp" class="close-btn">✕ Close</a>
            </div>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <label>Student Name</label>
                    <div class="value"><%= selectedComplaint.get("student_name") %></div>
                </div>
                
                <div class="detail-item">
                    <label>Email</label>
                    <div class="value"><%= selectedComplaint.get("email") %></div>
                </div>
                
                <div class="detail-item">
                    <label>Course & Year</label>
                    <div class="value"><%= selectedComplaint.get("course") %> - <%= selectedComplaint.get("year") %></div>
                </div>
                
                <div class="detail-item">
                    <label>Category</label>
                    <div class="value"><span class="category-badge"><%= selectedComplaint.get("category") %></span></div>
                </div>
                
                <div class="detail-item">
                    <label>Status</label>
                    <div class="value">
                        <span class="status-badge status-<%= selectedComplaint.get("status").toString().replace(" ", "-") %>">
                            <%= selectedComplaint.get("status") %>
                        </span>
                    </div>
                </div>
                
                <div class="detail-item">
                    <label>Date Submitted</label>
                    <div class="value"><%= selectedComplaint.get("date_submitted") %></div>
                </div>
                
                <div class="detail-item">
                    <label>Subject</label>
                    <div class="value"><%= selectedComplaint.get("subject") %></div>
                </div>
                
                <div class="detail-item full-width">
                    <label>Description</label>
                    <div class="description-text"><%= selectedComplaint.get("description") %></div>
                </div>
                
                <div class="detail-item full-width">
                    <label>Actions</label>
                    <div class="value">
                        <form action="admin" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="complaintId" value="<%= selectedComplaint.get("complaint_id") %>">
                            <select name="status" onchange="this.form.submit()" class="status-selector">
                                <option value="Pending" <%= "Pending".equals(selectedComplaint.get("status")) ? "selected" : "" %>> Pending</option>
                                <option value="In Progress" <%= "In Progress".equals(selectedComplaint.get("status")) ? "selected" : "" %>> In Progress</option>
                                <option value="Resolved" <%= "Resolved".equals(selectedComplaint.get("status")) ? "selected" : "" %>> Resolved</option>
                            </select>
                        </form>
                        
                        <form action="admin" method="post" style="display: inline;" 
                              onsubmit="return confirm('Are you sure you want to delete this complaint?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="complaintId" value="<%= selectedComplaint.get("complaint_id") %>">
                            <button type="submit" class="btn-delete"> Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
        
        <!-- Complaints Table -->
        <div class="profile-card" style="margin-top: 20px;">
            <h3> All Complaints</h3>
            
            <% if(complaints.isEmpty()) { %>
                <div class="no-data">
                    <p> No complaints found</p>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student</th>
                            <th>Course</th>
                            <th>Category</th>
                            <th>Subject</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Map<String, Object> c : complaints) { %>
                            <tr>
                                <td>#<%= String.format("%04d", c.get("complaint_id")) %></td>
                                <td>
                                    <strong><%= c.get("student_name") %></strong><br>
                                    <small style="color: #718096;"><%= c.get("email") %></small>
                                </td>
                                <td><%= c.get("course") %> - <%= c.get("year") %></td>
                                <td><span class="category-badge"><%= c.get("category") %></span></td>
                                <td>
                                    <%= c.get("subject") %>
                                    <!-- View Details Link -->
                                    <a href="adminDashboard.jsp?viewId=<%= c.get("complaint_id") %><%= request.getQueryString() != null ? "&" + request.getQueryString().replaceAll("viewId=[^&]*&?", "") : "" %>" 
                                       class="view-link" style="margin-left: 8px;">View</a>
                                </td>
                                <td>
                                    <span class="status-badge status-<%= c.get("status").toString().replace(" ", "-") %>">
                                        <%= c.get("status") %>
                                    </span>
                                </td>
                                <td><%= c.get("date_submitted") %></td>
                                <td class="action-buttons">
                                    <form action="admin" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="complaintId" value="<%= c.get("complaint_id") %>">
                                        <select name="status" onchange="this.form.submit()">
                                            <option value="Pending" <%= "Pending".equals(c.get("status")) ? "selected" : "" %>>Pending</option>
                                            <option value="In Progress" <%= "In Progress".equals(c.get("status")) ? "selected" : "" %>>In Progress</option>
                                            <option value="Resolved" <%= "Resolved".equals(c.get("status")) ? "selected" : "" %>>Resolved</option>
                                        </select>
                                    </form>
                                    
                                    <form action="admin" method="post" style="display: inline;" 
                                          onsubmit="return confirm('Are you sure you want to delete this complaint?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="complaintId" value="<%= c.get("complaint_id") %>">
                                        <button type="submit" class="btn-delete"> Delete </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</body>
</html>