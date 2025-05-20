# Railway Ticket Booking System

A Spring Boot application for managing railway ticket bookings with station management and passenger tracking.

## Features

- User Authentication (Signup/Login)
- Station Management
- Ticket Booking System
- Intermediate Station Assignment
- PostgreSQL Database Integration

## Tech Stack

- Java 17
- Spring Boot
- PostgreSQL
- Thymeleaf (Templates)
- Maven

## Prerequisites

- Java 17 or higher
- Maven
- PostgreSQL
- Git

## Local Development Setup

1. Clone the repository:
```bash
git clone <your-repository-url>
cd demoWeb-SpringBoot
```

2. Configure PostgreSQL:
   - Create a database named `ticketsystem`
   - Update `src/main/resources/application.properties` with your database credentials:
     ```properties
     spring.datasource.url=jdbc:postgresql://localhost:5432/ticketsystem
     spring.datasource.username=your_username
     spring.datasource.password=your_password
     ```

3. Build the application:
```bash
./mvnw clean install
```

4. Run the application:
```bash
./mvnw spring-boot:run
```

The application will be available at `http://localhost:8080`

## Database Schema

The application uses the following tables:

1. `login` - User authentication
   - emailid (Primary Key)
   - name
   - password

2. `train` - Station information
   - stations (Primary Key)
   - value

3. `passengerbooking` - Ticket bookings
   - email (Primary Key)
   - name
   - starting
   - destination

4. `supplementpassengers` - Intermediate stations
   - email (Primary Key)
   - intermediate_station

## Deployment to Railway

### Option 1: Deploy from GitHub

1. Push your code to GitHub
2. Go to [Railway Dashboard](https://railway.app/dashboard)
3. Create a new project
4. Select "Deploy from GitHub repo"
5. Choose your repository
6. Add a PostgreSQL database from Railway dashboard

### Option 2: Deploy using Railway CLI

1. Install Railway CLI:
```bash
npm i -g @railway/cli
```

2. Login to Railway:
```bash
railway login
```

3. Initialize and deploy:
```bash
railway init
railway up
```

## Environment Variables

The following environment variables are used in production:

- `DATABASE_URL`: PostgreSQL connection URL
- `DATABASE_USERNAME`: Database username
- `DATABASE_PASSWORD`: Database password
- `PORT`: Application port (default: 8080)

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── example/
│   │           └── demoWeb/
│   │               ├── Controller/
│   │               ├── Services/
│   │               ├── model/
│   │               └── Repo/
│   └── resources/
│       ├── templates/
│       ├── application.properties
│       └── schema.sql
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository. 