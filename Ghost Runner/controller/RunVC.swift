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
    var currentLoc: CLLocation?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
        
        // LOCATION MANAGER 
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if #available(iOS 14.0, *) {
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "to update best") { (Error) in
                print("done")
            }
        } else {
            // Fallback on earlier versions
        };
        
    }

    
    @objc
    func startCollectingGPSData()  {
        
        if(CLLocationManager.authorizationStatus() == .authorizedAlways) {

            let gps = GPS(locationManager: locationManager);
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
        locationManager.showsBackgroundLocationIndicator = true
        runSnapshotList.removeAll()
        // enable listner for background GPS change
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        // timer
        runTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCollectingGPSData), userInfo: nil, repeats: true)

        //
        startCollectingGPSData()
    
    }
    
    @IBAction func stopPress() {
        view.backgroundColor =  .systemOrange
        saveRunData()
        locationManager.showsBackgroundLocationIndicator = false
        // disable listner for background GPS change
        locationManager.stopUpdatingHeading();
        locationManager.stopUpdatingLocation();
    }
}

extension RunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        //print(heading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        }
    }
    
    
}

