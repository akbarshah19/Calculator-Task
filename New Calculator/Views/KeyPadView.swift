//
//  KeyPadView.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 17/03/25.
//

import UIKit

protocol KeyPadViewDelegate: AnyObject {
    func didPressClear()
    func didPressCalculate()
    func didPressKey(_ text: String)
}

class KeyPadView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var buttons: [CalculatorButton] = Constants.portraitButtons
    
    public weak var delegate: KeyPadViewDelegate?
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    private var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: KeyPadView")
    }

    private func setup() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(CalculatorButtonCell.self, forCellWithReuseIdentifier: "cell")
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
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
            delegate?.didPressCalculate()
        case "C":
            delegate?.didPressClear()
        default:
            delegate?.didPressKey(buttonTitle)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = 10
        let hSpacing: CGFloat = spacing * 3.0
        let cellWidth: CGFloat = (frame.width - hSpacing) / 4.0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
}
