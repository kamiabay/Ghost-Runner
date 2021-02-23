//
//  ProfileVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {

    var navigation: Navigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
        // Do any additional setup after loading the view.
        
        navigation = Navigator(currentViewController: self)
        
    }

    @IBAction func homeButtonPress(_ sender: UIButton) {
        navigation?.goToHome()
    }
    

}

