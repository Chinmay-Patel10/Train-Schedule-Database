<!-- MADE BY SRIJA GOTTIPARTHI, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sending message...</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
	<style>
		body {
				margin: 0 !important;
			}
	</style>
</head> 
<body>
	<%
		if ((session.getAttribute("user") == null))
		{
			response.sendRedirect("notFound.jsp");
		}
		else
		{
			String topic = request.getParameter("topic");
			String message = request.getParameter("message");
			String uName = (String)session.getAttribute("user");
			
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
		    Statement st = con.createStatement();
		    
		    String query = "INSERT INTO Messages(username, topic, message) " 
		    	+ "VALUES (\'" + uName + "\', \'" + topic + "\', \"" + message + "\");";
		    st.executeUpdate(query);
		    st.close();
	    	db.closeConnection(con);
		}
	%>
	<h3>Message sent!</h3>
	<form action="messaging.jsp" method="post">
    	<button>Send Another Message</button>
    </form>
</body>
</html>