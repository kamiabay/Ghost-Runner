//
//  RunVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//


import Foundation
import UIKit
import CoreLocation

class RunVC: UIViewController {
    var opponentRun: Run?; // NEEDS TO BE INITIALIZED
    let db = DB()
    var runSnapshotList = [RunSnapshot]();
    var runTimer: Timer?
  
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    let locationManager = CLLocationManager();
    var currentLoc: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
//        locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: " to update best") { (Error?) in
//            print("done")
//        };
        
    }

    
    @objc
    func startCollectingGPS()  {
        
        if(CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location

            let gps = GPS(
                latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude);
            runSnapshotList.append(RunSnapshot(gps: gps, elevation: "10"));
            print("\(runSnapshotList.count): saving gps : \(gps)")
        }
    }
    

    
    func saveRunData()  {
        if (!runSnapshotList.isEmpty) {
            runTimer?.invalidate()
            db.runDb.saveRunSnapShot(runSnapShotList: runSnapshotList);
           
        }
      
    }
    
    
    @IBAction func startPress(_ sender: UIButton) {
        view.backgroundColor =  .systemGreen
        runSnapshotList.removeAll()
        runTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCollectingGPS), userInfo: nil, repeats: true)

        startCollectingGPS()
    
    }
    
    @IBAction func stopPress() {
        view.backgroundColor =  .systemOrange
        saveRunData()
    }
}

extension RunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        }
    }
    
    
}

