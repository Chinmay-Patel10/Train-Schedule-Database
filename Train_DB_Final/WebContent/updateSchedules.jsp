<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update Account</title>
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
String fareStr = request.getParameter("fare");
String cFareStr = request.getParameter("cFare");
String sFareStr = request.getParameter("sFare");
String dFareStr = request.getParameter("dFare");

boolean invalidDate = false;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
formatter.setLenient(false);

// Parse and validate date and time inputs
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

// Parse and validate fare inputs
double fare = 0;
double cFare = 0;
double sFare = 0;
double dFare = 0;
boolean invalidFare = false;
try {
    if (fareStr != null) fare = Double.parseDouble(fareStr);
    if (cFareStr != null) cFare = Double.parseDouble(cFareStr);
    if (sFareStr != null) sFare = Double.parseDouble(sFareStr);
    if (dFareStr != null) dFare = Double.parseDouble(dFareStr);
} catch (NumberFormatException e) {
    invalidFare = true;
}

if (invalidDate || invalidFare) {
    out.println("<p>Sorry, there was an error with the input data. Please ensure all fields are correctly formatted and try again.</p>");
    out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
} else {
    boolean isDelayed = false;
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement st5 = con.createStatement();
    Statement st6 = con.createStatement();
    Statement st7 = con.createStatement();
    Statement st8 = con.createStatement();
    Statement st10 = con.createStatement();
    ResultSet rs5 = st5.executeQuery("SELECT * from Train where id ='" + trainID + "';");
    ResultSet rs6 = st6.executeQuery("SELECT * from Station where id ='" + originID + "';");
    ResultSet rs7 = st7.executeQuery("SELECT * from Station where id ='" + destID + "';");
    ResultSet rs8 = st8.executeQuery("SELECT * FROM Stops_In_Between WHERE transit_line_name = '" + transit + "' and ('" + originDTime + "' > arrival_time or '" + destATime + "' < departure_time)");
    ResultSet rs10 = st10.executeQuery("SELECT * FROM Stops_In_Between WHERE transit_line_name = '" + transit + "' and (id = '" + originID + "' or id = '" + destID + "')");

    if (!rs5.next()) {
        rs5.close();
        rs6.close();
        rs7.close();
        rs8.close();
        rs10.close();
        st5.close();
        st6.close();
        st7.close();
        st8.close();
        st10.close();
        db.closeConnection(con);
        out.println("<p>Sorry, Invalid Train ID or Station IDs or Timings or Tried to set stop as origin/destination before deleting</p>");
        out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    } else if (!rs6.next() || !rs7.next()) {
        rs5.close();
        rs6.close();
        rs7.close();
        rs8.close();
        rs10.close();
        st5.close();
        st6.close();
        st7.close();
        st8.close();
        st10.close();
        db.closeConnection(con);
        out.println("<p>Sorry, Station ID is invalid</p>");
        out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    } else if (rs8.next() || rs10.next()) {
        rs5.close();
        rs6.close();
        rs7.close();
        rs8.close();
        rs10.close();
        st5.close();
        st6.close();
        st7.close();
        st8.close();
        st10.close();
        db.closeConnection(con);
        out.println("<p>Sorry, Tried to set stop as origin/destination before deleting that stop from line</p>");
        out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    } else {
        Statement st2 = con.createStatement();
        Statement st9 = con.createStatement();
        ResultSet rs9 = st9.executeQuery("SELECT * FROM Schedule_Origin_of_Train_Destination_of_Train_On"
                + " WHERE transit_line_name = '" + transit + "' and"
                + " ('" + originDTime + "' > origin_departure_time"
                + " or '" + destATime + "' > destination_arrival_time);");

        // Check if train delayed
        if (rs9.next()) {
            isDelayed = true;
        }

        String query = "UPDATE Schedule_Origin_of_Train_Destination_of_Train_On"
                + " SET";
        if (isDelayed) {
            query += " isDelayed = '1',";
        }
        query += " normal_fare = '" + fare + "',"
                + " child_fare = '" + cFare + "',"
                + " senior_fare = '" + sFare + "',"
                + " disabled_fare = '" + dFare + "',"
                + " destination_arrival_time = '" + destATime + "',"
                + " destination_departure_time = '" + destDTime + "',"
                + " origin_arrival_time = '" + originATime + "',"
                + " origin_departure_time = '" + originDTime + "',"
                + " origin_station_id = '" + originID + "',"
                + " destination_station_id = '" + destID + "',"
                + " train_id = '" + trainID + "'"
                + " WHERE transit_line_name = '" + transit + "'";

        st2.executeUpdate(query);

        st2.close();
        rs5.close();
        rs6.close();
        rs7.close();
        rs8.close();
        rs9.close();
        rs10.close();
        st5.close();
        st6.close();
        st7.close();
        st8.close();
        st9.close();
        st10.close();
        db.closeConnection(con);

        out.println("<p>Schedule Updated!</p>");
        out.println("<button onclick=\"window.location.href='schedules.jsp';\">Go Back</button>");
    }
}
%>
</body>
</html>
