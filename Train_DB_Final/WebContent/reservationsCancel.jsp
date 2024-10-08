<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Create Reservation</title>
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

	//[reservation_number (PK), date_made, booking_fee, isMonthly, isWeekly,
//isRoundTrip, username (FK) references Customer not NULL]

	
	//Declaring stuff
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	String reservationID =request.getParameter("reservationID");
	String user = (String) session.getAttribute("user");
	
	Statement stV = con.createStatement();
	
	String vQuery = "SELECT * FROM Reservation_Portfolio"
			+ " WHERE reservation_number = \'" + reservationID + "\'"
			+ " AND username =\"" + user + "\";";
			
	ResultSet rsV = stV.executeQuery(vQuery);
	
	if (!rsV.next()) {
		out.println("<h3>Error: Reservation not found</h3>");
	} else {
		Statement stD = con.createStatement();
		String dQuery = "DELETE FROM Reservation_Portfolio WHERE reservation_number = \'" + reservationID + "\';";
		
		stD.executeUpdate(dQuery);
		
		stD.close();

		out.println("<h3>Successfully deleted Reservation number " + reservationID + "</h3>");
	}

	out.println("<button onclick=\"window.location.href='customerReservations.jsp';\">Back to Reservations</button><br><button onclick=\"window.location.href='customerHome.jsp';\">Return to Home Page</button>");
	
	rsV.close();
	stV.close();
	db.closeConnection(con);
  
	
	%>
	
	

</body>
</html>