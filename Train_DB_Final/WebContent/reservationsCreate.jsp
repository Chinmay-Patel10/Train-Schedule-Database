<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
            <%@ page import="java.io.*,java.util.*,java.sql.*"%>
    <%@ page import="javax.servlet.http.*,javax.servlet.*" %>
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
	%>
   
   <script>
   function addRow(){
   let numRows = parseInt(document.getElementsByName("numRows")[0].value);
   document.getElementsByName("numRows")[0].value=numRows+1;
	let table =   document.getElementsByName("table")[0];
   var row  = table.insertRow(numRows);
   var cell1 = row.insertCell(0);
   var cell2 = row.insertCell(1);
   var cell3 = row.insertCell(2);
   var cell4 = row.insertCell(3);
   var cell5 = row.insertCell(4);
   var cell6 = row.insertCell(5);
 
	cell1.innerHTML =   " <input required name=\"transitLine"+(numRows+1)+"\" type=\"text\"/> <label for=\"transitLine"+numRows+1+"\"> Transit Line Name</label> ";
	cell2.innerHTML =  "	<select required name=\"class"+(numRows+1)+"\" > <option value='first'>First</option> <option value='business'>Business</option> <option value='economy'>Economy</option> </select>"
	cell3.innerHTML = " <input required name=\"originId"+(numRows+1)+"\" type=\"number\"/> <label for=\"originId"+numRows+1+"\"> Origin Station Id</label>"
	cell4.innerHTML =	" <input required name=\"destId"+(numRows+1)+"\" type=\"number\"/> <label for=\"destId"+numRows+1+"\"> Destination Station Id</label>"
	cell5.innerHTML = "<input required name=\"seatNumber"+(numRows+1)+"\" type=\"number\"/> <label for=\"seatNumber"+numRows+1+"\"> Seat Number</label>"
	cell6.innerHTML = "<select required name=\"discount"+(numRows+1)+"\" ><option value='none'>None of the Above</option><option value='childSenior'>Child/Senior</option><option value='disabled'>Disabled</option></select>"
   }
   
   function updateTable(){
	   var x = document.getElementsByName("table")[0];
	   var y = document.getElementsByName("jkjk")[0];
	   let z = document.getElementsByName("llll")[0];
	   if(document.getElementsByName("bookingFeeType")[0].value=='monthly' || document.getElementsByName("bookingFeeType")[0].value=='weekly'){
		   y.style.display = "none";
		   x.style.display = "none";
		   z.setAttribute("formnovalidate");
	   }else{
		   y.style.display = "block";
		   x.style.display = "block";
		   z.removeAttribute("formnovalidate");
	   }
	   
   }
   
   </script>
   
   
     <form action="reservationSubmission.jsp" method="post">
     <h5>Reservation</h5>

  
  	<select required name="bookingFeeType"  onclick = "updateTable();">
  	  <option value='single' onclick = "updateTable();">One Way Trip</option>
    <option value='round'onclick = "updateTable();">Round Trip</option>
   
    </select><br>
    <label for="bookingFeeType"> Type of Reservation</label>
  
  <input type="hidden" name="numRows" value =1>
  <br>
     <table name="table">
     <tr>
     <td>
	<input required name="transitLine1" type="text"/>
	<label for="transitLine1"> Transit Line Name</label>
	</td>
	<td>
	<select required name="class1" >
    <option value='first'>First</option>
    <option value='business'>Business</option>
    <option value='economy'>Economy</option>
    </select>
    </td>
    <td>
        	<input required name="originId1" type="number"/>
	<label for="originId1"> Origin Station Id</label>
	</td>
	<td>
	    	<input required name="destId1" type="number"/>
	<label for="destId1"> Destination Station Id</label>	
    </td>
    <td>
    	<input required name="seatNumber1" type="number"/>
	<label for="seatNumber1"> Seat Number</label>
	</td>
	<td>
		<select required name="discount1" >
		<option value='none'>Normal_fare</option>
    <option value='child'>Child_fare</option>
    <option value='child'>Senior_fare</option>
    <option value='disabled'>Disabled_fare</option>
    </select>
    </td>
	</tr>
     </table>
     <button type="button" name="jkjk" onclick="addRow();">Add Ride</button>
     <br><br>
     <button  name="llll" type="submit">Submit</button>
     </form>

	<h3>List of Train Schedules:</h3>

		<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement st5 = con.createStatement();
	
		// Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
		String query5 = "SELECT *, TIMEDIFF(destination_arrival_time,origin_departure_time) AS 'diff', num_seats - count(seat_number) AS 'availSeats'" 
			+	" from Train AS T join Schedule_Origin_of_Train_Destination_of_Train_On AS S on (S.train_id = T.id)" 
			+	" left outer join (SELECT DISTINCT transit_line_name, seat_number FROM Has_Ride_Origin_Destination_PartOf) AS Seats using (transit_line_name)";
		
		// Query for temporary table containing all stops
		/*
		SELECT transit_line_name, origin_station_id AS id, origin_departure_time AS departure_time, origin_arrival_time AS arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On
		UNION
		SELECT transit_line_name, destination_station_id AS id, destination_departure_time AS departure_time, destination_arrival_time AS arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On
		UNION
		SELECT * FROM Stops_In_Between
		ORDER BY transit_line_name, arrival_time;
		*/
		
		// Check if stationID was set
		String stationID = request.getParameter("stationID");
		
		//request.setAttribute("empid", "1234"); ENDJSP
		String originID = request.getParameter("originID");	
		String destID = request.getParameter("destID");	
		
		// If there is a statioID
		if (stationID != null) {
			// search by station id
			query5 += " WHERE origin_station_id = \'" + stationID + "\' or destination_station_id = \'" + stationID + 
			"\' or exists (SELECT * from Stops_In_Between AS B WHERE S.transit_line_name = B.transit_line_name and id = \'"+ stationID + "\')";
		} else if (originID != null && destID != null) {
			query5 +=
					" join"
				+	" (SELECT transit_line_name, origin_station_id AS 'id', origin_departure_time AS 'departure_time', origin_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT transit_line_name, destination_station_id AS 'id', destination_departure_time AS 'departure_time', destination_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT * FROM Stops_In_Between"
				+	" ORDER BY transit_line_name, arrival_time) AS Temp using (transit_line_name)"
				+	" WHERE Temp.id = \'" + originID + "\'"
				+	" and Temp.arrival_time < any"
				+	" (SELECT Temp.arrival_time FROM Schedule_Origin_of_Train_Destination_of_Train_On AS S2"
				+	" join"
				+	" (SELECT transit_line_name, origin_station_id AS 'id', origin_departure_time AS 'departure_time', origin_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT transit_line_name, destination_station_id AS 'id', destination_departure_time AS 'departure_time', destination_arrival_time AS 'arrival_time' FROM Schedule_Origin_of_Train_Destination_of_Train_On"
				+	" UNION"
				+	" SELECT * FROM Stops_In_Between"
				+	" ORDER BY transit_line_name, arrival_time) AS Temp using (transit_line_name)"
				+	" WHERE S.transit_line_name = S2.transit_line_name"
				+	" and Temp.id = \'" + destID + "\')";
		}
		
		query5 += " GROUP BY T.id, transit_line_name, origin_station_id, destination_station_id, origin_arrival_time, destination_departure_time, destination_arrival_time, origin_departure_time, num_seats, Seats.seat_number";
		
		//Execute query against the database.
		ResultSet rs5 = st5.executeQuery(query5);
		
		
		//Make an HTML table to show the results in:
		out.print("<table>");

		//make header row
		out.print("<tr>");
		
		//make header columns
		out.print("<th>Transit Line</td>");
		out.print("<th>Train ID</td>");
		out.print("<th>Origin Station</td>");
		out.print("<th>Destination Station</td>");
		out.print("<th>Seats Available</td>");
		out.print("<th>Stops (by Station id)</td>");
		out.print("<th>Delayed?</td>");
		out.print("<th>Travel Time</td>");
		out.print("<th>Regular Fare</td>");
		out.print("<th>Child Fare</td>");
		out.print("<th>Senior Fare</td>");
		out.print("<th>Disabled Fare</td>");

    	out.print("</tr>");
    	
    	
		//parse out the results
		while (rs5.next()) {
			
			// Create row of data
			out.print("<tr>");
			
			out.print("<td>");
			out.print(rs5.getString("transit_line_name"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getInt("train_id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getInt("origin_station_id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getInt("destination_station_id"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getInt("availSeats"));
			out.print("</td>");
			
			// List of Stops
			out.print("<td>");
			
			// Create a statement to get all stops
		    Statement stmt6 = con.createStatement();
			String stopQuery = "SELECT * FROM Stops_In_Between WHERE transit_line_name = \'" + rs5.getString("transit_line_name") + "\' ORDER BY arrival_time";
			ResultSet rs6 = stmt6.executeQuery(stopQuery);
			String listOfStops = "" + rs5.getInt("origin_station_id") + " (Arrives: " + rs5.getString("origin_arrival_time") + " // Departs: " + rs5.getString("origin_departure_time") + ")";
			while (rs6.next()) {
				listOfStops += "<br/>" + rs6.getInt("id") + " (Arrives: " + rs6.getString("arrival_time") + " // Departs: " + rs6.getString("departure_time") + ")";
			}
			
			listOfStops += "<br/>" + rs5.getInt("destination_station_id") + " (Arrives: " + rs5.getString("destination_arrival_time") + " // Departs: " + rs5.getString("destination_departure_time") + ")";
			
			stmt6.close();
		    rs6.close();
		    
		    out.print(listOfStops);
		    
			out.print("</td>");
			
			String delayed = rs5.getInt("isDelayed") == 0 ? "No" : "Yes";
			out.print("<td>");
			out.print(delayed);
			out.print("</td>");
			
			// Travel time
			out.print("<td>");
			out.print(rs5.getString("diff"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getDouble("normal_fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getDouble("child_fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getDouble("senior_fare"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(rs5.getDouble("disabled_fare"));
			out.print("</td>");
			
			out.print("</tr>");

		}
		
		out.print("</table>");
		rs5.close();
		st5.close();
		db.closeConnection(con);
   
		%>
   
   	<button onclick="window.location.href='customerReservations.jsp';">Cancel Reservation</button>
	
   
      </body>
</html>