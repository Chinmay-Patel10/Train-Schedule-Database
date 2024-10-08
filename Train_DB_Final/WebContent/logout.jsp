<!-- MADE BY JOSHUA ROSS AND RONAK PARIKH, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logging Out</title>
</head>
<body>
<%
session.invalidate();
//session.getAttribute("user");   //this will throw an error
response.sendRedirect("login.jsp");
 
%>
</body>
</html>