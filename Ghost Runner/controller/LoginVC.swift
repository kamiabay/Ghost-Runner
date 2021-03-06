//
//  loginVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginVC: UIViewController, UIScrollViewDelegate {
    
//    @IBOutlet weak var signUpButton: UIButton!
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imgListName: [String] = ["runner-1","biker","fb-icon"]
    var frame = CGRect.zero
    
    var navigation: Navigator?
    
    var tester = Tester()

    let gradientLayer = CAGradientLayer()
    let rad: CGFloat = 20.0
     
    var containerView = UIView()
    var slideUpView = UIView()
    var loginButton = UIButton()
    var appleButton = UIButton()
    var signupButton = UIButton()
    
//    @IBOutlet weak var slideUpView: UIView!
    
    let slideUpViewHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsButton.isHidden = true
       
        // order matters
        navigation = Navigator(currentViewController: self)
        checkIfUserExist()
        
        
        GIDSignIn.sharedInstance().delegate = self
        navigation?.currentViewController?.navigationController?.navigationBar.isHidden = true
       
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        pageControl.numberOfPages = imgListName.count
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
        loginButton.setTitle("Login with email/pw", for: .normal)
        loginButton.addTarget(self, action:#selector(self.loginDefault), for: .touchUpInside)
        loginButton.layer.cornerRadius = 20.0
        
        appleButton.frame = CGRect(x: 20, y: 85, width: screenSize.width-40, height: 45)
        appleButton.backgroundColor = .black
        appleButton.setTitle("Sign in with Apple", for: .normal)
        appleButton.addTarget(self, action:#selector(self.loginWithApple), for: .touchUpInside)
        appleButton.layer.cornerRadius = 20.0
        
        signupButton.frame = CGRect(x: 20, y: 150, width: screenSize.width-40, height: 45)
        signupButton.backgroundColor = .systemOrange
        signupButton.setTitle("Sign up with email/pw", for: .normal)
        signupButton.addTarget(self, action:#selector(self.signUp), for: .touchUpInside)
        signupButton.layer.cornerRadius = 20.0
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
        slideUpView.addSubview(signupButton)
        
        window?.addSubview(slideUpView)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0.8
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height - self.slideUpViewHeight, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
    }
    
    func hideOptionsMenu() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
                        self.containerView.alpha = 0
                        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
                       }, completion: nil)
    }
    
    @objc func slideUpViewTapped() {
        hideOptionsMenu()
    }
    
    
    func checkIfUserExist() {
        print("does user exist => : \(LocalStorage().userExist())")
        if (LocalStorage().userExist()) {
           self.navigation?.goToHome()
        }
    }
    
    @objc func signUp() {
        hideOptionsMenu()
        navigation?.goToSignUp()
    }

    
    @objc func loginDefault() {
        hideOptionsMenu()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let emailVC = storyboard.instantiateViewController(identifier: "emailLogin") as? EmailLoginViewController else {
            assertionFailure("couldnt find this controller")
            return
        }
        navigation?.currentViewController?.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    @objc func loginWithApple() {
    }
    
    
    @IBAction func loginWithGoogle() {
        hideOptionsMenu()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginWithFacebook() {
    }
    
    // MARK: - Set up scroll view
    func setUpScrollView() {
        for index in 0..<imgListName.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: imgListName[index])

            self.scrollView.addSubview(imgView)
        }

        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(imgListName.count)), height: scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
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

// MARK: - Google Login Extension
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
            
            let isNew = authResult?.additionalUserInfo?.isNewUser ?? false;

            // User is signed in
            let uid = user.uid;
            let photoURL = user.photoURL?.absoluteString ?? "";
            let name = user.displayName ?? "";
            let code = Functions().randomCode();
            
           

            if (!isNew) {
                LocalStorage.init(uid: uid, name: name, photoURL: photoURL, code: "");
                self.navigation?.goToHome()
                return;
            }
            LocalStorage.init(uid: uid, name: name, photoURL: photoURL, code: code);
            Authentication()
                .saveUserOnDB(uid: uid, photoURL: photoURL, name: name, code: code, completion: { [weak self] () in
                DispatchQueue.main.async {
                    print(LocalStorage().getUser().toJSON())
                    self?.navigation?.goToHome()
                    }
              }
            );
          
           
           
            
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
