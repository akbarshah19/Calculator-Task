//
//  TrackingCanvasView.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 19/03/25.
//

import UIKit
import PencilKit

class TrackingCanvasView: PKCanvasView {

    var onDrawingStarted: (() -> Void)?
    var onDrawingEnded: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawingPolicy = .anyInput
        backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        onDrawingStarted?()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onDrawingEnded?()
    }
    
    func undo() {
        var temp = drawing
        if !temp.strokes.isEmpty {
            temp.strokes.removeLast()
            drawing = temp
        }
    }
    
    func clear() {
        drawing = PKDrawing()
    }
}
