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
	String rideQuery = "";
	
	String date_made = request.getParameter("date_made");
	String reservation_number = request.getParameter("reservation_number");
	
	int fail = 0;
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    formatter.setLenient(false);
    boolean invalidDate = false;
    
    try {
        formatter.parse(date_made);
    } catch (ParseException e) {
        fail = 2;
    }
	
	//Retrieve values
	double booking_fee = Double.parseDouble(request.getParameter("bFee"));
	String booking_fee_type = request.getParameter("bookingFeeType");
	if (booking_fee_type.equals("monthly")) isMonthly = 1;
	if (booking_fee_type.equals("weekly")) isWeekly = 1;
	if (booking_fee_type.equals("round")) isRoundTrip = 1;
	
	// Verify username exists
	
	String query = "UPDATE Reservation_Portfolio"
			+	" SET"
			+	" date_made = '" + date_made + "',"
			+	" booking_fee = '" + booking_fee + "',"
			+	" isRoundTrip = '" + isRoundTrip + "',"
			+	" isMonthly = '" + isMonthly + "',"
			+	" isWeekly = '" + isWeekly + "',"
			+	" username = '" + username
			+	"' WHERE reservation_number = '" + reservation_number + "';";
	
			
	Statement checkUser = con.createStatement();
	ResultSet usersFound = checkUser.executeQuery("SELECT * FROM Customer WHERE username = '" + username + "'");
	if (!usersFound.next()) {
		fail = 3;
		out.println("<p>An error has occurred. Please make sure you enter a valid user</p>");
        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
	}
	
	usersFound.close();
	checkUser.close();
	
	if (fail == 0) {
		if(isMonthly == 1 || isWeekly == 1){//if it's either of these, set query
			
			Statement st3 = con.createStatement();
			st3.executeUpdate("DELETE FROM Has_Ride_Origin_Destination_PartOf WHERE reservation_number = '" + reservation_number + "'");
			st3.close();
			
		} else {//else, we need to retrieve values for each ride and add them up
			int numrows = Integer.parseInt(request.getParameter("numRows"));
			
			// Get old number of rows
			int numOldRows = 0;
			Statement findRows = con.createStatement();
			ResultSet oldRows = findRows.executeQuery("SELECT count(*) AS 'count' FROM Has_Ride_Origin_Destination_PartOf WHERE reservation_number = '" + reservation_number + "' group by reservation_number;");
			if (oldRows.next()) {
				numOldRows = Integer.parseInt(oldRows.getString("count"));
			} 

			oldRows.close();
			findRows.close();
			
			//Values we need to retrieve
			String discount;
			String seatingClass;
			String seatNumber;
			String origID;
			String destID;
			String transitLine;
			String connection_number;
			
			String queryList[] = new String[numrows];
			
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
				connection_number = request.getParameter("connection_number" + i);
				
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
					stVerify.close();
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
				    	
						// Check if same transit line
						Statement stSeatsLine = con.createStatement();
						ResultSet rsSeatsLine = stSeatsLine.executeQuery("SELECT * FROM Has_Ride_Origin_Destination_PartOf WHERE connection_number='"+connection_number+"' and transit_line_name='" + transitLine + "';");
						if (!rsSeatsLine.next()) {
							out.println("<p>An error has occurred. Please make sure there are seats on the line</p>");
					        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
					        fail = 6;
							break;
						}
						rsSeatsLine.close();
						stSeatsLine.close();
					}
				} else {
					out.println("<p>An unknown error has occurred. Please contact a supervisor</p>");
			        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
			        fail = 7;
			        break;
				}
				rsSeats.close();
				stSeats.close();
				
				
				//insert update into query list table
				if (i <= numOldRows) {
					queryList[i-1] = "UPDATE Has_Ride_Origin_Destination_PartOf"
							+	" SET"
							+	" class = '" + seatingClass + "',"
							+	" seat_number = '" + seatNumber + "',"
							+	" isChildOrSenior = '" + isChildOrSenior + "',"
							+	" isDisabled = '" + isDisabled + "',"
							+	" origin_id = '" + origID + "',"
							+	" destination_id = '" + destID + "',"
							+	" transit_line_name = '" + transitLine
							+	"' WHERE connection_number = '" + connection_number + "' and reservation_number = '" + reservation_number + "';";
				} else {
					queryList[i-1] = "INSERT INTO Has_Ride_Origin_Destination_PartOf(origin_id, destination_id, class, seat_number, isChildOrSenior, isDisabled, transit_line_name, reservation_number)"
							+ " VALUES (\'" + origID + "\', \'" + destID
							+ "\', \"" + seatingClass + "\", \'" + seatNumber + "\', \'" 
							+ isChildOrSenior + "\', \'" + isDisabled + "\', \'" + transitLine + "\', \'" + reservation_number + "\')";
				}
				//close stuff
				originDest.close();
				stVerify.close();
			
				
			}
			if (fail == 0) {
			
				for (int i = 0; i < numrows; i++) {
					Statement rideUp = con.createStatement();
					rideUp.executeUpdate(queryList[i]);
					rideUp.close();
				}
			} 
			
		}			
		st.executeUpdate(query);
		st.close();
		db.closeConnection(con);
	}
	if (fail == 0) {
		out.println("<h3>Reservation updated successfully</p>");
    	out.println("<button onclick=\"window.location.href='reservations.jsp';\">Back to Reservations</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
	} else if (fail == 1) {
    	out.println("<p>An error has occurred. Please make sure you enter the transit line and stops correctly</p>");
        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
	} else if (fail == 2){
		out.println("<p>An error has occurred. Please make sure you enter the time in the correct format</p>");
        out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerRepHome.jsp';\">Return to Home Page</button>");
	}
	
	%>
	
	

</body>
</html>