//
//  ViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit
import SwiftUI

protocol MainDisplayLogic: AnyObject {
    func displayOutput(_ viewModel: MainModels.OutputViewModel)
    func displayResult(_ viewModel: MainModels.ResultViewModel)
}

class MainViewController: UIViewController {

    var interactor: MainBusinessLogic?
    private var router: MainRoutingLogic?
    
    private let containerView = UIView()
    private let displayView = DisplayLabelView()
    private let keyPadView = KeyPadView()
    
    private var keyPadViewHeight: NSLayoutConstraint?
    private var intitialCellHeight: CGFloat {
        let cellWidth = (view.frame.size.width - 30 - 20) / 4
        return cellWidth * 5 + 40
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIP()
        view.backgroundColor = .black
        keyPadView.delegate = self
        setupUI()
        setupNavBarButton()
    }
    
    private func setupVIP() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        self.interactor = interactor
        self.router = router
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
        router?.routeToHistory(from: self) { [weak self] history in
            self?.interactor?.displaySelectedHistory(history: history)
        }
    }
}

extension MainViewController: MainDisplayLogic {
    func displayOutput(_ viewModel: MainModels.OutputViewModel) {
        displayView.label.text = viewModel.outputText
        displayView.resultLabel.text = ""
        
        displayView.scrollToRight()
        displayView.scrollResultToRight()
    }

    func displayResult(_ viewModel: MainModels.ResultViewModel) {
        displayView.label.text = viewModel.resultText
        displayView.resultLabel.text = viewModel.expressionText
        
        displayView.scrollToRight()
        displayView.scrollResultToRight()
    }
}

extension MainViewController: KeyPadViewDelegate {
    func didPressClear() {
        interactor?.clear(displayText: displayView.label.text ?? "", gotResult: displayView.gotResult)
    }

    func didPressClearAll() {
        interactor?.clearAll()
    }

    func didPressCalculate() {
        interactor?.calculate(expression: displayView.label.text ?? "")
    }

    func didPressKey(_ text: String) {
        interactor?.appendSymbol(labelText: displayView.label.text ?? "", input: text)
    }
}

#Preview {
    UIKitPresenter(viewController: MainViewController())
}
