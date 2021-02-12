//
//  colorViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import PencilKit
@available(iOS 14.0,*)

class colorViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    
   
    
    @IBOutlet weak var canvasView: PKCanvasView!
    
    
    
   // let canvasWidth = 768
    //let canvasHight: CGFloat = 500
    var drawing = PKDrawing()
    private let toolPicker = PKToolPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        //background
        self.canvasView.backgroundColor = UIColor(patternImage: UIImage(named: "house")!)
        
        
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen,color: .red,width: 5)
        
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        
           
        }
    

      
        

    }
    

    

