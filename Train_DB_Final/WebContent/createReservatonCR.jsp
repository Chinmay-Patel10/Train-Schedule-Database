<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Create Reservation</title>
<style>
table {
	font-family: arial, sans-serif;
	border-collapse: collapse;
}

td, th {
	border: 1px solid #dddddd;
	text-align: left;
	padding: 8px;
}

tr:nth-child(even) {
	background-color: #dddddd;
}
</style>
</head>
<body>

	<%
		
	//[reservation_number (PK), date_made, booking_fee, isMonthly, isWeekly,
	//isRoundTrip, username (FK) references Customer not NULL]

	
	//Declaring stuff
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement st = con.createStatement();
	

	//double booking_fee = 0;
	int isMonthly = 0;
	int isWeekly = 0;
	int isRoundTrip = 0;
	String username = request.getParameter("userID");
	String query;
	String rideQuery = "";
	
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String date = df.format(new java.util.Date());
	
	int fail = 0;
	
	//Retrieve values
	double booking_fee = Double.parseDouble(request.getParameter("bFee"));
	String booking_fee_type = request.getParameter("bookingFeeType");
	if (booking_fee_type.equals("monthly")) isMonthly = 1;
	if (booking_fee_type.equals("weekly")) isWeekly = 1;
	if (booking_fee_type.equals("round")) isRoundTrip = 1;
	
	Statement checkUser = con.createStatement();
	ResultSet usersFound = checkUser.executeQuery("SELECT * FROM Customer WHERE username = '" + username + "'");
	if (!usersFound.next()) {
		fail = 2;
		out.println("<p>An error has occurred. Please make sure you enter a valid user</p>");
        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
	}
	
	
	if (fail == 0) {
		if(isMonthly == 1 || isWeekly == 1){//if it's either of these, set query
			//booking_fee = isMonthly==1 ? 1000 : 300;
			query = "INSERT INTO Reservation_Portfolio(date_made, booking_fee, isMonthly, isWeekly, isRoundTrip, username)"
					+ " VALUES (\'" + date + "\', \'" + booking_fee
					+ "\', \'" + isMonthly + "\', \'" + isWeekly + "\', \'" + isRoundTrip + "\', \'" + username + "\')";
					
			st.executeUpdate(query);
			st.close();
			db.closeConnection(con);
			
		} else {//else, we need to retrieve values for each ride and add them up
			int numrows = Integer.parseInt(request.getParameter("numRows"));
			
			//Values we need to retrieve
			String discount;
			String seatingClass;
			String seatNumber;
			String origID;
			String destID;
			String transitLine;
	
			for (int i = 1; i <= numrows; i++){ //for each row		
				int isChildOrSenior = 0;
				int isDisabled = 0;
				double rideFare = 0;
				discount = request.getParameter("discount" + i);
				seatingClass = request.getParameter("class" + i);
				seatNumber = request.getParameter("seatNumber" + i);
				origID = request.getParameter("originID" + i);
				destID = request.getParameter("destID" + i);
				transitLine = request.getParameter("transitLine" + i);
				
				
				
				//verify that the transitLine and stops are acceptable
				Statement stVerify = con.createStatement(); // No need to verify 
				String verifyQuery = "SELECT * FROM"
						+		"(SELECT transit_line_name, origin_station_id AS id, origin_departure_time AS departure_time, origin_arrival_time AS arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On"
						+		" UNION"
						+		" SELECT * FROM Stops_In_Between) AS Temp"
						+		" WHERE transit_line_name = '" + transitLine + "'"
						+		" and id = '" + origID + "'"
						+		" and departure_time < any (SELECT arrival_time FROM ("
						+		" SELECT transit_line_name, destination_station_id AS id, destination_departure_time AS departure_time, destination_arrival_time AS arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On"
						+		" UNION"
						+		" SELECT * FROM Stops_In_Between) AS Temp"
						+		" WHERE transit_line_name = '" + transitLine + "'"
						+		" and id = '" + destID + "')";
				
						
				ResultSet originDest = stVerify.executeQuery(verifyQuery);
				
				if (!originDest.next()){ //something is wrong, abort
					originDest.close();
					st.close();
					stVerify.close();
					db.closeConnection(con);
			    	out.println("<p>An error has occurred. Please make sure you enter the transit line and stops correctly</p>");
			        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
			        fail = 1;
					break;
				}
				
				String seatsQuery = "SELECT transit_line_name,num_seats - count(seat_number) AS 'availSeats'"
						+	" from Train AS T join Schedule_Origin_of_Train_Destination_of_Train_On AS S on (S.train_id = T.id)"
						+	" left outer join (SELECT DISTINCT transit_line_name, seat_number FROM Has_Ride_Origin_Destination_PartOf) AS Seats using (transit_line_name)"
						+	" where transit_line_name='" + transitLine + "'";
				Statement stSeats = con.createStatement();
				ResultSet rsSeats = stSeats.executeQuery(seatsQuery);
				if (rsSeats.next()){ //something is wrong, abort
					if (1 > Integer.parseInt(rsSeats.getString("availSeats"))) {
				    	out.println("<p>An error has occurred. Please make sure there are seats on the line</p>");
				        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
				        fail = 6;
						break;
					}
				} else {
					out.println("<p>An unknown error has occurred. Please contact a supervisor</p>");
			        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
			        fail = 7;
			        break;
				}
				rsSeats.close();
				stSeats.close();
				
				//insert into HasRide table
				rideQuery += "(\'" + origID + "\', \'" + destID
						+ "\', \"" + seatingClass + "\", \'" + seatNumber + "\', \'" 
						+ isChildOrSenior + "\', \'" + isDisabled + "\', \"" + transitLine + "\", \"R3SERVATION_NUMBER\")";
				
				if (i != numrows) {
					rideQuery += ", ";
				}
				
				//close stuff
				originDest.close();
				stVerify.close();
			
				
			}
			
			if (fail == 0) {
			query = "INSERT INTO Reservation_Portfolio(date_made, booking_fee, isMonthly, isWeekly, isRoundTrip, username)"
					+ " VALUES (\'" + date + "\', \'" + booking_fee
					+ "\', \'" + isMonthly + "\', \'" + isWeekly + "\', \'" + isRoundTrip + "\', \'" + username + "\')";
			
			
			
			st.executeUpdate(query);
			st.close();
			
			Statement st2 = con.createStatement();
			ResultSet rs2 = st2.executeQuery("SELECT reservation_number FROM Reservation_Portfolio WHERE date_made = '" + date + "'");
			String reservation_number = "";
			if (rs2.next()) {
				reservation_number = rs2.getString("reservation_number");
			}
			rs2.close();
			st2.close();
			
			rideQuery = rideQuery.replaceAll("R3SERVATION_NUMBER", reservation_number);
			
			rideQuery = "INSERT INTO Has_Ride_Origin_Destination_PartOf(origin_id, destination_id, class, seat_number, isChildOrSenior, isDisabled, transit_line_name, reservation_number)"
					+ " VALUES " + rideQuery;
			
			Statement st3 = con.createStatement();
			st3.executeUpdate(rideQuery);
			st3.close();
			st.close();
			db.closeConnection(con);
			} 
			
		}			
	}
	if (fail == 0) {
		out.println("<h3>Reservation completed successfully</h3>");
    	out.println("<button onclick=\"window.location.href='reservations.jsp';\">Back to Reservations</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
	}
	
	%>
	
	

</body>
</html>