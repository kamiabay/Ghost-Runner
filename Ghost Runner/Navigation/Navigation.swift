//
//  Navigation.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit

// Notes (Nikita):
// The new storyboard has to be initialized in order to be able to switch between the different storyboard files
// Original function:
//      guard let homeVC = currentViewController?.storyboard?.instantiateViewController...


// takes care of navigation to other screens
class Navigator  {
   
    struct RouteNames {
        let login = "loginRoute"
        let signUp = "signUpRoute"
        let home = "homeRoute"
        let run = "runRoute"
        let profile = "profileRoute"
    }
    
    let route = RouteNames();
    var currentViewController: UIViewController?
    
    required init(currentViewController: UIViewController) {
        self.currentViewController = currentViewController;
    }
    
    // Note: Main.storyboard refers to the login view; we may want to refactor
    func goToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(identifier: route.login) as? LoginVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        
        // Sets loginVC to be top of stack; prevents Back button from appearing
        currentViewController?.navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    func goToSignUp() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let signUpVC = storyboard.instantiateViewController(identifier: route.signUp) as? SignUpVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        currentViewController?.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func goToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let homeVC = storyboard.instantiateViewController(identifier: route.home) as? UITabBarController else {
            assertionFailure("couldnt find this controller")
            return
        }
        
        //currentViewController?.navigationController?.pushViewController(homeVC, animated: true)
        currentViewController?.navigationController?.setViewControllers([homeVC], animated: true)
        
    }
    
    // For testing purposes, I added an optional to the Run type of the parameter
    // When we implement the full run data pipeline, we can switch it back to Run only, no optional
    func goToRunView(opponentRun: Run?) {
        let storyboard = UIStoryboard(name: "Run", bundle: nil)
        guard let runVC = storyboard.instantiateViewController(identifier: route.run) as? RunVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        runVC.opponentRun = opponentRun;
        currentViewController?.navigationController?.pushViewController(runVC, animated: true)
    }
    
    func goToProfileView()  {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let profileVC = storyboard.instantiateViewController(identifier: route.profile) as? ProfileVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        currentViewController?.navigationController?.pushViewController(profileVC, animated: true)
    }
    
}


