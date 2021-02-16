//
//  localStorage.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation

class LocalStorage {
    private var user: User;
    
    init() {
        self.user = User(doc: ["":""]); // TODO: instantiate
    }
    
    func getUser() -> User {
        return self.user;
    }
    
}
