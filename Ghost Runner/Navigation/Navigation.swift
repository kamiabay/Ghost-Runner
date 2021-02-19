//
//  Navigation.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit



// takes care of navigation to other screens
class Navigator  {
   
    struct RouteNames {
        let login = "loginRoute"
        let home = "homeRoute"
        let run = "runRoute"
    }
    
    let route = RouteNames();
    var currentViewController: UIViewController?
    
    required init(currentViewController: UIViewController) {
        self.currentViewController = currentViewController;
    }
    
   
    func goToLogin() {
        guard let loginVC = currentViewController?.storyboard?.instantiateViewController(identifier: route.login) as? LoginVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        currentViewController?.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func goToMain() {
        guard let homeVC = currentViewController?.storyboard?.instantiateViewController(identifier: route.home) as? HomeVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        
        currentViewController?.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
    func goToRunView(opponentRun: Run) {
        guard let runVC = currentViewController?.storyboard?.instantiateViewController(identifier: route.run) as? RunVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        runVC.opponentRun = opponentRun;
        currentViewController?.navigationController?.pushViewController(runVC, animated: true)
    }
    
}


