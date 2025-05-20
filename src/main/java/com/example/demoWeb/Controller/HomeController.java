package com.example.demoWeb.Controller;
 import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demoWeb.Services.TicketService;
import com.example.demoWeb.model.Passengerdetails;
import com.example.demoWeb.model.StationAssign;

import org.springframework.ui.Model;
@Controller
public class HomeController {
    @Autowired
    private TicketService ticketService;
    @GetMapping("/booking")
    public String home(Model model) {
       List<StationAssign> assignments = ticketService.getStationAssignments();
    System.out.println("Station Assignments: " + assignments);
      model.addAttribute("stations", assignments);
        return "booking";

    }
    @PostMapping("/booking")
    public String handleBooking(@RequestParam String emailval, @RequestParam String name, @RequestParam String starting, @RequestParam String destination) {
      Passengerdetails pd = new Passengerdetails(emailval,name, starting, destination);
        //ticketService.addPassenger(passengerdetails);  
      ticketService.bookTicket(pd);
        return "redirect:/booking";
    }
    @RequestMapping("/")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/")
    public String handleLogin(@RequestParam String email, @RequestParam String password, Model model) {
       System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        boolean success = ticketService.login(email, password);
        if (success) {
            return "redirect:/booking"; // Redirect to booking page after successful login
        } else {
            System.out.println("Invalid email or password");
            model.addAttribute("error", "Invalid email or password");
            return "login"; // Show login page with error message
        }
    }

    @RequestMapping("/signup")
    public String showSignupPage() {
        return "signup";
    }

    @PostMapping("/signup")
    public String handleSignup(@RequestParam String name, @RequestParam String email, @RequestParam String password, Model model) {
        ticketService.signup(name, email, password);
        return "redirect:/"; 
    }
  
}
