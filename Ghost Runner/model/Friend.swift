//
//  Friend.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/1/21.
//

import Foundation


class Friend: User {
    
    
    override init(data: [String : Any]) {
        super.init(data: data)
    }
    
    
    override init(name: String, photoURL: String, uid: String) {
        super.init(name:name , photoURL: photoURL, uid: uid)
    }
}
