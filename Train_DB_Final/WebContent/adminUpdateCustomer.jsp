<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update Account</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
<style>
body {
margin: 0 !important;
}
	
	*{
 	max-width: none !important;
 }
</style>
</head>
<body>

<%
	// Get all registration data
	String firstName = request.getParameter("name_firstname");
	String lastName = request.getParameter("name_lastname");
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    String email = request.getParameter("email");
    
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    	Statement st2=con.createStatement();
    	String query = "Update Customer set password = \""+pwd+"\", email=\""+email+"\", name_firstname=\""+firstName+"\", name_lastname=\""+lastName+"\" where username=\""+userid+"\";";
    	st2.executeUpdate(query);
    	st2.close();

    	db.closeConnection(con);
    	out.println("<p>Account Updated!</p>");
    	out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
    
    
%>
</body>
</html>