//
//  dataChanges.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation

// RUNS HAVE TO BE SAVE AT THE SAME EXAT INTERVAL
class RunCalculation {
    private var opponentRun: Run;
    private var ownRunList = [RunSnapshot](); // EMPRY LIST ??
    init (otherRunner: Run) {
        self.opponentRun = otherRunner;
    }
    
    
    // FUNCTIONS
    
    func isOpponentBehind() -> Bool {
        // check distance traveled by OWN and OPONNENT
        return true;
    }
    
    func hasOpponenetFinishedRun() -> Bool {
        return opponentRun.isRunFinished();
    }
    
    
    // UPDATE AT INTERVAL: every 1-5 seconds
    func updateOwnRunAndGetOpponentLocation(runSnapshot: RunSnapshot) -> RunSnapshot{
        ownRunList.append(runSnapshot);
        return opponentRun.getNextRunLocation();
    }
    
    
    func getOwnFinalRunList() -> [RunSnapshot] {
        return ownRunList;
    }
    
    
}
