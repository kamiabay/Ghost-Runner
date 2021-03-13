//
//  Run.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import CoreLocation
import MapKit
// this is the run that we read from the Database
class Run {
    private var runID: String;
    private var runSnapshotList : [RunSnapshot];
    private let CALORIE_PER_SECONDS = 0.5; // just an idea
    private let date = Date();
    private var currentLocationIndex = 0;
    private var distanceMetersTraveled: Double = 0.0;
    private var currentSnapshot, prevSnapshot: RunSnapshot?;
    var runName: String;
    
    init(runSnapshotList: [RunSnapshot], runID: String, runName: String) {
        self.runSnapshotList = runSnapshotList;
        self.runID = runID;
        self.runName = runName;
    }


    
    // AT INITIATION
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
    
    // AT INITIATION
    func getFullMKPolyline() -> MKPolyline   {
        var list2DCordinates = [CLLocationCoordinate2D]()
        list2DCordinates = runSnapshotList.map{ (runSnapshot) -> CLLocationCoordinate2D in
            return runSnapshot.get2DCordinate()
        };
        let routeLine = MKPolyline(coordinates: list2DCordinates, count: list2DCordinates.count)
       
        return routeLine;
    }
    
    func initialSnapshot() -> RunSnapshot {
       return runSnapshotList.first ?? RunSnapshot(doc: ["" : "Any"]);
    }
    
    func halfWaySanpshot() -> RunSnapshot {
       let halfWayIndex = runSnapshotList.count / 2;
        return runSnapshotList[halfWayIndex];
    }
    
    func lastSnapshot() -> RunSnapshot {
        return runSnapshotList.last ?? RunSnapshot(doc: ["" : "Any"]);
    }
    
    func distanceTraveledSoFar() -> Double {
        return distanceMetersTraveled
    }
    
    // gets the location of runner
    func getNextRunLocation() -> RunSnapshot {
        prevSnapshot = currentSnapshot;
        if (!isRunFinished()) {
            currentSnapshot = runSnapshotList[currentLocationIndex];
            currentLocationIndex += 1;
            updateDistanceTraveled();
        }
        else {
            currentSnapshot = lastSnapshot(); // if finished just return thelast location
        }
        return currentSnapshot ?? lastSnapshot();
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
    
    func caloriesBurned() {
       // totalDistance()
    }
    
    func avgHeartRate() { // might not need it
        
    }
    
    func totalDuration() -> TimeInterval {
        let startTime = Date();
        let endTime = Date();

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        return endTime.timeIntervalSince(startTime)
    }
    
    
}





extension Run {
    
    private func updateDistanceTraveled() {
        var distance = 0.0;
        if (prevSnapshot == nil || currentSnapshot == nil) {
            distance = 0.0;
        }
        else {
            distance = currentSnapshot?.getCordinate().distance(from: prevSnapshot?.getCordinate() ?? lastSnapshot().getCordinate()) ?? 0.0
        }
        
        distanceMetersTraveled += distance ;
    }
}
