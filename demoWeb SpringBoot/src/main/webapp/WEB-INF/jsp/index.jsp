

<!DOCTYPE html>
<html>
<head>
    
    <title>Ticket Booking</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .booking-container {
            width: 400px;
            margin: 0 auto;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .booking-container h2 {
            text-align: center;
        }
        .booking-container input[type="text"],
        .booking-container input[type="email"],
        .booking-container select {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        .booking-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .booking-container input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="booking-container">
        <h2>Ticket Booking</h2>
        <form action="/booking" method="post">
            <label for="email">Email Id:</label>
            <input type="email" id="email" name="email" required>

            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="startingStation">Starting Station:</label>
            <select id="startingStation" name="startingStation" required>
                <c:forEach var="station" items="${stations}">
                    <option value="${station.value}">${station.station}</option>
                </c:forEach>
            </select>

            <label for="destinationStation">Destination Station:</label>
            <input type="text" id="destinationStation" name="destinationStation" required>

            <input type="submit" value="Book Ticket">
        </form>
    </div>
</body>
</html>
