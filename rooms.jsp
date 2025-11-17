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

    // ---------- DELETE ROOM ----------
    String del = request.getParameter("delete");
    if (del != null) {
        PreparedStatement dps = con.prepareStatement("DELETE FROM room WHERE roomNo=?");
        dps.setString(1, del);
        dps.executeUpdate();
        response.sendRedirect("rooms.jsp");
        return;
    }

    // ---------- INSERT ROOM ----------
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String roomNo = request.getParameter("roomNo");
        String type = request.getParameter("type");
        String floor = request.getParameter("floor");
        String capacity = request.getParameter("capacity");
        String status = request.getParameter("status");

        PreparedStatement ips = con.prepareStatement(
            "INSERT INTO room(roomNo, type, floor, capacity, status) VALUES(?,?,?,?,?)"
        );

        ips.setString(1, roomNo);
        ips.setString(2, type);
        ips.setString(3, floor);
        ips.setString(4, capacity);
        ips.setString(5, status);

        ips.executeUpdate();
        response.sendRedirect("rooms.jsp");
        return;
    }

    // ---------- FETCH ROOMS ----------
    ps = con.prepareStatement("SELECT * FROM room ORDER BY roomNo");
    rs = ps.executeQuery();

} catch(Exception e){
    out.println("<h3>Error: "+e+"</h3>");
}
%>

<div class="card">
    <h2>Room Management</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Room Number</th>
                    <th>Type</th>
                    <th>Floor</th>
                    <th>Capacity</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
                <%
                boolean found = false;

                while (rs != null && rs.next()) {
                    found = true;

                    String roomNo = rs.getString("roomNo");
                    String type = rs.getString("type");
                    String floor = rs.getString("floor");
                    String capacity = rs.getString("capacity");
                    String status = rs.getString("status");
                %>

                <tr>
                    <td><%= roomNo %></td>
                    <td><%= type %></td>
                    <td><%= floor %></td>
                    <td><%= capacity %></td>
                    <td>
                        <span class="badge <%= status.equals("Available") ? "badge-success" : "badge-danger" %>">
                            <%= status %>
                        </span>
                    </td>

                    <td>
                        <a href="rooms.jsp?delete=<%= URLEncoder.encode(roomNo, "UTF-8") %>">
                            <button class="action-btn btn-delete">Delete</button>
                        </a>
                    </td>
                </tr>

                <%
                }

                if (!found) {
                %>
                    <tr>
                        <td colspan="6" class="empty-state">No rooms registered</td>
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
