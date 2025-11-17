<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style.css">
</head>

<body>
    
<%
if (session.getAttribute("username") == null) {
    response.setStatus(403);   // Forbidden
    out.println("<h2 style='color:red;'>Access Denied</h2>");
    out.println("<p>You are not authorized to access this page.</p>");
    return;
}
%>



<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/silicon?useSSL=false",
        "root", ""
    );

    // FETCH PATIENT DATA FROM APPOINTMENTS
    ps = con.prepareStatement(
        "SELECT name, age, gender, ph_no FROM appointments GROUP BY name ORDER BY name"
    );
    rs = ps.executeQuery();

} catch(Exception e){
    out.println("<h3>Error: " + e + "</h3>");
}
%>

<div class="card">
    <h2>Patient Records</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Age</th>
                    <th>Gender</th>
                    <th>Phone</th>
                </tr>
            </thead>

            <tbody>
                <%
                boolean found = false;

                while (rs != null && rs.next()) {
                    found = true;

                    String name = rs.getString("name");
                    String age = rs.getString("age");
                    String gender = rs.getString("gender");
                    String phone = rs.getString("ph_no");
                %>

                <tr>
                    <td><%= name %></td>
                    <td><%= age %></td>
                    <td><%= gender %></td>
                    <td><%= phone %></td>
                </tr>

                <%
                }

                if (!found) {
                %>
                <tr>
                    <td colspan="4" class="empty-state">No patient records available</td>
                </tr>
                <%
                }
                %>
            </tbody>

        </table>
    </div>
</div>

</body>
</html>
