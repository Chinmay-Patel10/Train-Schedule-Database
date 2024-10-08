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
<%String username = request.getParameter("username"),type = request.getParameter("type"),action = request.getParameter("action");

if(type.equals( "customer")){
	
	if(action.equals( "add")){
		
		%>
		
		<h3>Create an Account</h3>
	<form action="adminCreateCustomer.jsp" method="post">
    <h5>First Name</h5> <input type="text" name="name_firstname" required>
    <h5>Last Name</h5> <input type="text" name="name_lastname" required>
    <h5>Username </h5><input type="text" name="username" required value=<%out.println(username); %>>
    <h5>Password  </h5><input type="password" name="password" required>
    <h5>Email </h5><input type="text" name="email" required> <br/>
    <br><br>
    <input type="submit" value="Create Account"><br><br><br>
</form>
		
		<%
		
	}else if (action.equals("edit")){
		ApplicationDB db = new ApplicationDB();
		    Connection con = db.getConnection();
		    Statement st = con.createStatement();
		ResultSet rs = st.executeQuery("SELECT * from Customer where username='" + username + "';");
		if(!rs.next()){
		rs.close();
    	st.close();
    	con.close();
    	out.println("<p>Sorry that user doesnt exist.</p>");
        out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
		}else{
			rs.first();
			String password = rs.getString("password"), email =rs.getString("email"), first = rs.getString("name_firstname"), last = rs.getString("name_lastname");
		
			rs.close();
	    	st.close();
	    	con.close();
%>
		
		<h3>Update an Account</h3>
	<form action="adminUpdateCustomer.jsp" method="post">
    <h5>First Name</h5> <input type="text" name="name_firstname" required value=<%out.println(first); %>>
    <h5>Last Name</h5> <input type="text" name="name_lastname" required value=<%out.println(last); %>>
    <h5>Username </h5><input type="text" name="username" required value=<%out.println(username); %> readonly>
    <h5>Password  </h5><input type="password" name="password" required value=<%out.println(password); %>>
    <h5>Email </h5><input type="text" name="email" required value=<%out.println(email); %>> <br/>

	<br/><br><br>
    <input type="submit" value="Update Account"><br><br><br>
</form>
		
		<%
		}
		
	}else{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
	   Statement st = con.createStatement();
	   st.executeUpdate("delete from Customer where username= \""+username +"\";");
	   st.close();
	   db.closeConnection(con);
		out.println("<p>Deleted</p>");
		
		 out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
	}
	
}else if (type.equals("employee")){
	if(action.equals( "add")){
		
		%>
				<h3>Create an Account</h3>
	<form action="adminCreateEmployee.jsp" method="post">
    <h5>First Name</h5> <input type="text" name="name_firstname" required>
    <h5>Last Name</h5> <input type="text" name="name_lastname" required>
    <h5>Username </h5><input type="text" name="username" required value=<%out.println(username); %>>
    <h5>Password  </h5><input type="password" name="password" required>
    <h5>SSN</h5> <input type="text" name="ssn" required>
        <select required name="type" >
    <option value="rep">Customer Representative</option>
    <option value="manag">Site Manager</option>
    </select>
    <br/><br><br>
    <input type="submit" value="Create Account"><br><br><br>
</form>
		
		<%
		
	}else if (action.equals("edit")){
		
		ApplicationDB db = new ApplicationDB();
		    Connection con = db.getConnection();
		    Statement st = con.createStatement(), st2 = con.createStatement();
		ResultSet rs = st.executeQuery("SELECT * from Employee_Customer_Rep where username='" + username + "';");
		ResultSet rs2 = st2.executeQuery("SELECT * from Employee_Site_Manager where username='" + username + "';");
		if(!rs.next()&&!rs2.next()){
		rs.close();
		rs2.close();
 	st.close();
		st2.close();
 	con.close();
 	out.println("<p>Sorry that user doesnt exist.</p>");
     out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
		}else{
			rs.beforeFirst();
			String typer;
			String ssn, first, last, password;
			if(rs.next()){
				//customer rep
				typer="rep";
				rs.first();
				ssn = rs.getString("ssn");
				first = rs.getString("name_firstname");
				last = rs.getString("name_lastname");
				password = rs.getString("password");
			}else{
				typer="manag";
				rs2.first();
				ssn = rs2.getString("ssn");
				first = rs2.getString("name_firstname");
				last = rs2.getString("name_lastname");
				password = rs2.getString("password");
				//manager
			}
			
		
			rs.close();
	    	st.close();
			rs2.close();
	    	st2.close();
	    	con.close();

%>
		
		

<h3>Update an Account</h3>
	<form action="adminUpdateEmployee.jsp" method="post">
    <h5>First Name</h5> <input type="text" name="name_firstname" required value=<%out.println(first); %>>
    <h5>Last Name</h5> <input type="text" name="name_lastname" required value=<%out.println(last); %>>
    <h5>Username </h5><input type="text" name="username" required value=<%out.println(username); %> readonly>
    <h5>Password  </h5><input type="password" name="password" required value=<%out.println(password); %>>
    <h5>SSN</h5> <input type="text" name="ssn" required value=<%out.println(ssn); %>>
        <input required name="type" type ="hidden" readonly value=<%out.println(typer); %>>
    
    <br/><br><br>
    <input type="submit" value="Update Account"><br><br><br>
</form>
		
		<%
		}
		
	}else{
		if(username.equals("admin")){
			out.println("<p>Cannot Delete The Original Site Manager</p>");
			 out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
		}else{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
	   Statement st = con.createStatement();
	   st.executeUpdate("delete from Employee_Customer_Rep where username= \""+username +"\";");
	   Statement st2 = con.createStatement();
	   st2.executeUpdate("delete from Employee_Site_Manager where username= \""+username +"\";");
		st.close();
		st2.close();
		db.closeConnection(con);
		out.println("<p>Deleted</p>");
		
		 out.println("<button onclick=\"window.location.href='commandcenter.jsp';\">Go Back</button>");
		}
	}
	
}


%>
</body>
</html>