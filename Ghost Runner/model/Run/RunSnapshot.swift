//
//  RunSnapshot.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import CoreLocation

class RunSnapshot {
    var gps: GPS;
    
    
    
    // get from db
    init(doc: [String : Any]) {
        self.gps = GPS(doc: doc["gps"] as? [String : Any] ?? ["" : ""]);
    }
    
    // get from device every TIME INTERVAL
    init(gps: GPS) {
        self.gps = gps;
    }
    
    
    private func formatTime(timeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss':'ZZZZ"
        let date = dateFormatter.date(from: timeString)
        print(date)
        return dateFormatter.date(from:timeString) ?? Date()

    }
    
    
    func getCordinate() -> CLLocation {
        return CLLocation(latitude: gps.latitude, longitude: gps.longitude);
    }
    
    func get2DCordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: gps.latitude, longitude: gps.longitude);
    }
    

    func toJSON () -> [String: Any] {
        return [
            "gps": gps.toJSON(),
        ]
    }
}
