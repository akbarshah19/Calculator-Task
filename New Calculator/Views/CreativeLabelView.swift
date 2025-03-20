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
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    func getText() -> String {
        return label.text ?? ""
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
        
        blurView.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -10)
        ])
        
        blurView.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = bounds.height / 2
    }
}
