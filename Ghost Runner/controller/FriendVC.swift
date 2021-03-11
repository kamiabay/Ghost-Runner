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
    @IBOutlet weak var addFriendButton: UIButton!
    
    var navigation: Navigator?
    let db = DB();
    var friendList = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        
        // General view styling
        addFriendButton.layer.cornerRadius = 18
        
        // Delegates, data sources
        friendTable.dataSource = self
        friendTable.delegate = self
        
        // Table styling
        friendTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        friendTable.showsVerticalScrollIndicator = false
        friendTable.showsHorizontalScrollIndicator = false
        
        // Function calls
        getAllFriends()
        
        
        
    }
    
    

    func getAllFriends()  {
        db.friendDb.getAllFriends(completion: { [weak self] (friendList) in
            DispatchQueue.main.async {
                self?.friendList = friendList
                print("data received")
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

extension FriendVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Table View: # rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    // Set the spacing between sections
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    // Make the background color show through
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // content in each view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        // Get cell data
        
        let cell_data = friendList[indexPath.row]
        
        // Set friend's name
        
        let friendTitle = cell.contentView.viewWithTag(201) as? UILabel
        friendTitle?.text = cell_data.name
        
        // Set friend's pic
        
        let friendPic = cell.contentView.viewWithTag(202) as? UIImageView
        
        guard let url = URL(string: self.friendList[indexPath.row].photoURL) else { return  UITableViewCell()}
        let data = try? Data(contentsOf: url)
        if let imageData = data {
            friendPic?.image = UIImage(data: imageData)
            friendPic?.layer.cornerRadius = (friendPic?.layer.frame.size.width ?? 22.5)/2
            friendPic?.layer.borderWidth = 1.0
            friendPic?.layer.borderColor = UIColor.white.cgColor
            friendPic?.layer.masksToBounds = true
        } else {
            friendPic?.image = nil
        }
        
        // Style cell
        
        cell.backgroundColor = .systemBackground
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    // ###############################################################
    // NOTE: USERINTERACTION for the CELL is disabled via Storyboard
    // When implementing tap action for the friend cell, don't forget
    // ###############################################################
    
    
}
