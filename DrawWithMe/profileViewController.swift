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
    @IBOutlet weak var topConstraint : NSLayoutConstraint!
    
    let userID = addViewController.id
    let ref = Database.database().reference()
    
    var storageURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.textColor = .black
        nameTextField.placeholderColor(text: "Name")
        
        nameTextField.delegate =  self
        
        settingUpKeyboardNotifications()
        errorLabel.alpha = 0
        imgView.layer.cornerRadius = 80
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        
        imgView.image = addViewController.photo
        nameTextField.text = addViewController.name
        
        getAllUserURLs()
        
        
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
            self.deleteUser()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel")
        }

        alertController.addAction(delete)
        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // to get all user images urls in storage
    func getAllUserURLs() {
        
        ref.child("Users").child(userID).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                if let prifileImage = value["imageURL"] as? String {
                    self.storageURLs.append(prifileImage)
                }
            } else {
                print("\n \n  SORRY \n \n ")
            }
        }
        
        ref.child("UserStickers").child(userID).observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                if let stickerURL = value["imageURL"] as? String {
                    print(stickerURL)
                    self.storageURLs.append(stickerURL)
                }
            } else {
                print("\n \n  SORRY \n \n ")
            }
        }
        
        ref.child("Trace").child(userID).observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                if let traceURL = value["imageURL"] as? String {
                    print(traceURL)
                    self.storageURLs.append(traceURL)
                }
            } else {
                print("\n \n  SORRY \n \n ")
            }
        }
    }
    
    lazy var loadingView : UIView = {
        $0.frame = self.view.bounds
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        return $0
    }(UIView())
    
    lazy var activityIndicator : UIActivityIndicatorView = {
       $0.hidesWhenStopped = true
       $0.style = .large
       $0.center = self.loadingView.center
       $0.startAnimating()
       return $0
   }(UIActivityIndicatorView())
    
    func deleteUser() {
        
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        view.endEditing(true)
        
        let ref = Database.database().reference()
        ref.child("Users").child(userID).removeValue { (error, reference) in
            if error == nil {
                if var IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
                    
                    for (index,userID) in IDs.enumerated() {
                        if userID == addViewController.id {
                            IDs.remove(at: index)
                            break
                        }
                    }
                    UserDefaults.standard.setValue(IDs, forKey: "usersIDs")
                    
                    for (index,i) in ViewController.users.enumerated() {
                        if i.id == addViewController.id {
                            ViewController.users.remove(at: index)
                        }
                    }
                    
                    ref.child("Trace").child(self.userID).removeValue()
                    ref.child("UserStickers").child(self.userID).removeValue()
                    
                    
                    for i in self.storageURLs {
                        let drawingRef = Storage.storage().reference(forURL:i)

                        drawingRef.delete { (error) in
                            if error == nil {
                                print("\n \n error : successfully deleted \n \n ")
                            } else {
                                print("\n \n error : ", error, "\n \n ")
                            }
                        }
                    }
                    
                    self.loadingView.removeFromSuperview()
                    print("User Deleted Successfully")
                    self.performSegue(withIdentifier: "goToSwitch", sender: nil)
                }
                
                
                
            }
        }
    }
    
    func updateUser() {
        view.endEditing(true)
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        
        guard let name = nameTextField.text, name.isEmpty == false else {
            // show error message
            errorLabel.alpha = 1
            self.loadingView.removeFromSuperview()
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
                                    self.loadingView.removeFromSuperview()
                                    addViewController.name = self.nameTextField.text!
                                    addViewController.photo = self.imgView.image!
                                    
                                    for (index, i) in ViewController.users.enumerated() {
                                        if i.id == addViewController.id {
                                            let updatedUser = User(id: i.id, name: self.nameTextField.text!, imageURL: i.imageURL, img: self.imgView.image!)
                                            ViewController.users.remove(at: index)
                                            ViewController.users.insert(updatedUser, at: index)
                                        }
                                    }
                                    
                                    
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
        topConstraint.constant = -150
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        topConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

