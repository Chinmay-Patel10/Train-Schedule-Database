<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.util.regex.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    	if ((session.getAttribute("user") == null) || (session.getAttribute("employee") == null))
    	{
    		response.sendRedirect("notFound.jsp");
    	}
%>
	
<!DOCTYPE html>
<html>
   <head>
      <title>Schedules</title>
      <style>
      	table {
			width:100%;
		}
		table, th, td {
  			border: 1px solid black;
 			border-collapse: collapse;
 			font-size: 8pt;
		}
		th, td {
  			text-align: center;
		}
		table tr:nth-child(even) {
  			background-color: #eee;
		}
		table tr:nth-child(odd) {
 			background-color: #fff;
		}
		table th {
  			background-color: aqua;
  			color: black;
		}
	  </style>
   </head>
   <body>
   	<form action="customerRepHome.jsp" method="get">
        <button>Home</button>
	</form>
   	<h3>Search by Station ID:</h3>
   	<form action="schedules.jsp" method="post">
  		<label for="stationID">Station ID:</label>
 		<input type="text" name="stationID" required><br/><br/>
  		<input type="submit" value="Submit">
	</form>
	<h3>Search by Origin/Destination:</h3>
   	<form action="schedules.jsp" method="post">
  		<label for="originID">Origin ID:</label>
 		<input type="text" name="originID" required><br/>
 		<label for="destID">Destination ID:</label>
 		<input type="text" name="destID" required><br/><br/>
  		<input type="submit" value="Submit">
	</form>
    <br/>
    <h4>Edit Schedules:</h4>
   	<form action="modifySchedules.jsp" method="post">
  		<label for="transit">Transit Line Name:</label>
 		<input type="text" name="transit" required>
 		<h5>Action To Perform</h5>
        <input required type="radio" name="action" value="add"/>Add
  		<br/>
  		<input required type="radio" name="action" value="edit"/>Edit
  		<br/>
  		<input required type="radio" name="action" value="delete"/>Delete
        <br/><br/>
  		<input type="submit" value="Submit">
	</form>
    <br/>
    <h3>List of Train Schedules:</h3>
    <form action="schedules.jsp" method="get">
        <button>Reset</button>
	</form><br/>
    <%
    
	try {
		ApplicationDB db = new ApplicationDB();
	    Connection con = db.getConnection();
	    Statement stmt = con.createStatement();
	    
		// Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		String query = "SELECT T.id, transit_line_name, origin_station_id, destination_station_id, origin_arrival_time, destination_departure_time, destination_arrival_time, origin_departure_time, num_seats, " 
			+ " TIMEDIFF(destination_arrival_time, origin_departure_time) AS 'diff', "
			+ " num_seats - COUNT(Seats.seat_number) AS 'availSeats', "
			+ " normal_fare, child_fare, senior_fare, disabled_fare, isDelayed"
			+ " FROM Train AS T "
			+ " JOIN Schedule_Origin_of_Train_Destination_of_Train_On AS S ON S.train_id = T.id"
			+ " LEFT OUTER JOIN (SELECT DISTINCT transit_line_name, seat_number FROM Has_Ride_Origin_Destination_PartOf) AS Seats USING (transit_line_name)";
		
		// Check if stationID was set
		String stationID = request.getParameter("stationID");
		String originID = request.getParameter("originID");	
		String destID = request.getParameter("destID");	
		
		// If there is a stationID
		if (stationID != null) {
			// search by station id
			query += " WHERE origin_station_id = \'" + stationID + "\' OR destination_station_id = \'" + stationID + 
			"\' OR EXISTS (SELECT * FROM Stops_In_Between AS B WHERE S.transit_line_name = B.transit_line_name AND id = \'"+ stationID + "\')";
		} else if (originID != null && destID != null) {
			query +=
					" JOIN"
				+	" (SELECT transit_line_name, origin_station_id AS 'id', origin_departure_time AS 'departure_time', origin_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT transit_line_name, destination_station_id AS 'id', destination_departure_time AS 'departure_time', destination_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT * FROM Stops_In_Between"
				+	" ORDER BY transit_line_name, arrival_time) AS Temp USING (transit_line_name)"
				+	" WHERE Temp.id = \'" + originID + "\'"
				+	" AND Temp.arrival_time < ANY"
				+	" (SELECT Temp.arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On AS S2"
				+	" JOIN"
				+	" (SELECT transit_line_name, origin_station_id AS 'id', origin_departure_time AS 'departure_time', origin_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT transit_line_name, destination_station_id AS 'id', destination_departure_time AS 'departure_time', destination_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT * FROM Stops_In_Between"
				+	" ORDER BY transit_line_name, arrival_time) AS Temp USING (transit_line_name)"
				+	" WHERE S.transit_line_name = S2.transit_line_name"
				+	" AND Temp.id = \'" + destID + "\')";
		}
		
		query += " GROUP BY T.id, transit_line_name, origin_station_id, destination_station_id, origin_arrival_time, destination_departure_time, destination_arrival_time, origin_departure_time, num_seats, normal_fare, child_fare, senior_fare, disabled_fare, isDelayed";
		
		// Execute query against the database.
		ResultSet rs = stmt.executeQuery(query);
		
		// Make an HTML table to show the results in:
		out.print("<table>");

		// Make header row
		out.print("<tr>");
		
		// Make header columns
		out.print("<th>Transit Line</th>");
		out.print("<th>Train ID</th>");
		out.print("<th>Origin Station</th>");
		out.print("<th>Destination Station</th>");
		out.print("<th>Seats Available</th>");
		out.print("<th>Stops (by Station id)</th>");
		out.print("<th>Delayed?</th>");
		out.print("<th>Travel Time</th>");
		out.print("<th>Regular Fare</th>");
		out.print("<th>Child Fare</th>");
		out.print("<th>Senior Fare</th>");
		out.print("<th>Disabled Fare</th>");

    	out.print("</tr>");
    	
		// Parse out the results
		while (rs.next()) {
			
			// Create row of data
			out.print("<tr>");
			
			out.print("<td>");
			out.print(rs.getString("transit_line_name"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getInt("id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getInt("origin_station_id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getInt("destination_station_id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getInt("availSeats"));
			out.print("</td>");
			
			// List of Stops
			out.print("<td>");
			
			// Create a statement to get all stops
		    Statement stmt2 = con.createStatement();
			String stopQuery = "SELECT * FROM Stops_In_Between WHERE transit_line_name = \'" + rs.getString("transit_line_name") + "\' ORDER BY arrival_time";
			ResultSet rs2 = stmt2.executeQuery(stopQuery);
			String listOfStops = "" + rs.getInt("origin_station_id") + " (Arrives: " + rs.getString("origin_arrival_time") + " // Departs: " + rs.getString("origin_departure_time") + ")";
			while (rs2.next()) {
				listOfStops += "<br/>" + rs2.getInt("id") + " (Arrives: " + rs2.getString("arrival_time") + " // Departs: " + rs2.getString("departure_time") + ")";
			}
			
			listOfStops += "<br/>" + rs.getInt("destination_station_id") + " (Arrives: " + rs.getString("destination_arrival_time") + " // Departs: " + rs.getString("destination_departure_time") + ")";
			
			stmt2.close();
		    rs2.close();
		    
		    out.print(listOfStops);
		    
			out.print("</td>");
			
			String delayed = rs.getInt("isDelayed") == 0 ? "No" : "Yes";
			out.print("<td>");
			out.print(delayed);
			out.print("</td>");
			
			// Travel time
			out.print("<td>");
			out.print(rs.getString("diff"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getDouble("normal_fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getDouble("child_fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getDouble("senior_fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getDouble("disabled_fare"));
			out.print("</td>");
			
			out.print("</tr>");

		}
		
		out.print("</table>");
		
		// Close the connection.
		stmt.close();
	    rs.close();
    	db.closeConnection(con);
	} catch (Exception e) {
		out.print(e);
	}
    %>
   </body>
</html>
