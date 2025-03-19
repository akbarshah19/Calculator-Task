//
//  KeyPadView.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 17/03/25.
//

import UIKit

protocol KeyPadViewDelegate: AnyObject {
    func didPressClear()
    func didPressClearAll()
    func didPressCalculate()
    func didPressKey(_ text: String)
}

class KeyPadView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let spacing: CGFloat = 10.0
    private var buttons: [CalculatorButton] {
        if UIDevice.current.orientation.isLandscape {
            return Constants.portraitButtons
        } else {
            return Constants.landscapeButtons
        }
    }
    
    public weak var delegate: KeyPadViewDelegate?
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported: KeyPadView")
    }

    private func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(CalculatorButtonCell.self, forCellWithReuseIdentifier: "cell")
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalculatorButtonCell
        else {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            let width = (self.frame.size.width - 4 * spacing) / 5
            let height = (self.frame.size.height - 3 * spacing) / 4
            return .init(width: width, height: height)
        } else {
            let width = (self.frame.size.width - 3 * spacing) / 4
            return .init(width: width, height: width)
        }
    }
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point),
               buttons[indexPath.row].title == "C" {
                delegate?.didPressClearAll()
            }
        }
    }
}
