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
        
        static var photoURL: String? {
            get {
                return UserDefaults.standard.string(forKey: "photoURL")
            }
            
            set(name) {
                UserDefaults.standard.set(name, forKey: "photoURL")
            }
        }
        
        static var code: String? {
            get {
                return UserDefaults.standard.string(forKey: "code")
            }
            
            set(name) {
                UserDefaults.standard.set(name, forKey: "code")
            }
        }
    }
    
    init(uid: String,name: String , photoURL: String, code: String) {
        Storage.uid = uid;
        Storage.name = name;
        Storage.photoURL = photoURL;
        Storage.code = code;
    }
    
    init() {
        self.user = User(data: ["":""]); // TODO: instantiate
    }
    
    func getUser() -> User {
        let name = Storage.name ?? "";
        let uid = Storage.uid ?? "";
        let photoURL = Storage.photoURL ?? "";
        let code = Storage.code ?? "";
        return User.init(name: name, photoURL: photoURL, uid: uid, code: code);
    }
    
    func userExist () -> Bool {
        print(" user uid in here => : \(Storage.uid)")

        if (Storage.uid == "") {
            return false
        }
        else if (Storage.uid == nil) {
            return false
        }
        else {return true}
    }
    
    func deleteUser() {
        Storage.uid = "";
        Storage.name = "";
        Storage.photoURL = "";
    }
    
}
