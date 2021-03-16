//
//  GPS.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import CoreLocation

class GPS {
    var latitude: Double;
    var longitude: Double;
    var altitude: Double;
    var location: CLLocation? // FORCED??
    var heading: CLHeading?
    
    init(locationManager: CLLocationManager) {
        location = locationManager.location;
        self.altitude = location?.altitude ?? 0.0;
        self.latitude = location?.coordinate.latitude ?? 0.0;
        self.longitude = location?.coordinate.longitude ?? 0.0;
    }
    
    // get from db
    init(doc: [String : Any]) {
        self.latitude = (doc["lat"] as? Double) ?? 0
        self.longitude = (doc["lon"] as? Double) ?? 0
        self.altitude = (doc["alt"] as? Double) ?? 0
       
    }
    
    func toJSON () -> [String: Any] {
        return [
            "lat": self.latitude,
            "lon": self.longitude,
            "alt": self.altitude,
           // "heading": self.heading,
        ]
    }

}
