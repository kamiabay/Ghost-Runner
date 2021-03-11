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


struct GhostObj {
    var runCalc: RunCalculation
    dynamic var anno: MKPointAnnotation
    
    init(runCalc: RunCalculation, anno: MKPointAnnotation) {
        self.runCalc = runCalc
        self.anno = anno
    }
}


class RunVC: UIViewController {
    let db = DB()
    
    // Timers
     var runTimer: Timer?
     var userTrackTimer: Timer?
     var opponenetTimer: Timer?
    
    // calculation
    var runCalculation : RunCalculation?  // initialized in viewDidLoad()
    let CONST_TIME: Double = 2.0;
    var lastDrawnPolyLine: MKOverlay?
    
    var friendsList = [Friend]()
    
    // Adding N ghosts vars
    var ghostOptions = [Run]()  // will init all options tied to the user
    var selectedGhosts: [Run?] = []  // this will replace opponentRun below
    var runCalculationList: [RunCalculation?] = []
    var GhostObjList: [GhostObj?] = []
    
    // Navigation declaration
     var navigation: Navigator?
     var opponentRun: Run?; // NEEDS TO BE INITIALIZED
   
  
    // Storyboard Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runToggleOutlet: UIButton!
    @IBOutlet weak var topPanel: UIVisualEffectView!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var addGhostButtonOutlet: UIButton!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var addGhostTable: UITableView!
    
    // CoreLocation Location Manager instance
    let locationManager = CLLocationManager()
    
    // Ghost location
    dynamic var ghostDot = MKPointAnnotation()
    dynamic var ghostDot1 = MKPointAnnotation()
    dynamic var ghostDot2 = MKPointAnnotation()
    //dynamic var ghosts: [MKPointAnnotation?] = []
    
    
    // Run recording toggle
    // 0 -> default, before user begins run; title says "Begin Run"
    // 1 -> user began run, currently recording; title says "End Run"
    // 2 -> user ended run, option to save replay; title says "Save Replay?"
    var runToggleState: Int = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        
        // DELEGATES
        mapView.delegate = self;
        locationManager.delegate = self
        addGhostTable.delegate = self
        addGhostTable.dataSource = self
        
        // load data
        self.getUserRunData()
        self.getFriendsList()
        
        // View Styling
        view.backgroundColor =  .darkGray
        runToggleOutlet.layer.cornerRadius = 10
        addGhostButtonOutlet.layer.cornerRadius = 10
        cancelButtonOutlet.layer.cornerRadius = 10
        topPanel.layer.cornerRadius = 15
        topPanel.layer.masksToBounds = true
        topPanel.layer.backgroundColor = UIColor.systemBackground.cgColor
//        topPanel.layer.shadowColor = UIColor.black.cgColor
//        topPanel.layer.shadowOpacity = 1.0
//        topPanel.layer.shadowRadius = 3.0
        
        // Popup styling
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        
        // MapView Styling
        mapView.layoutMargins = UIEdgeInsets(top: topPanel.bounds.height + 20, left: 0, bottom: 0, right: 8)
        
        // Init navigation
        
        

        

        
        // RunCalculation init
        // There are 2: one for single-ghost, and another for N ghosts
        // The one below is for single opponent
        runCalculation = RunCalculation(opponentRun: opponentRun ?? Run(runSnapshotList: [RunSnapshot](), runID: "null"));
        
        // Add the initially selected Ghost to the selectedGhosts list (if the user selected a target)
        // The user can add more ghosts via "Add Ghost"
        if let opp = opponentRun {
            selectedGhosts.append(opp)
            beginAddingGhosts()  // this will refresh the GhostObjList with the initially selected run
        }
        
        // Set up observer in background
//        NotificationCenter.default.addObserver(self, selector: #selector(resumeObservingUser), name: UIApplication.willEnterForegroundNotification, object: nil)
        
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
        
        print("RUN VC DOESNT thave a Retain cycle => GOOD")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    func beginAddingGhosts() {
        // Build the list (assuming getUserRunData() has completed
        
        // Reset GhostObjList; this is because if the user wants to add another ghost, we want to avoid double-dipping into selectedGhosts
        GhostObjList = []
        selectedGhosts.forEach {g in
            let runCalc = RunCalculation(opponentRun: g ?? Run(runSnapshotList: [RunSnapshot](), runID: "null"))
            //dynamic let anno = MKPointAnnotation()
            dynamic let anno = MKPointAnnotation()
            self.mapView.addAnnotation(anno)
            GhostObjList.append(GhostObj(runCalc: runCalc, anno: anno))
        }
    }
    
    
    func getUserRunData()  {
        self.db.runDb.getUserRunList(completion: { [weak self] (ghostOptions) in
            DispatchQueue.main.async {
                self?.ghostOptions = ghostOptions
                print("recived value is : \(self?.ghostOptions.count)")
            }
       })
    }
    
    func getFriendsList()  {
        self.db.friendDb.getAllFriends(completion: { [weak self](friendList) in
            DispatchQueue.main.async {
                self?.friendsList = friendList
            }
       })
    }
    
    // #######################################
    // Adding N ghosts
    // #######################################
    
    func openTableView() {
        popupView.center = view.center
        popupView.alpha = 0
        //popupView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.5) {
            self.popupView.alpha = 1
        }
    }
    
    func closeTableView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.popupView.alpha = 0
        }) { (success) in
            self.popupView.removeFromSuperview()
        }
    }
    

    
    // #######################################
    // Ghost/Opponent Functions
    // #######################################
    

 

    
    // Original function for only one opponent
