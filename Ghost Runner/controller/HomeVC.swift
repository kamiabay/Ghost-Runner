//
//  HomeVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit

class HomeVC: UIViewController, UITableViewDataSource {

    
    var runList = [Run](); // EMPTYLIST ?
    var db = DB(); // THE USER MUST BE SAVED ON THE LOCAL STORAGE BEFORE THIS
    var navigation: Navigator?;
    
    var totalRuns: Int? = 0
    //var runsList: [Run]? = []
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var runViewButton: UIButton!
    @IBOutlet weak var runsTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
        navigation = Navigator(currentViewController: self)
        getUserData();
       // getUserRunData();
        
        runsTable.dataSource = self
        
    }

    
    // FUNCTIONS
    func getUserData()  {
        
    }
    
    func getUserRunData()  {
        DispatchQueue.main.async {
           // self.runList = self.db.runDb.getUserRunList();
            // RELOAD THE VIEW AFTER
            }
    }
    
    func goToRunView(opponentRun: Run) {
        navigation?.goToRunView(opponentRun: opponentRun)
    }
    
    // UI Table protocols for displaying runs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalRuns ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runCell") ?? UITableViewCell(style: .default, reuseIdentifier: "runCell")
        
        let run_data = runList[indexPath.row]
        
        cell.textLabel?.text = ""
        
        return cell
        
    }

    @IBAction func runViewButtonPress(_ sender: UIButton) {
        navigation?.goToRunView(opponentRun: nil)
    }
    @IBAction func logoutButtonPress(_ sender: UIButton) {
        navigation?.goToLogin()
    }
}

