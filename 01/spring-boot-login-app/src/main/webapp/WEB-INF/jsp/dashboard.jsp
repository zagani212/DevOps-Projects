<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.devops.entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 20px;
        }
        h1 {
            color: #333;
        }
        .logout-btn {
            background: #d32f2f;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        .logout-btn:hover {
            background: #b71c1c;
        }
        .welcome {
            background: #e8eaf6;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        .welcome h2 {
            color: #333;
            margin-bottom: 10px;
        }
        .info-section {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .label {
            font-weight: 500;
            color: #555;
        }
        .value {
            color: #333;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        .btn-home {
            background: #667eea;
            color: white;
        }
        .btn-home:hover {
            background: #5568d3;
        }
        .btn-logout {
            background: #d32f2f;
            color: white;
        }
        .btn-logout:hover {
            background: #b71c1c;
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("/auth/login");
            return;
        }
    %>
    <div class="container">
        <header>
            <h1>Dashboard</h1>
            <a href="/auth/logout" class="logout-btn">Logout</a>
        </header>

        <div class="welcome">
            <h2>Welcome, <%= user.getFirstName() %>!</h2>
            <p>You are successfully logged in to your account.</p>
        </div>

        <div class="info-section">
            <div class="info-item">
                <span class="label">Username:</span>
                <span class="value"><%= user.getUsername() %></span>
            </div>
            <div class="info-item">
                <span class="label">Full Name:</span>
                <span class="value"><%= user.getFirstName() %> <%= user.getLastName() %></span>
            </div>
            <div class="info-item">
                <span class="label">Email:</span>
                <span class="value"><%= user.getEmail() %></span>
            </div>
            <div class="info-item">
                <span class="label">Member Since:</span>
                <span class="value"><%= user.getCreatedAt() %></span>
            </div>
        </div>

        <div class="action-buttons">
            <a href="/" class="btn btn-home">Home</a>
            <a href="/auth/logout" class="btn btn-logout">Logout</a>
        </div>
    </div>
</body>
</html>
