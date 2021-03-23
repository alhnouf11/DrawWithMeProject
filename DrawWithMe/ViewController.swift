//
//  ViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 20/06/1442 AH.
//

import UIKit
import Firebase
//alhnouf

struct User {
    let id : String?
    let name : String?
    let imageURL : String?
    let img : UIImage?
}

class ViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationItem!
    
    @IBOutlet weak var usersCollectionView : UICollectionView!
    
    static var users = [User]()
    static var usersImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        

        if ViewController.users.count == 0 {
            getUsers {
                
                for (index,i) in ViewController.users.enumerated() {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        guard let url = URL(string: i.imageURL!) else {return}

                        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if error == nil {
                                if let imageData = data {
                                    if let image = UIImage(data: imageData) {

                                        ViewController.users.remove(at: index)
                                        ViewController.users.insert(User(id: i.id, name: i.name, imageURL: i.imageURL, img: image), at: index)
                                            DispatchQueue.main.async {
                                                self.usersCollectionView.reloadData()
                                            }
                                    }
                                }
                            }
                        }
                        task.resume()
                    }
                    
                }
                
            }
        }
        
        
        
        
        
    }

    
    func getUsers(completion : @escaping ()->()) {
        if let IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
            print("IDs ", IDs)
            
            for id in IDs {
                Database.database().reference().child("Users").child(id).observeSingleEvent(of: .value) { (snapshot) in
                    if let value = snapshot.value  as? [String : AnyObject] {
                        if let name = value["name"] as? String, let imageURL = value["imageURL"] as? String {
                            let user = User(id: id, name: name, imageURL: imageURL, img: nil)
                            ViewController.users.append(user)

                            if ViewController.users.count == IDs.count {
                                print("USERS COUNT : ", ViewController.users.count)
                                completion()
                            }
                        }
                        
                        
                    }
                    else {
                        print("no users")
                    }
                }
                
            }
        }
    }

}



extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewController.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = usersCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserCollectionViewCell
        
        cell.imgView.layer.cornerRadius = usersCollectionView.frame.size.height * 0.7 / 2
        
        cell.nameLabel.text = ViewController.users[indexPath.row].name
        
        cell.imgView.image = ViewController.users[indexPath.row].img
        
//        if let stringURL = users[indexPath.row].imageURL {
//            let url = URL(string: stringURL)
            
//            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
//                if error == nil {
//                    if let imageData = data {
//                        if let image = UIImage(data: imageData) {
//                            self.usersImages.append(image)
//                            DispatchQueue.main.async {
//                                cell.imgView.image = image
//                            }
//                        }
//                    }
//                }
//            }
//            task.resume()
            
//        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimentions = usersCollectionView.frame.size.height
        return CGSize(width: dimentions, height: dimentions)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = ViewController.users[indexPath.row]
        addViewController.name = user.name!
        addViewController.id = user.id!
        addViewController.photo = UIImage()
        addViewController.photo = ViewController.users[indexPath.row].img!
        
        performSegue(withIdentifier: "goToHomePage", sender: nil)
    }
    

}



//extension ViewController {
//    func setDrawing(name : String, level : String) {
//
//        let autoID = String(Date().timeIntervalSince1970)
//
//
//        let storage = Storage.storage().reference()
//        let imageRef = storage.child("Drawing").child(autoID)
//
//        let OriginalImage = UIImage(named: "\(name)Original")
//        guard let imageData = OriginalImage!.pngData() else {return}
//
//        let img1 = UIImage(named: "\(name)1")?.pngData()
//        let img2 = UIImage(named: "\(name)2")?.pngData()
//        let partsArray = [img1, img2]
//
//        let descArray = ["\(name) Step #1", "\(name) Step #2"]
//
//        imageRef.putData(imageData, metadata: nil) { (meta, err) in
//            if err == nil {
//                imageRef.downloadURL { (url, error) in
//                    Database.database().reference().child("Drawing").childByAutoId().setValue(["Name" : "\(name)", "imageURL" : url?.absoluteString, "Level" : level]) { (error, reference) in
//                        if error == nil {
//                            print("Done")
//
//                            for (index, part) in partsArray.enumerated() {
//                                let storageRef = storage.child("DrawingPart").child(String(Date().timeIntervalSince1970))
//                                storageRef.putData(part!, metadata: nil) { (meta, err) in
//                                    storageRef.downloadURL { (url, error) in
//                                        Database.database().reference().child("DrawingPart").child(reference.key!).childByAutoId().setValue(["imgURL" : url?.absoluteString, "description" : descArray[index]]) { (err, refe) in
//                                            if error == nil {
//                                                print("Successfully Added")
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//
//
//
//                        }
//                        else {
//                            print(error?.localizedDescription)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func saveStickersToDatabase(level : String) {
//
//        for i in 1...10 {
//            guard let stickrtData = UIImage(named: "\(level)\(i)")?.pngData() else {return}
//            let autoID = String(Date().timeIntervalSince1970)
//
//
//            let storage = Storage.storage().reference()
//            let imageRef = storage.child("Stickers").child(autoID)
//
//            imageRef.putData(stickrtData, metadata: nil) { (meta, err) in
//                if err == nil {
//                    imageRef.downloadURL { (url, error) in
//                        let ref = Database.database().reference()
//                        ref.child("Stickers").child(level).childByAutoId().setValue(["stickerURL" : url?.absoluteString]) { (err, reference) in
//                            if err == nil {
//                                print("successfully \(i) sticker saved")
//                            }
//                        }
//                    }
//
//                }
//            }
//        }
//
//
//    }
//}
