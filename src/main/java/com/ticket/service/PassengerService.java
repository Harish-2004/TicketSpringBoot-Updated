package com.ticket.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ticket.model.PassengerDetails;

@Component
public class PassengerService {
    List<PassengerDetails> p = new ArrayList<>();

    @Autowired
    TicketService db;

    public void signup(String x, String y, String z) {  
        db.signup(x, y, z);
    }

    public boolean login(String x, String y) {  
        System.out.println("Check login");
        return db.login(x, y);
    }

    public void Booking(PassengerDetails pd) {
        db.bookTicket(pd);
    }

    public List<PassengerDetails> alldetails() {
        return db.getAllPassengers();
    }
}
