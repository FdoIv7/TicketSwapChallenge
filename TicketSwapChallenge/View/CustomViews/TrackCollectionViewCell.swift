//
//  TrackCollectionViewCell.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 03/08/22.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {

    static let identifier = "TrackCollectionViewCell"

    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .textColor
        label.font = UIFont(name: "Avenir", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, albumNameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
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

    func configure(with viewModel: TrackCollectionCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        albumNameLabel.text = viewModel.albumName
    }
}
