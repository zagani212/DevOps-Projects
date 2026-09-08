<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Application - Home</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 500px;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        p {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .button-group {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        a {
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            transition: all 0.3s ease;
            display: inline-block;
        }
        .btn-login {
            background: #667eea;
            color: white;
        }
        .btn-login:hover {
            background: #5568d3;
            transform: translateY(-2px);
        }
        .btn-register {
            background: #764ba2;
            color: white;
        }
        .btn-register:hover {
            background: #63398f;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Login App</h1>
        <p>A secure user authentication and registration system built with Spring Boot and MySQL</p>
        <div class="button-group">
            <a href="/auth/login" class="btn-login">Login</a>
            <a href="/auth/register" class="btn-register">Register</a>
        </div>
    </div>
</body>
</html>
