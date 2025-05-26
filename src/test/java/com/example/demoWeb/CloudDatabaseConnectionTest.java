package com.example.demoWeb;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
@ActiveProfiles("cloud")
public class CloudDatabaseConnectionTest {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    public void testDatabaseConnection() {
        try {
            // Try to execute a simple query
            Integer result = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            assertTrue(result == 1, "Database connection successful");
            System.out.println("Successfully connected to cloud database!");
        } catch (Exception e) {
            System.err.println("Failed to connect to cloud database: " + e.getMessage());
            throw e;
        }
    }
} 