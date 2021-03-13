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

    let db = DB()
    let locationManager = CLLocationManager()
    var navigation: Navigator?
    
    // Timers
     var runTimer: Timer?
    
    // calculation
    var runCalculation : RunCalculation?  // initialized in viewDidLoad()
    let CONST_TIME: Double = 0.25//2.0;
    var lastDrawnPolyLine: MKOverlay?
    var runCalculationList: [RunCalculation?] = []
    var ghostList = [GhostRun]()
    
    //
    var runToggleState: Int = 0
    var giList: [UIImageView?] = []
    var maxGhosts: Int = 0
       
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
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        
        setUpDelegate()
        setUpTopPanel()
        setUpLayout()
        initiateMapSetup()

        runCalculation = RunCalculation(opponentList: ghostList)
    }
    
    
    func beginGhostAnimation() {
        runTimer = Timer.scheduledTimer(timeInterval: CONST_TIME, target: self, selector: #selector(updateOpponentLocation), userInfo: nil, repeats: true)
        //updateOpponentLocation
    }
    
    @objc func updateOpponentLocation()  {
        //if (isFirstRun()) {return} // i.e NO OPPONENT i.e FIRST RUN

       
    }
    
    @objc func intervalUpdate() {
        let gps = GPS(locationManager: locationManager);
        runCalculation?.updateOwnLocation(runSnapshot: RunSnapshot(gps: gps))
        updateOwnPolyLine()
        updateOpponentLocation()
    }


    @objc func headingTap() {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
    }
    

}















// MARK: - ALL IBAction
extension RunVC {
    
    @IBAction func addGhostSymbolPress(_ sender: UIButton) {
        print("IMPLEMENT LATER")
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
    
    
    @IBAction func backButton(_ sender: UIButton) {
        runTimer?.invalidate()
        runTimer = nil
        navigation?.goBack()
    }
}



