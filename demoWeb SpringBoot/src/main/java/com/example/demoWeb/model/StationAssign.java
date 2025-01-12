package com.example.demoWeb.model;
import org.springframework.stereotype.Component;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Component
@Entity
@Table(name="train")
public class StationAssign {
    @Id
    private String stations;
    private int value;

    public StationAssign() {
    }

    public StationAssign(String station, int value) {
        this.stations = station;
        this.value = value;
    }

    public void assignStation(String station) {
        this.stations = station;
    }

    public void giveValue(int value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return stations + " " + value;
    }

    // Getters and Setters
    public String getStation() {
        return stations;
    }

    public void setStation(String station) {
        this.stations = station;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}

