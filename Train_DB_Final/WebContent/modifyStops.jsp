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
 <title>Stop Modification</title>
</head>
<body>
<%
String transit = request.getParameter("transit"), stationID=request.getParameter("stationID"), action = request.getParameter("action");
if(action.equals("add")){ // Add a schedule
%>
	<h3>Create a Stop</h3>
	<form action="createStop.jsp" method="post">
    	<h5>Transit Line Name</h5> <input type="text" name="transitLine" value="<%out.println(transit);%>" required>
    	<h5>Station ID</h5> <input type="number" name="stationID" value=<%out.println(stationID);%> required>
    	<h5>Arrival Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="aTime" required>
    	<h5>Departure Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="dTime" required>
    	<br/><br/>
    	<input type="submit" value="Submit">
	</form>
	
<%
		
}else if (action.equals("edit")){
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("SELECT * from Stops_In_Between where transit_line_name LIKE '" + transit + "';");
	if(!rs.next()){
	rs.close();
    st.close();
    con.close();
    out.println("<p>Sorry that stop doesnt exist.</p>");
    out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
	}else{
		rs.first();
	    String aTime = rs.getString("arrival_time");
	    String dTime = rs.getString("departure_time");
		rs.close();
	    st.close();
	    con.close();
%>
	<h3>Update a Stop</h3>
	<form action="updateStop.jsp" method="post">
    	<h5>Transit Line Name</h5> <input type="text" name="transitLine" value="<%out.println(transit);%>" required>
    	<h5>Station ID:</h5> <input type="number" name="stationID" value=<%out.println(stationID);%> required>
    	<h5>Arrival Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="aTime" value='<%out.println(aTime);%>' required>
    	<h5>Departure Time (YYYY-MM-DD hh:mm:ss)</h5><input type="text" name="dTime" value='<%out.println(dTime);%>' required>
   		<br/><br/>
    	<input type="submit" value="Update Account"><br><br><br>
	</form>
<%
	}
}else{
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement st = con.createStatement();
	st.executeUpdate("delete from Stops_In_Between where transit_line_name= '"+transit +"' and id='"+ stationID +"';");
	st.close();
	db.closeConnection(con);
	out.println("<p>Deleted</p>");
	
	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
}
%>
</body>
</html>
