//
//  UserSnapshot.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/13/21.
//

import Foundation
import MapKit

class UserSnapshot: MKPointAnnotation {
    let user: User
    let snapShot : RunSnapshot
    var image: UIImage
    
    init(user: User, runSnapshot: RunSnapshot) {
        self.user = user
        self.snapShot = runSnapshot
        self.image = user.getUIImage()
    }
    
}
