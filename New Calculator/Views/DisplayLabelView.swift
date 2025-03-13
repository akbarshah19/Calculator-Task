//
//  DisplayLabelView.swift
//  Calculator-Task
//
//  Created by Akbar Jumanazarov on 06/03/25.
//

import UIKit

class DisplayLabelView: UIView {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 60, weight: .regular)
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(displayLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            containerView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            displayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            displayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            displayLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            displayLabel.heightAnchor.constraint(equalToConstant: 60),
            
            displayLabel.widthAnchor.constraint(greaterThanOrEqualTo: containerView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    public func scrollToRight() {
        layoutIfNeeded()
        let offsetX = max(0, scrollView.contentSize.width - scrollView.bounds.width)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
