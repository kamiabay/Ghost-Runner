//
//  HomeVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import MaterialComponents.MaterialButtons



class HomeVC: UIViewController {

    
    var runList = [Run](); // EMPTYLIST ?
    let db = DB(); // THE USER MUST BE SAVED ON THE LOCAL STORAGE BEFORE THIS
    var navigation: Navigator?
    var totalRuns: Int? = 0
    let locationManager = CLLocationManager()
    var selectedRun: Run?

//    let cancelButton: MDCButton = {
//      let cancelButton = MDCButton()
//      cancelButton.translatesAutoresizingMaskIntoConstraints = false
//      cancelButton.setTitle("CANCEL", for: .normal)
//      //cancelButton.addTarget(self, action: #selector(didTapCancel(sender:)), for: .touchUpInside)
//      return cancelButton
//    }()
    
    
//    let fab = MDCFloatingButton()
//    let cancelButton: MDCButton = {
//      let cancelButton = MDCButton()
//      cancelButton.translatesAutoresizingMaskIntoConstraints = false
//      cancelButton.setTitle("CANCEL", for: .normal)
//      //cancelButton.addTarget(self, action: #selector(didTapCancel(sender:)), for: .touchUpInside)
//      return cancelButton
//    }()
    
    @IBOutlet weak var runViewButton: UIButton!
    @IBOutlet weak var runsTable: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectRunButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // General View Styling
        view.backgroundColor =  .systemBackground

        
        // Init navigation
        navigation = Navigator(currentViewController: self)
        // Get data from DB
        getUserData();
        getUserRunData();
        
        // CoreLocation authorization and set-up
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        
        // Table view
        runsTable.delegate = self
        runsTable.dataSource = self
        
        // Table styling
        runsTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        runsTable.showsVerticalScrollIndicator = false
        runsTable.showsHorizontalScrollIndicator = false
        
        // Map preview set-up; note other settings are set in IB
        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
        mapView.layer.cornerRadius = 10
        
        // Button Styling
        selectRunButton.layer.cornerRadius = 10
        runViewButton.layer.cornerRadius = 10
        
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        // Profile image tap support
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        // Prevent user interaction with SelectRun button initially
        selectRunButton.isUserInteractionEnabled = false
        
        // Request always authorization
        alwaysAuthorization()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUserRunData()
    }

    func alwaysAuthorization(){
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }

    // Database functions
    func getUserData()  {
        print(LocalStorage().getUser().toJSON())
        let localStorage = LocalStorage()
        let username = localStorage.getUser().name
        let greetingStr = "Hey, \(username) 👻"
        let ghostImage = localStorage.getUser().photoURL
        
        guard let url = URL(string: ghostImage) else {return}
        let data = try? Data(contentsOf: url)
        if let imageData = data {
            profileImage.image = UIImage(data: imageData)
        }
        greetingLabel.text = greetingStr
    }
    
    func getUserRunData()  {
        self.db.runDb.getUserRunList(completion: { [weak self] (runList) in
            DispatchQueue.main.async {
                self?.runList = runList
                print(" recived value is : \(self?.runList.count)")
                self?.runsTable.reloadData()  // prevent a crash by .reloadSections
                if runList.count > 0 {
                    self?.runsTable.reloadSections(IndexSet(integersIn: 0...runList.count-1), with: .top)
                }
            }
       })
    }
    
    // Buttons
    @IBAction func runViewButtonPress(_ sender: UIButton) {
        navigation?.goToRunView(opponentRun: nil)
    }
    @IBAction func selectRunButtonPress(_ sender: UIButton) {
        navigation?.goToRunView(opponentRun: selectedRun);
    }
    @objc func profileTap() {
        navigation?.goToProfileView()
    }
    
}





// MARK: - LOCATION MANAGER
extension HomeVC: CLLocationManagerDelegate {
  // handle delegate methods of location manager here
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            alwaysAuthorization()
            print("user allow app to get location data only when app is active")
        case .denied:
            alwaysAuthorization()
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            alwaysAuthorization()
            print("parental control setting disallow location data")
        case .notDetermined:
            alwaysAuthorization()
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        @unknown default:
            fatalError("[HomeVC]: CLLocationManager fatal error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}


// MARK: - Table View Functions
extension HomeVC: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.runList.count
    }
    
    // Table View: # rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.runList.count
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Table View: cell contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath)
        
        let cell_data = runList[indexPath.row]
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss"
        
        let runTitle = cell.contentView.viewWithTag(101) as? UILabel
        runTitle?.text = "\(indexPath.section)"
        
        let runDetails = cell.contentView.viewWithTag(102) as? UILabel
        runDetails?.text = "D: \(cell_data.totalDuration())"
        
        cell.backgroundColor = .systemBackground
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        
        
        return cell
        
    }
    
    // Table View: section selection; note that SECTION replaces ROW now
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let run_data = runList[indexPath.section]
        print("[HomeVC]: Updating MapView")
        
        // Update Select Run button
        if selectedRun == nil {
            print("Updating button!")
            selectRunButton.isUserInteractionEnabled = true
            selectRunButton.setTitle("Select Run", for: .normal)
            selectRunButton.backgroundColor = .systemGreen
            selectRunButton.setTitleColor(.white, for: .normal)
        }
        
        selectedRun = run_data
        
        let currOverlays = mapView.overlays
        mapView.removeOverlays(currOverlays)
        let polyline = run_data.getFullMKPolyline()
        mapView.addOverlay(polyline)
        
        // Zoom in on location
        if let first = mapView.overlays.first {
            let rect = mapView.overlays.reduce(first.boundingMapRect, {$0.union($1.boundingMapRect)})
            mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
        }
        
        // This action is moved to Select Run Button Press
        //navigation?.goToRunView(opponentRun: run_data);
    }
    
}

// MARK: - Map View Delegate
extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        // Give pin a custom image
        annotationView?.image = UIImage(systemName: "circle.dashed.inset.fill")
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .systemBlue
        polylineRenderer.lineWidth = 2.5
        return polylineRenderer
    }
    
}
