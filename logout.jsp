<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.invalidate();  // destroys session
    response.sendRedirect("login.html"); // go back to login page
%>
