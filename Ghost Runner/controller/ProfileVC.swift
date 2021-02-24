//
//  ProfileVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

import Foundation
import UIKit

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var navigation: Navigator?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UIButton!
    
    let localStorage = LocalStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemOrange
        // Do any additional setup after loading the view.
        
        navigation = Navigator(currentViewController: self)
        
        profileImage.layer.cornerRadius = 70
        profileImage.clipsToBounds = true
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        let userInfo = localStorage.getUser()
        
        self.userName.text = "Username: \(userInfo.name)"
        self.userID.setTitle("User ID: \(userInfo.uid)", for: .normal)
    }

    @IBAction func tapProfileImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            
           // let userDb = UserDb()
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPress(_ sender: UIButton) {
        navigation?.goToHome()
    }
}

