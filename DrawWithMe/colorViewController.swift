//
//  colorViewController.swift
//  DrawWithMe
//
//  Created by Alhnouf F on 22/06/1442 AH.
//

import UIKit
import PencilKit
class colorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpDrawing()
    }
    
    func setUpDrawing() {
        let canvasView = PKCanvasView(frame:  self.view.bounds)
        guard let window = view.window, let toolPicker = PKToolPicker.shared(for: window) else {return}
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        view.addSubview(canvasView)
    }

}
