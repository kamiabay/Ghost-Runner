//
//  loginVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
//    @IButlet weak var emailField: UITextField!
//    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    var navigation: Navigator?
    
    var tester = Tester()

    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = Navigator(currentViewController: self)
        navigation?.currentViewController?.navigationController?.navigationBar.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
//        emailField.setIcon(#imageLiteral(resourceName: "email_icon"))
//        passwordField.setIcon(#imageLiteral(resourceName: "pw_icon"))
        
        loginButton.layer.cornerRadius = 20.0
        appleLoginButton.layer.cornerRadius = 20.0
        googleLoginButton.layer.cornerRadius = 20.0
        facebookLoginButton.layer.cornerRadius = 20.0

        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)).cgColor, UIColor(#colorLiteral(red: 0, green: 0.749853909, blue: 0.7112129927, alpha: 1)).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    
    @IBAction func loginWithEmail() {
        // TODO: SAVE USER IN LOCAL STORAGE
        navigation?.goToSignUp()
    }
    
    @IBAction func loginWithApple() {
    }
    
    @IBAction func loginWithGoogle() {
    }
    
    @IBAction func loginWithFacebook() {
    }
}

// MARK: - Text Field extension to add images
extension UITextField {
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}
