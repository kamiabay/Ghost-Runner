//
//  FriendVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/2/21.
//

import Foundation
import UIKit
import Firebase

class FriendVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var friendCodeField: UITextField!
    
    var navigation: Navigator?
    let db = DB();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        friendCodeField.delegate = self
    }
    
    
    func getFriend(code: String) {
        db.friendDb.findFriendUsingCode(code: code) { (Friend) in
        
        }
        
        friendCodeField.text = ""
    }
    
//    func addFriend(friend: Friend)  {
//        db.friendDb.addFriend(friend: friend)
//    }

    @IBAction func addFriend() {
    }
    
    
    // MARK: - UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 5 {
//            getFriend(code: textField.text ?? "")
        }
        
        return true
    }
}
