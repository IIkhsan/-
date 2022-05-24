//
//  ImageCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Evans Owamoyo on 24.05.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitle)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
        contentView.layer.masksToBounds = true
        setupViews()
    }
    required init(coder: NSCoder) {
        fatalError("Coder not implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.frame = CGRect(x: contentView.frame.origin.x + 8, y: contentView.frame.origin.y + 8, width: contentView.frame.width - 8, height: contentView.frame.height - 8)
    }
    
    public func configure(image: UIImage?, title: String?, subtitle: String?) {
        self.imageView.image = image
        self.titleLabel.text = title
        self.subtitle.text = subtitle
    }
}
