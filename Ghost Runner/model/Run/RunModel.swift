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
    
    let runID: String;
    let runSnapshotList : [RunSnapshot];
    let totalDistance: Double;
    let runName: String;
    
    
    init(runSnapshotList: [RunSnapshot], runID: String, runName: String, totalDistance: Double) {
        self.runSnapshotList = runSnapshotList;
        self.runID = runID;
        self.runName = runName;
        self.totalDistance = totalDistance;
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
    
    // AT INITIATION
    func getFullMKPolyline() -> MKPolyline   {
        var list2DCordinates = [CLLocationCoordinate2D]()
        list2DCordinates = runSnapshotList.map{ (runSnapshot) -> CLLocationCoordinate2D in
            return runSnapshot.get2DCordinate()
        };
        let routeLine = MKPolyline(coordinates: list2DCordinates, count: list2DCordinates.count)
       
        return routeLine;
    }
    
    func totalDuration() -> TimeInterval {
        let startTime = Date();
        let endTime = Date();

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        return endTime.timeIntervalSince(startTime)
    }
    
}
