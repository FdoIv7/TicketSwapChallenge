//
//  SongTableViewCell.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 29/07/22.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    static let identifier = "SongTableViewCell"

    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .textColor
        label.font = UIFont(name: Constants.Fonts.avenir, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.heavy, size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews()
        setConstraints()
        setViewLook()
    }

    private func addSubviews() {
        contentView.addSubview(trackStackView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            trackStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            trackStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    private func setViewLook() {
        contentView.layer.shadowRadius = Constants.Layout.shadowRadius
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowColor = UIColor.black.cgColor
        setBackgroundColor()
    }

    private func setBackgroundColor() {
        contentView.backgroundColor = .darkBackground
    }

    public func configure(with viewModel: TrackCellViewModel) {
        artistNameLabel.text = viewModel.artistName
        trackNameLabel.text = viewModel.trackName
    }
}
