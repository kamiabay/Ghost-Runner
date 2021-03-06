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
    

    @IBOutlet weak var friendTable: UITableView!
    
    var navigation: Navigator?
    let db = DB();
    var friendList = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        friendTable.dataSource = self
        friendTable.backgroundColor = .lightGray
        getAllFriends()
    }
    
    

    func getAllFriends()  {
        db.friendDb.getAllFriends(completion: { [weak self] (friendList) in
            DispatchQueue.main.async {
                self?.friendList = friendList
//                print("\(friendList[0].code)")
                print("data recived")
                self?.friendTable.reloadData()
            }
           
        })
    }



    
    
    @IBAction func openAddFriendSheet() {
        guard let friendSheet = storyboard?.instantiateViewController(identifier: "friendSearchSheet") as? FriendSearchVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        present(friendSheet, animated: true);
    }
    
//
    
    

}

extension FriendVC: UITableViewDataSource {
    
    
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    // Make the background color show through
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    
    // content in each view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let content  = "  \(self.friendList[indexPath.row].name) "
        
        cell.textLabel?.text = content
       
        return cell
    }
    
    
}
