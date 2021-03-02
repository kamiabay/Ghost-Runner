//
//  Auth.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Authentication {
    private var db: Firestore;
    init() {
        self.db = Firestore.firestore();
    }
    func saveUserOnDB(uid: String, photoURL: String, name: String, completion: @escaping(() -> Void)) {
        let userRef = db.collection("user").document(uid)
        let async = DispatchGroup()
        async.enter()
        userRef.setData([
            "name": name,
            "photoURL":photoURL,
            "uid": uid,
            "creationTime": FieldValue.serverTimestamp(),
        ],merge: true)
        
        async.leave()
        async.notify(queue: .main) {
           
              completion()
            }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
    func emailSignIn(email: String, password: String) {
        
    }
    
    func emailSignUp(email: String, password: String) {
        
    }
    
    func googleSignIn() {
        
    }
    
    func googleSignUp() {
        
    }
}
