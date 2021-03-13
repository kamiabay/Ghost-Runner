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
    var code: String = "";
    
    
    // local
    init(name: String, photoURL: String, uid: String, code: String) {
        self.name = name
        self.photoURL = photoURL
        self.uid = uid
        self.code = code
    }
    
    
    
    // from db
    init(data: [String : Any]) {
        self.name = (data["name"] as? String) ?? ""
        self.photoURL = (data["photoURL"] as? String) ?? ""
        self.uid = (data["uid"] as? String) ?? ""
        self.code = (data["code"] as? String) ?? ""
    }
    func getUIImage() -> UIImage {
        
        let url = URL(string: photoURL)
        let data = try? Data(contentsOf: url!)
        
        return UIImage(data: data!)!; 
    }
    
    func toJSON () -> [String: Any] {
        return [
            "name": name,
            "photoURL": photoURL,
            "uid": uid,
            "code": code,
        ]
    }

}
