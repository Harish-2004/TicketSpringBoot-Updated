package com.example.demoWeb.Repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demoWeb.model.Passengerdetails;

public interface Repopassenger extends JpaRepository<Passengerdetails, String> {

}
