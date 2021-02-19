//
//  Navigation.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit



// takes care of navigation to other screens
class Navigator: UIViewController {
   
    struct RouteNames {
        let login = "loginRoute"
        let home = "homeRoute"
        let run = "runRoute"
    }
    
    let route = RouteNames();

    func goToLogin() { // NEEDS TESTING
        guard let loginVC = storyboard?.instantiateViewController(identifier: route.login) as? LoginVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func goToMain() {
        
        // This resolves the storyboard reference
        // This line will successfully create the storyboard instance based on Main.storyboard
        // "Main" is found because it's set in Info.plist under "Main storyboard file base name"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // This is an attempt to initialize the navigation controller
        // When printing nav.viewControllers, the LoginVC is visible as the only view in the stack
        guard let nav = storyboard.instantiateViewController(withIdentifier: "navController") as? UINavigationController else {
            assertionFailure("could not find NavigationController")
            return
        }
        print(nav.viewControllers)
        
        guard let homeVC = storyboard.instantiateViewController(identifier: "homeRoute") as? HomeVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        
        // For some reason, calling nav.pushViewController(homeVC, animated: true) doesn't do anything
        nav.pushViewController(homeVC, animated: true)
        
        // When printing nav.ViewControllers, the view stack hasn't changed
        print(nav.viewControllers)
        
        
        //print(navigationController?.viewControllers)
        //navigationController?.pushViewController(homeVC, animated: true)
        //print(navigationController?.viewControllers)
    }
    
    func goToRunView(opponentRun: Run) {
        guard let runVC = storyboard?.instantiateViewController(identifier: route.run) as? RunVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        runVC.opponentRun = opponentRun;
        navigationController?.pushViewController(runVC, animated: true)
    }
    
}
