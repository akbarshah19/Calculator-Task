//
//  DisplayLabelView.swift
//  Calculator-Task
//
//  Created by Akbar Jumanazarov on 06/03/25.
//

import UIKit

class DisplayLabelView: UIView {

    private let labelScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = false
//        scrollView.layer.borderColor = UIColor.blue.cgColor
//        scrollView.layer.borderWidth = 2
        return scrollView
    }()
    
    private let labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resultScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = false
//        scrollView.layer.borderColor = UIColor.red.cgColor
//        scrollView.layer.borderWidth = 2
        return scrollView
    }()
    
    private let resultContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let label: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 60, weight: .regular)
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var gotResult: Bool { resultLabel.text != "" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        layer.borderColor = UIColor.green.cgColor
//        layer.borderWidth = 2
        
        addSubview(resultScrollView)
        resultScrollView.addSubview(resultContainerView)
        resultContainerView.addSubview(resultLabel)
        
        addSubview(labelScrollView)
        labelScrollView.addSubview(labelContainerView)
        labelContainerView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            resultScrollView.topAnchor.constraint(equalTo: topAnchor),
            resultScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultScrollView.heightAnchor.constraint(equalToConstant: 24),
            
            resultContainerView.topAnchor.constraint(equalTo: resultScrollView.topAnchor),
            resultContainerView.bottomAnchor.constraint(equalTo: resultScrollView.bottomAnchor),
            resultContainerView.trailingAnchor.constraint(equalTo: resultScrollView.trailingAnchor),
            resultContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: resultScrollView.leadingAnchor),
            resultContainerView.heightAnchor.constraint(equalTo: resultScrollView.heightAnchor),
            resultContainerView.widthAnchor.constraint(greaterThanOrEqualTo: resultScrollView.widthAnchor),
            
            resultLabel.bottomAnchor.constraint(equalTo: resultContainerView.bottomAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor),
            resultLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resultContainerView.leadingAnchor),
            resultLabel.heightAnchor.constraint(equalToConstant: 20),
            resultLabel.widthAnchor.constraint(greaterThanOrEqualTo: resultContainerView.widthAnchor),
            
            labelScrollView.topAnchor.constraint(equalTo: resultScrollView.bottomAnchor),
            labelScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelContainerView.topAnchor.constraint(equalTo: labelScrollView.topAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: labelScrollView.bottomAnchor),
            labelContainerView.trailingAnchor.constraint(equalTo: labelScrollView.trailingAnchor),
            labelContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: labelScrollView.leadingAnchor),
            labelContainerView.heightAnchor.constraint(equalTo: labelScrollView.heightAnchor),
            labelContainerView.widthAnchor.constraint(greaterThanOrEqualTo: labelScrollView.widthAnchor),
            
            label.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: labelContainerView.leadingAnchor),
            label.heightAnchor.constraint(equalToConstant: 60),
            label.widthAnchor.constraint(greaterThanOrEqualTo: labelContainerView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    public func scrollToRight() {
        layoutIfNeeded()
        let offsetX = max(0, labelScrollView.contentSize.width - labelScrollView.bounds.width)
        labelScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }

    public func scrollResultToRight() {
        layoutIfNeeded()
        let offsetX = max(0, resultScrollView.contentSize.width - resultScrollView.bounds.width)
        resultScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
