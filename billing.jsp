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

    // ---------- INSERT BILL ----------
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String name = request.getParameter("name");
        String room = request.getParameter("room_charge");
        String doc  = request.getParameter("doc_fees");
        String med  = request.getParameter("med_cost");
        String lab  = request.getParameter("lab_test");
        String other = request.getParameter("others");
        String pay = request.getParameter("pay_method");

        PreparedStatement ips = con.prepareStatement(
            "INSERT INTO billing(name, room_charge, doc_fees, med_cost, lab_test, others, pay_method) VALUES(?,?,?,?,?,?,?)"
        );

        ips.setString(1, name);
        ips.setString(2, room);
        ips.setString(3, doc);
        ips.setString(4, med);
        ips.setString(5, lab);
        ips.setString(6, other);
        ips.setString(7, pay);

        ips.executeUpdate();
        response.sendRedirect("billing.jsp");
        return;
    }

    // ---------- FETCH BILL RECORDS ----------
    ps = con.prepareStatement("SELECT * FROM billing ORDER BY name ASC");
    rs = ps.executeQuery();

} catch(Exception e){
    out.println("<h3>Error: " + e + "</h3>");
}
%>

<div class="card">
    <h2>Billing Records</h2>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Room</th>
                    <th>Doctor</th>
                    <th>Medicine</th>
                    <th>Lab</th>
                    <th>Other</th>
                    <th>Total</th>
                    <th>Payment</th>
                </tr>
            </thead>

            <tbody>
                <%
                boolean exist = false;

                while (rs != null && rs.next()) {
                    exist = true;

                    double room = rs.getDouble("room_charge");
                    double doc  = rs.getDouble("doc_fees");
                    double med  = rs.getDouble("med_cost");
                    double lab  = rs.getDouble("lab_test");
                    double other = rs.getDouble("others");

                    double total = room + doc + med + lab + other;
                %>

                <tr>
                    <td><%= rs.getString("name") %></td>
                    <td>₹<%= room %></td>
                    <td>₹<%= doc %></td>
                    <td>₹<%= med %></td>
                    <td>₹<%= lab %></td>
                    <td>₹<%= other %></td>
                    <td><b>₹<%= total %></b></td>
                    <td><%= rs.getString("pay_method") %></td>
                </tr>

                <%
                }

                if (!exist) {
                %>
                <tr>
                    <td colspan="8" class="empty-state">No billing records</td>
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
