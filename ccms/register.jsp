<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration - CCMS</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2>Student Registration</h2>
            
            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">Registration failed! Email might already exist.</div>
            <% } %>
            
            <form action="register" method="post">
                <div class="form-group">
                    <label> Full Name</label>
                    <input type="text" name="name" required placeholder="Enter your full name">
                </div>
                
                <div class="form-group">
                    <label> Email Address</label>
                    <input type="email" name="email" required placeholder="Enter your email">
                </div>
                
                <div class="form-group">
                    <label> Password</label>
                    <input type="password" name="password" required placeholder="Create a password">
                </div>
                
                <div class="form-group">
                    <label> Course</label>
                    <select name="course" required>
                        <option value="">Select Course</option>
                        <option value="BCA">BCA</option>
                        <option value="BBA IT">BBA IT</option>
                        <option value="MBA DT">MBA DT</option>
                        <option value="MSc CA">MSc CA</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label> Year</label>
                    <select name="year" required>
                        <option value="">Select Year</option>
                        <option value="1">1st Year</option>
                        <option value="2">2nd Year</option>
                        <option value="3">3rd Year</option>
                        <option value="4">4th Year</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success">Register</button>
            </form>
            
            <div class="login-link">
                <a href="login.jsp">Already have an account? Login</a>
            </div>
        </div>
    </div>
</body>
</html>