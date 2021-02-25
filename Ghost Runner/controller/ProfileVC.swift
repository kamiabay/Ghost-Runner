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
        // Do any additional setup after loading the view.
        
        navigation = Navigator(currentViewController: self)
        
        self.userID.layer.cornerRadius = 19
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 70
        //profileImage.clipsToBounds = true
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        let userInfo = localStorage.getUser()
        
        self.user = userInfo.name
        self.uid = userInfo.uid
        self.userName.text = "\(user)"
        //self.userID.setTitle("User ID: \(uid)", for: .normal)
    }

    @IBAction func tapProfileImage(_ sender: Any) {
        presentProfilePicActionSheet()
    }
    
    func presentProfilePicActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Take a new photo or choose from your library", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
      present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = .camera
        pc.allowsEditing = true
        present(pc, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = .photoLibrary
        pc.allowsEditing = true
        present(pc, animated: true, completion: nil)
    }
    // Can add UIImagePickerController.camera to allow user to take picture
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
            self.image = image
           // let userDb = UserDb()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
        mf.body = "Add your friend \(self.user) on GhostRunner using the following code: \(self.uid)"
        
        present(mf, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPress(_ sender: UIButton) {
        navigation?.goToHome()
    }
}

