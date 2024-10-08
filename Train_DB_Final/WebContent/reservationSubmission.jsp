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

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement st = con.createStatement();

    double booking_fee = 0;
    int isRoundTrip = 0;
    String username = (String) session.getAttribute("user");
    String query;
    String rideQuery = "";

    DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String date = df.format(new java.util.Date());

    int fail = 0;

    String booking_fee_type = request.getParameter("bookingFeeType");
    if (booking_fee_type.equals("round")) isRoundTrip = 1;

    int numrows = Integer.parseInt(request.getParameter("numRows"));
    double total_fare = 0;

    for (int i = 1; i <= numrows; i++) {
        int isChild = 0;
        int isSenior = 0;
        int isDisabled = 0;
        double rideFare = 0;

        String discount = request.getParameter("discount" + i);
        String seatingClass = request.getParameter("class" + i);
        String seatNumber = request.getParameter("seatNumber" + i);
        String origID = request.getParameter("originId" + i);
        String destID = request.getParameter("destId" + i);
        String transitLine = request.getParameter("transitLine" + i);

        // Retrieve the appropriate fare based on discount type
        String fareQuery = "SELECT normal_fare, child_fare, senior_fare, disabled_fare FROM schedule_origin_of_train_destination_of_train_on WHERE transit_line_name = '" + transitLine + "'";
        Statement stFare = con.createStatement();
        ResultSet rsFare = stFare.executeQuery(fareQuery);
        if (rsFare.next()) {
            double normalFare = rsFare.getDouble("normal_fare");
            double childFare = rsFare.getDouble("child_fare");
            double seniorFare = rsFare.getDouble("senior_fare");
            double disabledFare = rsFare.getDouble("disabled_fare");

            if ("child".equals(discount)) {
                rideFare = childFare;
                isChild = 1;
            } else if ("senior".equals(discount)) {
                rideFare = seniorFare;
                isSenior = 1;
            } else if ("disabled".equals(discount)) {
                rideFare = disabledFare;
                isDisabled = 1;
            } else {
                rideFare = normalFare;
            }

            // Double the fare if it's a round trip
            if (isRoundTrip == 1) {
                rideFare *= 2;
            }

        } else {
            out.println("<p>An error has occurred. Fare information for " + transitLine + " could not be found</p>");
            out.println("<button onclick=\"window.location.href='reservationsCreate.jsp';\">Go Back</button><br><button onclick=\"window.location.href='customerHome.jsp';\">Return to Home Page</button>");
            fail = 1;
            break;
        }
        rsFare.close();
        stFare.close();

        if (fail != 0) break;

        total_fare += rideFare;

        rideQuery += "(\'" + origID + "\', \'" + destID
                + "\', \"" + seatingClass + "\", \'" + seatNumber + "\', \'" 
                + isChild + "\', \'" + isSenior + "\', \'" + isDisabled + "\', \"" + transitLine + "\", \"R3SERVATION_NUMBER\")";

        if (i != numrows) {
            rideQuery += ", ";
        }
    }

    if (fail == 0) {
        booking_fee = total_fare;
        query = "INSERT INTO Reservation_Portfolio(date_made, booking_fee, isRoundTrip, username)"
                + " VALUES (\'" + date + "\', \'" + booking_fee
                + "\', \'" + isRoundTrip + "\', \'" + username + "\')";
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

        rideQuery = "INSERT INTO Has_Ride_Origin_Destination_PartOf(origin_id, destination_id, class, seat_number, isChild, isSenior, isDisabled, transit_line_name, reservation_number)"
                + " VALUES " + rideQuery;

        Statement st3 = con.createStatement();
        st3.executeUpdate(rideQuery);
        st3.close();
        db.closeConnection(con);
    }

    if (fail == 0) {
        out.println("<h3>Reservation completed successfully with booking fee $" + booking_fee + "</h3>");
        out.println("<button onclick=\"window.location.href='customerReservations.jsp';\">Back to Reservations</button><br><button onclick=\"window.location.href='reservationsCreate.jsp';\">Create Another Reservation</button><br><button onclick=\"window.location.href='customerHome.jsp';\">Return to Home Page</button>");
    }
%>

</body>
</html>
