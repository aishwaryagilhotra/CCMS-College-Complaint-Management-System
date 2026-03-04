// ComplaintServlet.java - Without DAO (like your insertPerson.jsp pattern)

import java.io.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.http.*;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        res.setContentType("text/html");
        HttpSession session = req.getSession();
        Integer studentId = (Integer) session.getAttribute("studentId");
        
        if(studentId == null) {
            res.sendRedirect("login.jsp?error=session");
            return;
        }
        
        String action = req.getParameter("action");
        
        if("view".equals(action)) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
                
                String sql = "SELECT * FROM complaints WHERE student_id = ? ORDER BY date_submitted DESC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, studentId);
                
                ResultSet rs = ps.executeQuery();
                
                List<Map<String, Object>> complaints = new ArrayList<>();
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
                
                req.setAttribute("complaints", complaints);
                
                rs.close();
                ps.close();
                con.close();
                
                RequestDispatcher dis = req.getRequestDispatcher("viewComplaints.jsp");
                dis.forward(req, res);
                
            } catch(Exception e) {
                PrintWriter out = res.getWriter();
                out.println("Error: " + e.getMessage());
            }
        }
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        HttpSession session = req.getSession();
        Integer studentId = (Integer) session.getAttribute("studentId");
        
        if(studentId == null) {
            res.sendRedirect("login.jsp?error=session");
            return;
        }
        
        String action = req.getParameter("action");
        
        if("raise".equals(action)) {
            String category = req.getParameter("category");
            String subject = req.getParameter("subject");
            String description = req.getParameter("description");
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
                
                String sql = "INSERT INTO complaints (student_id, category, subject, description, status, date_submitted) " +
                            "VALUES (?, ?, ?, ?, 'Pending', ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, studentId);
                ps.setString(2, category);
                ps.setString(3, subject);
                ps.setString(4, description);
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
                
                int rowsInserted = ps.executeUpdate();
                
                if(rowsInserted > 0) {
                    res.sendRedirect("studentDashboard.jsp?success=raised");
                } else {
                    res.sendRedirect("raiseComplaint.jsp?error=1");
                }
                
                ps.close();
                con.close();
                
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        }
    }
}