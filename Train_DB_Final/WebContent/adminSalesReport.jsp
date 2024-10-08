<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
            <%@ page import="java.io.*,java.util.*,java.sql.*"%>
    <%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
 <title>Admin Command Center</title>
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
<%String month = request.getParameter("month");
String year = request.getParameter("year");
%>
<h5>Total Sales For The Month of <%  out.println(month+"/"+year); %></h5>
<%
ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
   Statement st = con.createStatement();
   ResultSet rs = st.executeQuery("select sum(totalfare) from Reservation_Portfolio as jjk, ( select reservation_number, (booking_fee+sum(fare)) as totalfare from (select reservation_number, booking_fee, (if(isChild, child_fare,if(isSenior, senior_fare,if(isDisabled,disabled_fare,normal_fare)))*if(class='economy',1,if(class='business',1.5,2))) as fare from (select r.reservation_number, booking_fee, class,isChild, isSenior,isDisabled,normal_fare,child_fare, senior_fare,disabled_fare  from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as n group by reservation_number union select reservation_number, booking_fee as totalfare from Reservation_Portfolio as ri where ri.isWeekly or ri.isMonthly ) as lkl where jjk.reservation_number = lkl.reservation_number and month(jjk.date_made) = "+month+" and year( jjk.date_made) ="+year+" ;");
	if(rs.next()){
	  rs.first();
	  String s = rs.getString("sum(totalfare)");
	  if(s!=null)
	  out.println("<p> $"+s+"</p>");
	  else out.println("<p> N/A </p>");
  }else{
	  out.println("<p> N/A </p>");
  }
	  rs.close();
	st.close();
	db.closeConnection(con);
		   out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
		   
%>
</body>
</html>