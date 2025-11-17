<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.*, java.time.format.*" %>

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

int totalPatients = 0;
int activeDoctors = 0;
int todayAppointments = 0;
int availableRooms = 0;

// today's date (yyyy-mm-dd)
String today = java.time.LocalDate.now().toString();

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/silicon?useSSL=false",
        "root", ""
    );

    // 1️⃣ TOTAL PATIENTS (from appointments table, grouped by name)
    ps = con.prepareStatement("SELECT COUNT(DISTINCT name) AS total FROM appointments");
    rs = ps.executeQuery();
    if (rs.next()) totalPatients = rs.getInt("total");

    // 2️⃣ ACTIVE DOCTORS (status = Available)
    ps = con.prepareStatement("SELECT COUNT(*) AS total FROM doctor WHERE status='Available'");
    rs = ps.executeQuery();
    if (rs.next()) activeDoctors = rs.getInt("total");

    // 3️⃣ TODAY'S APPOINTMENTS
    ps = con.prepareStatement("SELECT COUNT(*) AS total FROM appointments WHERE date=?");
    ps.setString(1, today);
    rs = ps.executeQuery();
    if (rs.next()) todayAppointments = rs.getInt("total");

    // 4️⃣ AVAILABLE ROOMS (status = Available)
    ps = con.prepareStatement("SELECT COUNT(*) AS total FROM room WHERE status='Available'");
    rs = ps.executeQuery();
    if (rs.next()) availableRooms = rs.getInt("total");

} catch(Exception e){
    out.println("<h3>Error: "+e+"</h3>");
}
%>

<!-- Print counts in exact same dashboard UI format -->

<div class="stats-grid">

    <div class="stat-card">
        <h3><%= totalPatients %></h3>
        <p>Total Patients</p>
    </div>

    <div class="stat-card">
        <h3><%= activeDoctors %></h3>
        <p>Active Doctors</p>
    </div>

    <div class="stat-card">
        <h3><%= todayAppointments %></h3>
        <p>Today's Appointments</p>
    </div>

    <div class="stat-card">
        <h3><%= availableRooms %></h3>
        <p>Available Rooms</p>
    </div>

</div>

</body>
</html>
