<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search and Update Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
        }

        form {
            max-width: 400px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 10px;
        }

        input[type="text"],
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .error {
            color: #dc3545;
            text-align: center;
        }
    </style>
</head>
<body>

<jsp:include page="navigation.jsp" />

<h2>Search and Update Account Details</h2>

<%-- Display success or error messages --%>
<% String message = (String) request.getAttribute("message"); %>
<% String error = (String) request.getAttribute("error"); %>

<% if (message != null && !message.isEmpty()) { %>
    <p class="success"><%= message %></p>
<% } else if (error != null && !error.isEmpty()) { %>
    <p class="error"><%= error %></p>
<% } %>

<form method="post">
    <label for="studentId">Enter account ID to update:</label>
    <input type="text" id="studentId" name="studentId">
    <input type="submit" value="Search">
</form>

<%
    String studentId = request.getParameter("studentId");

    if (studentId != null && !studentId.isEmpty()) {
        HttpSession session1 = request.getSession(true);

        session1.setAttribute("studentId", studentId);
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/studentdb", "root", "Rupa");
            ps = conn.prepareStatement("SELECT * FROM student WHERE student_id = ?");
            ps.setString(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
%>
                <div>
                    <form action="UpdateServlet" method="post">
                        <input type="hidden" name="studentId" value="<%= studentId %>" />
                        <label for="student_id">Student Id:</label>
                        <input type="text" id="student_id" name="student_id" value="<%= rs.getInt("student_id") %>" required><br>
                        
                        <label for="name">Name:</label>
                        <input type="text" id="name" name="name" value="<%= rs.getString("name") %>" required><br>
                        <label for="date_of_birth">Date Of Birth:</label>
                        <input type="text" id="date_of_birth" name="date_of_birth" value="<%= rs.getString("date_of_birth") %>" required><br>
                        <label for="gender">Gender:</label>
                        <input type="text" id="gender" name="gender" value="<%= rs.getString("gender") %>" required><br>
                        <label for="email">email:</label>
                        <input type="text" id="email" name="email" value="<%= rs.getString("email") %>" required><br>
                        <label for="phone_number">Phone Number:</label>
                        <input type="text" id="phone_number" name="phone_number" value="<%= rs.getInt("phone_number") %>" required><br>
                        <label for="address">Address:</label>
                        <input type="text" id="address" name="address" value="<%= rs.getString("address") %>" required><br>
                        <label for="enrollment_date">Enrollment Date:</label>
                        <input type="text" id="enrollment_date" name="enrollment_date" value="<%= rs.getString("enrollment_date") %>" required><br>
                        <label for="program_id">Program Id:</label>
                        <input type="text" id="program_id" name="program_id" value="<%= rs.getInt("program_id") %>" required><br>
                        <input type="submit" value="Update">
                    </form>
                </div>
<%
            } else {
%>
                <p class="error">Account with ID <%= studentId %> not found.</p>
<%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>
