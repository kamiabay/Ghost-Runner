//
//  FriendVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/2/21.
//

import Foundation
import UIKit
import Firebase

class FriendVC: UIViewController {
    
    var navigation: Navigator?
    let db = DB();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
      
    }
    
    
    func getFriend(code: String) {
        db.friendDb.findFriendUsingCode(code: code) { (Friend) in
        
        }
    }
    
    func addFriend(friend: Friend)  {
        db.friendDb.addFriend(friend: friend)
    }


    
}
