<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Revenue</title>

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
%>
<h5>Total Sales For <%  out.println(key); %></h5>
<%
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();
Statement st = con.createStatement();
ResultSet rs;

if(type.equals("customerName")){
	rs = st.executeQuery("select sum(totalfare) as totalfare from ( select reservation_number, (booking_fee+sum(fare)) as totalfare from (select reservation_number, booking_fee, (if(isChild, child_fare, if(isSenior, senior_fare, if(isDisabled,disabled_fare,normal_fare)))*if(class='economy',1,if(class='business',1.5,2))) as fare from (select r.reservation_number, booking_fee, class,isChild, isSenior,isDisabled,normal_fare,child_fare, senior_fare,disabled_fare  from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as n group by reservation_number union select reservation_number, booking_fee as totalfare from Reservation_Portfolio as ri where ri.isWeekly or ri.isMonthly ) as cq, Reservation_Portfolio as rr where cq.reservation_number = rr.reservation_number and rr.username = \""+key+"\";");
	
}else if(type.equals("transitLine")){
	rs = st.executeQuery("select  sum(farefare) as totalfare from  (select reservation_number, transit_line_name, (if(isChild,child_fare, if(isSenior, senior_fare, if(isDisabled,disabled_fare,normal_fare)))*if(class='economy',1,if(class='business',1.5,2))) as farefare from (select r.reservation_number, rd.transit_line_name, booking_fee, class,isChild, isSenior, isDisabled,normal_fare,child_fare, senior_fare, disabled_fare  from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as jl where transit_line_name = \""+key+"\";");
	
}else{
	rs = st.executeQuery("select  sum(farefare) as totalfare from  (select reservation_number, transit_line_name, (if(isChild,child_fare, if(isSenior, senior_fare,if(isDisabled,disabled_fare,normal_fare)))*if(class='economy',1,if(class='business',1.5,2))) as farefare from (select r.reservation_number, rd.transit_line_name, booking_fee, class,isChild,isSenior, isDisabled,normal_fare,child_fare, senior_fare,disabled_fare  from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as jl where transit_line_name in  ( select transit_line_name from (select zz.transit_line_name, origin_station_id, destination_station_id,id from Schedule_Origin_of_Train_Destination_of_Train_On as zz, Stops_In_Between as zx where zz.transit_line_name = zx.transit_line_name)as gggg where origin_station_id in (select id from Station where city = \""+key+"\") or destination_station_id in (select id from Station where city =  \""+key+"\") or id in (select id from Station where city =  \""+key+"\") );");
	
}
if(rs.next()){
	  rs.first();
	  String s = rs.getString(1);
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