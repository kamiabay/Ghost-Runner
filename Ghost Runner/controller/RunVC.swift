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
    dynamic var anno: GhostAnno
    
    
    init(runCalc: RunCalculation, anno: GhostAnno) {
        self.runCalc = runCalc
        self.anno = anno
    }
}


class RunVC: UIViewController {
    let db = DB()
    
    // Timers
     var runTimer: Timer?
    
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
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var addGhostTable: UITableView!
    @IBOutlet weak var addGhostSymbol: UIButton!
    
    @IBOutlet weak var headingButton: UIImageView!
    
    @IBOutlet weak var gi0: UIImageView!
    @IBOutlet weak var gi1: UIImageView!
    @IBOutlet weak var gi2: UIImageView!
    @IBOutlet weak var gi3: UIImageView!
    @IBOutlet weak var gi4: UIImageView!
    @IBOutlet weak var gi5: UIImageView!
    
    private var confirmPopupView: UIView!
    
    var giList: [UIImageView?] = []
    var maxGhosts: Int = 0
    
    // CoreLocation Location Manager instance
    let locationManager = CLLocationManager()
    
    
    // Run recording toggle
    // 0 -> default, before user begins run; title says "Begin Run"
    // 1 -> user began run, currently recording; title says "End Run"
    // 2 -> user ended run, option to save replay; title says "Save Replay?"
    var runToggleState: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init navigation
        navigation = Navigator(currentViewController: self)
        
        // DELEGATES
        mapView.delegate = self;
        locationManager.delegate = self
        addGhostTable.delegate = self
        addGhostTable.dataSource = self
        
        // Initialize the top panel ghost icons
        giList = [gi0, gi1, gi2, gi3, gi4, gi5]
        maxGhosts = giList.count
        giList.forEach {gi in
            gi?.layer.cornerRadius = (gi?.layer.frame.size.width ?? 22.5)/2
            gi?.layer.borderWidth = 1.0
            gi?.layer.borderColor = UIColor.clear.cgColor
            gi?.layer.masksToBounds = true
            gi?.alpha = 0
        }
        
        headingButton.layer.borderWidth = 2.0
        headingButton.layer.masksToBounds = false
        headingButton.layer.borderColor = UIColor.white.cgColor
        headingButton.layer.cornerRadius = headingButton.frame.size.width/2
        headingButton.clipsToBounds = true
        
