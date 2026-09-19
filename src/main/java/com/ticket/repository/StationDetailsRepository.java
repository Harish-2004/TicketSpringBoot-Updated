package com.ticket.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.ticket.model.StationAssign;

public interface StationDetailsRepository extends JpaRepository<StationAssign, String> {

}
