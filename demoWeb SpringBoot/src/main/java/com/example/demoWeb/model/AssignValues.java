package com.example.demoWeb.model;

import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
//import java.lang.Math;
import java.util.stream.Collectors;

@Component
public class AssignValues {
   
    private String station;
    private int value;
    public AssignValues() {
    }

    public AssignValues(String station, int value) {
        this.station = station;
        this.value = value;
    }

    public String getStation() {
        return station;
    }

    public int getValue() {
        return value;
    }

    public String check(Passengerdetails pd, List<AssignValues> a,  List<Passengerdetails> allPassengers) {
      
        Map<String, Integer> stationMap = a.stream()
            .collect(Collectors.toMap(AssignValues::getStation, AssignValues::getValue));

        // Print the map
        stationMap.forEach((station, value) -> System.out.println(station + " -> " + value));
         int x;
        int min=1000;
        int indexvalue=0;
        for (int i = 0; i < allPassengers.size(); i++)
        {     x=stationMap.get(allPassengers.get(i).getDestination())-stationMap.get(pd.getStarting());
            if(x>0 && min>x )
            {
                min=x;
                indexvalue=i;
                
            }
        }
        System.out.println(pd);
        System.out.println("The nearest station is: "+allPassengers.get(indexvalue).getDestination());
        return allPassengers.get(indexvalue).getDestination();

            
        

        // Sendmsg sendmsg = new Sendmsg(a.get(x).dtname, pd);
        // System.out.println(sendmsg.sendText());

        // new Sendemail(sendmsg.sendText(), email);
    }

    @Override
    public String toString() {
        return station + " " + value+ "\n";
    }
}

