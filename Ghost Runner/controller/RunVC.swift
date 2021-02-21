//
//  RunVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//


import Foundation
import UIKit
import CoreLocation
import MapKit

class RunVC: UIViewController {
    var opponentRun: Run?; // NEEDS TO BE INITIALIZED
    let db = DB()
    var runSnapshotList = [RunSnapshot]();
    var runTimer: Timer?
    var userTrackTimer: Timer?
  
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumeObservingUser), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Beging to update the user's location on the app after location is authorized
        let authorizeLocQueue = DispatchQueue(label: "authorizelocation")
        authorizeLocQueue.async {
            if !(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
                self.locationManager.requestWhenInUseAuthorization()
                print("asking for auth")
            }
        }
        authorizeLocQueue.async {
            while !(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {}
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            self.setInitialZoom()
            self.startObservingUser()
            print("began observing user")
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func resumeObservingUser() {
        self.startObservingUser()
    }
    
    func setInitialZoom() {
        if let currLoc = locationManager.location?.coordinate {
            let zoomRegion = MKCoordinateRegion(center: currLoc, latitudinalMeters: CLLocationDistance(exactly: 1000) ?? 0, longitudinalMeters: CLLocationDistance(exactly: 1000) ?? 0)
            mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: false)
        }
    }
    
    func startObservingUser() {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            userTrackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateMapCenter), userInfo: nil, repeats: true)
            updateMapCenter()
        }
    }
    
    @objc func updateMapCenter() {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            if let currLoc = locationManager.location?.coordinate {
                mapView.setCenter(currLoc, animated: true)
            }
        }
    }

    
    @objc
    func startCollectingGPSData()  {
        
        if(CLLocationManager.authorizationStatus() == .authorizedAlways) {
            let gps = GPS(locationManager: locationManager);
            runSnapshotList.append(RunSnapshot(gps: gps));
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
        runTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startCollectingGPSData), userInfo: nil, repeats: true)

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
