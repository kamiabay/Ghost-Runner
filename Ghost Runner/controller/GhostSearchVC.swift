//
//  GhostSearchVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/10/21.
//

import Foundation
import UIKit


protocol ModalDelegate {
func GhostFriendGotSelected(ghost: GhostRun)
}

class GhostSearchVC: UIViewController, ModalDelegate {
    func GhostFriendGotSelected(ghost: GhostRun) {
        
    }
    


   
    @IBOutlet weak var friendTable: UITableView!
    var friendList = [Friend]()
    let db = DB();
    var delegate: ModalDelegate?
    var friendGhostRun: GhostRun?;
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
       
        self.isModalInPresentation = true
        // Delegates, data sources
        friendTable.dataSource = self
        friendTable.delegate = self
        
        // Table styling
        friendTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        friendTable.showsVerticalScrollIndicator = false
        friendTable.showsHorizontalScrollIndicator = false
        
        getAllFriends();

    }
    
    
    
    func getAllFriends()  {
        db.friendDb.getAllFriends(completion: { [weak self] (friendList) in
            DispatchQueue.main.async {
                self?.friendList = friendList
                self?.friendTable.reloadData()
                
            }
        })
    }

    @IBAction func doneBtn(_ sender: Any) {
        delegate?.GhostFriendGotSelected(ghost: friendGhostRun!)
        self.isModalInPresentation = false
        self.dismiss(animated: true) {
            //
        }
    }
}

extension GhostSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Table View: # rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    
    // content in each view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ghostCell", for: indexPath)
        // Get cell data
        let cell_data = friendList[indexPath.row]
        
        cell.textLabel?.text = "\(cell_data.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendList[indexPath.row]
        db.friendDb.getFreindLastRun(uid: friend.uid) { [weak self] (Run) in 
            print(Run.lastSnapshot().toJSON())
            
            self?.friendGhostRun = GhostRun(user: friend, run: Run );
        }
    }
    

    
}

