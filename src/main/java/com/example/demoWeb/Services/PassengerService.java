package com.example.demoWeb.Services;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
// import org.springframework.stereotype.Service;

import com.example.demoWeb.model.Passengerdetails;

@Component
public class PassengerService {
    List<Passengerdetails> p=new ArrayList<>();

    @Autowired
    TicketService db;
    public void signup(String x,String y,String z)
    {  
    	db.signup(x,y,z);
    	
    }
    public boolean login(String x,String y)
    {  System.out.println("Check login");
    	return db.login(x,y);
    }
    public void Booking(Passengerdetails pd)
    {
        db.bookTicket(pd);
    }
   public List<Passengerdetails> alldetails()
   {
       return db.getAllPassengers();
   }
    // public int count(String x)
    // {
    // 	return db.get(x);
    // }
}
