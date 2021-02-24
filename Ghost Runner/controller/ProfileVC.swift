//
//  ProfileVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

import Foundation
import UIKit
import MessageUI

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {

    var navigation: Navigator?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UIButton!
    
    let localStorage = LocalStorage()
    var user = ""
    var uid = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        navigation = Navigator(currentViewController: self)
        
        profileImage.layer.cornerRadius = 70
        profileImage.clipsToBounds = true
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        let userInfo = localStorage.getUser()
        
        self.user = userInfo.name
        self.uid = userInfo.uid
        self.userName.text = "Username: \(user)"
        self.userID.setTitle("User ID: \(uid)", for: .normal)
    }

    @IBAction func tapProfileImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            self.image = image
           // let userDb = UserDb()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userCodeButtonPress(_ sender: Any) {
        let mf = MFMessageComposeViewController()
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            // add error message label
            return
        }
        mf.messageComposeDelegate = self
        mf.recipients = [] // Might have a way to autopopulate this
        mf.body = "Add your friend \(self.user) on GhostRunner using the following code \(self.uid)"
        
        present(mf, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPress(_ sender: UIButton) {
        navigation?.goToHome()
    }
}

