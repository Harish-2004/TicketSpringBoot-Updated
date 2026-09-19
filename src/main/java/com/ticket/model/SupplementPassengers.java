package com.ticket.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.CascadeType;
import java.util.Objects;

@Entity
@Table(name = "supplementpassengers")
public class SupplementPassengers {

    @Id
    private String email;

    private String intermediateStation;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "passenger_email", referencedColumnName = "email")
    private PassengerDetails passenger;

    // Default constructor
    public SupplementPassengers() {}

    // Constructor
    public SupplementPassengers(String email, String intermediateStation) {
        this.email = email;
        this.intermediateStation = intermediateStation;
    }

    // Getters and Setters
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getIntermediateStation() {
        return intermediateStation;
    }

    public void setIntermediateStation(String intermediateStation) {
        this.intermediateStation = intermediateStation;
    }

    public PassengerDetails getPassenger() {
        return passenger;
    }

    public void setPassenger(PassengerDetails passenger) {
        this.passenger = passenger;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SupplementPassengers that = (SupplementPassengers) o;
        return Objects.equals(email, that.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email);
    }

    @Override
    public String toString() {
        return "SupplementPassengers{" +
                "email='" + email + '\'' +
                ", intermediateStation='" + intermediateStation + '\'' +
                '}';
    }
}
