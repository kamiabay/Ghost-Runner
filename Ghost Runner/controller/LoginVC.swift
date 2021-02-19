//
//  loginVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation

import UIKit
class LoginVC: UIViewController {
    
    let navigation = Navigator()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        navigation.goToMain()
    }
    
    
}

