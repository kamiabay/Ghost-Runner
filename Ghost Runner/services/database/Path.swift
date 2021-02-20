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
    func userPrivate() -> FirebaseFirestore.DocumentReference{
        return db.collection("user").document("user.uid")
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
