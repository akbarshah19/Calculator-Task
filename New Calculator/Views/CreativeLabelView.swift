//
//  CreativeLabelView.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 19/03/25.
//

import UIKit

class CreativeLabelView: UIView {
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        blurView.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = bounds.height / 2
    }
}
