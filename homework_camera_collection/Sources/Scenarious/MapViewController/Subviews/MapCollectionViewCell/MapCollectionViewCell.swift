//
//  MapCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Роман Сницарюк on 12.05.2022.
//

import UIKit

final class MapCollectionViewCell: UICollectionViewCell {
    // MARK: UI
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Configure
    
    func configure(with pin: Pin) {
        imageView.image = pin.image
        titleLabel.text = "Сохранено: \(pin.date.toString(using: .commonDateFormatter))"
        descriptionLabel.text = pin.position
    }
}
