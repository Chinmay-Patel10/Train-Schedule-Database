<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>

<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Sort</title>
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
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
		<style>
			body {
			margin: 0 !important;
			}
		</style>
	</head>
	
	<body>

		<h3>Sort Trains Schedules</h3>
		
		<%
		
		String type = request.getParameter("sortType");
		String order = request.getParameter("sortOrder");
				
		out.print("Sorting all schedules by " + type + " in " + order + " order");
		out.print("<br><br>");		

		out.print("<table>");		
			
		out.print("<tr>");
			out.print("<th>Transit Line</td>");
			out.print("<th>Train ID</td>");
			out.print("<th>Origin Station</td>");
			out.print("<th>Departure Time</td>");
			out.print("<th>Destination Station</td>");
			out.print("<th>Arrival Time</td>");
			out.print("<th>Total Travel Time</td>");
			out.print("<th>Regular Fare Cost</td>");
    		out.print("</tr>");
    	
    		ApplicationDB db = new ApplicationDB();
	   	Connection con = db.getConnection();
	    
	    	// lots of work to find the sort by stuff
		String sortHelp = "";
		String orderHelp = "";
		
		if (type.equals("arrival time")) {
			sortHelp = "destination_arrival_time";
		} else if (type.equals("departure time")) {
			sortHelp = "origin_departure_time ";
		} else if (type.equals("origin")) {
			sortHelp = "origin_station_id ";
		} else if (type.equals("destination")) {
			sortHelp = "destination_station_id ";
		} else {
			sortHelp = "normal_fare";
		}
	
		if (order.equals("ascending")) {		
			orderHelp = " ASC"; 
		} else {
			orderHelp = " DESC";
		} 


	    	String q1 = "select transit_line_name, train_id, origin_station_id, origin_departure_time, destination_station_id, destination_arrival_time, normal_fare, TIMEDIFF(destination_arrival_time,origin_departure_time) AS 'travel' from Schedule_Origin_of_Train_Destination_of_Train_On Order by " + sortHelp + orderHelp;			    
	   	Statement st1 = con.createStatement();
		ResultSet rs1 = st1.executeQuery(q1);

		while (rs1.next()) {
			
			out.print("<tr>");

				out.print("<td>");
					out.print(rs1.getString("transit_line_name"));
				out.print("</td>");
				
				out.print("<td>");
					out.print(rs1.getInt("train_id"));
				out.print("</td>");

				out.print("<td>");
					out.print(rs1.getInt("origin_station_id"));
				out.print("</td>");
								
				out.print("<td>");
					out.print(rs1.getString("origin_departure_time"));
				out.print("</td>");
				
				out.print("<td>");
					out.print(rs1.getInt("destination_station_id"));
				out.print("</td>");
							
				out.print("<td>");
					out.print(rs1.getString("destination_arrival_time"));
				out.print("</td>");
				
				out.print("<td>");
					out.print(rs1.getString("travel"));
				out.print("</td>");
				
				out.print("<td>");
					out.print(rs1.getDouble("normal_fare"));
				out.print("</td>");
				
			out.print("</tr>");
		}
		
		out.print("</table>");
		
		st1.close();
		rs1.close();
		db.closeConnection(con);
		
		%>
		
		<br><br>
		<button onclick="window.location.href='browsinghub.jsp';">Return to Browse Home</button>
	</body>		
</html>
		
