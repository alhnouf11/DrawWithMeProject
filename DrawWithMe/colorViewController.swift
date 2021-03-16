//
//  colorViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import PencilKit
import Firebase
@available(iOS 14.0,*)


class colorViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

  
    @IBOutlet weak var canvasView: PKCanvasView!
    
    @IBOutlet weak var originalImage : UIImageView!
    @IBOutlet weak var saveNewDrawingButton : UIButton!
    
    
    
   // let canvasWidth = 768
    //let canvasHight: CGFloat = 500
    var drawing = PKDrawing()
    private let toolPicker = PKToolPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        //background
        view.backgroundColor = UIColor(patternImage: TracingVC.capturedImage)
        
        originalImage.image = TracingVC.originalImage
        
        canvasView.backgroundColor = .clear
        
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen,color: .red,width: 5)
        
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        
           
        }
    
    
    @IBAction func saveNewDrawing(_ sender : UIButton) {
        
        originalImage.alpha = 0
        saveNewDrawingButton.alpha = 0
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let newDrawing = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        originalImage.alpha = 1
        saveNewDrawingButton.alpha = 1
        
        
        let storage = Storage.storage().reference()
        let imageRef = storage.child("DrawingImage").child(addViewController.id).child(scoreViewController.tracingImageID)
        
        guard let imageData = newDrawing.pngData() else {return}
        
        imageRef.putData(imageData, metadata: nil) { (meta, err) in
            if err == nil {
                imageRef.downloadURL { (url, error) in
                    let ref = Database.database().reference()
                    ref.child("MyDrawings").child(addViewController.id).child(scoreViewController.tracingImageID).updateChildValues(["imageURL" : url!.absoluteString]) {  (error, ref) in
                        if error == nil {
                            
                            print("\n \n DONE \n \n ")
                            
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeVC")
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
    }

      
        

    }
    

