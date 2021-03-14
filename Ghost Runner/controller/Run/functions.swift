//
//  functions.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/12/21.
//

import Foundation


extension RunVC {
    
    
    func saveRunData()  {
        let ownRunList = runCalculation!.getOwnFinalRunList();
        if (!ownRunList.isEmpty) {
            db.runDb.saveRunSnapShot(runSnapShotList: ownRunList);
        }
    }
    
    func updateOwnPolyLine()  {
        if let previous = lastDrawnPolyLine {
            // Remove last drawn segment if needed.
            self.mapView.removeOverlay(previous)
            lastDrawnPolyLine = nil
        }
        let currPolyLine = runCalculation!.getOwnCurrentPolyLine(); // REMOVE !
        self.mapView.addOverlay(currPolyLine)
        lastDrawnPolyLine = currPolyLine;
    }
    
    func isFirstRun() -> Bool {
        return ghostList.isEmpty == true
    }
    
    
    func pickTheWinner() {
        if (ghostList.isEmpty) {return} // i.e NO OPPONENT i.e FIRST RUN
    }
    
    func startRun() {
        view.backgroundColor =  .systemGreen
        
        locationManager.showsBackgroundLocationIndicator = true
        runCalculation?.deleteOwnRunList()
       
        // enable listner for background GPS change
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        // timer
        runTimer = Timer.scheduledTimer(timeInterval: CONST_TIME, target: self, selector: #selector(intervalUpdate), userInfo: nil, repeats: true)
    
        // NOTE: THE BELOW LINE WILL BE REMOVED AFTER DEMO, this will return the code to debugging
        beginGhostAnimation()
    }
    
    func endRun() {
        view.backgroundColor = .darkGray
        runTimer?.invalidate()
        runTimer = nil
        
        saveRunData()
        locationManager.showsBackgroundLocationIndicator = false
        // disable listner for background GPS change
        locationManager.stopUpdatingHeading();
        locationManager.stopUpdatingLocation();
        
        pickTheWinner();
    }
    
}
