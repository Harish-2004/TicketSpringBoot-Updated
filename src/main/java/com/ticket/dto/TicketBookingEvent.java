package com.ticket.dto;

import java.io.Serializable;

public class TicketBookingEvent implements Serializable {

    private String email;
    private String name;
    private String starting;
    private String destination;
    private long timestamp;

    public TicketBookingEvent() {
    }

    public TicketBookingEvent(String email, String name, String starting, String destination) {
        this.email = email;
        this.name = name;
        this.starting = starting;
        this.destination = destination;
        this.timestamp = System.currentTimeMillis();
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

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "TicketBookingEvent{" +
                "email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", starting='" + starting + '\'' +
                ", destination='" + destination + '\'' +
                ", timestamp=" + timestamp +
                '}';
    }
}
