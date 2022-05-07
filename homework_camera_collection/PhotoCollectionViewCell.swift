//
//  PhotoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Рустем on 07.05.2022.
//

import UIKit

struct Photo {
    var image: UIImage
    var date: String
    var coordinates: String
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    func configure(_ photo: Photo) {
        imageView.image = photo.image
        dateLabel.text = photo.date
        coordinatesLabel.text = photo.coordinates
    }
    
}
