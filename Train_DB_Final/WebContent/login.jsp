<!-- MADE BY JOSHUA ROSS AND RONAK PARIKH, DATABASES GROUP 11 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
   <head>
      <title>Login</title>
		
   </head>
   <body>
     <p>Group 13: Chinmay, Gurvir, Karam, Roman </p>
     <h3>Login</h3>
    <form action="checkLoginDetails.jsp" method="post">
        <h5>Username</h5>
        <input name="username" type="text" autocomplete="off" required>
        <h5>Password</h5>
        <input name="password" type="password" required>
        <br><br>
        <button>Login</button>
    </form>
    <h3>Don't Have An Account?</h3>
    <form action="createPage.jsp" method="post">
		<button>Create an Account</button>
    </form>
     
   </body>
</html>