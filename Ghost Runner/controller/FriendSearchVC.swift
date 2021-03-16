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
        addedFriend.text = ""
        NotificationCenter.default.addObserver( self,selector:#selector(self.keyboardDidShow), name: UITextField.textDidChangeNotification, object: searchBar)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    @objc func keyboardDidShow(notifcation: NSNotification) {
        if searchBar.text?.count == 5 {
            guard let code = searchBar.text else {
                return
            }
            getFriend(code: code)
        }
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
            self?.addedFriend.text = "Added: \(friend.name)! Try adding their ghosts during your next run!";
            }
        })
        searchBar.text = ""
    }
    

}
