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
    var runCalculation : RunCalculation?
    let CONST_TIME: Double = 1.0;
    var lastDrawnPolyLine: MKOverlay?
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
        
        // DELEGATES
        mapView.delegate = self;
        locationManager.delegate = self

        runCalculation = RunCalculation(opponentRun: opponentRun ?? Run(runSnapshotList: [RunSnapshot](), runID: "null"));
        
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
            self.initiateMapSetup()
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
    
    func initiateMapSetup() {
        //self.locationManager.startUpdatingLocation()
        //self.locationManager.startUpdatingHeading()
        self.mapView.showsUserLocation = true
        self.setInitialZoom()
        self.mapView.addAnnotation(self.ghostDot)
     //   self.startObservingUser()
       // print("Began observing user")
       
//        self.beginGhostAnimation()
       // print("Began animating opponent")
    }
    
    // #######################################
    // Ghost/Opponent Functions
    // #######################################
    

    // TO BE REMOVED
    func beginGhostAnimation() {
        runTimer = Timer.scheduledTimer(timeInterval: CONST_TIME, target: self, selector: #selector(updateOpponentLocation), userInfo: nil, repeats: true)
        //updateOpponentLocation
    }
    
    @objc func updateOpponentLocation()  {
        if (opponentRun == nil) {return} // i.e NO OPPONENT i.e FIRST RUN
        
        if let nextCoord = runCalculation?.getOpponentNextRunsnapshot().get2DCordinate() {
            UIView.animate(withDuration: CONST_TIME) {
                self.ghostDot.coordinate.latitude = nextCoord.latitude
                self.ghostDot.coordinate.longitude = nextCoord.longitude
            }
        }
    }
    
    func updateOwnPolyLine()  {
        if let previous = lastDrawnPolyLine {
            // Remove last drawn segment if needed.
            self.mapView.removeOverlay(previous)
            lastDrawnPolyLine = nil
        }
        let currPolyLine = runCalculation!.getOwnCurrentPolyLine();
        self.mapView.addOverlay(currPolyLine)
        lastDrawnPolyLine = currPolyLine;
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
    
//    func startObservingUser() {
//            userTrackTimer = Timer.scheduledTimer(timeInterval: CONST_TIME, target: self, selector: #selector(updateMapCenter), userInfo: nil, repeats: true)
//            updateMapCenter()
//    }
//
    @objc func resumeObservingUser() {
      //  self.startObservingUser()
    }
    
    @objc func centerMapToCurrentLocation() {
        if let currLoc = locationManager.location?.coordinate {
            mapView.setCenter(currLoc, animated: true)
            print("updating center!")
        }
    }
    
    
    // #######################################
    // User Run/Snapshot Recording
    // #######################################
    
    @objc func intervalUpdate() {
        //let snap = opponentRun!.getNextRunLocation();
        //runCalculation?.updateOwnRunAndGetOpponentLocation(runSnapshot: snap)
            let gps = GPS(locationManager: locationManager);
            runCalculation?.updateOwnRunAndGetOpponentLocation(runSnapshot: RunSnapshot(gps: gps))
            updateOwnPolyLine()
            updateOpponentLocation()
            centerMapToCurrentLocation() // LOCK THE USER TO ONLY THAT LOCATION , CANT ZOOM OUT/IN
    }
    
    func saveRunData()  {
        let ownRunList = runCalculation!.getOwnFinalRunList();
        if (!ownRunList.isEmpty) {
            db.runDb.saveRunSnapShot(runSnapShotList: ownRunList);
        }
      
    }
    
    func pickTheWinner() {
        if (opponentRun == nil) {return} // i.e NO OPPONENT i.e FIRST RUN
    }
    
    
    
    // #######################################
    // Buttons
    // #######################################
    
    
    @IBAction func animateOpponent() {
        beginGhostAnimation();
    }
    
    
    @IBAction func startPress(_ sender: UIButton) {
        view.backgroundColor =  .systemGreen
        
        locationManager.showsBackgroundLocationIndicator = true
        runCalculation?.deleteOwnRunList()
       
        // enable listner for background GPS change
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        // timer
        runTimer = Timer.scheduledTimer(timeInterval: CONST_TIME, target: self, selector: #selector(intervalUpdate), userInfo: nil, repeats: true)

    }
    
    @IBAction func stopPress() {
        view.backgroundColor =  .systemOrange
        runTimer?.invalidate()
        
    
        saveRunData()
        locationManager.showsBackgroundLocationIndicator = false
        // disable listner for background GPS change
        locationManager.stopUpdatingHeading();
        locationManager.stopUpdatingLocation();
        
        pickTheWinner();
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



extension RunVC: MKMapViewDelegate {
    
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


    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .systemBlue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
       }
    
}
