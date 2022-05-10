//
//  ImageInfoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Ильдар Арсламбеков on 10.05.2022.
//

import UIKit

class ImageInfoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateInfoLabel: UILabel!
    @IBOutlet weak var locationInfoLabel: UILabel!
    
    func configure(info: ImageInfoAnnotation) {
        self.imageView.image = info.image
        self.dateInfoLabel.text = info.date.formatted()
        self.locationInfoLabel.text = info.coordinate.longitude.description + info.coordinate.latitude.description
    }
}
