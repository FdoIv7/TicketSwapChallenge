//
//  AlbumCollectionViewCell.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 24/07/22.
//

import UIKit
import SDWebImage

class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumCollectionViewCell"
    
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        nameLabel.textColor = .textColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        return nameLabel
    }()

    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Heavy", size: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        addSubviews()
        setConstraints()
        setViewLook()
    }

    private func setViewLook() {
        contentView.layer.cornerRadius = Constants.Layout.cornerRadius
        contentView.layer.shadowRadius = Constants.Layout.shadowRadius
        contentView.layer.shadowOpacity = Constants.Layout.shadowOpacity
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowColor = UIColor.black.cgColor
    }

    private func addSubviews() {
        contentView.addSubview(coverImage)
        contentView.addSubview(textStackView)
    }

    // Maybe implement prepare for reuse
    private func setConstraints() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            textStackView.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 15),
            textStackView.leadingAnchor.constraint(equalTo: coverImage.leadingAnchor),
            //textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: NewReleasesViewModel) {
        nameLabel.text = viewModel.albumName
        artistNameLabel.text = viewModel.artist
        coverImage.sd_setImage(with: viewModel.imageURL)
    }
}
