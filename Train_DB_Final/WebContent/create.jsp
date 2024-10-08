<!-- MADE BY JOSHUA ROSS AND RONAK PARIKH, DATABASES GROUP 11 -->


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
    <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Account</title>
</head>
<body>

<%
	// Get all registration data
	String firstName = request.getParameter("name_firstname");
	String lastName = request.getParameter("name_lastname");
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    String email = request.getParameter("email");
    
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement st = con.createStatement();
    Statement st5 = con.createStatement();
    Statement st6 = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * from Customer where username='" + userid + "';");
    ResultSet rs5 = st5.executeQuery("SELECT * from Employee_Customer_Rep where username='" + userid + "';");
    ResultSet rs6=st6.executeQuery("SELECT * from Employee_Site_Manager where username='" + userid + "';");
    
    if (rs.next()||userid==null||pwd==null||rs5.next()||rs6.next()) {
    	rs.close();
    	st.close();
    	rs5.close();
    	rs6.close();
    	st5.close();
    	st6.close();
    	con.close();
    	out.println("<p>Sorry that user already exists or is invalid. You can login or create an account with a different username.</p>");
        out.println("<button onclick=\"window.location.href='createPage.jsp';\">Try Again</button><br><button onclick=\"window.location.href='login.jsp';\">Log In</button>");
              
    } else {
    	Statement st2=con.createStatement();
    	String query = "INSERT INTO Customer(username, password, email, name_firstname, name_lastname) VALUES (\'" + 
        	    userid + "\', \'" + pwd + "\', \'" + email + "\', \'" + 
        	    firstName + "\', \'" + lastName + "\');";
    	st2.executeUpdate(query);
    	st2.close();
    	rs.close();
    	st.close();
    	rs5.close();
    	rs6.close();
    	st5.close();
    	st6.close();
    	db.closeConnection(con);
    	out.println("<p>Account Created!</p><button onclick=\"window.location.href='login.jsp';\">Log In</button>");
    }
    
%>
</body>
</html>