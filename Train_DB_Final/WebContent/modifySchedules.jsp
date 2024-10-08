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
 <title>Train Schedule Modification</title>
</head>
<body>
<%
String transit = request.getParameter("transit"),action = request.getParameter("action");
if(action.equals( "add")){ // Add a schedule
%>
	<h4>Add Stops:</h4>
	<form action="modifyStops.jsp" method="post">
  		<label for="stop">Transit Line Name:</label>
 		<input type="text" name="transit" value="<%out.println(transit);%>" required>
 		<label for="stop">Station ID:</label>
 		<input type="text" name="stationID" required>
 		<h5>Action To Perform</h5>
        <input required type="radio" name="action" value="add"/>Add
  		<br/>
  		<input required type="radio" name="action" value="edit"/>Edit
  		<br/>
  		<input required type="radio" name="action" value="delete"/>Delete
        <br/><br/>
  		<input type="submit" value="Submit">
	</form>
	<h3>Create a Schedule</h3>
	<form action="createSchedule.jsp" method="post">
    	<h5>Transit Line Name</h5> <input type="text" name="transitLine" value="<%out.println(transit);%>" required>
    	<h5>Train ID</h5> <input type="number" name="trainID" required>
    	<h5>Origin Station ID</h5> <input type="number" name="originID" required>
    	<h5>Destination Station ID</h5><input type="number" name="destID" required>
    	<h5>Origin Arrival Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="originATime" required>
    	<h5>Origin Departure Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="originDTime" required>
    	<h5>Destination Arrival Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="destATime" required>
    	<h5>Destination Departure Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="destDTime" required>
    	<h5>Regular Fare</h5><input type="number" name="fare" required> <br/>
    	<h5>Child Fare</h5> <input type="number" name="cFare" required>
    	<h5>Senior Fare</h5> <input type="number" name="sFare" required>
    	<h5>Disabled Fair</h5> <input type="number" name="dFare" required>
    	<br/><br/>
    	<input type="submit" value="Submit">
	</form>
	
<%
		
}else if (action.equals("edit")){
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("SELECT * from Schedule_Origin_of_Train_Destination_of_Train_On where transit_line_name LIKE '" + transit + "';");
	if(!rs.next()){
	rs.close();
    st.close();
    con.close();
    out.println("<p>Sorry that stop doesnt exist.</p>");
    out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
	}else{
		rs.first();
		String trainID = rs.getString("train_id");
	    String originID = rs.getString("origin_station_id");   
	    String destID = rs.getString("destination_station_id");
	    String originATime = rs.getString("origin_arrival_time");
	    String originDTime = rs.getString("origin_departure_time");
	    String destATime = rs.getString("destination_arrival_time");
	    String destDTime = rs.getString("destination_departure_time");
	    String fare = rs.getString("normal_fare");
	    String cFare = rs.getString("child_fare");
	    String sFare = rs.getString("senior_fare");
	    String dFare = rs.getString("disabled_fare");		
		rs.close();
	    st.close();
	    con.close();
%>
	<h4>Edit Stops:</h4>
	<form action="modifyStops.jsp" method="post">
  		<label for="stop">Transit Line Name:</label>
 		<input type="text" name="transit" value="<%out.println(transit);%>" required>
 		<label for="stop">Station ID:</label>
 		<input type="text" name="stationID" required>
 		<h5>Action To Perform</h5>
        <input required type="radio" name="action" value="add"/>Add
  		<br/>
  		<input required type="radio" name="action" value="edit"/>Edit
  		<br/>
  		<input required type="radio" name="action" value="delete"/>Delete
        <br/><br/>
  		<input type="submit" value="Submit">
	</form>	
	<h3>Update a Schedule</h3>
	<form action="updateSchedules.jsp" method="post">
    	<h5>Transit Line Name</h5> <input type="text" name="transitLine" value="<%out.println(transit);%>" required>
    	<h5>Train ID</h5> <input type="number" name="trainID" value=<%out.println(trainID);%> required>
    	<h5>Origin Station ID</h5> <input type="number" name="originID" value=<%out.println(originID);%> required>
    	<h5>Destination Station ID</h5><input type="number" name="destID" value=<%out.println(destID);%> required>
    	<h5>Origin Arrival Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="originATime" value="<%out.println(originATime);%>" required>
    	<h5>Origin Departure Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="originDTime" value="<%out.println(originDTime);%>" required>
    	<h5>Destination Arrival Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="destATime" value="<%out.println(destATime);%>" required>
    	<h5>Destination Departure Time (YYYY-MM-DD hh:mm:ss)</h5> <input type="text" name="destDTime" value="<%out.println(destDTime);%>" required>
    	<h5>Regular Fare</h5><input type="number" name="fare" value=<%out.println(fare);%> required> <br/>
    	<h5>Child Fare</h5> <input type="number" name="scFare" value=<%out.println(cFare);%> required>
    	<h5>Senior Fare</h5> <input type="number" name="scFare" value=<%out.println(sFare);%> required>
    	<h5>Disabled Fair</h5> <input type="number" name="dFare" value=<%out.println(dFare);%> required>
   		<br/><br><br>
    	<input type="submit" value="Update Account"><br><br><br>
	</form>
		
<%
	}
}else{
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement st = con.createStatement();
	st.executeUpdate("delete from Schedule_Origin_of_Train_Destination_of_Train_On where transit_line_name= \""+transit +"\";");
	st.close();
	db.closeConnection(con);
	out.println("<p>Deleted</p>");
	
	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
}
%>
</body>
</html>