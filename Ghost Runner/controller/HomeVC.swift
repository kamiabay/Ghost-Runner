//
//  HomeVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit
import CoreLocation

class HomeVC: UIViewController {

    
    var runList = [Run](); // EMPTYLIST ?
    let db = DB(); // THE USER MUST BE SAVED ON THE LOCAL STORAGE BEFORE THIS
    var navigation: Navigator?;
    var totalRuns: Int? = 0
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var runViewButton: UIButton!
    @IBOutlet weak var runsTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
        navigation = Navigator(currentViewController: self)
        
        // data request
        getUserData();
        getUserRunData();
        
        // LOCATION authorization
       
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        // delegates
        locationManager.delegate = self
        runsTable.dataSource = self
        
        alwaysAuthorization()
    }

    func alwaysAuthorization(){
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }

    
    // FUNCTIONS
    func getUserData()  {
        
    }
    
    func getUserRunData()  {
        self.db.runDb.getUserRunList(completion: { (runList) in
            DispatchQueue.main.async {
                self.runList = runList
                print(" recived value is : \(self.runList.count)")
                self.runsTable.reloadData()
                }
       });
   
    }
    
    // BUTTONS
    @IBAction func runViewButtonPress(_ sender: UIButton) {
        navigation?.goToRunView(opponentRun: nil)
    }
    @IBAction func logoutButtonPress(_ sender: UIButton) {
        navigation?.goToLogin()
    }
    
    
    
    

}





// LOCATION MANAGER
extension HomeVC: CLLocationManagerDelegate {
  // handle delegate methods of location manager here
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}



// TABLE VIEW
extension HomeVC: UITableViewDataSource {
    
    // UI Table protocols for displaying runs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.runList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runCell") ?? UITableViewCell(style: .default, reuseIdentifier: "runCell")
        
        let run_data = runList[indexPath.row]
        
        cell.textLabel?.text = "\(run_data.getNextRunLocation().toJSON()) "
        
        return cell
        
    }

}
