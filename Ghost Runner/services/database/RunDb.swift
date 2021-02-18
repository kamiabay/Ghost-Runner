//
//  test.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import FirebaseFirestore

class RunDb {
    private var user: User;
    private var path: Path;
    
    init(user: User) {
        self.user = user;
        self.path = Path.init(user: user);
    }
    
    // CALL EVERY INTERVAL 
    func saveRunSnapShot(runSnapShot: RunSnapshot, runID: String) {
        let ref = path.userEachRun(runID: runID);
        
        ref.setData([
            "runData": FieldValue.arrayUnion([runSnapShot.toJSON()])
        ], merge: true);
    }

}
