//
//  addViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

class addViewController: UIViewController {
    @IBOutlet var imgView:UIImageView!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func backButton(_ sender: Any) {
        let vcAddUI = self.storyboard?.instantiateViewController(identifier: "switchUI")
        navigationController?.pushViewController(vcAddUI!, animated: true)
    }
    
    static var name = ""
    static var id = ""
    static var photo = UIImage()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.layer.cornerRadius = 40
        
        settingUpKeyboardNotifications()
        
        if let IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
        print("IDs : \n", IDs)
        } else {
            print("no n o")
        }

        errorLabel.alpha = 0
     
    }
    

    
    @IBAction func didTabButton() {
        let vc =  UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        
        
    }
    
    @IBAction func saveProfileButton(_ sender  : UIButton) {
        
        guard let name = nameTextField.text, name.isEmpty == false else {
            // show error message
            errorLabel.alpha = 1
            return
        }
        
        errorLabel.alpha = 0
        
        let ref = Database.database().reference()
        ref.child("Users").childByAutoId().setValue(["name" : nameTextField.text]) { (error, reference) in
            if error == nil {
                print("Successfully Added")
                if let userID = reference.key {
                    if let IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
                        var usersIDs = IDs
                        (usersIDs).append(userID)
                        UserDefaults.standard.setValue(usersIDs, forKey: "usersIDs")
      
                    }
                    else {
                        var IDs = [String]()
                        (IDs).append(userID)
                        UserDefaults.standard.setValue(IDs, forKey: "usersIDs")
                    }
                    
                    // store profile photo
                    
                    print("Storage Time")
                    
                    let storage = Storage.storage().reference()
                    let imageRef = storage.child("ProfileImage").child(userID)
                    
                    guard let imageData = self.imgView.image?.resize(size: 80).pngData() else {return}
                    
                    imageRef.putData(imageData, metadata: nil) { (meta, err) in
                        if err == nil {
                            imageRef.downloadURL { (url, error) in
                                ref.child("Users").child(userID).updateChildValues(["imageURL" : url?.absoluteString]) {  (error, ref) in
                                    if error == nil {
                                        addViewController.name = self.nameTextField.text!
                                        addViewController.id = userID
                                        addViewController.photo = self.imgView.image!
                                        self.performSegue(withIdentifier: "goToHomePage", sender: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    

 
}

extension addViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")]as? UIImage{
            imgView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension addViewController {
    
    func settingUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
