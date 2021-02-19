//
//  HomeVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    var runList = [Run](); // EMPTYLIST ?
    var db = DB(); // THE USER MUST BE SAVED ON THE LOCAL STORAGE BEFORE THIS
    var navigation: Navigator?;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .red
        navigation = Navigator(currentViewController: self)
        getUserData();
       // getUserRunData();
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

}

