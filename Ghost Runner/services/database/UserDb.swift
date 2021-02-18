//
//  user.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation


class UserDb {
    private var user: User;
    private var path: Path;
    
    init(user: User) {
        self.user = user;
        self.path = Path.init(user: user);
    }
    
    func updateProfilePic(photoURL: String) {
        let ref = path.userPrivate();
        
        ref.setData([
            "photoURL": photoURL,
        ], merge: true);
        
    }
    
    func updateInfo(name: String) {
        let ref = path.userPrivate();
        
        ref.setData([
            "name": name,
        ], merge: true);
        
    }
    
    
}
