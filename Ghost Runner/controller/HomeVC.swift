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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
    
        
        getUserData();
        getUserRunData();
    }

    
    
    func getUserData()  {
        
    }
    
    func getUserRunData()  {
        DispatchQueue.main.async {
  
            }
    }

}

