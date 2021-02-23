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
    init (opponentRun: Run) {
        self.opponentRun = opponentRun;
    }

    
    // DYLAN'S FUNCTIONS
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // KAMI FUNCTIONS
    
    
    // OPPONENT
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
    
    
    
    // OWN
    
    
    // UPDATE AT INTERVAL: every 1-5 seconds
    func updateOwnRunAndGetOpponentLocation(runSnapshot: RunSnapshot) {
        ownRunList.append(runSnapshot);
       // return opponentRun.getNextRunLocation();
    }
    
    func getOwnFinalRunList() -> [RunSnapshot] {
        return ownRunList;
    }
    
    func deleteOwnRunList() {
        ownRunList.removeAll()
    }
    
    
}
 
