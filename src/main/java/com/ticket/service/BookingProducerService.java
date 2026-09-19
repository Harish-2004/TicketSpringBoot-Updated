package com.ticket.service;

import com.ticket.config.KafkaTopicConfig;
import com.ticket.dto.TicketBookingEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class BookingProducerService {

    private static final Logger logger = LoggerFactory.getLogger(BookingProducerService.class);

    @Autowired
    private KafkaTemplate<String, TicketBookingEvent> kafkaTemplate;

    public void sendBookingEvent(TicketBookingEvent event) {
        logger.info("Publishing TicketBookingEvent to Kafka topic '{}': {}", KafkaTopicConfig.TICKET_BOOKING_TOPIC, event);
        // Use user email as message partition key for ordering
        kafkaTemplate.send(KafkaTopicConfig.TICKET_BOOKING_TOPIC, event.getEmail(), event);
    }
}
