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
 
     <h3>Command Center</h3>
     
     <%
     	out.println("<p> Welcome Site Administrator " + ((String) (session.getAttribute("user")))+".</p>");
        out.println("<button onclick=\"window.location.href='logout.jsp';\">Log Out</button>");
     %>
     
     
     
         <form action="adminModifyLogin.jsp" method="post">
        <h5>Modify/Create Login Of Username:</h5>
        <input required name="username" type="text"/>
        
        <h5>Which Is A</h5>

  <input required type="radio" name="type" value="customer"/>Customer
  <br>
  <input required type="radio" name="type" value="employee"/>Employee
        <br>
        <h5>Action To Perform</h5>
          <input required type="radio" name="action" value="add"/>Add
  			<br>
  			<input required type="radio" name="action" value="edit"/>Edit
  			<br>
  			<input required type="radio" name="action" value="delete"/>Delete
        
        <br><br>
        
        
        <button>Continue</button>
    </form>
     
     
     
      <br><br>
     
     
     
     <form action="adminSalesReport.jsp" method="post">
     <h5>Calculate Sales Report For The Month Of</h5>
     
    <select required name="month" >
    <option value='1'>January</option>
    <option value='2'>February</option>
    <option value='3'>March</option>
    <option value='4'>April</option>
    <option value='5'>May</option>
    <option value='6'>June</option>
    <option value='7'>July</option>
    <option value='8'>August</option>
    <option value='9'>September</option>
    <option value='10'>October</option>
    <option value='11'>November</option>
    <option value='12'>December</option>
    </select>
  
	<input required type="number" name="year" min="1000" max="9999">
     
     <br><br>
     <button>Calculate</button>
     </form>
     
     
      <br><br>
     
     
    <form action="adminListReservations.jsp" method="post">
        <h5>List Reservations Of</h5>
        
        <input required name="key" type="text"/>
        
        <h5>Which Is A</h5>

  <input required type="radio" name="type" value="customerName"/>Customer Username
  <br>
  <input required type="radio" name="type" value="transitLine"/>Transit Line Name
        <br><br>
        <button>Search</button>
    </form>
    
    
     <br><br>
    
    
    
        <form action="adminListRevenue.jsp" method="post">
        <h5>List Revenue Of</h5>
        
        <input required name="key" type="text"/>
        
        <h5>Which Is A</h5>

  <input required type="radio" name="type" value="customerName"/>Customer Name
  <br>
  <input required type="radio" name="type" value="transitLine"/>Transit Line Name
  <br>
  <input required type="radio" name="type" value="destinationCity"/>Destination City
        <br><br>
        <button>Search</button>
    </form>
    
    
     <br><br>
    
    <h5>Best Customer:</h5>
    <%
    ApplicationDB db = new ApplicationDB();
   	Connection con = db.getConnection();
       Statement st = con.createStatement();
       ResultSet rs = st.executeQuery("select username from (select username, sum(totalfare) as totalCustomer from (select ff.username, ff.reservation_number, fg.totalfare from (select r.username, r.reservation_number from Reservation_Portfolio as r) as ff, (select reservation_number, (booking_fee+sum(fare)) as totalfare from (select reservation_number, booking_fee, (if(isChild,child_fare, if(isSenior, senior_fare, if(isDisabled,disabled_fare,normal_fare)))*if(class='economy',1,if(class='business',1.5,2))) as fare from (select r.reservation_number, booking_fee, class,isChild, isSenior,isDisabled,normal_fare,child_fare,senior_fare, disabled_fare  from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as n group by reservation_number union select reservation_number, booking_fee as totalfare from Reservation_Portfolio as ri where ri.isWeekly or ri.isMonthly) as fg where ff.reservation_number = fg.reservation_number) as jj group by username) as kl where kl.totalCustomer in (select max(totalCustomer) as totalCustomer from (select username, sum(totalfare) as totalCustomer from (select ff.username, ff.reservation_number, fg.totalfare from (select r.username, r.reservation_number from Reservation_Portfolio as r) as ff, (select reservation_number, (booking_fee+sum(fare)) as totalfare from (select reservation_number, booking_fee, (if(isChild, child_fare, if(isSenior, senior_fare, if(isDisabled,disabled_fare,normal_fare)))*if(class='economy',1,if(class='business',1.5,2))) as fare from (select r.reservation_number, booking_fee, class,isChild,isSenior, isDisabled,normal_fare,child_fare, senior_fare,disabled_fare  from Reservation_Portfolio as r, Has_Ride_Origin_Destination_PartOf as rd, Schedule_Origin_of_Train_Destination_of_Train_On as s where r.reservation_number = rd.reservation_number and rd.transit_line_name=s.transit_line_name) as k) as n group by reservation_number union select reservation_number, booking_fee as totalfare from Reservation_Portfolio as ri where ri.isWeekly or ri.isMonthly) as fg where ff.reservation_number = fg.reservation_number) as jj group by username) as kjkh);");
      if(rs.next()){
    	  rs.first();
    	  out.println("<p> "+rs.getString("username")+"</p>");
      }else{
    	  out.println("<p> N/A </p>");
      }
	  rs.close();
  	st.close();
  	db.closeConnection(con);
      %>
    
     <br><br>
    
    <h5>Top 5 Most Active Train Lines:</h5>
    
    
       <%
     db = new ApplicationDB();	
   	 con = db.getConnection();
        st = con.createStatement();
        rs = st.executeQuery("select transit_line_name, numberOfReservations from (select s.transit_line_name, count(*) as numberOfReservations from Has_Ride_Origin_Destination_PartOf as r, Schedule_Origin_of_Train_Destination_of_Train_On as s where s.transit_line_name=r.transit_line_name group by s.transit_line_name) as q order by numberOfReservations desc;");
      
       if(rs.next()){
    	   int count = 0;
    	  rs.beforeFirst();
    	  out.println("<table><tr><th>Transit Line Name</th><th>Number of Reservations</th></tr>");
    	  while(rs.next()&&count<5){
    	  out.println("<tr><td> "+rs.getString("transit_line_name")+"</td><td>"+rs.getString("numberOfReservations")+"</td></tr>");
    	  count++;
    	  }
    	  out.println("</table>");
      }else{
    	  out.println("<p> N/A </p>");
      }
	  rs.close();
  	st.close();
  	db.closeConnection(con);
      %>
 
    <br><br>
    <h3>Some Useful Data:</h3>
    	<h5>List of Train Schedules</h5> 
    <%
    db = new ApplicationDB();	
  	 con = db.getConnection();
       st = con.createStatement();
       rs = st.executeQuery("select * from Schedule_Origin_of_Train_Destination_of_Train_On;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Transit Line Name</th><th>Delayed?</th><th>Normal Fare</th><th>Child Fare</th><th>Senior Fare</th><th>Disabled Fare</th><th>Destination Arrival Date & Time</th><th>Destination Departure Date & Time</th><th>Origin Arrival Date & Time</th><th>Origin Departure Date & Time</th><th>Origin Station Number</th><th>Destination Station Number</th><th>Train Number</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString("isDelayed")+"</td><td>"+rs.getString("normal_fare")+"</td><td>"+rs.getString("child_fare")+"</td><td>"+rs.getString("senior_fare")+"</td><td>"+rs.getString("disabled_fare")+"</td><td>"+rs.getString("destination_arrival_time")+"</td><td>"+rs.getString("destination_departure_time")+"</td><td>"+rs.getString("origin_arrival_time")+"</td><td>"+rs.getString("origin_departure_time")+"</td><td>"+rs.getString("origin_station_id")+"</td><td>"+rs.getString("destination_station_id")+"</td><td>"+rs.getString("train_id")+"</td></tr>");
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>
	<h5>List of Other Stops Each Train Schedule Makes Besides their Origin and Destination</h5>
	    <%
    db = new ApplicationDB();	
  	 con = db.getConnection();
       st = con.createStatement();
       rs = st.executeQuery("select * from Stops_In_Between;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Transit Line Name</th><th>Station Number</th><th>Departure Date & Time</th><th>Arrival Date & Time</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString("id")+"</td><td>"+rs.getString("departure_time")+"</td><td>"+rs.getString("arrival_time")+"</td></tr>");
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>

	<h5>List of All Users in the System</h5>
		    <%
    db = new ApplicationDB();
  	 con = db.getConnection();
       st = con.createStatement();
       rs = st.executeQuery("select username , \"Customer\" as type from Customer union select username, \"Customer Rep\" as type from Employee_Customer_Rep union select username, \"Site Manager\" as type from Employee_Site_Manager;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Username</th><th>Type Of User</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString("type")+"</td></tr>");
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>
	<h5>List of All Trains</h5>
		    <%
    db = new ApplicationDB();
  	 con = db.getConnection();
       st = con.createStatement();
       rs = st.executeQuery("select * from Train;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Train Number</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1));
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>
	<h5>List of All Stations</h5>
		    <%
    db = new ApplicationDB();	
  	 con = db.getConnection();
       st = con.createStatement();
       rs = st.executeQuery("select * from Station;");
    	rs.beforeFirst();
    	
       out.println("<table><tr><th>Station Number</th><th>Station Name</th><th>State</th><th>City</th></tr>");
       	while(rs.next()){
       	out.println("<tr><td> "+rs.getString(1)+"</td><td>"+rs.getString(2)+"</td><td>"+rs.getString(3)+"</td><td>"+rs.getString(4)+"</td></tr>");
       	}
       out.println("</table>");
       
       rs.close();
     	st.close();
     	db.closeConnection(con);
    %>
    
     <br><br>
    
    <%  out.println("<button onclick=\"window.location.href='logout.jsp';\">Log Out</button>"); %>
     
   </body>
</html>