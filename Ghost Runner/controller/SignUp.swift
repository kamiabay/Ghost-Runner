//
//  SignUp.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//


import Foundation
import UIKit

class SignUpVC: UIViewController {
    
    var navigation: Navigator?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation = Navigator(currentViewController: self)
        navigation?.currentViewController?.navigationController?.navigationBar.isHidden = true
        
        emailField.setIcon(#imageLiteral(resourceName: "email_icon"))
        
        continueButton.layer.cornerRadius = 20.0
        
        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)).cgColor, UIColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        
    }

    @IBAction func backToLogin() {
        navigation?.goToLogin()
    }
    
    @IBAction func continueSignUp() {
        // temporary
        navigation?.goToHome()
    }
    
}
