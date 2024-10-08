<!-- MADE BY JOSHUA ROSS, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    	if ((session.getAttribute("user") == null) || (session.getAttribute("employee") == null))
    	{
    		response.sendRedirect("notFound.jsp");
    	}
%>
<!DOCTYPE html>
<html>
<head>
<title>Train Schedule Modification</title>
<style>
table {
	font-family: arial, sans-serif;
	border-collapse: collapse;
	white-space: nowrap;
}

td, th {
	font-family: arial, sans-serif;
	font-size: 6pt;
	border: 1px solid #dddddd;
	text-align: left;
	padding: 8px;
}

tr:nth-child(even) {
	background-color: #dddddd;
}
</style>
</head>
<body>
	
	<form action="reservations.jsp" method="get">
		<button>Back</button>
	</form>
	<%
String resID = request.getParameter("resID"),action = request.getParameter("action");
if(action.equals("add")){ // Add a schedule
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
 
	cell1.innerHTML = "<input required name=\"transitLine"+(numRows+1)+"\" type=\"text\"/> <label for=\"transitLine"+(numRows+1)+"\"> Transit Line Name</label> ";
	cell2.innerHTML = "<select required name=\"class"+(numRows+1)+"\" > <option value='first'>First</option> <option value='business'>Business</option> <option value='economy'>Economy</option> </select>"
	cell3.innerHTML = "<input required name=\"originID"+(numRows+1)+"\" type=\"number\"/> <label for=\"originID"+(numRows+1)+"\"> Origin Station Id</label>"
	cell4.innerHTML = "<input required name=\"destID"+(numRows+1)+"\" type=\"number\"/> <label for=\"destID"+(numRows+1)+"\"> Destination Station Id</label>"
	cell5.innerHTML = "<input required name=\"seatNumber"+(numRows+1)+"\" type=\"number\"/> <label for=\"seatNumber"+(numRows+1)+"\"> Seat Number</label>"
	cell6.innerHTML = "<select required name=\"discount"+(numRows+1)+"\" ><option value='childSenior'>Child/Senior</option><option value='disabled'>Disabled</option><option value='none' selected>None of the Above</option></select>"
	
   }
   
   function updateTable(){
	   var x = document.getElementsByName("table")[0];
	   var y = document.getElementsByName("jkjk")[0];
	   let z = document.getElementsByName("llll")[0];
	   if(document.getElementsByName("bookingFeeType")[0].value=='monthly' || document.getElementsByName("bookingFeeType")[0].value=='weekly'){
		   y.style.display = "none";
		   x.style.display = "none";
		   z.setAttribute("formnovalidate", "");
		   //document.getElementsByName("transitLine1")[0].removeAttribute('required');
	   }else{
		   y.style.display = "block";
		   x.style.display = "block";
		   z.removeAttribute("formnovalidate");
		   //document.getElementsByName("transitLine1")[0].required = true;
	   }
	   
   }
   window.onload = function() {
	   updateTable();
	   document.getElementsByName("transitLine1")[0].required = true;
	};
   </script>


	<form action="createReservationCR.jsp" method="post">
		<h5>Reservation</h5>
		<br> <label for="userID">For Username:</label> <input type="text"
			name="userID" required><br /> <label for="bFee">Booking
			Fee:</label> <input type="number" step="0.01" name="bFee" required><br />
		<label for="bookingFeeType"> Type of Reservation</label> <select
			required name="bookingFeeType" onchange="updateTable();">
			<option value='single'>One Way Trip</option>
			<option value='monthly'>Monthly Pass</option>
			<option value='weekly'>Weekly Pass</option>
			<option value='round'>Round Trip</option>
		</select> <input type="hidden" name="numRows" value=1> <br>
		<table name="table">
			<tr>
				<td><input required name="transitLine1" type="text" /> <label
					for="transitLine1"> Transit Line Name</label></td>
				<td><select required name="class1">
						<option value='first'>First</option>
						<option value='business'>Business</option>
						<option value='economy'>Economy</option>
				</select></td>
				<td><input required name="originID1" type="number" /> <label
					for="originID1"> Origin Station Id</label></td>
				<td><input required name="destID1" type="number" /> <label
					for="destID1"> Destination Station Id</label></td>
				<td><input required name="seatNumber1" type="number" /> <label
					for="seatNumber1"> Seat Number</label></td>
				<td><select required name="discount1">
						<option value='childSenior'>Child/Senior</option>
						<option value='disabled'>Disabled</option>
						<option value='none' selected>None of the Above</option>
				</select></td>
			</tr>
		</table>
		<button type="button" name="jkjk" onclick="addRow();">Add
			Ride</button>
		<br>
		<br>
		<button name="llll" type="submit">Submit</button>
	</form>

	<button onclick="window.location.href='reservations.jsp';">Cancel
		Reservation</button>



	<%	
	}else if (action.equals("edit")){
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery("SELECT * from Reservation_Portfolio where reservation_number = '" + resID + "'");
		if(!rs.next()){
			rs.close();
    		st.close();
    		out.println("<p>Reservation number doesn't exist or was deleted.</p>");
		}else{
			rs.first();
			String date_made = rs.getString("date_made"), booking_fee =rs.getString("booking_fee"), isMonthly = rs.getString("isMonthly"), 
					isWeekly = rs.getString("isWeekly"), isRoundTrip = rs.getString("isRoundTrip"), username = rs.getString("username");
			
			rs.close();
	    	st.close();
	    	
	    	boolean hasRide = false;
	    	String bFeeType = "";
	    	if(isRoundTrip.equals("1")) {
	    		bFeeType = "round";
	    		hasRide = true;
	    	}
	    	else{
	    		bFeeType = "single";
	    		hasRide = true;
	    	}
	    	
%>
	<script>
   function addRow(isBegin){
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
   var cell7 = row.insertCell(6);
 
	cell1.innerHTML = "<input required name=\"transitLine"+(numRows+1)+"\" type=\"text\"/> <label for=\"transitLine"+(numRows+1)+"\"> Transit Line Name</label> ";
	cell2.innerHTML = "<select required name=\"class"+(numRows+1)+"\" > <option value='first'>First</option> <option value='business'>Business</option> <option value='economy'>Economy</option> </select>";
	cell3.innerHTML = "<input required name=\"originID"+(numRows+1)+"\" type=\"number\"/> <label for=\"originID"+(numRows+1)+"\"> Origin Station Id</label>";
	cell4.innerHTML = "<input required name=\"destID"+(numRows+1)+"\" type=\"number\"/> <label for=\"destID"+(numRows+1)+"\"> Destination Station Id</label>";
	cell5.innerHTML = "<input required name=\"seatNumber"+(numRows+1)+"\" type=\"number\"/> <label for=\"seatNumber"+(numRows+1)+"\"> Seat Number</label>";
	cell6.innerHTML = "<select required name=\"discount"+(numRows+1)+"\" ><option value='childSenior'>Child/Senior</option><option value='disabled'>Disabled</option><option value='none'>None of the Above</option></select>";
	if (isBegin) {
		x = "'deleteRow" + (numRows+1) +"'";
   		cell7.innerHTML = '<input type="hidden" name="connection_number'+(numRows+1)+'"><button type="button" name="remove" onclick="document.forms[' + x + '].submit();">Remove</button>';

   		var f = document.createElement("form");
   		f.id = "deleteRow" + (numRows+1);
   		f.action = "deleteRide.jsp";
   		f.method = "post";

   		f.innerHTML = '<input type="hidden" name="resID" value="<%out.print(resID);%>"><input type="hidden" name="action" value="edit"><input id="con" type="hidden" name="connNum">';
   		
   		var element = document.getElementById("removals");
   		element.appendChild(f);
   	} else {
	   cell7.innerHTML = '<input type="hidden" name="connection_number'+(numRows+1)+'">N/A';
   	}
	
   }
   
   function updateTable(){
	   var x = document.getElementsByName("table")[0];
	   var y = document.getElementsByName("jkjk")[0];
	   let z = document.getElementsByName("llll")[0];
	   if(document.getElementsByName("bookingFeeType")[0].value=='monthly' || document.getElementsByName("bookingFeeType")[0].value=='weekly'){
		   y.style.display = "none";
		   x.style.display = "none";
		   z.setAttribute("formnovalidate", "");
		   //document.getElementsByName("transitLine1")[0].removeAttribute('required');
	   }else{
		   y.style.display = "block";
		   x.style.display = "block";
		   z.removeAttribute("formnovalidate");
		   //document.getElementsByName("transitLine1")[0].required = true;
	   }
	   
   }
   window.onload = function() {
	   document.querySelector('option[value="<%out.print(bFeeType);%>"]').selected = true;
	   <%if (hasRide) {
		  	Statement st2 = con.createStatement();
			ResultSet rs2 = st2.executeQuery("SELECT * from Has_Ride_Origin_Destination_PartOf where reservation_number = '" + resID + "'");
			
			// Iterate through values for each row
			for (int i = 1; rs2.next(); i++) {
				String seatClass = rs2.getString("class"), seat_number = rs2.getString("seat_number"), isChild = rs2.getString("isChild"), isSenior = rs2.getString("isSenior"), 
						isDisabled = rs2.getString("isDisabled"), origin_id = rs2.getString("origin_id"), destination_id = rs2.getString("destination_id"),
						transit_line_name = rs2.getString("transit_line_name"), connection_number = rs2.getString("connection_number");
				String discount = isChild.equals("1") ? "child" : "none";
				discount = isDisabled.equals("1") ? "disabled" : discount;
				if (i > 1) { // If more than one rows, add one
	   %>
	   			addRow(true);
	   			<%}%>
	   			document.getElementsByName("transitLine<%out.print(i);%>")[0].value = "<%out.print(transit_line_name);%>";
	   			document.getElementsByName("class<%out.print(i);%>")[0].querySelector('option[value="<%out.print(seatClass);%>"]').selected = true;
	   			document.getElementsByName("originID<%out.print(i);%>")[0].value = <%out.print(origin_id);%>;
	   			document.getElementsByName("destID<%out.print(i);%>")[0].value = <%out.print(destination_id);%>;
	   			document.getElementsByName("seatNumber<%out.print(i);%>")[0].value = <%out.print(seat_number);%>;
	   			document.getElementsByName("discount<%out.print(i);%>")[0].querySelector('option[value="<%out.print(discount);%>"]').selected = true;
	   			document.getElementById("deleteRow<%out.print(i);%>").children[2].value = "<%out.print(connection_number);%>";
	   			document.getElementsByName("connection_number<%out.print(i);%>")[0].value = "<%out.print(connection_number);%>";
	<%	}
			rs2.close();
			st2.close();
	   }
	   db.closeConnection(con);
	   %>
		updateTable();
		};
	</script>


	<form action="updateReservationCR.jsp" method="post">
		<h5>Reservation</h5>
		<br> <label for="userID">For Username:</label> <input required
			type="text" name="userID" value='<%out.print(username);%>'><br />
		<label for="bFee">Booking Fee:</label> <input required type="number"
			step="0.01" name="bFee" value=<%out.print(booking_fee);%>><br />
		<label for="date_made">Date Created (YYYY-MM-DD hh:mm:ss):</label> <input
			required type="text" name="date_made"
			value='<%out.print(date_made);%>'><br /> <label
			for="bookingFeeType">Type of Reservation:</label> <select required
			name="bookingFeeType" onchange="updateTable();">
			<option value='single'>One Way Trip</option>
			<option value='round'>Round Trip</option>
		</select> <input type="hidden" name="numRows" value=1> <input
			type="hidden" name="reservation_number" value="<%out.print(resID);%>">
		<br>
		<table name="table">
			<tr>
				<td><input required name="transitLine1" type="text" /> <label
					for="transitLine1"> Transit Line Name</label></td>
				<td><select required name="class1">
						<option value='first'>First</option>
						<option value='business'>Business</option>
						<option value='economy'>Economy</option>
				</select></td>
				<td><input required name="originID1" type="number" /> <label
					for="originID1"> Origin Station Id</label></td>
				<td><input required name="destID1" type="number" /> <label
					for="destID1"> Destination Station Id</label></td>
				<td><input required name="seatNumber1" type="number" /> <label
					for="seatNumber1"> Seat Number</label></td>
				<td><select required name="discount1">
						<option value='childSenior'>Child</option>
						<option value='disabled'>Senior</option>
						<option value='disabled'>Disabled</option>
						<option value='none'>None of the Above</option>
				</select></td>
				
			</tr>
		</table>
		<button type="button" name="jkjk" onclick="addRow(false);">Add
			Ride</button>
		<br>
		<br>
		<button name="llll" type="submit">Submit</button>
	</form>

	<button onclick="window.location.href='reservations.jsp';">Cancel
		Reservation</button>

	<span id="removals">
		<form id="deleteRow1" action="deleteRide.jsp" method="post">
			<input type="hidden" name="resID" value="<%out.print(resID);%>">
			<input type="hidden" name="action" value="edit"> <input
				id='con' type="hidden" name="connNum">
		</form>
	</span>


	<%
	}
		
}else{
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement st = con.createStatement();
	st.executeUpdate("delete from Reservation_Portfolio where reservation_number= \""+ resID +"\";");
	st.close();
	db.closeConnection(con);
	out.println("<p>Deleted</p>");	
	out.println("<button onclick=\"window.location.href='reservations.jsp';\">Go Back</button>");
	}
	



%>
</body>
</html>