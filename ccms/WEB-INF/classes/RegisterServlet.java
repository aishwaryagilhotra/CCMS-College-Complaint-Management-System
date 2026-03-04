// RegisterServlet.java

import java.io.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.*;
import java.sql.*;
import jakarta.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        PrintWriter out = res.getWriter();
        res.setContentType("text/html");
        
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String course = req.getParameter("course");
        int year = Integer.parseInt(req.getParameter("year"));
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ccms", "root", "87651234");
            
            String sql = "INSERT INTO students (name, email, password, course, year) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, course);
            ps.setInt(5, year);
            
            int rowsInserted = ps.executeUpdate();
            
            if(rowsInserted > 0) {
                res.sendRedirect("login.jsp?success=registered");
            } else {
                res.sendRedirect("register.jsp?error=1");
            }
            
            ps.close();
            con.close();
            
        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
}