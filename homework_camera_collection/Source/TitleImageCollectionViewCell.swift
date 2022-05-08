//
//  TitleImageCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Руслан on 07.05.2022.
//

import UIKit

final class TitleImageCollectionViewCell: UICollectionViewCell {
    // MARK: UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutConstants.stackViewSpacing
        stackView.addArrangedSubviews(imageView, titleLabel, subtitleLabel)
        return stackView
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .backgroundColor
        layer.cornerRadius = LayoutConstants.cornerRadius
        configureStackViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    func configure(image: UIImage?, title: String?, subtitle: String?) {
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func configureStackViewLayout() {
        contentView.addSubview(stackView)
        stackView.frame = CGRect(
            x: contentView.frame.origin.x + LayoutConstants.stackViewInset,
            y: contentView.frame.origin.y + LayoutConstants.stackViewInset,
            width: contentView.frame.width - 2 * LayoutConstants.stackViewInset,
            height: contentView.frame.height - 2 * LayoutConstants.stackViewInset
        )
    }
}

// MARK: - Constants

private extension UIColor {
    static let backgroundColor: UIColor = .white
}

private enum LayoutConstants {
    static let cornerRadius: CGFloat = 30
    static let stackViewInset: CGFloat = 20
    static let stackViewSpacing: CGFloat = 8
}
