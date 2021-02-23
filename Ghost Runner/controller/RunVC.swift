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
    
    
    // Timers
    var runTimer: Timer?
    var userTrackTimer: Timer?
    var opponenetTimer: Timer?
  
    // Storyboard Outlets
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // CoreLocation Location Manager instance
    let locationManager = CLLocationManager();
    
    // Ghost location
    dynamic var ghostDot = MKPointAnnotation()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // General view styling
        view.backgroundColor =  .darkGray
        
        // Set up observer in background
        NotificationCenter.default.addObserver(self, selector: #selector(resumeObservingUser), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // In case user did not enable location, this will ask again, stalling our user/ghost functions
        let authorizeLocQueue = DispatchQueue(label: "authorizelocation")
        authorizeLocQueue.async {
            if !(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
                self.locationManager.requestWhenInUseAuthorization()
                print("asking for auth")
            }
        }
        
        // Wait until there is location approval to begin user/ghost functions
        authorizeLocQueue.async {
            while !(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {}
            self.CLandMapKitSetup()
            self.beginUpdatingMap()
        }
    }
    
    // Deinit notification for when app enters foreground
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    // #######################################
    // CL/MK Set-up
    // #######################################
    
    func CLandMapKitSetup() {
        // For Kami's background support
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        
        if #available(iOS 14.0, *) {
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "to update best") { (Error) in
                print("done")
            }
        } else {
            print("locationManager needs to fall back onto older version")
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    func beginUpdatingMap() {
        self.locationManager.startUpdatingLocation()
        //self.locationManager.startUpdatingHeading()
        self.mapView.showsUserLocation = true
        self.setInitialZoom()
        self.startObservingUser()
        print("Began observing user")
        
        self.mapView.addAnnotation(self.ghostDot)
        self.animateOpponent()
        print("Began animating opponent")
    }
    
    // #######################################
    // Ghost/Opponent Functions
    // #######################################
    
    @IBAction func animateOpponent() {
        beginGhostAnimation();
    }
    
    func beginGhostAnimation() {
        runTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateOpponentLocation), userInfo: nil, repeats: true)
    }
    
    @objc func updateOpponentLocation()  {
        //print("\(opponentRun?.getNextRunLocation().toJSON())")
        //mapView.setCenter((opponentRun?.getNextRunLocation().get2DCordinate())!, animated: true)
        
        //let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        //mkAnnotation.coordinate = (opponentRun?.getNextRunLocation().get2DCordinate())!
        
        if let nextCoord = opponentRun?.getNextRunLocation().get2DCordinate() {
            UIView.animate(withDuration: 2) {
                self.ghostDot.coordinate.latitude = nextCoord.latitude
                self.ghostDot.coordinate.longitude = nextCoord.longitude
            }
        }
    }
    
    // #######################################
    // User GPS Tracking/Animation
    // #######################################
    
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
    
    @objc func resumeObservingUser() {
        self.startObservingUser()
    }
    
    @objc func updateMapCenter() {
        if let currLoc = locationManager.location?.coordinate {
            mapView.setCenter(currLoc, animated: true)
            print("updating center!")
        }
    }
    
    
    // #######################################
    // User Run/Snapshot Recording
    // #######################################
    
    @objc func startCollectingGPSData()  {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            print("saving GPS")
            let gps = GPS(locationManager: locationManager);
            runSnapshotList.append(RunSnapshot(gps: gps));
            print("\(runSnapshotList.count): saving gps : \(gps)")
        }
    }
    
    func saveRunData()  {
        if (!runSnapshotList.isEmpty) {
            runTimer?.invalidate() // end the timer
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
          //  print("New location is \(location)")
        }
    }
}


func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }

    let identifier = "Annotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

    if annotationView == nil {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = true
    } else {
        annotationView!.annotation = annotation
    }

    return annotationView
}

