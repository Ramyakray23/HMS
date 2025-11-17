<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body>

<%
try{
        String username = request.getParameter("username");   
        String password = request.getParameter("password");

        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/silicon?useSSL=false","root",""
        );

        PreparedStatement ps=con.prepareStatement(
            "select * from registration where name = ? and password = ?"
        );
        ps.setString(1,username);
        ps.setString(2,password);

        ResultSet x=ps.executeQuery();
        
        if(x.next()) {

            // ⭐ CREATE SESSION
            session.setAttribute("username", username);

            // redirect to dashboard
            response.sendRedirect("dashboard.html");
            return;
        }
        else {
            out.println("<h3>Invalid login!</h3>");
        }
}
catch(Exception e){       
    out.println(e);       
}      
%>

</body>
</html>
