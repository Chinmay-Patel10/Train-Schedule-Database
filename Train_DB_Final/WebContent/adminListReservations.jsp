<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
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
	*{
 	max-width: none !important;
 }
	
</style>
</head>
<body>


<%
String type = request.getParameter("type"); 
String key = request.getParameter("key"); 
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
Statement st = con.createStatement();
ResultSet rs;
if(type.equals("customerName")){

     rs= st.executeQuery("select  * from Reservation_Portfolio as reservations left outer join Has_Ride_Origin_Destination_PartOf as rides on rides.reservation_number = reservations.reservation_number where reservations.username =\""+key+"\";");
     
    	
}else{
	
	rs= st.executeQuery("select  * from Reservation_Portfolio as reservations left outer join Has_Ride_Origin_Destination_PartOf as rides on rides.reservation_number = reservations.reservation_number where transit_line_name =\""+key+"\";");
}

rs.beforeFirst();
out.println("<table><tr><th>Reservation Number</th><th>Date & Time Made</th><th>Booking Fee</th><th>A Round Trip?</th><th>Customer Username</th><th>Is The Passenger a Child on this Ride?</th><th>Is The Passenger a Senior on this Ride?</th><th>Is the Passenger Disabled on this Ride?</th><th>Origin Station Id of this Ride</th><th>Destination Station Id of this Ride</th><th>Transit Line Name of this Ride</th></tr>");
	while(rs.next()){
	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString("date_made")+"</td><td>"+rs.getString("booking_fee")+"</td><td>"+rs.getString("isRoundTrip")+"</td><td>"+rs.getString("username")+"</td><td>"+rs.getString("isChild")+"</td><td>"+rs.getString("isSenior")+"</td><td>"+rs.getString("isDisabled")+"</td><td>"+rs.getString("origin_id")+"</td><td>"+rs.getString("destination_id")+"</td><td>"+rs.getString("transit_line_name")+"</td></tr>");
	}
out.println("</table>");

%>

<h3>Note: Booking fee is only applied once per reservation. This is a list of rides, so the booking fee may be repeated as well as other items that are the same for each ride.</h3>

<% 

out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
    rs.close();
	st.close();
	con.close();
%>
</body>
</html>