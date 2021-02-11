//
//  colorViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import PencilKit

class testViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    
   
    
    @IBOutlet var canvasView: PKCanvasView!
  
    let canvasWidth = 768
    let canvasHight: CGFloat = 500
    var drawing = PKDrawing()

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.allowsFingerDrawing = true
        
        if let window = parent?.view.window,
             let toolPicker = PKToolPicker.shared(for: window) {
             toolPicker.setVisible(true, forFirstResponder: canvasView)
             toolPicker.addObserver(canvasView)
            
             canvasView.becomeFirstResponder()
            
        }
        

    }
    

    

}
