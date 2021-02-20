//
//  loginVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
   
    var navigation: Navigator?;
    
    var tester = Tester()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigation = Navigator(currentViewController: self)
         view.backgroundColor = .systemOrange
        // Do any additional setup after loading the view.
        
        //let jsonData = tester.readFile() ?? Data()
        //let testData = tester.testParse(jsonData: jsonData)
        
        
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        navigation?.goToHome()
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        navigation?.goToSignUp()
    }
    
    
    
}

