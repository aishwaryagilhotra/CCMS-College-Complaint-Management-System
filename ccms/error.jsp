<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - CCMS</title>
    <link rel="stylesheet" href="style.css">
</head>
<body style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="error-page">
        <div class="error-icon"></div>
        <h1>Oops! Something Went Wrong</h1>
        
        <div style="background: #f7fafc; padding: 20px; border-radius: 5px; margin: 20px 0; text-align: left;">
            <h3 style="color: #2d3748; margin-bottom: 10px;">Error Details:</h3>
            <% if(exception != null) { %>
                <p style="color: #718096;"><strong>Type:</strong> <%= exception.getClass().getSimpleName() %></p>
                <p style="color: #718096;"><strong>Message:</strong> <%= exception.getMessage() %></p>
            <% } else { %>
                <p style="color: #718096;">An unexpected error occurred. Please try again.</p>
            <% } %>
        </div>
        
        <div style="margin-top: 30px;">
            <a href="login.jsp" class="btn btn-primary" style="margin-right: 10px;">🔐 Go to Login</a>
            <a href="javascript:history.back()" class="btn btn-primary" style="background: #a0aec0;">↩️ Go Back</a>
        </div>
        
        <div style="color: #cbd5e0; font-size: 14px; margin-top: 20px;">
            Error Code: <%= pageContext.getErrorData().getStatusCode() %>
        </div>
    </div>
</body>
</html>