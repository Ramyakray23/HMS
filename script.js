/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



      // Login state
      let isLoggedIn = false;

      // Data Storage
      let patients = [];
      let doctors = [];
      let appointments = [];
      let rooms = [];
      let bills = [];
      let idCounters = { patient: 1, doctor: 1, appointment: 1, bill: 1 };

      // Main Login Handler
      function handleMainLogin(e) {
        e.preventDefault();
        const username = document
          .getElementById("mainLoginUsername")
          .value.trim();
        const password = document
          .getElementById("mainLoginPassword")
          .value.trim();

        // Since it's a frontend project, accept any input
        if (username && password) {
          isLoggedIn = true;
          document.getElementById("loginPage").style.display = "none";
          document.getElementById("mainApp").style.display = "block";
          // ensure dashboard and UI are in correct state
          updateDoctorDropdown();
          renderDoctors();
          renderAppointments();
          renderRooms();
          renderBills();
          updateDashboard();
        } else {
          alert("Please enter both username and password");
        }
      }

      // Logout Handler
      function handleLogout() {
        if (confirm("Are you sure you want to logout?")) {
          isLoggedIn = false;
          document.getElementById("loginPage").style.display = "flex";
          document.getElementById("mainApp").style.display = "none";
          document.getElementById("mainLoginUsername").value = "";
          document.getElementById("mainLoginPassword").value = "";
          closeMenu();
          // reset to dashboard page view state
          document
            .querySelectorAll(".page")
            .forEach((p) => p.classList.remove("active"));
          document.getElementById("dashboard").classList.add("active");
          document
            .querySelectorAll(".nav-btn")
            .forEach((b) => b.classList.remove("active"));
          document.querySelector(".nav-btn").classList.add("active"); // first nav button
        }
      }

      // Navigation - now safe: showPage(pageId, btnElement)
      function showPage(pageId, btnEl) {
        document
          .querySelectorAll(".page")
          .forEach((p) => p.classList.remove("active"));
        document
          .querySelectorAll(".nav-btn")
          .forEach((b) => b.classList.remove("active"));
        const page = document.getElementById(pageId);
        if (page) page.classList.add("active");
        if (btnEl) btnEl.classList.add("active");
        closeMenu();
      }

      function toggleMenu() {
        document.getElementById("navLinks").classList.toggle("active");
      }

      function closeMenu() {
        document.getElementById("navLinks").classList.remove("active");
      }

      // Doctor Management
      function addDoctor(e) {
        e.preventDefault();
        const doctor = {
          id: idCounters.doctor++,
          name: document.getElementById("doctorName").value,
          specialty: document.getElementById("doctorSpecialty").value,
          phone: document.getElementById("doctorPhone").value,
          email: document.getElementById("doctorEmail").value,
          experience: document.getElementById("doctorExp").value,
          available: document.getElementById("doctorAvailable").value,
        };
        doctors.push(doctor);
        renderDoctors();
        updateDoctorDropdown();
        updateDashboard();
        e.target.reset();
        alert("Doctor added successfully!");
      }

      function toggleDoctorAvailability(doctorId) {
        const idx = doctors.findIndex((d) => d.id === doctorId);
        if (idx === -1) return;
        const current = doctors[idx].available;
        // normalize toggle values
        doctors[idx].available =
          current === "Available" ? "Unavailable" : "Available";
        renderDoctors();
        updateDoctorDropdown();
        updateDashboard();
      }

      function renderDoctors() {
        const tbody = document.getElementById("doctorTableBody");
        if (!tbody) return;
        if (doctors.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="8" class="empty-state">No doctors registered</td></tr>';
          return;
        }
        tbody.innerHTML = doctors
          .map((d) => {
            let badgeClass = "badge-warning";
            if (d.available === "Available") badgeClass = "badge-success";
            else if (d.available === "Unavailable") badgeClass = "badge-danger";
            else badgeClass = "badge-warning";

            return `
                <tr>
                    <td>D${String(d.id).padStart(3, "0")}</td>
                    <td>${d.name}</td>
                    <td>${d.specialty}</td>
                    <td>${d.phone}</td>
                    <td>${d.email}</td>
                    <td>${d.experience || "-"} years</td>
                    <td><span class="badge ${badgeClass}">${
              d.available
            }</span></td>
                    <td>
                        <button class="action-btn btn-delete" onclick="deleteDoctor(${
                          d.id
                        })">Delete</button>
                        <button class="toggle-availability ${
                          d.available === "Available"
                            ? "toggle-available"
                            : "toggle-unavailable"
                        }" onclick="toggleDoctorAvailability(${d.id})">
                            ${
                              d.available === "Available"
                                ? "Make Unavailable"
                                : "Make Available"
                            }
                        </button>
                    </td>
                </tr>
                `;
          })
          .join("");
      }

      function deleteDoctor(id) {
        if (confirm("Are you sure you want to delete this doctor?")) {
          doctors = doctors.filter((d) => d.id !== id);
          renderDoctors();
          updateDoctorDropdown();
          updateDashboard();
        }
      }

      function updateDoctorDropdown() {
        const select = document.getElementById("apptDoctor");
        if (!select) return;
        const options = ['<option value="">Select Doctor</option>'];
        options.push(
          ...doctors.map(
            (d) =>
              `<option value="${d.name}">${d.name} - ${d.specialty}</option>`
          )
        );
        select.innerHTML = options.join("");
      }

      // Appointment Management
      function addAppointment(e) {
        e.preventDefault();
        const appointment = {
          id: idCounters.appointment++,
          patient: document.getElementById("apptPatient").value,
          doctor: document.getElementById("apptDoctor").value,
          date: document.getElementById("apptDate").value,
          time: document.getElementById("apptTime").value,
          type: document.getElementById("apptType").value,
          notes: document.getElementById("apptNotes").value,
          age: document.getElementById("apptAge").value.trim(),
          gender: document.getElementById("apptGender").value,
          phone: document.getElementById("apptPhone").value.trim(),


          status: "Scheduled",
        };
        appointments.push(appointment);
        //Patient Table logic

                //Patient Table logic
        const patientName = appointment.patient.trim();

        // check if patient already exists
        const existingPatient = patients.find(
        (p) => p.name.toLowerCase() === patientName.toLowerCase()
        );

        if (!existingPatient) {
        const newPatient = {
            name: patientName,
            age: appointment.age || "-",
            gender: appointment.gender || "-",
            phone: appointment.phone || "-",
            };

        patients.push(newPatient);
        updatePatientRecords();
        }



        renderAppointments();
        updateDashboard();
        e.target.reset();
        alert("Appointment scheduled successfully!");
      }

      function renderAppointments() {
        const tbody = document.getElementById("apptTableBody");
        if (!tbody) return;
        if (appointments.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="8" class="empty-state">No appointments scheduled</td></tr>';
          return;
        }
        tbody.innerHTML = appointments
          .map(
            (a) => `
                <tr>
                    <td>A${String(a.id).padStart(3, "0")}</td>
                    <td>${a.patient}</td>
                    <td>${a.doctor}</td>
                    <td>${a.date}</td>
                    <td>${a.time}</td>
                    <td>${a.type}</td>
                    <td><span class="badge badge-info">${a.status}</span></td>
                    <td>
                        <button class="action-btn btn-delete" onclick="deleteAppointment(${
                          a.id
                        })">Cancel</button>
                    </td>
                </tr>
            `
          )
          .join("");
      }

            function deleteAppointment(id) {
        if (confirm("Are you sure you want to cancel this appointment?")) {
            // Find the appointment being deleted
            const deletedAppointment = appointments.find((a) => a.id === id);

            // Remove the appointment
            appointments = appointments.filter((a) => a.id !== id);

            // Remove patient if they have no other appointments left
            if (deletedAppointment) {
            const patientName = deletedAppointment.patient.toLowerCase();

            const hasOtherAppointments = appointments.some(
                (a) => a.patient.toLowerCase() === patientName
            );

            if (!hasOtherAppointments) {
                patients = patients.filter(
                (p) => p.name.toLowerCase() !== patientName
                );
                updatePatientRecords();
            }
            }

            // Re-render and update everything
            renderAppointments();
            updateDashboard();

            alert("Appointment and patient record removed successfully!");
        }
        }


      // Room Management
      function addRoom(e) {
        e.preventDefault();
        const room = {
          number: document.getElementById("roomNumber").value,
          type: document.getElementById("roomType").value,
          floor: document.getElementById("roomFloor").value,
          capacity: document.getElementById("roomCapacity").value,
          status: document.getElementById("roomStatus").value,
        };
        rooms.push(room);
        renderRooms();
        updateDashboard();
        e.target.reset();
        alert("Room added successfully!");
      }

      function renderRooms() {
        const tbody = document.getElementById("roomTableBody");
        if (!tbody) return;
        if (rooms.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="6" class="empty-state">No rooms registered</td></tr>';
          return;
        }
        tbody.innerHTML = rooms
          .map(
            (r) => `
                <tr>
                    <td>${r.number}</td>
                    <td>${r.type}</td>
                    <td>Floor ${r.floor}</td>
                    <td>${r.capacity} beds</td>
                    <td><span class="badge ${
                      r.status === "Available"
                        ? "badge-success"
                        : r.status === "Occupied"
                        ? "badge-danger"
                        : "badge-warning"
                    }">${r.status}</span></td>
                    <td>
                        <button class="action-btn btn-delete" onclick="deleteRoom('${
                          r.number
                        }')">Delete</button>
                    </td>
                </tr>
            `
          )
          .join("");
      }

      function deleteRoom(number) {
        if (confirm("Are you sure you want to delete this room?")) {
          rooms = rooms.filter((r) => r.number !== number);
          renderRooms();
          updateDashboard();
        }
      }

      // Billing Management
      function addBill(e) {
        e.preventDefault();
        const roomCharges = parseFloat(
          document.getElementById("billRoom").value || 0
        );
        const doctorFees = parseFloat(
          document.getElementById("billDoctor").value || 0
        );
        const medicine = parseFloat(
          document.getElementById("billMedicine").value || 0
        );
        const lab = parseFloat(document.getElementById("billLab").value || 0);
        const other = parseFloat(
          document.getElementById("billOther").value || 0
        );
        const total = roomCharges + doctorFees + medicine + lab + other;

        const bill = {
          id: idCounters.bill++,
          patient: document.getElementById("billPatient").value,
          room: roomCharges,
          doctor: doctorFees,
          medicine: medicine,
          lab: lab,
          other: other,
          total: total,
          payment: document.getElementById("billPayment").value,
          date: new Date().toLocaleDateString(),
        };
        bills.push(bill);
        renderBills();
        e.target.reset();
        alert(`Bill generated! Total: ${total.toFixed(2)}`);
      }

      function renderBills() {
        const tbody = document.getElementById("billTableBody");
        if (!tbody) return;
        if (bills.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="10" class="empty-state">No billing records</td></tr>';
          return;
        }
        tbody.innerHTML = bills
          .map(
            (b) => `
                <tr>
                    <td>B${String(b.id).padStart(3, "0")}</td>
                    <td>${b.patient}</td>
                    <td>${b.room.toFixed(2)}</td>
                    <td>${b.doctor.toFixed(2)}</td>
                    <td>${b.medicine.toFixed(2)}</td>
                    <td>${b.lab.toFixed(2)}</td>
                    <td>${b.other.toFixed(2)}</td>
                    <td><strong>${b.total.toFixed(2)}</strong></td>
                    <td>${b.payment}</td>
                    <td>${b.date}</td>
                </tr>
            `
          )
          .join("");
      }

      // Dashboard Updates
      function updateDashboard() {
        // Update total patients (unique by name)
        const uniquePatients = new Set(patients.map((p) => p.name));
        appointments.forEach((a) => uniquePatients.add(a.patient));
        document.getElementById("totalPatients").innerText =
          uniquePatients.size;

        // Update total doctors
        const activeDoctors = doctors.filter(
          (d) => d.available === "Available"
        ).length;
        document.getElementById("totalDoctors").innerText = activeDoctors;

        // Update today's appointments
        const today = new Date().toISOString().split("T")[0];
        const todaysAppointments = appointments.filter(
          (a) => a.date === today
        ).length;
        document.getElementById("todayAppointments").innerText =
          todaysAppointments;

        // Update available rooms
        const available = rooms.filter((r) => r.status === "Available").length;
        document.getElementById("availableRooms").innerText = available;

        // Update recent activity
        const recent = [];
        if (appointments.length > 0) {
          const lastAppt = appointments[appointments.length - 1];
          recent.push(
            `🩺 Appointment scheduled for ${lastAppt.patient} with ${lastAppt.doctor} on ${lastAppt.date}`
          );
        }
        if (doctors.length > 0) {
          const lastDoc = doctors[doctors.length - 1];
          recent.push(`👨‍⚕️ Doctor ${lastDoc.name} (${lastDoc.specialty}) added`);
        }
        if (patients.length > 0) {
          const lastPat = patients[patients.length - 1];
          recent.push(`👤 Patient ${lastPat.name} added`);
        }

        const recentEl = document.getElementById("recentActivity");
        if (recent.length > 0) {
          recentEl.innerHTML = recent.map((r) => `<p>${r}</p>`).join("");
          recentEl.classList.remove("empty-state");
        } else {
          recentEl.innerText = "No recent activity";
          recentEl.classList.add("empty-state");
        }
      }
      //  Update patient records table
      function updatePatientRecords() {
        const tableBody = document.getElementById("patientTableBody");
        console.log("Updating patient table...");
        if (!tableBody) return; // if table doesn't exist yet
        tableBody.innerHTML = "";

        patients.forEach((p, index) => {
          const row = document.createElement("tr");
          row.innerHTML = `
            <td>${index + 1}</td>
            <td>${p.name}</td>
            <td>${p.age || "-"}</td>
            <td>${p.gender || "-"}</td>
            <td>${p.phone || "-"}</td>
        `;
          tableBody.appendChild(row);
        });

        if (patients.length === 0) {
          tableBody.innerHTML = `<tr><td colspan="5" class="empty-state">No patient records available</td></tr>`;
        }
      }

      // Initialize on page load - show login page first
      window.addEventListener("DOMContentLoaded", function () {
        // initial renders to avoid empty UI problems
        renderDoctors();
        renderAppointments();
        renderRooms();
        renderBills();
        updateDoctorDropdown();
        updateDashboard();
        updatePatientRecords();
      });
    