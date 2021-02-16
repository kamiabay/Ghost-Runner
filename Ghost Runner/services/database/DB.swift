//
//  db.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation

class DB {
    private var user: User;
    public var test : RunDb;
    
    init() {
        self.user = LocalStorage().getUser();
        self.test = RunDb.init(user: user);
    }
    
    
    
    
    private func checkUser() {
        if (LocalStorage().getUser() == nil) {
            // log out
        }
    }
    
}
