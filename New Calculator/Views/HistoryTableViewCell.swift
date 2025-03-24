//
//  HistoryTableViewCell.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 17/03/25.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    static let reuseIdentifier = "HistoryTableViewCell"

    private let expressionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(resultLabel)
        contentView.addSubview(expressionLabel)

        NSLayoutConstraint.activate([
            expressionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            expressionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expressionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            resultLabel.topAnchor.constraint(equalTo: expressionLabel.bottomAnchor, constant: 4),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with history: HistoryModels.History) {
        expressionLabel.text = history.expression
        resultLabel.text = history.answer
    }
}
