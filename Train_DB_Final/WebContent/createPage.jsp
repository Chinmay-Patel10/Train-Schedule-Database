<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Create Account</title>
</head>
<body>
<h3>Create an Account</h3>
<form action="create.jsp" method="post">
    <h5>First Name</h5> <input type="text" name="name_firstname" autocomplete="off" required>
    <h5>Last Name</h5> <input type="text" name="name_lastname" autocomplete="off" required>
    <h5>Username </h5><input type="text" name="username" autocomplete="off" required>
    <h5>Password  </h5><input type="password" name="password" autocomplete="off" required>
    <h5>Email </h5><input type="text" name="email" autocomplete="off" required><br><br>
    <input type="submit" value="Create Account"><br><br><br>
</form>
</body>
</html>