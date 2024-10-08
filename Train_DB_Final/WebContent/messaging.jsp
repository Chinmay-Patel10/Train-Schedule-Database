<!-- MADE BY SRIJA GOTTIPARTHI, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Messages & Alerts</title>
	<link rel="stylesheet"
		href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
	<style>
	body {
		margin: 0 !important;
	}
	</style>
</head>
<body>
	<%
		if ((session.getAttribute("user") == null)) {
		response.sendRedirect("notFound.jsp");
	}
	%>
	
	<%
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement s = con.createStatement();
	String uName = (String) session.getAttribute("user");

	
	%>

	<h3>Message a Customer Representative</h3>
	<form action="sendMessage.jsp" method="post">
		<h5>Message topic:</h5>
		<input name="topic" type="text">
		<h5>Message:</h5>
		<input name="message" type="text" /> <br>
		<br>
		<button>Send</button>
	</form>
	<form action="customerHome.jsp">
		<button>Back to Home</button>
	</form>
	<br>
	
	<h3>Search Messages</h3>
	<form action="messageSearchResults.jsp" method="post">
		<h5>Search by Topic:</h5>
		<input name="searchTopic" type="text"><br>
		<button>Search</button>
	</form>

	<h3>Past Messages:</h3>
	<%
		Statement st = con.createStatement();
	Statement st2 = con.createStatement();

	ResultSet rs = st.executeQuery("SELECT * from Messages where username=\'" + uName + "\'");
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

	st.close();
	st2.close();
	rs.close();
	db.closeConnection(con);
	%>
</body>
</html>