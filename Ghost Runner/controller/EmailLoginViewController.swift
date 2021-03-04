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
    
    var navigation: Navigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation = Navigator(currentViewController: self)
        
        navigation?.currentViewController?.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        navigation?.goToLogin()
    }
    
    @IBAction func login() {
        let email = emailField.text ?? ""
        let pw = pwField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: pw) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error != nil {
                print(error as Any)
                return
            }
            
            if let user = authResult?.user {
                let code = Functions().randomCode();
                LocalStorage.init(uid: user.uid, name: user.displayName ?? "", photoURL: "", code: code);
                self?.navigation?.goToHome()
            }
        }
    }
    
}
