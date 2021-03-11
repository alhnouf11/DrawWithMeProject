//
//  scoreViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import Firebase

class scoreViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel : UILabel!
    
    @IBOutlet weak var star1 : UIImageView!
    @IBOutlet weak var star2 : UIImageView!
    @IBOutlet weak var star3 : UIImageView!
    @IBOutlet weak var star4 : UIImageView!
    @IBOutlet weak var star5 : UIImageView!
    
    @IBOutlet weak var stickersStackView : UIStackView!

    var stickers = [UIImage]()
    
    var userStickers = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TracingVC.scoreResul = "Excellent"
        
        print("scoreViewController : ",TracingVC.scoreResul)

        scoreLabel.text = TracingVC.scoreResul

        // depend on level
        
        for i in 1...5 {
            if let image = UIImage(named: "\(TracingVC.tracingLevel)\(i)") {
                stickers.append(image)
            }
        }
        
        starsSetUp()
     
        
        // save user drawing in database
        saveUserDrawingImage()
        saveUserStickers()
        
    }
    
    func saveUserStickers() {
        for i in userStickers {
           
            let storage = Storage.storage().reference()
            let imageRef = storage.child("UserStickers").child(String(Date().timeIntervalSince1970))
            
            guard let imageData = i.pngData() else {return}
            
            imageRef.putData(imageData, metadata: nil) { (meta, err) in
                if err == nil {
                    imageRef.downloadURL { (url, error) in
                        Database.database().reference().child("MyStickers").child(addViewController.id).childByAutoId().setValue(["imageURL" : url?.absoluteString]) { (error, reference) in
                            if error == nil {
                                print("Done ya girl")
                            }
                            else {
                                print(error?.localizedDescription)
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func saveUserDrawingImage() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.string(from: Date())
        
        let storage = Storage.storage().reference()
        let imageRef = storage.child("DrawingImage").child(String(Date().timeIntervalSince1970))
        
        guard let imageData = TracingVC.capturedImage.resize(size: 80).pngData() else {return}
        
        imageRef.putData(imageData, metadata: nil) { (meta, err) in
            if err == nil {
                imageRef.downloadURL { (url, error) in
                    Database.database().reference().child("MyDrawings").child(addViewController.id).childByAutoId().setValue(["imageURL" : url?.absoluteString, "date" : dateString, "score" : TracingVC.scoreResul]) { (error, reference) in
                        if error == nil {
                            print("Done ya girl")
                        }
                    }
                }
            }
        }
    }
    
    
    func starsSetUp() {
        switch TracingVC.scoreResul {
        case "Excellent":
            star1.image = UIImage(systemName: "star.fill")
            star1.tintColor = .orange
            
            star2.image = UIImage(systemName: "star.fill")
            star2.tintColor = .orange
            
            star3.image = UIImage(systemName: "star.fill")
            star3.tintColor = .orange
            
            star4.image = UIImage(systemName: "star.fill")
            star4.tintColor = .orange
            
            star5.image = UIImage(systemName: "star.fill")
            star5.tintColor = .orange
            
            getRandomStickers(limit: 2)
        
        case "Very Good":
            // 4 stars
            star1.image = UIImage(systemName: "star.fill")
            star1.tintColor = .orange
            
            star2.image = UIImage(systemName: "star.fill")
            star2.tintColor = .orange
            
            star3.image = UIImage(systemName: "star.fill")
            star3.tintColor = .orange
            
            star4.image = UIImage(systemName: "star.fill")
            star4.tintColor = .orange
            
            getRandomStickers(limit: 1)
        
        case "Good":
            // 3 stars
            star1.image = UIImage(systemName: "star.fill")
            star1.tintColor = .orange
            
            star2.image = UIImage(systemName: "star.fill")
            star2.tintColor = .orange
            
            star3.image = UIImage(systemName: "star.fill")
            star3.tintColor = .orange

            getRandomStickers(limit: 0)
        
        case "Poor":
            // 2 stars
            star1.image = UIImage(systemName: "star.fill")
            star1.tintColor = .orange
            
            star2.image = UIImage(systemName: "star.fill")
            star2.tintColor = .orange
        
        default:
            star1.image = UIImage(systemName: "star.fill")
            star1.tintColor = .orange

        }
    }

    
    
    func getRandomStickers(limit : Int) {
        for _ in 0...limit {
            let randomSticker = Int(arc4random_uniform(UInt32(stickers.count)))
            let stickerImageView = UIImageView()
            stickerImageView.image = stickers[randomSticker]
            stickerImageView.contentMode = .scaleAspectFit

            stickersStackView.addArrangedSubview(stickerImageView)
            userStickers.append(stickers[randomSticker])
            
            NSLayoutConstraint.activate([
                stickerImageView.widthAnchor.constraint(equalTo: stickerImageView.heightAnchor)
            ])

            stickers.remove(at: randomSticker)
        }
    }
    

}
