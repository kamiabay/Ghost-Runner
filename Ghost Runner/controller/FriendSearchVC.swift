//
//  FriendSearchVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/4/21.
//

import Foundation
import UIKit
import Firebase

class FriendSearchVC: UIViewController {

    @IBOutlet weak var addedFriend: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    let db = DB();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .blue
        searchBar.delegate = self
    }
    
    
    func addFriend(friend: Friend)  {
        db.friendDb.addFriend(friend: friend)
    }
    
    func getFriend(code: String) {
        print("calling with \(code)")
        
        db.friendDb.findFriendUsingCode(code: code, completion: { [weak self] (friend) in
        DispatchQueue.main.async {
            print(friend.toJSON())
            
            self?.addFriend(friend: friend);
            self?.addedFriend.text = "added: \(friend.name) to your friends list";
            }
        });
        
    }
    

}



// MARK: - UITextField Delegate
extension FriendSearchVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 5 {
            let code = (textField.text ?? "") as String
            getFriend(code: code)
        }
        
        return true
    }
}

