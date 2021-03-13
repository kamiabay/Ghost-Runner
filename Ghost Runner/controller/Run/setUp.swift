//
//  setUp.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/12/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

// INIT SETUP
extension RunVC {
    
    func setUpDelegate()  {
        // DELEGATES
        mapView.delegate = self;
        locationManager.delegate = self
    }
    
    func setUpTopPanel()  {
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
    }
    
    
    func setUpLayout()  {
    
        headingButton.layer.borderWidth = 2.0
        headingButton.layer.masksToBounds = false
        headingButton.layer.borderColor = UIColor.white.cgColor
        headingButton.layer.cornerRadius = headingButton.frame.size.width/2
        headingButton.clipsToBounds = true
        
        // Heading image tap support
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headingTap))
        headingButton.isUserInteractionEnabled = true
        headingButton.addGestureRecognizer(tapGestureRecognizer)
        
        
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
    }
    

}

extension RunVC { //HELPERS
    
    func initiateMapSetup() {
        self.mapView.showsUserLocation = true
        self.CLandMapKitSetup()
        self.setInitialZoom()
    }
    
    func CLandMapKitSetup() {
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
    
    func setInitialZoom() {
        if let currLoc = locationManager.location?.coordinate {
            let zoomRegion = MKCoordinateRegion(center: currLoc, latitudinalMeters: CLLocationDistance(exactly: 400) ?? 0, longitudinalMeters: CLLocationDistance(exactly: 400) ?? 0)
            mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: false)
        }
    }
    
}
