//
//  dataChanges.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import CoreLocation
import MapKit
// RUNS HAVE TO BE SAVE AT THE SAME EXACT INTERVAL => we can play with this idea more

class RunCalculation {
    private var opponentRun: Run;
    private var ownRunList = [RunSnapshot](); // EMPRY LIST ??
    private var ownPolyLineList = [CLLocationCoordinate2D]()
    init (opponentRun: Run) {
        self.opponentRun = opponentRun;
    }

    
    // DYLAN'S FUNCTIONS
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // KAMI FUNCTIONS
    
    
    // OPPONENT
    func getOwnCurrentPolyLine() -> MKPolyline {
        return MKPolyline(coordinates: ownPolyLineList, count: ownPolyLineList.count)
    }

    func getOpponentFullMKPolyline() -> MKPolyline {
        return opponentRun.getFullMKPolyline()
    }
    
    func isOpponentBehind() -> Bool {
        // check distance traveled by OWN and OPONNENT
        return true;
    }
    
    func hasOpponenetFinishedRun() -> Bool {
        return opponentRun.isRunFinished();
    }
    
    func getOpponentNextRunsnapshot() -> RunSnapshot {
        return opponentRun.getNextRunLocation()
    }
    
    // OWN
    
    
    // UPDATE AT INTERVAL: every 1-5 seconds
    func updateOwnRunAndGetOpponentLocation(runSnapshot: RunSnapshot) {
        ownRunList.append(runSnapshot);
        updateCurrentPolyLine(runSnapshot: runSnapshot)
       // return opponentRun.getNextRunLocation();
    }
    
    
    func getOwnFinalRunList() -> [RunSnapshot] {
        return ownRunList;
    }
    
    func deleteOwnRunList() {
        ownRunList.removeAll()
    }
    
    func updateCurrentPolyLine(runSnapshot: RunSnapshot) {
        ownPolyLineList.append(runSnapshot.get2DCordinate())
    }
    
    
}
 
