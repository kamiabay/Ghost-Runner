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
import FirebaseAuth

class LoginVC: UIViewController, UIScrollViewDelegate {
    
//    @IBOutlet weak var signUpButton: UIButton!
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var movies: [String] = ["google-icon","apple-icon","fb-icon"]
    var frame = CGRect.zero
    
    var navigation: Navigator?
    
    var tester = Tester()

    let gradientLayer = CAGradientLayer()
    let rad: CGFloat = 20.0
     
    var containerView = UIView()
    var slideUpView = UIView()
    var loginButton = UIButton()
    var appleButton = UIButton()
//    @IBOutlet weak var slideUpView: UIView!
    
    let slideUpViewHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self

        navigation = Navigator(currentViewController: self)
        
        navigation?.currentViewController?.navigationController?.navigationBar.isHidden = true
        checkIfUserExist();
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        pageControl.numberOfPages = movies.count
        setUpScrollView()
        
        googleLoginButton.layer.cornerRadius = rad

        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)).cgColor, UIColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    

    

    
    func initializeBUttons() {
        let screenSize = UIScreen.main.bounds.size
//        let buttonHeight: CGFloat = 45
//        let widthOffset: CGFloat = 40
//        let leadingX: CGFloat = 20
//        let topY: CGFloat = 20
//        let inbetween: CGFloat = 20
        
        loginButton.frame = CGRect(x: 20, y: 20, width: screenSize.width-40, height: 45)
        loginButton.backgroundColor = .systemGreen
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.addTarget(self, action:#selector(self.loginDefault), for: .touchUpInside)
        loginButton.layer.cornerRadius = 20.0
        
        appleButton.frame = CGRect(x: 20, y: 85, width: screenSize.width-40, height: 45)
        appleButton.backgroundColor = .black
        appleButton.setTitle("Sign in with Apple", for: .normal)
        appleButton.addTarget(self, action:#selector(self.loginWithApple), for: .touchUpInside)
        appleButton.layer.cornerRadius = 20.0
    }
    
    @IBAction func bringUpOptions() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.frame = self.view.frame
        
        window?.addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(slideUpViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.alpha = 0
        
        let screenSize = UIScreen.main.bounds.size
        slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: slideUpViewHeight)
        slideUpView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        initializeBUttons()
        slideUpView.addSubview(appleButton)
        slideUpView.addSubview(loginButton)
        
        window?.addSubview(slideUpView)
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0.8
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height - self.slideUpViewHeight, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
    }
    
    
    @objc func slideUpViewTapped() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    
    func checkIfUserExist() {
  
        if (LocalStorage().userExist()) {
            self.navigation?.goToHome()
        }
    }
    
    @objc func signUp() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
        navigation?.goToSignUp()
    }

    
    @objc func loginDefault() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
        navigation?.goToHome()
    }
    
    @objc func loginWithApple() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
        navigation?.goToSignUp()
    }
    
    
    @IBAction func loginWithGoogle() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
        GIDSignIn.sharedInstance().signIn()
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
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    
    // MARK: - UIScrollViewDelegate method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
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


extension LoginVC : GIDSignInDelegate{
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
       
      if let error = error {
        print(error)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        

        Auth.auth().signIn(with: credential) { (authResult, error) in
            
          if let error = error {
            print(error)
            return
          }
            guard let user = authResult?.user else {
                return;
            }
            // User is signed in
            let uid = user.uid;
            let photoURL = user.photoURL?.absoluteString ?? "";
            let name = user.displayName ?? "";
            
            Authentication().saveUserOnDB(uid: uid, photoURL: photoURL, name:name, completion: { () in
                DispatchQueue.main.async {
                   
                    LocalStorage.init(uid: uid, name: name, photoURL: photoURL);

                    }
                self.navigation?.goToHome()
              }
            );
           
           
            
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
