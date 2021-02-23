//
//  currentRun.swift
//  Ghost Runner
//
//  Created by Dylan Long on 2/20/21.
//

import Foundation
import CoreLocation

struct RunData {
    var userID: String = ""
    var opponentID: String?
    var runID: String = ""
    var isInitialRun: Bool = false
    var distSegment: [Double]?
    var totalDistance: Double?
    var userTimePerSegment: [Double]?
    var userDistancePerTimeConst: [Double]?
    var opponentTimePerSegment: [Double]?
    var opponentDistancePerTimeConst: [Double]?
    var userRunSnapshotList: [RunSnapshot]? // Not sure if these need to be in the struct
    var opponentRunSnapshotList: [RunSnapshot]?
}

class CurrentRun {
    let timeConst = 1.0 // [sec]
    private var runData = RunData()
    private var previousTime = Date() // Need to ensure accurate start time by resetting at some point
    private var locationManager: CLLocationManager?

    // If it is initial run then opponentID and runID should be nil
    init(userID: String, opponentId: String?, runID: String?) {
        self.runData.userID = userID
        self.runData.opponentID = opponentId
        self.runData.runID = runID ?? ""
        
        if self.runData.runID == "" {
            self.runData.isInitialRun = true
            self.runData.runID = createRunID()
        }
        else {
            loadRun()
        }
    }
    
    func loadRun() {
        //use runID to get user/opponentTimePerSegment, user/opponentRunSnapshotList, distSegment, totalDistance
    }
    
    // Need to create new run ID's somehow
    func createRunID() -> String {
        return ""
    }
    
    // Setting elevation to 0 for now but may need to change
    // At this point it only adds to userRunSnapshotList and NOT to runData.userDistancePerTimeSegment, later
    // it is converted
    func addUserDist() {
        //let coordinates = getUserCoordinates()
        guard let locMan = locationManager else {
            print("Could not access locationManager in func addUserDist")
            return
        }
        
        let currentGPS = GPS(locationManager: locMan) // Need to learn how this works
        let runSnapShot = RunSnapshot(gps: currentGPS)
        self.runData.userRunSnapshotList?.append(runSnapShot)
    }
    
    func addUserTime() {
        let currentTime = Date()
        let timeInterval = currentTime.distance(to: previousTime)
        self.runData.userTimePerSegment?.append(timeInterval.magnitude)
    }
    
    func getTimeComparison(segmentNum: Int) -> (timeDifference: Double, isAhead: Bool) {
        
        guard let userTime = self.runData.userTimePerSegment?[segmentNum] else {
            print("Could not find user's time in func getTimeComparison")
            return (0.0, false)
        }
     
        guard let opponentTime = self.runData.opponentTimePerSegment?[segmentNum] else {
            print("Could not find opponent's time in func getTimeComparison")
            return (0.0, false)
        }
        
        let timeDiff = userTime - opponentTime
        if timeDiff >= 0 {
            return (timeDiff, false)
        }
        return (timeDiff, true)
    }
    
    /*private func getUserCoordinates() -> (latitude: Double, longitude: Double) {
        // Make calls to CLLocation for latitude and longitude values
        return (0, 0)
    }*/
    
    private func convertCoordToDist(coordinates: [Double : Double]) -> Double {
        // CLLocation provides 'distance' function that makes this super easy
        return 0.0
    }
    
    func finishRun() -> RunData {
        calculateSegment()
        calculateUserTimePerSegment()
        return runData
    }
    
    func addUserDistancePerTimeSegment() {
        
    }
    
    private func calculateSegment() {
        let distSum = self.runData.userDistancePerTimeConst?.reduce(0, +) ?? 0
        let ceilingOfSum = ceil(distSum)
        let inaccurateSegment = distSum/ceilingOfSum
        // Find closest values in userDistancePerTimeConstant
    }
    
    private func calculateUserTimePerSegment() {
        
    }
}
