// LogoutServlet.java

import java.io.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if(session != null) {
            session.invalidate();
        }
        res.sendRedirect("login.jsp");
    }
}