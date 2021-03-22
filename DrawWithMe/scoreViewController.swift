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
    
    @IBOutlet weak var closeButton : UIButton!
    @IBOutlet weak var colorItButton : UIButton!

    var stickers = [UIImage]()
    
    var userStickers = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        TracingVC.scoreResul = Score.Excellent.rawValue
        
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
           
            let autoID = String(Date().timeIntervalSince1970)
            
            let storage = Storage.storage().reference()
            let imageRef = storage.child("UserStickers").child(addViewController.id).child(autoID)
            
            guard let imageData = i.pngData() else {return}
            
            imageRef.putData(imageData, metadata: nil) { (meta, err) in
                if err == nil {
                    imageRef.downloadURL { (url, error) in
                        Database.database().reference().child("UserStickers").child(addViewController.id).childByAutoId().setValue(["imageURL" : url?.absoluteString]) { (error, reference) in
                            if error == nil {
                                print("Done saveUserStickers")
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
    
    static var tracingImageID = ""
    
    func saveUserDrawingImage() {
        
        closeButton.isEnabled = false
        colorItButton.isEnabled = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.string(from: Date())
        
        let autoID = String(Int(Date().timeIntervalSince1970))
        
        let storage = Storage.storage().reference()
        let imageRef = storage.child("Trace").child(addViewController.id).child(autoID)
        
        guard let imageData = TracingVC.capturedImage.pngData() else {return}
        
        imageRef.putData(imageData, metadata: nil) { (meta, err) in
            if err == nil {
                imageRef.downloadURL { (url, error) in
                    Database.database().reference().child("Trace").child(addViewController.id).child(autoID).setValue(["imageURL" : url?.absoluteString, "date" : dateString, "score" : TracingVC.scoreResul, "level" : TracingVC.tracingLevel]) { (error, reference) in
                        if error == nil {
                            scoreViewController.tracingImageID = autoID
                            self.closeButton.isEnabled = true
                            self.colorItButton.isEnabled = true
                        }
                    }
                }
            }
        }
    }
    
    
    func starsSetUp() {
        switch TracingVC.scoreResul {
        case Score.Excellent.rawValue:
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
        
        case Score.VeryGood.rawValue:
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
        
        case Score.Good.rawValue:
            // 3 stars
            star1.image = UIImage(systemName: "star.fill")
            star1.tintColor = .orange
            
            star2.image = UIImage(systemName: "star.fill")
            star2.tintColor = .orange
            
            star3.image = UIImage(systemName: "star.fill")
            star3.tintColor = .orange

            getRandomStickers(limit: 0)
        
        case Score.Poor.rawValue:
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
