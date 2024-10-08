<!-- MADE BY SRIJA GOTTIPARTHI, DATABASES GROUP 11 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
   <head>
      <title>Not Found</title>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
		<style>
		body {
		margin: 0 !important;
		}
		</style>
   </head>
   <body>
   	<p>You are not logged in or you do not have permission to access this page</p><br/>
	<button onclick="window.location.href='login.jsp';">Log in</button>
   </body>
</html>