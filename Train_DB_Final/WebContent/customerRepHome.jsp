<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    	if ((session.getAttribute("user") == null) || (session.getAttribute("employee") == null))
    	{
    		response.sendRedirect("notFound.jsp");
    	}
%>

<!DOCTYPE html>
<html>
   	<head>
	   	<title>Train Employee Home</title>
	   	<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
		<style>
		body {
		margin: 0 !important;
		}
		</style>
   </head>
   <body>
   	<h2>Logged in as <%=session.getAttribute("user")%></h2><br/>
   	<form action="repMessaging.jsp" method="get">
        <button>Reply to Customer Messages</button>
	</form>
	<form action="reservations.jsp" method="get">
        <button>Access Reservations</button>
	</form>
	<form action="schedules.jsp" method="get">
        <button>Access Train Schedules</button>
	</form>
	<br/>
	<h3>Stop List Chart</h3>
    <%
    ApplicationDB db = new ApplicationDB();
  	 	Connection con = db.getConnection();
       	Statement st = con.createStatement();
       	ResultSet rs = st.executeQuery("select * from Station;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Station Number</th><th>Station Name</th><th>State</th><th>City</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString(2)+"</td><td>"+rs.getString(3)+"</td><td>"+rs.getString(4)+"</td></tr>");
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>
    <h3>List of All Trains</h3>
		    <%
    	db = new ApplicationDB();
  	 	con = db.getConnection();
       	st = con.createStatement();
       	rs = st.executeQuery("select * from Train;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Train Number</th><th>Number of Seats</th><th>Number of Cars</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString(2)+"</td><td>"+rs.getString(3)+"</td></tr>");
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>
    <br/>
    <form action="logout.jsp" method="get">
        <button>Log Out</button>
	</form>

   </body>
</html>