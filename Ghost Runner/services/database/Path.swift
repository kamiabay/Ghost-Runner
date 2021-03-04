//
//  Path.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import FirebaseFirestore

class Path {
    private var user: User;
    private var db: Firestore;
    init(user: User) {
        self.user = user;
        self.db = Firestore.firestore();
    }
    
    
    // USER
    func allUsers() -> FirebaseFirestore.CollectionReference{
        return db.collection("user")
    }
    
    func userPrivate() -> FirebaseFirestore.DocumentReference{
        return db.collection("user").document(user.uid)
    }
    
    // FRIENDS
    func allFriends() -> FirebaseFirestore.CollectionReference {
        return userPrivate().collection("friends")
    }
    
    func eachFriend(friendUID: String) -> FirebaseFirestore.DocumentReference {
        return allFriends().document(friendUID)
    }
    
    func friendAllRuns(friendUID: String) -> FirebaseFirestore.CollectionReference {
        return allUsers().document(friendUID).collection("run")
    }
    
    // RUNS
    func userAllRuns() -> FirebaseFirestore.CollectionReference {
        return self.userPrivate().collection("run");
    }
    
    func userEachRun(runID: String) -> FirebaseFirestore.DocumentReference {
        return self.userPrivate().collection("run").document(runID);
    }
    
    
    
    // 
}
