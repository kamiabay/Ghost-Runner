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
                  
                    let runData: [Any] = (document.data()["runData"]) as! [Any];
                    snap = runData.map { (run) -> RunSnapshot in
                        return RunSnapshot(doc: run as! [String : Any]);
                    }
                    runList.append(Run(runSnapshotList: snap, runID: "rand id"))
                }
                async.leave()
                async.notify(queue: .main) {
                      completion(runList)
                    }
            }
        }
    }
    
    
    
    

    
    

}
