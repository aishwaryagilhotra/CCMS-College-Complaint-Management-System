// AdminServlet.java 

import java.io.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.http.*;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        res.setContentType("text/html");
        HttpSession session = req.getSession();
        String role = (String) session.getAttribute("role");
        
        if(role == null || !"admin".equals(role)) {
            res.sendRedirect("login.jsp?error=session");
            return;
        }
        
        String action = req.getParameter("action");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
            
            String sql = "";
            PreparedStatement ps = null;
            
            if("filter".equals(action) && req.getParameter("category") != null && !req.getParameter("category").isEmpty()) {
                String category = req.getParameter("category");
                sql = "SELECT c.*, s.name as student_name, s.course, s.year FROM complaints c " +
                      "JOIN students s ON c.student_id = s.student_id " +
                      "WHERE c.category = ? ORDER BY c.date_submitted DESC";
                ps = con.prepareStatement(sql);
                ps.setString(1, category);
            } 
            else if("search".equals(action) && req.getParameter("search") != null && !req.getParameter("search").isEmpty()) {
                String searchTerm = req.getParameter("search");
                sql = "SELECT c.*, s.name as student_name, s.course, s.year FROM complaints c " +
                      "JOIN students s ON c.student_id = s.student_id " +
                      "WHERE s.name LIKE ? ORDER BY c.date_submitted DESC";
                ps = con.prepareStatement(sql);
                ps.setString(1, "%" + searchTerm + "%");
            } 
            else {
                sql = "SELECT c.*, s.name as student_name, s.course, s.year FROM complaints c " +
                      "JOIN students s ON c.student_id = s.student_id " +
                      "ORDER BY c.date_submitted DESC";
                ps = con.prepareStatement(sql);
            }
            
            ResultSet rs = ps.executeQuery();
            
            List<Map<String, Object>> complaints = new ArrayList<>();
            while(rs.next()) {
                Map<String, Object> complaint = new HashMap<>();
                complaint.put("complaint_id", rs.getInt("complaint_id"));
                complaint.put("student_name", rs.getString("student_name"));
                complaint.put("course", rs.getString("course"));
                complaint.put("year", rs.getInt("year"));
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
            
            RequestDispatcher dis = req.getRequestDispatcher("adminDashboard.jsp");
            dis.forward(req, res);
            
        } catch(Exception e) {
            PrintWriter out = res.getWriter();
            out.println("Error: " + e.getMessage());
        }
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        res.setContentType("text/html");
        HttpSession session = req.getSession();
        String role = (String) session.getAttribute("role");
        
        if(role == null || !"admin".equals(role)) {
            res.sendRedirect("login.jsp?error=session");
            return;
        }
        
        String action = req.getParameter("action");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
            
            if("updateStatus".equals(action)) {
                int complaintId = Integer.parseInt(req.getParameter("complaintId"));
                String status = req.getParameter("status");
                
                String sql = "UPDATE complaints SET status = ? WHERE complaint_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, complaintId);
                
                int updated = ps.executeUpdate();
                
                ps.close();
                con.close();
                
                if(updated > 0) {
                    res.sendRedirect("admin?action=viewAll");
                } else {
                    res.sendRedirect("adminDashboard.jsp?error=1");
                }
            } 
            else if("delete".equals(action)) {
                int complaintId = Integer.parseInt(req.getParameter("complaintId"));
                
                String sql = "DELETE FROM complaints WHERE complaint_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, complaintId);
                
                int deleted = ps.executeUpdate();
                
                ps.close();
                con.close();
                
                if(deleted > 0) {
                    res.sendRedirect("admin?action=viewAll");
                } else {
                    res.sendRedirect("adminDashboard.jsp?error=1");
                }
            }
            
        } catch(Exception e) {
            PrintWriter out = res.getWriter();
            out.println("Error: " + e.getMessage());
        }
    }
}