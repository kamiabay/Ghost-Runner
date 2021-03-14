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
    
    private var opponentList: [GhostRun];    
    let ownCurrentRun = OwnCurrentRun()
    
    init (opponentList: [GhostRun]) {
        self.opponentList = opponentList;
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
    
    
    func updateOwnGetOpponentsNextLocation(runSnapshot: RunSnapshot) -> [UserSnapshot] {
        ownCurrentRun.updateLocation(runSnapshot: runSnapshot);
        return getOpponentNextRunsnapshot()
    }
    
    private func getOpponentNextRunsnapshot() -> [UserSnapshot] {
        return opponentList.map { (GhostRun) -> UserSnapshot in
            return UserSnapshot(user: GhostRun.user, runSnapshot: GhostRun.runData.getNextRunSnapShot())
        }

    }
    

}

class OwnCurrentRun {
    private var ownRunList = [RunSnapshot]();
    private var ownPolyLineList = [CLLocationCoordinate2D]()
    
    
    func getCurrentPolyLine() -> MKPolyline {
        return MKPolyline(coordinates: ownPolyLineList, count: ownPolyLineList.count)
    }

    
    func updateLocation(runSnapshot: RunSnapshot) {
        ownRunList.append(runSnapshot);
        updateCurrentPolyLine(runSnapshot: runSnapshot)
    }
    
    
    func getFinalRunList() -> [RunSnapshot] {
        return ownRunList;
    }
    
    func deleteRunList() {
        ownRunList.removeAll()
    }
    
    private func updateCurrentPolyLine(runSnapshot: RunSnapshot) {
        ownPolyLineList.append(runSnapshot.get2DCordinate())
    }
    
}
 
