<!-- MADE BY JOSHUA ROSS AND RONAK PARIKH, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
</head>
<body>

<%
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    //Class.forName("com.mysql.jdbc.Driver");
    ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
    Statement st = con.createStatement();
    Statement st2 = con.createStatement();
    Statement st3 = con.createStatement();
    ResultSet rs = st.executeQuery("select * from Customer where username='" + userid + "' and password='" + pwd + "';");
    ResultSet rs2 = st2.executeQuery("select * from Employee_Customer_Rep where username='" + userid + "' and password='" + pwd + "';");
    ResultSet rs3 = st3.executeQuery("select * from Employee_Site_Manager where username='" + userid + "' and password='" + pwd + "';");
    
    if (rs.next()&&userid!=null) {
    	rs.close();
    	rs2.close();
    	rs3.close();
    	st.close();
    	st2.close();
    	st3.close();
    	db.closeConnection(con);
        session.setAttribute("user", userid); // the username will be stored in the session
        out.println("<p>Logged in as Customer " + userid+".</p>");
        
        /* Removed in favor of customerHome page
        out.println("<button onclick=\"window.location.href='messaging.jsp';\">Messages</button>");
        out.println("<button onclick=\"window.location.href='logout.jsp';\">Log Out</button>");
        */
        
        response.sendRedirect("customerHome.jsp");
        
    } 
    else if (rs2.next() && userid!=null)
    {
    	rs.close();
    	rs2.close();
    	rs3.close();
    	st.close();
    	st2.close();
    	st3.close();
    	db.closeConnection(con);
        session.setAttribute("user", userid); // the username will be stored in the session
        session.setAttribute("employee", userid);
        
        /* Removed in favor of customerRepHome page
        out.println("<p>Logged in as Customer Rep " + userid+".</p>");
        out.println("<button onclick=\"window.location.href='messaging.jsp';\">Messages</button>");
        out.println("<button onclick=\"window.location.href='repMessaging.jsp';\">Reply to Messages</button>");
        out.println("<button onclick=\"window.location.href='logout.jsp';\">Log Out</button>");
        */
        
        response.sendRedirect("customerRepHome.jsp");
    }
    else if (rs3.next() && userid!=null)
    {
    	rs.close();
    	rs2.close();
    	rs3.close();
    	st.close();
    	st2.close();
    	st3.close();
    	db.closeConnection(con);
        session.setAttribute("user", userid); // the username will be stored in the session
        session.setAttribute("employee", userid);
        session.setAttribute("admin", userid);
        
        response.sendRedirect("commandcenter.jsp");
    }
    else {
    	rs.close();
    	rs2.close();
    	rs3.close();
    	st.close();
    	st2.close();
    	st3.close();
    	db.closeConnection(con);
        out.println("<p>That username and/or password was not recognized.</p> <button onclick=\"window.location.href='login.jsp';\">Go Back</button>");
    }
    
%>
</body>
</html>