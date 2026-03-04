<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>College Complaint System - Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2>College Complaint Management Login</h2>
            
            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    <% if(request.getParameter("error").equals("invalid")) { %>
                        Invalid email or password! Please try again.
                    <% } else if(request.getParameter("error").equals("session")) { %>
                        Session expired! Please login again.
                    <% } %>
                </div>
            <% } %>
            
            <% if(request.getParameter("success") != null) { %>
                <div class="success-message">
                    <% if(request.getParameter("success").equals("registered")) { %>
                        Registration successful! Please login.
                    <% } %>
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required placeholder="Enter your email">
                </div>
                
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required placeholder="Enter your password">
                </div>
                
                <div class="form-group">
                    <label>Login as</label>
                    <select name="role" required>
                        <option value="">Select Role</option>
                        <option value="student">Student</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            
            <div class="register-link">
                <a href="register.jsp">New Student? Register Here</a>
            </div>
        </div>
    </div>
</body>
</html>