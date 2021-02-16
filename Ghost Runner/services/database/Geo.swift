//
//  test.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import FirebaseFirestore

class GeoData {
    private var user: User?;
    private var path: Path?;
    
    init(user: User) {
        self.user = user;
        self.path = Path.init(user: user);
        
    }
    
    
    
}
