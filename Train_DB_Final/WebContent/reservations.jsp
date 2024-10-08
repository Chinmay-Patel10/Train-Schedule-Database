<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
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
      <title>Reservations</title>
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
   	<h3>Search by Reservation Number</h3>
   	<form action="reservations.jsp" method="post">
  		<label for="resID">Reservation Number:</label>
 		<input type="text" name="resID" required><br/><br/>
  		<input type="submit" value="Submit">
	</form>
    <br/>
    <h3>Search by Transit Line or Train ID (only need one)</h3>
   	<form action="reservations.jsp" method="post">
  		<label for="transit">Transit Line:</label>
 		<input type="text" name="transit"><br/>
 		<label for="trainID">Train ID:</label>
 		<input type="text" name="trainID"><br/><br/>
  		<input type="submit" value="Submit">
	</form>
    <br/>
    <h4>Modify Reservations:</h4>
   	<form action="modifyReservationsCR.jsp" method="post">
  		<label for="resID">Reservation Number (unnecessary for add):</label>
 		<input type="text" name="resID">
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
    <h3>Train Reservations:</h3>
    <form action="reservations.jsp" method="get">
        <button>Reset</button>
	</form><br/>

    <%
    
	try {

		ApplicationDB db = new ApplicationDB();
	    Connection con = db.getConnection();
	    Statement stmt = con.createStatement();
	    
		
		// Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		String query =  "SELECT R.reservation_number, R.username, C.name_firstname, C.name_lastname,"
			+	" R.isMonthly, R.isWeekly, R.isRoundTrip, R.date_made, R.booking_fee, FareCalc.totalFare - R.booking_fee AS fare,"
			+	" IF(H.transit_line_name is NULL, 'N/A', H.transit_line_name) AS 'transit_line_name',"
			+	" IF(S.train_id is NULL, 'N/A', S.train_id) AS 'train_id',"
			+	" IF(H.class is NULL, 'N/A', H.class) AS 'class',"
			+	" IF(H.seat_number is NULL, 'N/A', H.seat_number) AS 'seat_number',"
			+	" IF(H.origin_id is NULL, 'N/A', H.origin_id) AS 'idOfOrigin',"
			+	" IF(H.destination_id is NULL, 'N/A', H.destination_id) AS 'idOfDest'"
			+	" FROM Customer AS C join Reservation_Portfolio AS R using (username)"
			+	" left outer join (Has_Ride_Origin_Destination_PartOf AS H"
			+	" join Schedule_Origin_of_Train_Destination_of_Train_On AS S using (transit_line_name)"
			+	" join Train AS T on (S.train_id = T.id)) using (reservation_number)" 
			+	" join ("
			+	" select reservation_number, (booking_fee+sum(fare)) as totalfare"
			+	" from"
			+	" (select reservation_number, booking_fee,"
			+	" (if(isChild,child_fare,if(isSenior,senior_fare,if(isDisabled,disabled_fare,normal_fare)))*"
			+	" if(class='economy',1,if(class='business',1.5,2))) as fare"
			+	" from (select r.reservation_number, booking_fee, class,isChild,isSenior,isDisabled,normal_fare,child_fare,senior_fare,disabled_fare"
			+	" from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s"
			+	" where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as n group by reservation_number"
			+	" union"
			+	" select reservation_number, booking_fee as totalfare from Reservation_Portfolio as ri where ri.isWeekly or ri.isMonthly"
			+	" ) as FareCalc using (reservation_number)";
		
		// Check if parameters were set
		String resID = request.getParameter("resID");
		String transit = request.getParameter("transit");
		String trainID = request.getParameter("trainID");
		
		// If there is a username
		if (resID != null) {
			query += " WHERE reservation_number = \'" + resID + "\'";
		} else if (transit != null && !transit.equals("")) {
			query += " WHERE transit_line_name LIKE \'" + transit + "\'";
		} else if (trainID != null) {
			query += " WHERE train_id = \'" + trainID + "\'";
		}
		
		query += " ORDER BY reservation_number DESC";
		
		//Execute query against the database.
		ResultSet rs = stmt.executeQuery(query);
		
		
		//Make an HTML table to show the results in:
		out.print("<table>");

		//make header row
		out.print("<tr>");
		//make header columns
		out.print("<th>Reservation Number</td>");
		out.print("<th>Username</td>");
		out.print("<th>Customer Name</td>");
		out.print("<th>Type of Reservation</td>");
		out.print("<th>Reservation Created</td>");
		out.print("<th>Booking Fee</td>");
		out.print("<th>Fare (By Reservation)</td>");
		out.print("<th>Transit Line</td>");
		out.print("<th>Train ID</td>");
		out.print("<th>Origin Station ID</td>");
		out.print("<th>Destination Station ID</td>");

    	out.print("</tr>");
    	
		//parse out the results
		while (rs.next()) {
			
			// Create row of data
			out.print("<tr>");
			
			out.print("<td>");
			out.print(rs.getInt("reservation_number"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("username"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("name_firstname") + " " + rs.getString("name_lastname"));
			out.print("</td>");
			
			// Type of Reservation
			String typeOfRes = "";
			if (rs.getInt("isRoundTrip") == 1) {
				typeOfRes = "Round Trip";
			} else {
				typeOfRes = "Single Ride";
			}
			out.print("<td>");
			out.print(typeOfRes);
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("date_made"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getDouble("booking_fee"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getDouble("fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("transit_line_name"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("train_id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("idOfOrigin"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs.getString("idOfDest"));
			out.print("</td>");
			
			out.print("</tr>");

		}
		out.print("</table>");

		//close the connection.
		stmt.close();
	    rs.close();
    	db.closeConnection(con);
	} catch (Exception e) {
		out.print(e);
	}
    
    %>
   </body>
</html>
