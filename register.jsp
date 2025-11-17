<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Register User</title>
</head>
<body>

<%
try {

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Class.forName("com.mysql.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/silicon?useSSL=false",
        "root",
        ""
    );

    // Check if username already exists
    PreparedStatement check = con.prepareStatement(
        "SELECT * FROM registration WHERE name=?"
    );
    check.setString(1, username);
    ResultSet rs = check.executeQuery();

    if(rs.next()) {
        out.println("<h3>Username already exists! Try another.</h3>");
    } else {

        // INSERT without ID
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO registration(name, password) VALUES(?, ?)"
        );

        ps.setString(1, username);
        ps.setString(2, password);

        ps.executeUpdate();

        out.println("<h3>Registration Successful!</h3>");

        // Redirect back to login
        response.sendRedirect("dashboard.html");
    }

    con.close();

} catch(Exception e) {
    out.println("Error: " + e);
}
%>

</body>
</html>
