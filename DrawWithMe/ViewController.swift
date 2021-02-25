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
}

class ViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationItem!
    
    @IBOutlet weak var usersCollectionView : UICollectionView!
    
    var users = [User]()
    var usersImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let IDs = UserDefaults.standard.object(forKey: "usersIDs") as? [String] {
            print("IDs ", IDs)
            
            for id in IDs {
                Database.database().reference().child("Users").child(id).observeSingleEvent(of: .value) { (snapshot) in
                    if let value = snapshot.value  as? [String : AnyObject] {
                        if let name = value["name"] as? String, let imageURL = value["imageURL"] as? String {
                            let user = User(id: id, name: name, imageURL: imageURL)
                            self.users.append(user)
                            self.usersCollectionView.reloadData()
                        }
                    }
                    else {
                        print("no users")
                    }
                }
            }
            
        }
        
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        
    }


}



extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = usersCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserCollectionViewCell
        
        cell.imgView.layer.cornerRadius = usersCollectionView.frame.size.height * 0.7 / 2
        
        cell.nameLabel.text = users[indexPath.row].name
        
        if let stringURL = users[indexPath.row].imageURL {
            let url = URL(string: stringURL)
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.usersImages.append(image!)
                        DispatchQueue.main.async {
                            cell.imgView.image = image
                        }
                    }
                }
            }
            task.resume()
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimentions = usersCollectionView.frame.size.height
        return CGSize(width: dimentions, height: dimentions)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        addViewController.name = user.name!
        addViewController.id = user.id!
        addViewController.photo = usersImages[indexPath.row]
        
        performSegue(withIdentifier: "goToHomePage", sender: nil)
    }
    

}
