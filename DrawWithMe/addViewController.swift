//
//  addViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

class addViewController: UIViewController{
    @IBOutlet var imgView:UIImageView!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var topConstraint : NSLayoutConstraint!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    // self.dismiss(animated: true, completion: nil) --> Modally
    
    @IBAction func backButtonAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true) // ---> navigation
        
    }
    
    static var name = ""
    static var id = ""
    static var photo = UIImage()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.textColor = .black
        nameTextField.placeholderColor(text: "Name")
        
        nameTextField.delegate = self
        
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
    
    @IBAction func saveProfileButton(_ sender  : UIButton) {
        
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        view.endEditing(true)
        
        
        guard let name = nameTextField.text, name.isEmpty == false else {
            // show error message
            errorLabel.alpha = 1
            loadingView.removeFromSuperview()
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
                                        ViewController.users.append(User(id: userID, name: self.nameTextField.text!, imageURL: url?.absoluteString, img: self.imgView.image!))
                                        self.loadingView.removeFromSuperview()
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
            topConstraint.constant = -180
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
