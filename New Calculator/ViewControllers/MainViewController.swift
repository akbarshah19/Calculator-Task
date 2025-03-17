//
//  ViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    private let containerView = UIView()
    private let displayView = DisplayLabelView()
    private let keyPadView = KeyPadView()
    
    private let viewModel = MainViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        keyPadView.delegate = self
               
        setupUI()
        setupBindings()
        setupNavBarButton()
    }
    
    private func setupBindings() {
        viewModel.onDisplayUpdate = { [weak self] result, expr in
            self?.displayView.resultLabel.text = expr
            self?.displayView.label.text = result
            self?.displayView.scrollResultToRight()
            self?.displayView.scrollToRight()
        }
    }
    
    private func setupNavBarButton() {
        let historyButton = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .done,
            target: self,
            action: #selector(presentHistory)
        )
        historyButton.tintColor = .orange
        navigationItem.leftBarButtonItem = historyButton
    }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        containerView.addSubview(keyPadView)
        NSLayoutConstraint.activate([
            keyPadView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            keyPadView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            keyPadView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        containerView.addSubview(displayView)
        NSLayoutConstraint.activate([
            displayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayView.bottomAnchor.constraint(equalTo: keyPadView.topAnchor, constant: -16)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let spacing: CGFloat = 10
        let hSpacing: CGFloat = spacing * 3.0
        let collectionHeight: CGFloat = ((containerView.frame.width - hSpacing) / 4.0) * 5.0 + 40.0
        NSLayoutConstraint.activate([
            keyPadView.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }
    
    @objc
    private func presentHistory() {
        let navigationController = UINavigationController(rootViewController: HistoryViewController())

        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 20
        }

        present(navigationController, animated: true)
    }
}

extension MainViewController: KeyPadViewDelegate {
    func didPressClear() {
        let newText = viewModel.clear(displayText: displayView.label.text ?? "", gotResult: displayView.gotResult)
        displayView.label.text = newText
        displayView.resultLabel.text = ""
    }
    
    func didPressCalculate() {
        viewModel.calculate(expression: displayView.label.text ?? "")
    }
    
    func didPressKey(_ text: String) {
        let updated = viewModel.appendSymbol(currentText: displayView.label.text ?? "", symbol: text)
        displayView.label.text = updated
        displayView.resultLabel.text = ""
        displayView.scrollToRight()
    }
}

#Preview {
    UIKitPresenter(viewController: MainViewController())
}