        // Heading image tap support
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headingTap))
        headingButton.isUserInteractionEnabled = true
        headingButton.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        // load data
        self.getUserRunData()
        self.getFriendsList()
        
        // View Styling
        view.backgroundColor =  .darkGray
        runToggleOutlet.layer.cornerRadius = 10
        cancelButtonOutlet.layer.cornerRadius = 10
        topPanel.layer.cornerRadius = 15
        topPanel.layer.masksToBounds = true
        topPanel.layer.backgroundColor = UIColor.systemBackground.cgColor
        
        // Popup styling
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        
        // MapView Styling
        mapView.layoutMargins = UIEdgeInsets(top: topPanel.bounds.height + 7, left: 0, bottom: 0, right: 8)
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: CLLocationDistance.init(2000), maxCenterCoordinateDistance: CLLocationDistance.init(2000))
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // RunCalculation init
        // This is only for the user run
        // Note: passing the opponentRun is deprecated, thus an empty run is passed
        runCalculation = RunCalculation(opponentRun: Run(runSnapshotList: [RunSnapshot](), runID: "null"))
        
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
    
    // #######################################
    // Set-up/refresh Ghost objects
    // #######################################
    
    func beginAddingGhosts() {
        // Build the list (assuming getUserRunData() has completed
        // Reset GhostObjList; this is because if the user wants to add another ghost, we want to avoid double-dipping into selectedGhosts
        GhostObjList = []
        
        giList.forEach {gi in
            gi?.image = nil
            gi?.layer.borderColor = UIColor.clear.cgColor
        }
        
        var i = 0
        selectedGhosts.forEach {g in
            let runCalc = RunCalculation(opponentRun: g ?? Run(runSnapshotList: [RunSnapshot](), runID: "null"))
            //dynamic let anno = MKPointAnnotation()
            dynamic let anno = GhostAnno()
            
            if i == 0 {
                if let url = URL(string: LocalStorage().getUser().photoURL) {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        let im = UIImage(data: imageData)
                        anno.image = im
                        giList[i]?.image = im
                        giList[i]?.layer.borderColor = UIColor.white.cgColor
                    }
                }
            } else {
                if let url = URL(string: friendsList[0].photoURL) {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        let im = UIImage(data: imageData)
                        anno.image = im
                        giList[i]?.image = im
                        giList[i]?.layer.borderColor = UIColor.white.cgColor
                    }
                }
            }
            
            self.mapView.addAnnotation(anno)
            GhostObjList.append(GhostObj(runCalc: runCalc, anno: anno))
            i += 1
        }
        
        giList.forEach {gi in
            UIView.animate(withDuration: 1) {
                gi?.alpha = 1
            }
        }
        
    }
    
    // #######################################
    // Database & data
    // #######################################
    
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
                
                
                if let opp = self?.opponentRun {
                    self?.selectedGhosts.append(opp)
                    self?.beginAddingGhosts()  // this will refresh the GhostObjList with the initially selected run
                }
            }
       })
    }
    
    // #######################################
    // Table view to add ghosts
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
    
    func beginGhostAnimation() {
        runTimer = Timer.scheduledTimer(timeInterval: CONST_TIME, target: self, selector: #selector(updateOpponentLocation), userInfo: nil, repeats: true)
        //updateOpponentLocation
    }
    
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
        if let currPolyLine = runCalculation?.getOwnCurrentPolyLine() {
            self.mapView.addOverlay(currPolyLine)
            lastDrawnPolyLine = currPolyLine;
        }
    }
    
    // #######################################
    // User GPS Tracking/Animation
    // #######################################
    
    func setInitialZoom() {
        if let currLoc = locationManager.location?.coordinate {
            let zoomRegion = MKCoordinateRegion(center: currLoc, latitudinalMeters: CLLocationDistance(exactly: 400) ?? 0, longitudinalMeters: CLLocationDistance(exactly: 400) ?? 0)
            mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: false)
        }
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
    
    // Key function; calls most of the animation/GPS update functions
    @objc func intervalUpdate() {
        
        let gps = GPS(locationManager: locationManager);
        
        // NOTE: The function currently doesn't do anything for opponent location; it only updates user location
        runCalculation?.updateOwnRunAndGetOpponentLocation(runSnapshot: RunSnapshot(gps: gps))
        
        // Polyline update; NOTE: CURRENTLY NOT COMPATIBLE WITH MULTIPLE GHOSTS
        updateOwnPolyLine()
        
        // Updates all ghosts
        updateOpponentLocation()
        
        // NO LONGER NECESSARY BECAUSE OF NEW HEADING TRACKING
        //centerMapToCurrentLocation() // LOCK THE USER TO ONLY THAT LOCATION , CANT ZOOM OUT/IN
    }

    func saveRunData()  {
        if let ownRunList = runCalculation?.getOwnFinalRunList() {
            if (!ownRunList.isEmpty) {
                db.runDb.saveRunSnapShot(runSnapShotList: ownRunList);
            }
        }
    }
    
    // #######################################
    // Buttons and helpers
    // #######################################
    
    @objc func headingTap() {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)    }
    
    @IBAction func addGhostSymbolPress(_ sender: UIButton) {
        // Note for Sam King: for our submission, the key function of the app is to compete against your own Ghost. Because of that, we disabled adding additional ghosts to make this version's user-flow much simpler and easier to use.
//        if selectedGhosts.count < maxGhosts {
//            openTableView()
//        } else {
//            print("Max ghosts added")
//        }
    }
    
    // ONLY FOR DEBUG
    @IBAction func animateOpponent() {
        beginGhostAnimation();
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
            
            // NOTE: THIS IS TEMPORARY (FOR DEMO); REMOVE BELOW LINE AFTER REPLAYS ARE IMPLEMENTED
            navigation?.goBack()
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
    
    // NOTE: app continues to send "finished the run" repeatedly 
    @IBAction func backButton(_ sender: UIButton) {
        runTimer?.invalidate()
        runTimer = nil
        navigation?.goBack()
    }
}



extension RunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
          //  print("New location is \(location)")
        }
        centerMapToCurrentLocation()
    }
    
    
}

class GhostAnno : MKPointAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
    var image: UIImage?

//    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//    }
}

extension RunVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //guard annotation is MKPointAnnotation else { return nil }
        guard annotation is GhostAnno else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let ghostAnno = annotation as? GhostAnno

        if (ghostAnno?.image != nil) {
            //annotationView?.image = ghostAnno?.image
            
            let im = ghostAnno?.image
            
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContext(size)
            im?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            let imView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imView.image = resizedImage
            imView.layer.cornerRadius = imView.layer.frame.size.width/2
            imView.layer.borderWidth = 1.0
            imView.layer.borderColor = UIColor.white.cgColor
            imView.layer.masksToBounds = true
            annotationView?.addSubview(imView)
            
            
            
        }
        else {
            annotationView?.image = UIImage(systemName: "leaf.fill")
            //annotationView?.tintColor = UIColor.red
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
