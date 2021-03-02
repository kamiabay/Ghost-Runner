//
//  EmailLoginViewController.swift
//  Ghost Runner
//
//  Created by Z W on 3/1/21.
//

import Foundation
import Firebase
import UIKit

class EmailLoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login() {
        let email = emailField.text ?? ""
        let pw = pwField.text ?? ""
        
        Auth.auth()
    }
    
}
