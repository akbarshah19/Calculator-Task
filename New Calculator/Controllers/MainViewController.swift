//
//  ViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    private let userDefaultsManager = UserDefaultsManager()
    private let calculator = Calculator()
    private let displayView = DisplayLabelView()
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    private var buttons: [CalculatorButton] = Constants.portraitButtons
    private var isPortrait = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
                
        setupNavBarButton()
        setupDisplayLabel()
        setupCollectionView()
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
    
    private func setupDisplayLabel() {
        view.addSubview(displayView)
        NSLayoutConstraint.activate([
            displayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            displayView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            displayView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            displayView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupCollectionView() {
        let spacing: CGFloat = 10
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(CalculatorButtonCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: displayView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        updateLayoutForCurrentSize(view.frame.size)
    }
    
    private func updateLayoutForCurrentSize(_ size: CGSize) {
        let spacing: CGFloat = 10
        isPortrait = size.width < size.height
        
        buttons = isPortrait ? Constants.portraitButtons : Constants.landscapeButtons
        
        let safeAreaInsets = view.safeAreaInsets
        
        let availableWidth = size.width - safeAreaInsets.left - safeAreaInsets.right
        let availableHeight = size.height - safeAreaInsets.top - safeAreaInsets.bottom - 116
        
        if isPortrait {
            let columns: Int = 4
            let totalHorizontalSpacing: CGFloat = spacing * (CGFloat(columns) + 1)
            let cellWidth: CGFloat = (availableWidth - totalHorizontalSpacing) / CGFloat(columns)
            
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        } else {
            let columns: Int = 5
            let rows: Int = 4
            
            let totalHorizontalSpacing: CGFloat = spacing * (CGFloat(columns) + 1)
            let cellWidth: CGFloat = (availableWidth - totalHorizontalSpacing) / CGFloat(columns)
            
            let totalVerticalSpacing: CGFloat = spacing * (CGFloat(rows) + 1)
            let cellHeight: CGFloat = (availableHeight - totalVerticalSpacing) / CGFloat(rows)
            
            let finalSize = CGSize(width: cellWidth, height: cellHeight)
            layout.itemSize = finalSize            
        }
        
        layout.invalidateLayout()
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayoutForCurrentSize(view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                self?.updateLayoutForCurrentSize(size)
            }, completion: nil)
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
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalculatorButtonCell else {
            return UICollectionViewCell()
        }
        
        let buttonModel = buttons[indexPath.item]
        cell.configure(with: buttonModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonTitle = buttons[indexPath.item].title
        
        switch buttonTitle {
        case "=":
            guard var text = displayView.label.text else {
                return
            }
            
            //Removing last certain symbols in case the expression is not finished
            let symbols = ["+", "−", "×", "÷", "(", "."]
            if let last = text.last, symbols.contains(String(last)) {
                text.removeLast()
            }
            
            let result = calculator.calculate(expression: text)
            if result != displayView.label.text {
                displayView.resultLabel.text = text
                
                let history: History = .init(id: UUID().uuidString, expression: text, answer: result, date: .now)
                do {
                    try userDefaultsManager.addHistory(history)
                } catch {
                    print(error)
                }
            }
            displayView.resultLabel.text = text
            displayView.label.text = "\(result)"
        case "C":
            //Clear everything if got result from calculations
            if displayView.gotResult {
                displayView.resultLabel.text = ""
                displayView.label.text = "0"
                return
            }
            
            //Nullify if last result was 'Undefined'
            if displayView.label.text == "Undefined" {
                displayView.label.text = "0"
                return
            }
            
            //Nullify if there is only one character in label
            guard let text = displayView.label.text, text.count > 1 else {
                displayView.label.text = "0"
                return
            }
            
            displayView.label.text?.removeLast()
        default:
            displayView.resultLabel.text = ""
            
            if displayView.label.text == "0" {
                let symbols = ["+", "×", "÷", "-", ",", "(", ")"]
                if symbols.contains(buttonTitle) {
                    switch buttonTitle {
                    case ",": displayView.label.text? = "0,"
                    case "-": displayView.label.text? = buttonTitle
                    default: displayView.label.text? = "0\(buttonTitle)"
                    }
                } else {
                    displayView.label.text? = buttonTitle
                }
                
                return
            }
            
            let symbols = ["+", "×", "÷", "-", ","]
            if let last = displayView.label.text?.last,
               symbols.contains(String(last)),
               symbols.contains(buttonTitle) {
                displayView.label.text?.removeLast()
                displayView.label.text? += buttonTitle
                return
            }
            
            displayView.label.text? += buttonTitle
        }
    }
}

#Preview {
    UIKitPresenter(viewController: MainViewController())
}
