//
//  Navigation.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/18/21.
//

import Foundation
import UIKit

struct RouteNames {
    let login = "loginRoute"
    let home = "homeRoute"
    let run = "runRoute"
}

// takes care of navigation to other screens
class Navigator: UIViewController {
    let route = RouteNames();
    

    func goToLogin() { // NEEDS TESTING
        guard let loginVC = storyboard?.instantiateViewController(identifier: route.login) as? LoginVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func goToMain() {
        guard let homeVC = storyboard?.instantiateViewController(identifier: route.home) as? HomeVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func goToRun(opponentRun: Run) {
        guard let runVC = storyboard?.instantiateViewController(identifier: route.run) as? RunVC else {
            assertionFailure("couldnt find this controller")
            return
        }
        runVC.opponentRun = opponentRun;
        navigationController?.pushViewController(runVC, animated: true)
        
    }
    
}
