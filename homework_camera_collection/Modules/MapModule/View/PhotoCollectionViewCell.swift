//
//  PhotoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Danil Gerasimov on 10.05.2022.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var imageView: UIImageView = UIImageView()
    var dateLabel: UILabel = UILabel()
    var coordsLabel: UILabel = UILabel()
    
    var stackView: UIStackView = UIStackView()
    
    // MARK: - Private methods
    
    func configure(image: UIImage, date: String, coords: String) {
        self.imageView.image = image
        dateLabel.text = "date: \(date)"
        coordsLabel.text = coords
        
        configureLabels()
        configureImageView()
        configureCellLayer()
        addViews()
        configureLayout()
    }
    
    private func configureLabels() {
        dateLabel.font = dateLabel.font.withSize(12)
        coordsLabel.font = coordsLabel.font.withSize(12)
        dateLabel.numberOfLines = 0
        coordsLabel.numberOfLines = 0
    }
    
    private func configureCellLayer() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func addViews() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(coordsLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        coordsLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
