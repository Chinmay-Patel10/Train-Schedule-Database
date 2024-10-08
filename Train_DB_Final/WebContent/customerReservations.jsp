<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*, java.util.concurrent.TimeUnit"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Reservations</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
		<style>
		body {
		margin: 0 !important;
		}
		</style>
</head>
<body>


	<%
		if ((String) session.getAttribute("user") == null) {
		String redirectURL = "http://localhost:8080/Login/login.jsp";
		response.sendRedirect(redirectURL);
	}
	%>

	<h3>Reservations</h3>

		<p>
			Welcome, <% out.print((String) session.getAttribute("user"));%>
		</p>

		<button onclick="window.location.href='reservationsCreate.jsp';">Make a New Reservation</button>

	<br>

	<h4>View Reservations</h4>

		<% 
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
		%>

	<h5>Current Reservations</h5>
	<!-- Should let an individual see which reservations they have made that are pending -->
	
		<%
		
		String username = (String) session.getAttribute("user");
		
		try {
	
			DateFormat df1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date1 = df1.format(new java.util.Date());
			
			Statement stmt1 = con.createStatement();
	
			// Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String query1 = "SELECT * FROM Customer AS C join Reservation_Portfolio AS R using (username)"
			+ " join Has_Ride_Origin_Destination_PartOf AS H using (reservation_number)"
			+ " join Schedule_Origin_of_Train_Destination_of_Train_On AS S using (transit_line_name)"
			+ " join Train AS T on (S.train_id = T.id)"
			+ " WHERE username = \"" + username + "\""
			+ " AND origin_arrival_time >= \'" + date1 + "\'"
			+ " ORDER BY reservation_number DESC;";
	
			//Execute query against the database.
			ResultSet rs1 = stmt1.executeQuery(query1);
			
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
			out.print("<th>Transit Line</td>");
			out.print("<th>Train ID</td>");
			out.print("<th>Boarding Class</td>");
			out.print("<th>Origin Station ID</td>");
			out.print("<th>Destination Station ID</td>");
			out.print("</tr>");
		
			//Add rows
			while (rs1.next()) {
				
				// Create row of data
				out.print("<tr>");
	
				int reservation_number = rs1.getInt("reservation_number");
				
				out.print("<td>");
				out.print(reservation_number);
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("username"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("name_firstname") + " " + rs1.getString("name_lastname"));
				out.print("</td>");
	
				// Type of Reservation
				String typeOfRes = "";
				if (rs1.getInt("isRoundTrip") == 1) {
					typeOfRes = "Round Trip";
				} else {
					typeOfRes = "Single Ride";
				}
				out.print("<td>");
				out.print(typeOfRes);
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("date_made"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getDouble("booking_fee"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("transit_line_name"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("train_id"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("class"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("H.origin_id"));
				out.print("</td>");
	
				out.print("<td>");
				out.print(rs1.getString("H.destination_id"));
				out.print("</td>");
				
				out.print("</tr>");
			}
			rs1.close();
			stmt1.close();
		} catch (Exception e){
			out.println("<p>An error has occurred. Table 1 cannot be displayed.</p>");
			out.println("<p>" + e.getMessage() + "</p>");
		}
		out.print("</table>");
		
		%>
		


	<h5>Delete Reservation</h5>
	
	<form action="reservationsCancel.jsp" method="post">
		<p>Please enter the reservation id:
		<input required name="reservationID" type="number"/>
		</p> <br>
		<button type="submit">Submit</button>
	</form>

	<h5>Past Reservations</h5>
	<!-- Should let an individual see which reservations they have made that expired -->
	
		<%
	
		try {
			
			DateFormat df3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date3 = df3.format(new java.util.Date());
			
			Statement stmt3 = con.createStatement();

			// Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String query3 = "SELECT * FROM Customer AS C join Reservation_Portfolio AS R using (username)"
			+ " join Has_Ride_Origin_Destination_PartOf AS H using (reservation_number)"
			+ " join Schedule_Origin_of_Train_Destination_of_Train_On AS S using (transit_line_name)"
			+ " join Train AS T on (S.train_id = T.id)"
			+ " WHERE username = \"" + username + "\""
			+ " AND origin_arrival_time < \'" + date3 + "\'"
			+ " ORDER BY reservation_number DESC;";

			//Execute query against the database.
			ResultSet rs3 = stmt3.executeQuery(query3);
			
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
			out.print("<th>Transit Line</td>");
			out.print("<th>Train ID</td>");
			out.print("<th>Boarding Class</td>");
			out.print("<th>Seat Number</td>");
			out.print("<th>Origin Station ID</td>");
			out.print("<th>Destination Station ID</td>");

			out.print("</tr>");

			//Filter such that only current reservations show
			while (rs3.next()) {

				// Create row of data
				out.print("<tr>");

				out.print("<td>");
				out.print(rs3.getInt("reservation_number"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("username"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("name_firstname") + " " + rs3.getString("name_lastname"));
				out.print("</td>");

				// Type of Reservation
				String typeOfRes = "";
				if (rs3.getInt("isMonthly") == 1) {
					typeOfRes = "Monthly";
				} else if (rs3.getInt("isWeekly") == 1) {
					typeOfRes = "Weekly";
				} else if (rs3.getInt("isRoundTrip") == 1) {
					typeOfRes = "Round Trip";
				} else {
					typeOfRes = "Single Ride";
				}
				out.print("<td>");
				out.print(typeOfRes);
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("date_made"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getDouble("booking_fee"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("transit_line_name"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("train_id"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("class"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("seat_number"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("H.origin_id"));
				out.print("</td>");

				out.print("<td>");
				out.print(rs3.getString("H.destination_id"));
				out.print("</td>");

				out.print("</tr>");
			}
			rs3.close();
			stmt3.close();
		} catch (Exception e) {
			out.println("<p>An error has occurred. Table 3 cannot be displayed.</p>");
			out.println("<p>" + e.getMessage() + "</p>");
		}
		out.print("</table>");
		%>
		
	
	<br>
	
	<button onclick="window.location.href='customerHome.jsp';">Return to Homepage</button>
	


</body>
</html>