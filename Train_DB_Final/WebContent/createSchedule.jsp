<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Schedule</title>
</head>
<body>

<%
	// Get all registration data
	String transit = request.getParameter("transitLine");
	String trainID = request.getParameter("trainID");
    String originID = request.getParameter("originID");   
    String destID = request.getParameter("destID");
    String originATime = request.getParameter("originATime");
    String originDTime = request.getParameter("originDTime");
    String destATime = request.getParameter("destATime");
    String destDTime = request.getParameter("destDTime");
    String fare = request.getParameter("fare");
    String scFare = request.getParameter("scFare");
    String dFare = request.getParameter("dFare");
    
    boolean invalidDate = false;
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    formatter.setLenient(false);
    
    try {
        java.util.Date oA = formatter.parse(originATime);
        java.util.Date oD = formatter.parse(originDTime);
        java.util.Date dA = formatter.parse(destATime);
        java.util.Date dD = formatter.parse(destDTime);
        if (oA.after(oD) || oD.after(dA) || dA.after(dD)) {
        	invalidDate = true;
        }
    } catch (ParseException e) {
        invalidDate = true;
    }
    
    if (invalidDate) {
    	out.println("<p>Sorry that date is in an invalid format or invalid timing</p>");
        out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    }
    else {
    	    	
    	ApplicationDB db = new ApplicationDB();
    	Connection con = db.getConnection();
    	Statement st = con.createStatement();
    	Statement st5 = con.createStatement();
    	Statement st6 = con.createStatement();
    	Statement st7 = con.createStatement();
    	Statement st8 = con.createStatement();
    	ResultSet rs = st.executeQuery("SELECT * from Schedule_Origin_of_Train_Destination_of_Train_On where transit_line_name='" + transit + "'");
    	ResultSet rs5 = st5.executeQuery("SELECT * from Train where id ='" + trainID + "';");
    	ResultSet rs6 = st6.executeQuery("SELECT * from Station where id ='" + originID + "';");
    	ResultSet rs7 = st7.executeQuery("SELECT * from Station where id ='" + destID + "';");
    	ResultSet rs8 = st8.executeQuery("SELECT * FROM Stops_In_Between WHERE transit_line_name = '" + transit + "' and ('" + originDTime + "' > arrival_time or '" + destATime + "' < departure_time)");
    	if (rs.next()||transit==null||fare==null||scFare==null||dFare==null) {
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs7.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st7.close();
    		st8.close();
    		db.closeConnection(con);
    		out.println("<p>Sorry, Transit Line already exists or fields not set</p>");
        	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
              
    	} else if (!rs5.next()) {
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs7.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st7.close();
    		st8.close();
    		db.closeConnection(con);
    		out.println("<p>Sorry, Invalid Train ID</p>");
        	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    	} else if (!rs6.next()||!rs7.next()) {
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs7.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st7.close();
    		st8.close();
    		db.closeConnection(con);
    		out.println("<p>Sorry, Invalid Station IDs</p>");
        	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    	} else if (rs8.next()) {
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs7.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st7.close();
    		st8.close();
    		db.closeConnection(con);
    		out.println("<p>Sorry, the stops in between do not match the origin and destination</p>");
        	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    	} else {
    		Statement st2=con.createStatement();
    		String query = "INSERT INTO Schedule_Origin_of_Train_Destination_of_Train_On(transit_line_name, isDelayed, normal_fare, senior_child_fare, disabled_fare, destination_arrival_time, destination_departure_time, origin_arrival_time, origin_departure_time, origin_station_id, destination_station_id, train_id) VALUES (\'" + 
        	    transit + "\', \'0\', \'" + fare + "\', \'" + scFare + "\', \'" + dFare + "\', \'" + 
    			destATime + "\', \'" + destDTime + "\', \'" + originATime + "\', \'" + originDTime + "\', \'" + 
        	    originID + "\', \'" + destID + "\', \'" + trainID + "\');";
    		st2.executeUpdate(query);
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs7.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st7.close();
    		st8.close();
    		st2.close();
    		db.closeConnection(con);
    		out.println("<p>Schedule Created!</p>");
    		out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    	}
    }
%>
</body>
</html>