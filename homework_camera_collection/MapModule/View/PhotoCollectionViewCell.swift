//
//  PhotoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Даниил Багаутдинов on 11.05.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setData(photo: Photo) {
        imageView.image = photo.image
        coordsLabel.text = photo.coords
        dateLabel.text = photo.date
    }
}
