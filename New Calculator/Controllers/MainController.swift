//
//  ViewController.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit

class MainController: UIViewController {
    
    private let displayLabel = UILabel()
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    private var buttons: [CalculatorButton] = []
    private var isPortrait = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        isPortrait = UIDevice.current.orientation.isPortrait || view.frame.width < view.frame.height
        
        setupDisplayLabel()
        setupCollectionView()
        updateButtonsForCurrentOrientation()
    }
    
    func setupDisplayLabel() {
        displayLabel.text = "0"
        displayLabel.textColor = .white
        displayLabel.font = .systemFont(ofSize: 48, weight: .bold)
        displayLabel.textAlignment = .right
        displayLabel.numberOfLines = 1
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayLabel)
        
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            displayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            displayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupCollectionView() {
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        updateLayoutForCurrentSize(view.frame.size)
    }
    
    private func updateButtonsForCurrentOrientation() {
        buttons = isPortrait ? Constants.portraitButtons : Constants.landscapeButtons
        collectionView.reloadData()
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
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateLayoutForCurrentSize(view.frame.size)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLayoutForCurrentSize(view.frame.size)
    }
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        let tappedButton = buttons[indexPath.item]
        print("Tapped: \(tappedButton)")
    }
}

