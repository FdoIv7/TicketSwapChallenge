//
//  ArtistResultTableViewCell.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 02/08/22.
//

import UIKit
import SDWebImage

class ArtistResultTableViewCell: UITableViewCell {

    static let identifier = "ArtistResultTableViewCell"

    private lazy var artistImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
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

    private func setConstraints() {
        NSLayoutConstraint.activate([
            artistImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            artistImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            artistImage.widthAnchor.constraint(equalToConstant: 100),
            artistImage.heightAnchor.constraint(equalToConstant: 100),
            artistImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: artistImage.trailingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            artistNameLabel.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.7)
        ])
    }

    private func addSubviews() {
        contentView.addSubview(artistImage)
        contentView.addSubview(artistNameLabel)
    }

    private func setViewLook() {
        backgroundColor = .darkBackground
        artistImage.layer.cornerRadius = Constants.Layout.cornerRadius
        artistImage.layer.shadowRadius = Constants.Layout.shadowRadius
        artistImage.layer.shadowOpacity = Constants.Layout.shadowOpacity
        artistImage.layer.shadowOffset = .zero
        artistImage.layer.shadowColor = UIColor.black.cgColor
    }

    public func configure(with viewModel: SearchResultCellViewModel) {
        if let imageURL = viewModel.imageURL {
            artistImage.sd_setImage(with: imageURL)
            artistImage.contentMode = .scaleToFill
        } else {
            artistImage.image = UIImage(named: "musician")
            artistImage.contentMode = .scaleAspectFill
        }
        artistNameLabel.text = viewModel.artist
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        artistImage.image = nil
        artistNameLabel.text = nil
    }
}