//    @objc func updateOpponentLocation()  {
//        if (isFirstRun()) {return} // i.e NO OPPONENT i.e FIRST RUN
//
//        if let nextCoord = runCalculation?.getOpponentNextRunsnapshot().get2DCordinate() {
//            UIView.animate(withDuration: CONST_TIME) {
//                self.ghostDot.coordinate.latitude = nextCoord.latitude
//                self.ghostDot.coordinate.longitude = nextCoord.longitude
//            }
//        }
//    }
    // Now supports N-ghosts
    @objc func updateOpponentLocation()  {
        //if (isFirstRun()) {return} // i.e NO OPPONENT i.e FIRST RUN
        print("here")
        print(GhostObjList.count)
        GhostObjList.forEach { g in
            if let nextCoord =
                g?.runCalc.getOpponentNextRunsnapshot().get2DCordinate() {
                UIView.animate(withDuration: CONST_TIME) {
                    g?.anno.coordinate.latitude = nextCoord.latitude
                    g?.anno.coordinate.longitude = nextCoord.longitude
                }
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
    

    @objc func resumeObservingUser() {
      //  self.startObservingUser()
    }
    
    func centerMapToCurrentLocation() {
        if let currLoc = locationManager.location?.coordinate {
            mapView.setCenter(currLoc, animated: true)
            print("updating center!")
        }
    }
    
    
    // #######################################
    // User Run/Snapshot Recording
    // #######################################
    
    @objc func intervalUpdate() {
     
        print("is moving \(!isUserMoving(locationManager: locationManager))")
       // if(!isUserMoving(locationManager: locationManager)) {return}
        
       
        
        let gps = GPS(locationManager: locationManager);
        
        // NOTE: The function currently doesn't do anything for opponent location; it only updates user location
        runCalculation?.updateOwnRunAndGetOpponentLocation(runSnapshot: RunSnapshot(gps: gps))
        
        // Polyline update; NOTE: CURRENTLY NOT COMPATIBLE WITH MULTIPLE GHOSTS
       // updateOwnPolyLine()
        
        // Updates all ghosts
        //updateOpponentLocation()
        centerMapToCurrentLocation() // LOCK THE USER TO ONLY THAT LOCATION , CANT ZOOM OUT/IN
    }

    
    
    func saveRunData()  {
        let ownRunList = runCalculation!.getOwnFinalRunList();
        if (!ownRunList.isEmpty) {
            db.runDb.saveRunSnapShot(runSnapShotList: ownRunList);
        }
    }
    

    
    
    
    // #######################################
    // Buttons
    // #######################################
    
    @IBAction func addGhostButtonPress(_ sender: UIButton) {
        openTableView()
    }
    

    
    @IBAction func beginEndToggle(_ sender: UIButton) {
        if runToggleState == 0 {
            runToggleOutlet.setTitle("End Run", for: .normal)
            startRun()
            runToggleState = 1
            runToggleOutlet.backgroundColor = .systemRed
        } else if runToggleState == 1 {
            runToggleOutlet.setTitle("Save Replay?", for: .normal)
            endRun()
            runToggleState = 2
            runToggleOutlet.backgroundColor = .systemPurple
        } else if runToggleState == 2 {
            // add option to save replay
            print("User wants to save replay")
        } else {
            print("[RunVC: beginEndToggle()] Something went wrong...")
        }
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
    }
    
    func endRun() {
        view.backgroundColor = .darkGray
        
        runTimer?.invalidate()
        
        saveRunData()
        locationManager.showsBackgroundLocationIndicator = false
        // disable listner for background GPS change
        locationManager.stopUpdatingHeading();
        locationManager.stopUpdatingLocation();
        
        pickTheWinner();
    }
    
    // NOTE: app continues to send "finished the run" repeatedly 
    @IBAction func backButton(_ sender: UIButton) {
        runTimer?.invalidate()
        navigation?.goBack()
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
        
        // Give pin a custom image
        annotationView?.image = UIImage(systemName: "circle.dashed.inset.fill")
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .systemBlue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
       }
    
}

extension RunVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ghostOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ghostCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ghostCell")
        let ghost_data = ghostOptions[indexPath.row]
        cell.textLabel?.text = "\(ghost_data.getNextRunLocation().toJSON())"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ghost_data = ghostOptions[indexPath.row]
        print("User selected ghost")
        
        // Append selected ghost to list
        selectedGhosts.append(ghost_data)
        
        // Reload all ghosts as annotations
        beginAddingGhosts()
        
        // dismiss table
        closeTableView()
        
    }
    
    
    
    
}

extension RunVC { //HELPERS
    
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
        self.mapView.showsUserLocation = true
        self.setInitialZoom()
        //self.mapView.addAnnotation(self.ghostDot)
        
        // Already added these
//        GhostObjList.forEach { g in
//            self.mapView.addAnnotation(g?.anno)
//        }
    }
    
    
    func isUserMoving(locationManager: CLLocationManager) -> Bool {
        let speed = locationManager.location?.speed ?? 2.0
       return speed < 0
    }
    
    func isFirstRun() -> Bool {
        return opponentRun == nil
    }
    
    
    func pickTheWinner() {
        if (opponentRun == nil) {return} // i.e NO OPPONENT i.e FIRST RUN
    }
}
