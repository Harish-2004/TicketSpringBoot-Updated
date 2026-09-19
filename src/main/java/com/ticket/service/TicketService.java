package com.ticket.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.jdbc.core.JdbcTemplate;

import com.ticket.repository.PassengerRepository;
import com.ticket.repository.StationDetailsRepository;
import com.ticket.repository.SupplementPassengerRepository;
import com.ticket.model.AssignValues;
import com.ticket.model.PassengerDetails;
import com.ticket.model.StationAssign;
import com.ticket.model.SupplementPassengers;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TicketService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private AssignValues assignValues;

    private final int abx = 5;

    @Autowired
    private PassengerRepository passengerRepository;
     
    @Autowired
    private SupplementPassengerRepository supplementPassengerRepository;

    @Autowired
    private StationDetailsRepository stationDetailsRepository;

    public void addPassenger(PassengerDetails pd) {
        passengerRepository.save(pd);
    }

    public List<PassengerDetails> getAllPassengers() {
        return passengerRepository.findAll();
    }

    public void signup(String name, String email, String password) {
        String query = "INSERT INTO login (name, emailid, password) VALUES (?, ?, ?)";
        jdbcTemplate.update(query, name, email, password);
    }

    public boolean login(String email, String password) {
        String query = "SELECT password FROM login WHERE emailid = ?";
        @SuppressWarnings("deprecation")
        List<String> passwords = jdbcTemplate.query(query, new Object[]{email}, (rs, rowNum) -> rs.getString("password"));
        if (passwords.isEmpty()) {
            return false;
        }
        String storedPassword = passwords.get(0);
        return password.equals(storedPassword);
    }

    public long countRecords(String tableName) {
        if ("passengerbooking".equalsIgnoreCase(tableName)) {
            return passengerRepository.count();
        } else if ("train".equalsIgnoreCase(tableName)) {
            return stationDetailsRepository.count();
        } else {
            throw new IllegalArgumentException("Unknown table name: " + tableName);
        }
    }

    public List<StationAssign> getStationAssignments() {
        return stationDetailsRepository.findAll();
    }

    public void bookTicket(PassengerDetails pd) {
        long count = countRecords("passengerbooking");
        System.out.println("count=" + count);
        System.out.println("abx=" + abx);
        passengerRepository.save(pd);
        if (count > 2) {
            List<StationAssign> stationAssignments = getStationAssignments();
            if (stationAssignments != null && !stationAssignments.isEmpty()) {
                System.out.println("stationAssignments=" + stationAssignments);
                
                List<PassengerDetails> allPassengers = getAllPassengers();
                if (allPassengers != null && !allPassengers.isEmpty()) {
                    String intermediatestation = assignValues.check(pd, convertStationAssignToAssignValues(stationAssignments), allPassengers);
                    if (intermediatestation != null) {
                        SupplementPassengers sp = new SupplementPassengers(pd.getEmail(), intermediatestation);
                        System.out.println("Saving SupplementPassengers: " + sp);
                        supplementPassengerRepository.save(sp);
                    } else {
                        System.out.println("Intermediate station is null, skipping saving SupplementPassengers.");
                    }
                } else {
                    System.out.println("No passengers found, skipping SupplementPassengers creation.");
                }
            } else {
                System.out.println("No station assignments found, skipping logic.");
            }
        } else {
            System.out.println("Count is less than or equal to 2, skipping logic.");
        }
    }

    private List<AssignValues> convertStationAssignToAssignValues(List<StationAssign> stationAssignments) {
        return stationAssignments.stream()
                .map(sa -> new AssignValues(sa.getStation(), sa.getValue()))
                .collect(Collectors.toList());
    }
}
