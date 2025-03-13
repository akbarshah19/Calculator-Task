//
//  CalculatorButtonCell.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit

class CalculatorButtonCell: UICollectionViewCell {
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 35, weight: .light)
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.size.height / 2
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.contentView.alpha = self.isHighlighted ? 0.5 : 1.0
            }
        }
    }
    
    func configure(with buttonModel: CalculatorButton) {
        buttonLabel.text = buttonModel.title
        contentView.backgroundColor = buttonModel.color.color
    }
}
