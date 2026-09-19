package com.ticket.service;

import com.ticket.config.KafkaTopicConfig;
import com.ticket.dto.TicketBookingEvent;
import com.ticket.model.PassengerDetails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class BookingConsumerService {

    private static final Logger logger = LoggerFactory.getLogger(BookingConsumerService.class);

    @Autowired
    private TicketService ticketService;

    @KafkaListener(topics = KafkaTopicConfig.TICKET_BOOKING_TOPIC, groupId = "ticket-booking-group")
    public void consumeBookingEvent(TicketBookingEvent event) {
        logger.info("Successfully consumed TicketBookingEvent from Kafka: {}", event);
        try {
            PassengerDetails pd = new PassengerDetails(
                    event.getEmail(),
                    event.getName(),
                    event.getStarting(),
                    event.getDestination()
            );
            ticketService.bookTicket(pd);
            logger.info("Successfully processed ticket booking asynchronously for passenger: {}", event.getEmail());
        } catch (Exception e) {
            logger.error("Error processing consumed TicketBookingEvent for email {}: {}", event.getEmail(), e.getMessage(), e);
        }
    }
}
