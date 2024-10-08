<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
   <head>
      <title>Train HomePage</title>
    
   </head>
   <body>
   	<%
    	if ((session.getAttribute("user") == null))
    	{
    		response.sendRedirect("notFound.jsp");
    	}
	%>
   	<p>Welcome <%=session.getAttribute("user")%>!</p>
   	<p><button onclick="window.location.href='customerReservations.jsp';">Manage Reservations</button></p>
   	<p><button onclick="window.location.href='messaging.jsp';">Message customer support</button></p>
	<p><button onclick="window.location.href='browsinghub.jsp';">Browse Trains</button></p>
	<p><button onclick="window.location.href='logout.jsp';">Log Out</button></p>

   </body>
</html>