//
//  ViewController.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/11/21.
//

import UIKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
        // Do any additional setup after loading the view.
    }
    func go() {
        guard let UserAccountViewController = storyboard?.instantiateViewController(identifier: "userAccount") as? ViewController else {
            assertionFailure("couldnt find this controller")
            return
        }
        navigationController?.pushViewController(UserAccountViewController, animated: true)
    }


}

