package com.ticket.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ticket.dto.TicketBookingEvent;
import com.ticket.service.BookingProducerService;
import com.ticket.service.TicketService;
import com.ticket.model.StationAssign;

@Controller
public class HomeController {

    @Autowired
    private TicketService ticketService;

    @Autowired
    private BookingProducerService bookingProducerService;

    @GetMapping("/booking")
    public String home(@RequestParam(required = false) String status, Model model) {
        List<StationAssign> assignments = ticketService.getStationAssignments();
        model.addAttribute("stations", assignments);
        if ("queued".equals(status)) {
            model.addAttribute("message", "Ticket booking request submitted asynchronously via Kafka!");
        }
        return "booking";
    }

    @PostMapping("/booking")
    public String handleBooking(@RequestParam String emailval, @RequestParam String name, @RequestParam String starting, @RequestParam String destination) {
        TicketBookingEvent event = new TicketBookingEvent(emailval, name, starting, destination);
        bookingProducerService.sendBookingEvent(event);
        return "redirect:/booking?status=queued";
    }

    @RequestMapping("/")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/")
    public String handleLogin(@RequestParam String email, @RequestParam String password, Model model) {
        boolean success = ticketService.login(email, password);
        if (success) {
            return "redirect:/booking";
        } else {
            model.addAttribute("error", "Invalid email or password");
            return "login";
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
