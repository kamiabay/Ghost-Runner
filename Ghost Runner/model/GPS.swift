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
  
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    // get from db
    init(doc: [String : Any]) {
        self.latitude = (doc["latitude"] as? Double) ?? 0
        self.longitude = (doc["longitude"] as? Double) ?? 0
    }
    
    func toJSON () -> [String: Any] {
        return [
            "latitude": self.latitude,
            "longitude": self.longitude,
        ]
    }

}
