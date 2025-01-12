package com.example.demoWeb.Services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demoWeb.Repo.Repopassenger;
import com.example.demoWeb.Repo.StationdetailsRepo;
import com.example.demoWeb.Repo.Supplementpassengerrepo;
import com.example.demoWeb.model.AssignValues;
import com.example.demoWeb.model.Passengerdetails;
import com.example.demoWeb.model.StationAssign;
import com.example.demoWeb.model.Supplementpassengers;

import org.springframework.jdbc.core.JdbcTemplate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TicketService {

    // Commented JDBC template approach
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private AssignValues assignValues;

    private final int abx = 5;

    @Autowired
    private Repopassenger repopassenger;
     
    @Autowired
    private Supplementpassengerrepo supplementpassengerrepo;

    @Autowired
    private StationdetailsRepo stationdetailsRepo;

    public void addPassenger(Passengerdetails pd) {
        // JDBC template approach
        // String query = "INSERT INTO passengerbooking (name, starting, destination) VALUES (?, ?, ?)";
        // jdbcTemplate.update(query, pd.getName(), pd.getStarting(), pd.getDestination());

        // JPA approach
        repopassenger.save(pd);
    }

    public List<Passengerdetails> getAllPassengers() {
        // JDBC template approach
        // String query = "SELECT id, name, starting, destination FROM passengerbooking";
        // return jdbcTemplate.query(query, (rs, rowNum) -> {
        //     Passengerdetails pd = new Passengerdetails();
        //     pd.setId(rs.getInt("id"));
        //     pd.setName(rs.getString("name"));
        //     pd.setStarting(rs.getString("starting"));
        //     pd.setDestination(rs.getString("destination"));
        //     return pd;
        // });

        // JPA approach
        return repopassenger.findAll();
    }

    public void signup(String name, String email, String password) {
        // JDBC template approach
        String query = "INSERT INTO login (name, emailid, password) VALUES (?, ?, ?)";
        jdbcTemplate.update(query, name, email, password);

        // // JPA does not have direct support for this kind of query. Consider using a UserDetails entity with a repository.
        // throw new UnsupportedOperationException("Signup logic needs an entity and repository.");
    }

    public boolean login(String email, String password) {
        // JDBC template approach
        String query = "SELECT password FROM login WHERE emailid = ?";
        @SuppressWarnings("deprecation")
        List<String> passwords = jdbcTemplate.query(query, new Object[]{email}, (rs, rowNum) -> rs.getString("password"));
        if (passwords.isEmpty()) {
            return false;
        }
        String storedPassword = passwords.get(0);
        return password.equals(storedPassword);

        // JPA version: Requires a UserDetails entity and repository.
        // throw new UnsupportedOperationException("Login logic needs an entity and repository.");
    }

    public long countRecords(String tableName) {
        // This method should be implemented per entity with JPA.
        if ("passengerbooking".equalsIgnoreCase(tableName)) {
            return repopassenger.count();
        } else if ("train".equalsIgnoreCase(tableName)) {
            return stationdetailsRepo.count();
        } else {
            throw new IllegalArgumentException("Unknown table name: " + tableName);
        }
    }

    public List<StationAssign> getStationAssignments() {
        // JDBC template approach
        // String query = "SELECT stations, value FROM train";
        // return jdbcTemplate.query(query, (rs, rowNum) -> {
        //     StationAssign sa = new StationAssign();
        //     sa.setStation(rs.getString("stations"));
        //     sa.setValue(rs.getInt("value"));
        //     return sa;
        // });

        // JPA approach
        return stationdetailsRepo.findAll();
    }

    public void bookTicket(Passengerdetails pd) {
        long count = countRecords("passengerbooking");
        System.out.println("count=" + count);
        System.out.println("abx=" + abx);
        repopassenger.save(pd);
        if (count > 2) {
            List<StationAssign> stationAssignments = getStationAssignments();
            if (stationAssignments != null && !stationAssignments.isEmpty()) {
                System.out.println("stationAssignments=" + stationAssignments);
                
                List<Passengerdetails> allPassengers = getAllPassengers();
                if (allPassengers != null && !allPassengers.isEmpty()) {
                    String intermediatestation = assignValues.check(pd, convertStationAssignToAssignValues(stationAssignments), allPassengers);
                    if (intermediatestation != null) {
                        Supplementpassengers sp = new Supplementpassengers(pd.getEmail(),intermediatestation);
                        System.out.println("Saving Supplementpassengers: " + sp);
                        supplementpassengerrepo.save(sp);
                    } else {
                        System.out.println("Intermediate station is null, skipping saving Supplementpassengers.");
                    }
                } else {
                    System.out.println("No passengers found, skipping Supplementpassengers creation.");
                }
            } else {
                System.out.println("No station assignments found, skipping logic.");
            }
        } else {
            System.out.println("Count is less than or equal to 2, skipping logic.");
        }
    }

    private List<AssignValues> convertStationAssignToAssignValues(List<StationAssign> stationAssignments) {
        // Convert StationAssign objects to AssignValues objects
        return stationAssignments.stream()
                .map(sa -> new AssignValues(sa.getStation(), sa.getValue()))
                .collect(Collectors.toList());
    }
}
