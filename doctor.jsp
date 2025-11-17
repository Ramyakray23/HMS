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

    // --------- 1. Toggle availability ----------
    String toggle = request.getParameter("toggle");
    if (toggle != null) {
        PreparedStatement tps = con.prepareStatement(
            "UPDATE doctor SET status = CASE WHEN status='Available' THEN 'Unavailable' ELSE 'Available' END WHERE name=?"
        );
        tps.setString(1, toggle);
        tps.executeUpdate();
        response.sendRedirect("doctor.jsp");
        return;
    }

    // --------- 2. Insert doctor ----------
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String spec = request.getParameter("specialization");
        String ph = request.getParameter("ph_no");
        String email = request.getParameter("email");
        String experienceStr = request.getParameter("experience");
        String status = request.getParameter("status");

        int exp = 0;
        if (experienceStr != null && !experienceStr.trim().equals("")) {
            exp = Integer.parseInt(experienceStr);
        }

        PreparedStatement ips = con.prepareStatement(
            "INSERT INTO doctor(name, specialization, ph_no, email, experience, status) VALUES(?,?,?,?,?,?)"
        );

        ips.setString(1, name);
        ips.setString(2, spec);
        ips.setString(3, ph);
        ips.setString(4, email);
        ips.setInt(5, exp);
        ips.setString(6, status);

        ips.executeUpdate();
        response.sendRedirect("doctor.jsp");
        return;
    }

    // --------- 3. Fetch doctors ----------
    ps = con.prepareStatement("SELECT * FROM doctor ORDER BY name");
    rs = ps.executeQuery();

} catch(Exception e){
    out.println("<h3>Error: "+e+"</h3>");
}
%>

<div class="card">
    <h2>Doctor List</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Specialization</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Experience</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
                <%
                boolean found = false;

                while (rs != null && rs.next()) {
                    found = true;
                    String name = rs.getString("name");
                    String spec = rs.getString("specialization");
                    String ph = rs.getString("ph_no");
                    String email = rs.getString("email");
                    int exp = rs.getInt("experience");
                    String status = rs.getString("status");
                %>

                <tr>
                    <td><%= name %></td>
                    <td><%= spec %></td>
                    <td><%= ph %></td>
                    <td><%= email %></td>
                    <td><%= exp %> years</td>
                    <td>
                        <span class="badge <%= status.equals("Available") ? "badge-success" : "badge-danger" %>">
                            <%= status %>
                        </span>
                    </td>

                    <td>
                        <a href="doctor.jsp?toggle=<%= URLEncoder.encode(name, "UTF-8") %>">
                            <button class="action-btn <%= status.equals("Available") ? "toggle-unavailable" : "toggle-available" %>">
                                <%= status.equals("Available") ? "Make Unavailable" : "Make Available" %>
                            </button>
                        </a>
                    </td>
                </tr>

                <%
                }

                if (!found) {
                %>
                    <tr>
                        <td colspan="7" class="empty-state">No doctors registered</td>
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
