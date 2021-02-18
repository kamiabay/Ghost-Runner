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
        guard let UserAccountViewController = storyboard?.instantiateViewController(identifier: route.login) as? ViewController else {
            assertionFailure("couldnt find this controller")
            return
        }
        navigationController?.pushViewController(UserAccountViewController, animated: true)
    }
    
    func goToMain() {
        
    }
    
    func goToRun() {
        
    }
    
}
