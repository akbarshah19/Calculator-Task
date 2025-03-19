//
//  CalculatorButtonCell.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 17/03/25.
//

import UIKit

class CalculatorButtonCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CalculatorButtonCell"

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.clipsToBounds = true
        
        contentView.addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.6 : 1.0
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
    func configure(with model: CalculatorButton) {
        buttonLabel.text = model.title
        contentView.backgroundColor = model.color.color
    }
}
