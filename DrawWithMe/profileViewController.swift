//
//  profileViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

class profileViewController: UIViewController {
    @IBOutlet var imgView:UIImageView!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpKeyboardNotifications()
        errorLabel.alpha = 0
        imgView.layer.cornerRadius = 80
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        
        imgView.image = addViewController.photo
        nameTextField.text = addViewController.name
    }
    
    @IBAction func didTabButton() {
        let vc =  UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
  
    }
    
    @IBAction func saveButtonAction(_ sender : UIButton) {
        updateUser()
    }
    
    @IBAction func deleteButtonAction(_ sender : UIButton) {
        
        let alertController = UIAlertController(title: "Delete Profile", message: "Are you sure to delete this profile ?", preferredStyle: .alert)
                
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed default")
            self.deleteUSer()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel")
        }

        alertController.addAction(delete)
        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteUSer() {
        let storage = Storage.storage().reference()
        let imageRef = storage.child("ProfileImage").child(addViewController.id)
        
        imageRef.delete { (error) in
            if error == nil {
                
                let ref = Database.database().reference().child("Users").child(addViewController.id)
                ref.removeValue { (error, reference) in
                    if error == nil {
                        if var IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
                            
                            for (index,userID) in IDs.enumerated() {
                                if userID == addViewController.id {
                                    IDs.remove(at: index)
                                    break
                                }
                            }
                           
                            UserDefaults.standard.setValue(IDs, forKey: "usersIDs")
                            print(IDs)
                            
                            self.performSegue(withIdentifier: "goToSwitch", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    func updateUser() {
        guard let name = nameTextField.text, name.isEmpty == false else {
            // show error message
            errorLabel.alpha = 1
            return
        }
        
        errorLabel.alpha = 0
        
        let ref = Database.database().reference()
        ref.child("Users").child(addViewController.id).setValue(["name" : nameTextField.text]) { (error, reference) in
            if error == nil {
                print("Successfully Added")
                
                
                // store profile photo
                
                print("Storage Time")
                
                let storage = Storage.storage().reference()
                let imageRef = storage.child("ProfileImage").child(addViewController.id)
                
                guard let imageData = self.imgView.image?.resize(size: 80).pngData() else {return}
                
                imageRef.putData(imageData, metadata: nil) { (meta, err) in
                    if err == nil {
                        imageRef.downloadURL { (url, error) in
                            ref.child("Users").child(addViewController.id).updateChildValues(["imageURL" : url?.absoluteString]) {  (error, ref) in
                                if error == nil {
                                    addViewController.name = self.nameTextField.text!
                                    addViewController.photo = self.imgView.image!
                                    self.performSegue(withIdentifier: "goToHomePage", sender: nil)
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



extension profileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

extension profileViewController {
    
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
