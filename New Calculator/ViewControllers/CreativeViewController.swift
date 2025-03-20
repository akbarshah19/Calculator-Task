//
//  CreativeViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 19/03/25.
//

import UIKit
import SwiftUI
import Vision

class CreativeViewController: UIViewController {

    private let textRecognizer = TextRecognizer()
    private var labelView = CreativeLabelView()
    private var canvasView: TrackingCanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        navigationItem.title = "Creative"
        labelView.isHidden = true
        setupNavButtons()
    }

    private func setupCanvas() {
        canvasView = TrackingCanvasView(frame: view.bounds)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(canvasView)
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            labelView.heightAnchor.constraint(equalToConstant: 50)
        ])
        view.bringSubviewToFront(labelView)

        canvasView.onDrawingStarted = {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.labelView.alpha = 0
            } completion: { [weak self] _ in
                self?.labelView.isHidden = true
            }
        }

        canvasView.onDrawingEnded = { [weak self] in
            guard let strongSelf = self else { return }
            var text: String = ""
            let image = strongSelf.canvasView.drawing.image(
                from: strongSelf.canvasView.bounds,
                scale: UIScreen.main.scale
            )
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.labelView.alpha = 1
                self?.textRecognizer.recognizeText(from: image) { recognizedText in
                    text = recognizedText
                }
            } completion: { [weak self] _ in
                self?.labelView.isHidden = false
                DispatchQueue.main.async { [weak self] in
                    self?.labelView.text = text
                }
            }
        }
    }
    
    private func setupNavButtons() {
        let undo = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .done,
            target: self,
            action: #selector(didTapUndo)
        )
        undo.tintColor = .orange
        
        let clear = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(didTapClear)
        )
        clear.tintColor = .red
        
        navigationItem.rightBarButtonItems = [clear, undo]
    }
    
    @objc
    func didTapUndo() {
        canvasView.undo()
    }
    
    @objc
    func didTapClear() {
        canvasView.clear()
    }
}

#Preview {
    UIKitPresenter(viewController: CreativeViewController())
}
