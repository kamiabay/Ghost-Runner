//
//  RunData.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/13/21.
//

import Foundation


class RunData {
    
    private let runModel: Run;
    private let runSnapshotList : [RunSnapshot];
    private let CALORIE_PER_SECONDS = 0.5; // just an idea
    private var currentLocationIndex = 0;
    private var distanceMetersTraveled: Double = 0.0;
    private var currentSnapshot, prevSnapshot: RunSnapshot?;
    
    init(runModel: Run) {
        self.runModel = runModel
        runSnapshotList = runModel.runSnapshotList
    }
    
    
    func distanceTraveledSoFar() -> Double {
        return distanceMetersTraveled
    }
    
    // gets the location of runner
    func getNextRunSnapShot() -> RunSnapshot {
        prevSnapshot = currentSnapshot;
        if (!isRunFinished()) {
            currentSnapshot = runSnapshotList[currentLocationIndex];
            currentLocationIndex += 1;
            updateDistanceTraveled();
        }
        else {
            currentSnapshot = runModel.lastSnapshot(); // if finished just return thelast location
        }
        return currentSnapshot ?? runModel.lastSnapshot();
    }
    
    func isRunFinished() -> Bool {
        if (currentLocationIndex == runSnapshotList.count - 1 || runSnapshotList.isEmpty) {
            print("finished the run")
            return true;
        }
        else {
            return false
        }
    }
        
}


extension RunData {
    
    private func updateDistanceTraveled() {
        var distance = 0.0;
        if (prevSnapshot == nil || currentSnapshot == nil) {
            distance = 0.0;
        }
        else {
            distance = currentSnapshot?.getCordinate().distance(from: prevSnapshot?.getCordinate() ?? runModel.lastSnapshot().getCordinate()) ?? 0.0
        }
        
        distanceMetersTraveled += distance ;
    }
}
