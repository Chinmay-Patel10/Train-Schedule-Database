<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>

<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Train Stops</title>
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

		<h3>Trains Stops</h3>
		
		<%			
		
    		int originID = Integer.parseInt(request.getParameter("origin"));   
   		int destID = Integer.parseInt(request.getParameter("dest"));
   		String tLine = request.getParameter("line"); 
   		
		out.print("<table>");		
			
		out.print("<tr>");
			out.print("<th>Station ID</td>");
			out.print("<th>Station Name</td>");
			out.print("<th>Arrival Time</td>");
    		out.print("</tr>");
    	
    		ApplicationDB db = new ApplicationDB();
	    	Connection con = db.getConnection();
	    
	   	String srt = "SELECT a.origin_station_id AS id, b.name AS sName, a.origin_arrival_time AS aTime FROM Schedule_Origin_of_Train_Destination_of_Train_On a, Station b WHERE a.origin_station_id = b.id AND transit_line_name = \'" + tLine + "\'";
	    	String mid = "SELECT a.id, b.name AS sName, a.arrival_time AS aTime FROM Stops_In_Between a, Station b WHERE a.id = b.id AND transit_line_name = \'" + tLine + "\'";
	    	String end = "SELECT a.destination_station_id AS id, b.name AS sName, a.destination_arrival_time AS aTime FROM Schedule_Origin_of_Train_Destination_of_Train_On a, Station b WHERE a.destination_station_id = b.id AND transit_line_name = \'" + tLine + "\'";

	    	String all = srt + " UNION " + mid + " UNION " + end;
	    
	    	Statement st1 = con.createStatement();
		ResultSet rs1 = st1.executeQuery(all);
		
		while (rs1.next()) {	
			
			if (rs1.getInt("id") == originID) {
				out.print("<tr>");
					out.print("<td>");
						out.print(rs1.getInt("id"));
					out.print("</td>");
					out.print("<td>");
						out.print(rs1.getString("sName"));
					out.print("</td>");
					out.print("<td>");
						out.print(rs1.getString("aTime"));
					out.print("</td>");					
				out.print("</tr>");
				
				while (rs1.next()) {
					out.print("<tr>");
						out.print("<td>");
							out.print(rs1.getInt("id"));
						out.print("</td>");
						out.print("<td>");
							out.print(rs1.getString("sName"));
						out.print("</td>");
						out.print("<td>");
							out.print(rs1.getString("aTime"));
						out.print("</td>");						
					out.print("</tr>");
					
					if (rs1.getInt("id") == destID) {
						break;
					}
				}
			}
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
		
