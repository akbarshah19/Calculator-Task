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
        setupNavBarButton()
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
        let vc = HistoryViewController()
        vc.didSelect = { [weak self] history in
            self?.displayView.label.text = history.answer
            self?.displayView.resultLabel.text = history.expression
        }
        
        let navigationController = UINavigationController(rootViewController: vc)
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
        viewModel.clear(displayText: displayView.label.text ?? "", gotResult: displayView.gotResult) { [weak self] output in
            self?.displayView.label.text = output
            self?.displayView.resultLabel.text = ""
        }
    }
    
    func didPressClearAll() {
        displayView.label.text = "0"
        displayView.resultLabel.text = ""
    }
    
    func didPressCalculate() {
        viewModel.calculate(expression: displayView.label.text ?? "") { [weak self] result, expression in
            self?.displayView.label.text = result
            self?.displayView.resultLabel.text = expression
            self?.displayView.scrollResultToRight()
            self?.displayView.scrollToRight()
        }
    }
    
    func didPressKey(_ text: String) {
        viewModel.appendSymbol(labelText: displayView.label.text ?? "", input: text) { [weak self] output in
            self?.displayView.label.text = output
            self?.displayView.resultLabel.text = ""
            self?.displayView.scrollToRight()
        }
    }
}

#Preview {
    UIKitPresenter(viewController: MainViewController())
}
