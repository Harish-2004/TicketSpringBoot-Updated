package com.ticket.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaTopicConfig {

    public static final String TICKET_BOOKING_TOPIC = "ticket-booking-events";

    @Bean
    public NewTopic ticketBookingTopic() {
        return TopicBuilder.name(TICKET_BOOKING_TOPIC)
                .partitions(3)
                .replicas(1)
                .build();
    }
}
