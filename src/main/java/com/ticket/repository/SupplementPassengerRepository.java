package com.ticket.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.ticket.model.SupplementPassengers;

public interface SupplementPassengerRepository extends JpaRepository<SupplementPassengers, String> {

}
