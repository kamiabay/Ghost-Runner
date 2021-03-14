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
    func saveRunSnapShot(runSnapShotList: [RunSnapshot]) {
        let ref = path.userAllRuns();
        let jsonList = runSnapShotList.map { (runSnapShot) -> [String: Any] in
           return runSnapShot.toJSON()
        };
        
        ref.addDocument(data: [
            "runData": FieldValue.arrayUnion(jsonList),
            "creationTime": FieldValue.serverTimestamp(),
        ]);
    }
    
    
    func getUserRunList(completion: @escaping(([Run]) -> ())) {
        let ref = path.userAllRuns().order(by: "creationTime", descending: true);
       
        var runList = [Run]();
        let async = DispatchGroup()
        
        
        ref.getDocuments() { (querySnapshot, err) in
            async.enter()
            if let err = err {
                print("Error getting documents: \(err)")
                async.leave()
            } else {
                var snap = [RunSnapshot]();
                for document in querySnapshot!.documents {
                    let documentID = document.documentID;
                    let doc = document.data() as! [String : Any];
                    let runData: [Any] = (document.data()["runData"]) as! [Any];
                    let runName = (doc["runName"] ?? "Afternoon Run") as! String
                    snap = runData.map { (run) -> RunSnapshot in
                        return RunSnapshot(doc: run as! [String : Any]);
                    }
                    runList.append(Run(runSnapshotList: snap, runID: documentID, runName: runName, totalDistance: 55.0))
                }
                async.leave()
                async.notify(queue: .main) {
                      completion(runList)
                    }
            }
        }
    }
    
    
    func deleteRun(runID: String)  {
        let ref = path.userEachRun(runID: runID);
        ref.delete();
    }
    

}
