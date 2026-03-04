// LoginServlet.java 

import java.io.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.*;
import java.sql.*;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
        } catch(Exception e) {
            e.printStackTrace();
        }
        return con;
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        PrintWriter out = res.getWriter();
        res.setContentType("text/html");
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        
        HttpSession session = req.getSession();
        
        if("student".equals(role)) {
            try {
                Connection con = getConnection();
                String sql = "SELECT * FROM students WHERE email = ? AND password = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, password);
                
                ResultSet rs = ps.executeQuery();
                
                if(rs.next()) {
                    session.setAttribute("studentId", rs.getInt("student_id"));
                    session.setAttribute("studentName", rs.getString("name"));
                    session.setAttribute("studentCourse", rs.getString("course"));
                    session.setAttribute("studentYear", rs.getInt("year"));
                    session.setAttribute("role", "student");
                    res.sendRedirect("studentDashboard.jsp");
                } else {
                    res.sendRedirect("login.jsp?error=invalid");
                }
                
                rs.close();
                ps.close();
                con.close();
                
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else if("admin".equals(role)) {
            try {
                Connection con = getConnection();
                String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, password);
                
                ResultSet rs = ps.executeQuery();
                
                if(rs.next()) {
                    session.setAttribute("adminId", rs.getInt("admin_id"));
                    session.setAttribute("adminName", rs.getString("username"));
                    session.setAttribute("role", "admin");
                    res.sendRedirect("adminDashboard.jsp");
                } else {
                    res.sendRedirect("login.jsp?error=invalid");
                }
                
                rs.close();
                ps.close();
                con.close();
                
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        }
    }
}