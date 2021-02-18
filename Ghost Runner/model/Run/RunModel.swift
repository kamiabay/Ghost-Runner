//
//  Run.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import CoreLocation

// this is the run that we read from the Database
class Run {
    private var runID: String;
    private var runSnapshotList : [RunSnapshot];
    private let CALORIE_PER_SECONDS = 0.5; // just an idea
    private let date = Date();
    private var currentLocationIndex = 0;
    
    init(runSnapshotList: [RunSnapshot], runID: String) {
        self.runSnapshotList = runSnapshotList;
        self.runID = runID;
    }
    
    // DYLAN'S FUNCTIONS
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // KAMI FUNCTIONS
    func avgSpeed() -> Double {
        let calendar = Calendar.current
        let time = totalDuration();
        let second = calendar.component(.second, from: time)
        return totalDistance() / Double(second);  // check later
    }
    
    func totalDistance() -> Double {
        var prevCordinate: CLLocation?;
        var distance = 0.0;
        runSnapshotList.forEach{ (runSnapshot) in
            prevCordinate = runSnapshot.getCordinate();
            // WRONG => NO !
            let distanceInMeters = prevCordinate!.distance(from: prevCordinate!)
            distance = distance + distanceInMeters;
        };
        
        return distance;
    }
    
    // gets the location of runner
    func getNextRunLocation() -> RunSnapshot {
        var currentSnapshot: RunSnapshot;
        if (currentLocationIndex == runSnapshotList.count) {
            currentSnapshot = runSnapshotList[currentLocationIndex];
        }
        else {
            currentSnapshot = runSnapshotList[runSnapshotList.count - 1];
        }
        currentLocationIndex += 1;
        return currentSnapshot;
    }
    
    func isRunFinished() -> Bool {
        
        if (currentLocationIndex == runSnapshotList.count) {
            return true;
        }
        else {
            return false
        }
    }
    
    func caloriesBurned() {
       // totalDistance()
    }
    
    func avgHeartRate() { // might not need it
        
    }
    
    func totalDuration() -> Date {
        let startTime = runSnapshotList[0].time;
        let endTime = runSnapshotList[runSnapshotList.count - 1].time;
        
        return Date.init(timeInterval: startTime.timeIntervalSince1970, since: endTime); // wrong
    }
    

    
}
