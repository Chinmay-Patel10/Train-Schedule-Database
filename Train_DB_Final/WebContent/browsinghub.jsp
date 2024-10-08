<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>

<html>

	<!-- page with all the buttons -->
	<head>
		<meta charset="ISO-8859-1">
		<title>Browse and Search</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
		<style>
		body {
		margin: 0 !important;
		}
		</style>
	</head>
	
	<body>
	
		<h2>Browse and Search</h2>
		
		<!-- train scheds -->
		<section>
			<!-- search for train schedules 
			by origin, destination, date of travel -->
			<h3>Search Train Schedules</h3>
			
			<form action="trainSched.jsp" method="post">
				<label for="origin">Origin ID:</label>
  				<input name="origin" type="number"/>
  
  				<label for="dest">Destination ID:</label>
  				<input name="dest" type="number"/>
  	
				<label for="tDate">Date of Travel (YYYY-MM-DD):</label>
				<input name="tDate" type="text"/>	
				<br>			
				<button>Search</button>
			</form>
		</section>
		
		<!-- sort trains -->
		<section>
			<!-- sort by different criteria 
			(by arrival time, departure time, 
			origin, destination, fare)  -->
		
		<!-- train stops -->
		<section>
			<!-- a user should be able to see all 
			the stops a train will make -->
			<h3>See Train Stops</h3>
    
			<form action="stops.jsp" method="post">	
				<label for="origin">Origin ID:</label>
  				<input name="origin" type="number"/>
  
  				<label for="dest">Destination ID:</label>
  				<input name="dest" type="number"/>
  				<label for="line">Train Line:</label>
				<input name="line" type="text"/>
				<br>
				<button>Search</button>
			</form>
		</section>
		
		<h3>Sort All Trains</h3>
			<form action="sortTrains.jsp" method="post">
				
				<label for="sortType">Sort by:</label>

				<select name="sortType">
  					<option value="arrival time">Arrival Time</option>
 					<option value="departure time">Departure Time</option>
  					<option value="origin">Origin</option>
 					<option value="destination">Destination</option>
 					<option value="fare">Fare</option>
				</select>
				
				<label for="sortOrder">Order:</label>

				<select name="sortOrder">
  					<option value="ascending">Ascending</option>
 					<option value="descending">Descending</option>
				</select>
				<br>
				<button>Search</button>
			</form>
		</section>
		 
		<br><br>
		<button onclick="window.location.href='customerHome.jsp';">Return to Homepage</button>
	</body>
</html>