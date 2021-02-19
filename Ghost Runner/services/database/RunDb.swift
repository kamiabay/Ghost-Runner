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
    
    // CALL AT THE END OF THE RUN
    func saveRunSnapShot(runSnapShotList: [RunSnapshot], runID: String) {
        let ref = path.userEachRun(runID: runID);
        let jsonList = runSnapShotList.map { (runSnapShot) -> [String: Any] in
           return runSnapShot.toJSON()
        };
        ref.setData([
            "runData": FieldValue.arrayUnion(jsonList), // MIGHT NOT WORK
            "creationTime": FieldValue.serverTimestamp(),
        ], merge: true);
    }
    
    func getUserRunList() -> [Run] {
        let ref = path.userAllRuns();
        var runList = [Run]();
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
//                let runList = querySnapshot.map { (QuerySnapshot) -> [Run] in
//                    let list: [RunSnapshot] = QuerySnapshot.documents.map { (QueryDocumentSnapshot) -> RunSnapshot in
//                        return RunSnapshot(doc: QueryDocumentSnapshot.data());
//                    }
//
//                    return Run(runSnapshotList: list, runID: "String")
//                }

            }
        }
        
        return runList;
        
    }

}
