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

    private var labelView = CreativeLabelView()
    private var canvasView: TrackingCanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        labelView.isHidden = true
    }

    private func setupCanvas() {
        canvasView = TrackingCanvasView(frame: view.bounds)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(canvasView)
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.topAnchor),
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

        canvasView.onDrawingEnded = {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.labelView.alpha = 1
            } completion: { [weak self] _ in
                self?.labelView.isHidden = false
            }
        }
    }
}

#Preview {
    UIKitPresenter(viewController: CreativeViewController())
}
