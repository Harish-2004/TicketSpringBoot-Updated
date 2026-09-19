package com.ticket.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.ticket.model.PassengerDetails;

public interface PassengerRepository extends JpaRepository<PassengerDetails, String> {

}
