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
class Opponent {
    
}

class RunCalculation {
    private var opponentList: [GhostRun];
    private var ownRunList = [RunSnapshot](); // EMPRY LIST ??
    private var ownPolyLineList = [CLLocationCoordinate2D]()
    init (opponentList: [GhostRun]) {
        self.opponentList = opponentList;
    }

        
    // OPPONENT
    func getOwnCurrentPolyLine() -> MKPolyline {
        return MKPolyline(coordinates: ownPolyLineList, count: ownPolyLineList.count)
    }

    func getOpponentFullMKPolyline() -> [MKPolyline] {
        return opponentList.map { (GhostRun) -> MKPolyline in
            GhostRun.run.getFullMKPolyline()
        }
    }
    
    func amIAhead() -> Bool {
        // check distance traveled by OWN and OPONNENT
        return true;
    }
    
//    func hasOpponenetFinishedRun() -> Bool {
//        return opponentList.isRunFinished();
//    }
    
    func getOpponentNextRunsnapshot() -> [RunSnapshot] {
        return opponentList.map { (GhostRun) -> RunSnapshot in
            GhostRun.run.getNextRunLocation()
        }

    }
    
    // OWN
    
    
    // UPDATE AT INTERVAL: every 1-5 seconds
    func updateOwnLocation(runSnapshot: RunSnapshot) {
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
 
