//
//  RunSnapshot.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation

class RunSnapshot {
    var elevation: String;
    var gps: GPS;
    
    
    // save from local
    init(elevation: String, gps: GPS ) {
        self.elevation = elevation;
        self.gps = gps;
    }
    
    // get from db
    init(doc: [String : Any]) {
        self.elevation = (doc["elevation"] as? String) ?? ""
        self.gps = GPS(doc: doc["gps"] as? [String : Any] ?? ["" : ""])
    }
}
