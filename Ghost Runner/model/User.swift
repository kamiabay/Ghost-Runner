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
    
    // local
    init(name: String, photoURL: String, uid: String) {
        self.name = name
        self.photoURL = photoURL
        self.uid = uid
    }
    
    // from db
    init(data: [String : Any]) {
        self.name = (data["name"] as? String) ?? ""
        self.photoURL = (data["photoURL"] as? String) ?? ""
        self.uid = (data["uid"] as? String) ?? ""
    }
    
    func toJSON () -> [String: Any] {
        return [
            "name": name,
            "photoURL": photoURL,
            "uid": uid,
        ]
    }

}
