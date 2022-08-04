//
//  CollectionViewHeader.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 03/08/22.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {

    static let identifier = "CollectionViewHeader"

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.frame = bounds
    }
    private func setView() {
        addSubviews()
        backgroundColor = .systemTeal
    }

    private func addSubviews() {
        addSubview(headerLabel)
    }

    public func configure(title: String) {
        headerLabel.text = title
    }
}
