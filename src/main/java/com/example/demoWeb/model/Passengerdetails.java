package com.example.demoWeb.model;

import org.springframework.stereotype.Component;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Component
@Entity
@Table(name = "passengerbooking")
public class Passengerdetails {

    @Id
    private String email;  // email as primary key
    private String name;
    private String starting;
    private String destination;

    public Passengerdetails() {
    }

    public Passengerdetails(String email, String name, String starting, String destination) {
        this.email = email;
        this.name = name;
        this.starting = starting;
        this.destination = destination;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStarting() {
        return starting;
    }

    public void setStarting(String starting) {
        this.starting = starting;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    @Override
    public String toString() {
        return "Passengerdetails{" +
                "email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", starting='" + starting + '\'' +
                ", destination='" + destination + '\'' +
                '}';
    }
}
