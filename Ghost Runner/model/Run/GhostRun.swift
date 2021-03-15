//
//  GhostRun.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/10/21.
//

import Foundation
import MapKit

class GhostRun: MKPointAnnotation {
    var runData: RunData
    var run: Run
    var user: User
    var image: UIImage
    
    init(user: User, run: Run) {
        self.user = user
        self.run = run
        self.runData = RunData(runModel: run)
        self.image = user.getUIImage()
    }
    
}
