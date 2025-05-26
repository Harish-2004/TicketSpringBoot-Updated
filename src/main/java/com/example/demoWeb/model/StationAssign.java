package com.example.demoWeb.model;
import org.springframework.stereotype.Component;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Component
@Entity
@Table(name="train")
public class StationAssign {
    @Id
    @Column(name = "station")
    private String station;
    
    @Column(name = "value")
    private int value;

    public StationAssign() {
    }

    public StationAssign(String station, int value) {
        this.station = station;
        this.value = value;
    }

    public void assignStation(String station) {
        this.station = station;
    }

    public void giveValue(int value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return station + " " + value;
    }

    // Getters and Setters
    public String getStation() {
        return station;
    }

    public void setStation(String station) {
        this.station = station;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}

