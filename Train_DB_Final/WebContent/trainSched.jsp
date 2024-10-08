<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>

<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Train Schedules</title>
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
		<!-- search for train schedules 
			by origin, destination, date of travel -->
		<h3>Schedule Search</h3>
	
		<% 
		
		int originID = Integer.parseInt(request.getParameter("origin"));   
   		int destID = Integer.parseInt(request.getParameter("dest"));
		String dANDt = request.getParameter("tDate");
		String tDate = dANDt.substring(0,10);
		
		
		ApplicationDB db = new ApplicationDB();
	  	Connection con = db.getConnection();
	   	String q2 = "SELECT a.origin_station_id, a.destination_station_id, a.origin_departure_time, b.name AS oName, c.name AS dName  FROM Schedule_Origin_of_Train_Destination_of_Train_On a, Station b, Station c WHERE a.origin_station_id = \'" + originID + "\' AND a.destination_station_id = \'" + destID + "\' AND  b.id = \'" + originID + "\' AND c.id = \'" + destID + "\'";
    		Statement st2 = con.createStatement();
		ResultSet rs2 = st2.executeQuery(q2);
		rs2.next();
		String orName = rs2.getString("oName");
	   	String deName = rs2.getString("dName");
	    
		out.print("Schedule for " + tDate + " from " + orName + " to " + deName);
		out.print("<br><br>");	

	
		out.print("<table>");		
		
		out.print("<tr>");
			out.print("<th>Origin Station ID</td>");
			out.print("<th>Origin Station Name</td>");
			out.print("<th>Destination Station ID</td>");
			out.print("<th>Destination Station Name</td>");
			out.print("<th>Date</td>");
			out.print("<th>Departure Time</td>");
    		out.print("</tr>");
		    
    		String q1 = "SELECT a.origin_station_id, a.destination_station_id, a.origin_departure_time, b.name AS oName, c.name AS dName  FROM Schedule_Origin_of_Train_Destination_of_Train_On a, Station b, Station c WHERE a.origin_station_id = \'" + originID + "\' AND a.destination_station_id = \'" + destID + "\' AND  b.id = \'" + originID + "\' AND c.id = \'" + destID + "\'";
    		Statement st1 = con.createStatement();
		ResultSet rs1 = st1.executeQuery(q1);
		
		while (rs1.next()){
			
			String getDate = rs1.getString("origin_departure_time");
			String shortDate = getDate.length() >= 10 ? getDate.substring(0, 10) : null;
		    
		    if (shortDate != null && shortDate.equals(tDate)) {
		        out.print("<tr>");
		        out.print("<td>");
		        out.print(rs1.getInt("origin_station_id"));
		        out.print("</td>");
		        out.print("<td>");
		        out.print(rs1.getString("oName"));
		        out.print("</td>");
		        out.print("<td>");
		        out.print(rs1.getInt("destination_station_id"));
		        out.print("</td>");
		        out.print("<td>");
		        out.print(rs1.getString("dName"));
		        out.print("</td>");
		        out.print("<td>");
		        out.print(shortDate);
		        out.print("</td>");
		        out.print("<td>");
		        
		        String getTime = rs1.getString("origin_departure_time");
		        String shortTime = getTime.length() > 11 ? getTime.substring(11) : "N/A";
		        out.print(shortTime);
		        
		        out.print("</td>");
		        out.print("</tr>");
			}
		}
		
		out.print("</table>");		
		
		st1.close();
		rs1.close();
		st2.close();
		rs2.close();
    		db.closeConnection(con);				
		%>
		<br><br>
		<button onclick="window.location.href='browsinghub.jsp';">Return to Browse Home</button>
	</body>	
</html>
