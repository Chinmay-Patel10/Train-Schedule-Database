<!-- MADE BY SRIJA GOTTIPARTHI, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Search Results</title>
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
			String searchTopic = request.getParameter("searchTopic");
			String searchUser = (String)session.getAttribute("user");
			
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
		    Statement st = con.createStatement();
		    Statement st2 = con.createStatement();
		    
		    String query = "SELECT * from Messages where username = '" + searchUser + "' AND topic LIKE \'%" + searchTopic + "%\'";
			ResultSet rs = st.executeQuery(query);
			
			if(!rs.next())
			{
				out.println("<p>No messages match your query.</p>");
			}
			
			else
			{
				rs.beforeFirst();
				while (rs.next()) {
					String u = rs.getString("username");
					String t = rs.getString("topic");
					String m = rs.getString("message");
					String repUser = rs.getString("usernameOfRep");
					String a = "";
					ResultSet agents = st2.executeQuery("SELECT name_firstname from Employee_Customer_Rep WHERE username=\'" + repUser + "\';");
					if (agents.next()) {
						a = agents.getString("name_firstname");
					}
					String rep = rs.getString("reply");
					String displayMessage = "";
					if (a == null || rep == null) {
						displayMessage = "Topic: " + t + "<br>Message: " + m + "<br>Response: No response.";
					} else {
						displayMessage = "Topic: " + t + "<br>Message: " + m + "<br>Response: " + rep + "<br>Agent: " + a;
					}
					

					out.print("<p>" + displayMessage + "</p>");
					agents.close();
				}
			}
			
			st.close();
			st2.close();
			rs.close();
			db.closeConnection(con);
		}
	%>
	<form action="messaging.jsp">
		<button>Back to Messages</button>
	</form>
</body>
</html>