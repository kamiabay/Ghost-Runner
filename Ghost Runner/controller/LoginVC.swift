//
//  loginVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class LoginVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    var movies: [String] = ["apple-icon","fb-icon","google-icon"]
    var frame = CGRect.zero
    
    var navigation: Navigator?;
    
    var tester = Tester()

    let gradientLayer = CAGradientLayer()
    let rad: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigation = Navigator(currentViewController: self)
//        checkIfUserExist();
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
       
        navigation?.currentViewController?.navigationController?.navigationBar.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        emailField.setIcon(#imageLiteral(resourceName: "email_icon"))
        passwordField.setIcon(#imageLiteral(resourceName: "pw_icon"))
        
        pageControl.numberOfPages = movies.count
        setUpScrollView()
        
        loginButton.layer.cornerRadius = rad
        appleLoginButton.layer.cornerRadius = rad
        googleLoginButton.layer.cornerRadius = rad
        facebookLoginButton.layer.cornerRadius = rad

        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)).cgColor, UIColor(#colorLiteral(red: 0, green: 0.749853909, blue: 0.7112129927, alpha: 1)).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
      withError error: NSError!) {
//        GIDSignIn.sharedInstance().signIn()

        if (error == nil) {
          // Perform any operations on signed in user here.
          // ...
        } else {
          print("\(error.localizedDescription)")
        }
    }
    func checkIfUserExist() {
        print(LocalStorage().getUser().toJSON())
        print(LocalStorage().userExist())
        if (LocalStorage().userExist()) {
            self.navigation?.goToHome()
        }
    }
    
    // tocuh outside of the keypad will dismiss the keypad
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func signUp() {
        GIDSignIn.sharedInstance().signIn()

       // navigation?.goToSignUp()
    }
    
    @IBAction func loginWithEmail() {
        // TODO: SAVE USER IN LOCAL STORAGE
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            
            if error != nil {
                print(error as Any)
                return
            }
            
            if let user = authResult?.user {
                LocalStorage.init(name: "kami", uid: user.uid);
                self?.navigation?.goToHome()
            }
        
            
          
        }
    }
    
    @IBAction func loginWithApple() {
    }
    
    @IBAction func loginWithGoogle() {
    }
    
    @IBAction func loginWithFacebook() {
    }
    
    // MARK: - Set up scroll view
    func setUpScrollView() {
        for index in 0..<movies.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: movies[index])

            self.scrollView.addSubview(imgView)
        }

        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(movies.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    // MARK: - UIScrollViewDelegate method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
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
