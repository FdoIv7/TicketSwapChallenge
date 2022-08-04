//
//  ArtistAlbumCollectionCell.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 03/08/22.
//

import UIKit
import SDWebImage

class ArtistAlbumCollectionCell: UICollectionViewCell {
    static let identifier = "ArtistAlbumCollectionCell"
    
    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.Images.photo)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: Constants.Fonts.heavy, size: 15)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        return nameLabel
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
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

    private func setConstraints() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            textStackView.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 35),
            textStackView.leadingAnchor.constraint(equalTo: coverImage.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: AlbumCellViewModel) {
        nameLabel.text = viewModel.albumName
        coverImage.sd_setImage(with: viewModel.imageURL)
    }
}

