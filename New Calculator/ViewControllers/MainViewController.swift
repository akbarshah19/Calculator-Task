//
//  ViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let displayView = DisplayLabelView()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    private var collectionView: UICollectionView!
    
    private let viewModel = MainViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
               
        setupUI()
        setupNavBarButton()
        
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
            action: #selector(didPressHistory)
        )
        historyButton.tintColor = .orange
        navigationItem.leftBarButtonItem = historyButton
    }
    
    private func setupUI() {
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(CalculatorButtonCell.self, forCellWithReuseIdentifier: "cell")
        
        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        containerView.addSubview(displayView)
        NSLayoutConstraint.activate([
            displayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            displayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            displayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -16)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let spacing: CGFloat = 10
        let hSpacing: CGFloat = spacing * 3.0
        let cellWidth: CGFloat = (containerView.frame.width - hSpacing) / 4.0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        let collectionHeight: CGFloat = ((containerView.frame.width - hSpacing) / 4.0) * 5.0 + 40.0
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
    }
    
    @objc
    private func didPressHistory() {
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

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalculatorButtonCell else {
            return UICollectionViewCell()
        }
        
        let buttonModel = viewModel.buttons[indexPath.item]
        cell.configure(with: buttonModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonTitle = viewModel.buttons[indexPath.item].title

        switch buttonTitle {
        case "=":
            viewModel.calculate(expression: displayView.label.text ?? "")
        case "C":
            let newText = viewModel.clear(displayText: displayView.label.text ?? "", gotResult: displayView.gotResult)
            displayView.label.text = newText
            displayView.resultLabel.text = ""
        default:
            let updated = viewModel.appendSymbol(currentText: displayView.label.text ?? "", symbol: buttonTitle)
            displayView.label.text = updated
            displayView.resultLabel.text = ""
            displayView.scrollToRight()
        }
    }
}

#Preview {
    UIKitPresenter(viewController: MainViewController())
}
