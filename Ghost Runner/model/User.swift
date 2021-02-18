//
//  user.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import Firebase

class User {
    var name: String = "";
    var photoURL: String = "";
    var uid: String = "";
    
    // from db
    init(doc: [String : Any]) {
        self.name = (doc["name"] as? String) ?? ""
        self.photoURL = (doc["photoURL"] as? String) ?? ""
        self.uid = (doc["uid"] as? String) ?? ""
    }
    
    func toJSON () -> [String: Any] {
        return [
            "name": name,
            "photoURL": photoURL,
            "uid": uid,
        ]
    }

}
