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
    
    struct ApiError: Error {
        var message: String
        var code: String
        
        init(response: [String: Any]) {
            self.message = (response["error_message"] as? String) ?? "Network error"
            self.code = (response["error_code"] as? String) ?? "network_error"
        }
    }
    
    typealias ApiCompletion = ((_ response: [String: Any]?, _ error: ApiError?) -> Void)
    
    // CALL AT THE END OF THE RUN
    func saveRunSnapShot(runSnapShotList: [RunSnapshot]) {
        let ref = path.userAllRuns();
        let jsonList = runSnapShotList.map { (runSnapShot) -> [String: Any] in
           return runSnapShot.toJSON()
        };
        
        ref.addDocument(data: [
            "runData": FieldValue.arrayUnion(jsonList), // MIGHT NOT WORK
            "creationTime": FieldValue.serverTimestamp(),
        ]);
    }
    
    func getUserRunList(completion:@escaping(([Run]) -> ())) {
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
                print("\( runList.count): before ");
                async.leave()
                async.notify(queue: .main) {
                    print("\( runList.count): after ");
                      completion(runList)
                    }
            }
        }
        

        
       
      
        
    }

}
