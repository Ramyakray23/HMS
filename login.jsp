<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login Check</title>
</head>
<body>

<%
try {

    // Read values from login.html form
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Class.forName("com.mysql.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/silicon?useSSL=false",
        "root",
        ""
    );

    // Check if user exists with same username + password
    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM registration WHERE name=? AND password=?"
    );

    ps.setString(1, username);
    ps.setString(2, password);

    ResultSet rs = ps.executeQuery();

    if(rs.next()) {
        // Successful login
        out.println("<h3>Login Successful!</h3>");

        // Redirect to dashboard
        response.sendRedirect("dashboard.html");
    } else {
        out.println("<h3>Invalid username or password!</h3>");
    }

    con.close();

} catch(Exception e) {
    out.println("Error: " + e);
}
%>

</body>
</html>
