<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style.css">
</head>
<body>

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

    // --------- DELETE appointment ----------
    String del = request.getParameter("delete");
    if (del != null) {
        PreparedStatement dps = con.prepareStatement(
            "DELETE FROM appointments WHERE name=?"
        );
        dps.setString(1, del);
        dps.executeUpdate();
        response.sendRedirect("appointments.jsp");
        return;
    }

    // --------- INSERT appointment ----------
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String ph_no = request.getParameter("ph_no");
        String doctor = request.getParameter("doctor");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String age = request.getParameter("age");
        String gender = request.getParameter("gender");
        String type = request.getParameter("type");
        String notes = request.getParameter("notes");

        PreparedStatement ips = con.prepareStatement(
            "INSERT INTO appointments(name, ph_no, doctor, date, time, age, gender, type, notes) VALUES(?,?,?,?,?,?,?,?,?)"
        );

        ips.setString(1, name);
        ips.setString(2, ph_no);
        ips.setString(3, doctor);
        ips.setString(4, date);
        ips.setString(5, time);
        ips.setString(6, age);
        ips.setString(7, gender);
        ips.setString(8, type);
        ips.setString(9, notes);

        ips.executeUpdate();
        response.sendRedirect("appointments.jsp");
        return;
    }

    // --------- FETCH appointments ----------
    ps = con.prepareStatement("SELECT * FROM appointments ORDER BY date, time");
    rs = ps.executeQuery();

} catch(Exception e){
    out.println("<h3>Error: "+e+"</h3>");
}
%>

<div class="card">
    <h2>Appointment List</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Phone</th>
                    <th>Doctor</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Age</th>
                    <th>Gender</th>
                    <th>Type</th>
                    <th>Notes</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
                <%
                boolean found = false;

                while (rs != null && rs.next()) {
                    found = true;

                    String name = rs.getString("name");
                    String ph = rs.getString("ph_no");
                    String doctor = rs.getString("doctor");
                    String date = rs.getString("date");
                    String time = rs.getString("time");
                    String age = rs.getString("age");
                    String gender = rs.getString("gender");
                    String type = rs.getString("type");
                    String notes = rs.getString("notes");
                %>

                <tr>
                    <td><%= name %></td>
                    <td><%= ph %></td>
                    <td><%= doctor %></td>
                    <td><%= date %></td>
                    <td><%= time %></td>
                    <td><%= age %></td>
                    <td><%= gender %></td>
                    <td><%= type %></td>
                    <td><%= notes %></td>

                    <td>
                        <a href="appointments.jsp?delete=<%= URLEncoder.encode(name, "UTF-8") %>">
                            <button class="action-btn btn-delete">Delete</button>
                        </a>
                    </td>
                </tr>

                <%
                }

                if (!found) {
                %>
                    <tr>
                        <td colspan="10" class="empty-state">No appointments scheduled</td>
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
