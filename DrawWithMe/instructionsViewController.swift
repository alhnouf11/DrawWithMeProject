//
//  instructionsViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import AVFoundation

class instructionsViewController: UIViewController {
    
    @IBOutlet weak var videoView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let path = Bundle.main.path(forResource: "My Movie", ofType: "mp4") else {return}
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspect
        self.videoView.layer.addSublayer(playerLayer)
        
        player.play()
        
        
        
    }
    

   

}
