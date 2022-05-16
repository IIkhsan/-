//
//  PhotoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Илья Желтиков on 16.05.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    
    
    func setData(photoCell: PhotoCell) {
        cellImage.image = photoCell.image
        dateLabel.text = photoCell.date
        coordinateLabel.text = photoCell.coordinate
    }
}
