//
//  ViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit
import SwiftUI

enum Calculatortype: Identifiable, Hashable {
    case standard, creative
    
    var id: Self { return self }
}

class MainViewController: UIViewController {
    
    private let containerView = UIView()
    private let displayView = DisplayLabelView()
    private let keyPadView = KeyPadView()
    
    private let viewModel = MainViewModel()
    private var keyPadViewHeight: NSLayoutConstraint?
    private var intitialCellHeight: CGFloat {
        let cellWidth = (view.frame.size.width - 30 - 20) / 4
        return cellWidth * 5 + 40
    }
        
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
        keyPadViewHeight = keyPadView.heightAnchor.constraint(equalToConstant: intitialCellHeight)
        keyPadViewHeight?.isActive = true
        
        containerView.addSubview(displayView)
        NSLayoutConstraint.activate([
            displayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayView.bottomAnchor.constraint(equalTo: keyPadView.topAnchor, constant: -16)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let totalWidth = size.width - 20
        
        if UIDevice.current.orientation.isLandscape {
            let totalHeight = size.height * 0.6
            self.keyPadViewHeight?.constant = totalHeight
        } else {
            let cellWidth = (totalWidth - 30) / 4
            self.keyPadViewHeight?.constant = cellWidth * 5 + 40
        }
        
        self.keyPadView.collectionView.reloadData()
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
