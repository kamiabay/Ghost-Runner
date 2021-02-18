//
//  RunSnapshot.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import CoreLocation

class RunSnapshot {
    var elevation: String;
    var gps: GPS;
    var time: Date;
    
    
    // get from db
    init(doc: [String : Any]) {
        self.elevation = (doc["elevation"] as? String) ?? ""
        self.gps = GPS(doc: doc["gps"] as? [String : Any] ?? ["" : ""]);
        self.time = (doc["creationTime"] as? Date) ?? Date()
    }
    
    // get from device every TIME INTERVAL
    init(gps: GPS, elevation: String) {
        self.elevation = elevation;
        self.gps = gps;
        self.time =  Date(); // MIGHT CHANGE
    }
    
    func getCordinate() -> CLLocation {
        return CLLocation(latitude: gps.latitude, longitude: gps.longitude);
    }
    

    func toJSON () -> [String: Any] {
        return [
            "gps": gps.toJSON(),
            "elevation": elevation,
        ]
    }
}
