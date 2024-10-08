<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Stop</title>
</head>
<body>

<%
	// Get all registration data
	String transit = request.getParameter("transitLine");
	String stationID = request.getParameter("stationID");
    String aTime = request.getParameter("aTime");
    String dTime = request.getParameter("dTime");

    
    boolean invalidDate = false;
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    formatter.setLenient(false);
    
    try {
        java.util.Date arrive = formatter.parse(aTime);
        java.util.Date depart = formatter.parse(dTime);
        if (arrive.after(depart)) {
        	invalidDate = true;
        }
    } catch (ParseException e) {
        invalidDate = true;
    }
    
    if (invalidDate) {
    	out.println("<p>Sorry that date is in an invalid format.</p>");
        out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    }
    else {
    	    	
    	ApplicationDB db = new ApplicationDB();
    	Connection con = db.getConnection();
    	Statement st = con.createStatement();
    	Statement st5 = con.createStatement();
    	Statement st6 = con.createStatement();
    	Statement st8 = con.createStatement();
    	ResultSet rs = st.executeQuery("SELECT * from (SELECT transit_line_name, origin_station_id AS id, origin_departure_time AS departure_time, origin_arrival_time AS arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On UNION SELECT transit_line_name, destination_station_id AS id, destination_departure_time AS departure_time, destination_arrival_time AS arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On UNION SELECT * FROM Stops_In_Between) AS Temp where transit_line_name='" + transit + "' and id='" + stationID + "'");
    	ResultSet rs5 = st5.executeQuery("SELECT * from Schedule_Origin_of_Train_Destination_of_Train_On where transit_line_name ='" + transit + "';");
    	ResultSet rs6 = st6.executeQuery("SELECT * from Station where id ='" + stationID + "';");
    	ResultSet rs8 = st8.executeQuery("SELECT transit_line_name FROM Schedule_Origin_of_Train_Destination_of_Train_On"
    	+		" WHERE transit_line_name = '" + transit + "' and"
    	+		" ('"+ aTime +"' < origin_departure_time or '" + dTime + "' > destination_arrival_time)"
    	+		" UNION"
    	+		" SELECT transit_line_name FROM Stops_In_Between"
    	+		" WHERE transit_line_name = '" + transit + "'" 
    	+		" and '" + aTime + "' < departure_time"
    	+		" and '" + dTime+ "' > arrival_time");
    	if (rs.next()||transit==null||stationID==null||!rs5.next()||!rs6.next()||rs8.next()) {
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st8.close();
    		db.closeConnection(con);
    		out.println("<p>Sorry, Stop already exists or Invalid Transit Line or Station ID or Timings</p>");
        	out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
              
    	} else {
    		Statement st2=con.createStatement();
    		String query = "INSERT INTO Stops_In_Between(transit_line_name,id,departure_time,arrival_time) VALUES ('" + 
        	    transit + "', '" + stationID + "', '" + dTime + "', '" + aTime + "');";
    		st2.executeUpdate(query);
    		rs.close();
    		st.close();
    		rs5.close();
    		rs6.close();
    		rs8.close();
    		st5.close();
    		st6.close();
    		st8.close();
    		st2.close();
    		db.closeConnection(con);
    		out.println("<p>Stop Created!</p>");
    		out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    	}
    }
%>
</body>
</html>