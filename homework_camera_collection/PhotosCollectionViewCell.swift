//
//  PhotoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by andrewoch on 17.05.2022.
//

import UIKit

struct Photo {
    var image: UIImage
    var date: String
    var coordinates: String
}

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.layer.cornerRadius = 8
        collectionView.clipsToBounds = true
    }
    
    func configure(_ photo: Photo) {
        imageView.image = photo.image
        dateLabel.text = photo.date
        coordinatesLabel.text = photo.coordinates
    }
    
}
