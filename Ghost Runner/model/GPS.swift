//
//  GPS.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation

class GPS {
    var latitude: String;
    var longitude: String;
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    // get from db
    init(doc: [String : Any]) {
        self.latitude = (doc["latitude"] as? String) ?? ""
        self.longitude = (doc["longitude"] as? String) ?? ""
    }
}
