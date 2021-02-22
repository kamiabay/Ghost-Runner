//
//  localStorage.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation

class LocalStorage {
    private var user: User?;
    
    
    private struct Storage {
        static var uid: String? {
            get {
                return UserDefaults.standard.string(forKey: "uid")
            }
            
            set(uid) {
                UserDefaults.standard.set(uid, forKey: "uid")
            }
        }
        
        static var name: String? {
            get {
                return UserDefaults.standard.string(forKey: "name")
            }
            
            set(name) {
                UserDefaults.standard.set(name, forKey: "name")
            }
        }
    }
    
    init(name: String , uid: String) {
        Storage.name = name;
        Storage.uid = uid;
    }
    init() {
        self.user = User(doc: ["":""]); // TODO: instantiate
    }
    
    func getUser() -> User {
        let name = Storage.name ?? "no name";
        let uid = Storage.uid ?? "no uid";

        return User.init(name: name, photoURL: "", uid: uid);
    }
    
    func userExist () -> Bool {
        return (Storage.uid != nil)
    }
    
}
