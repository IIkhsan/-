//
//  PhotoCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Tagir Kabirov on 19.05.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let identifier = "PhotoInfoCell"
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var photoDate: UILabel!
    @IBOutlet weak var cellVIew: UIView!
    @IBOutlet weak var photoCoordinate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImg.layer.cornerRadius = 10
        cellVIew.layer.cornerRadius = 15
    }

}

extension PhotoCollectionViewCell: IConfigurableView {
    func configure(with model: PhotoInfo) {
        photoImg.image = model.image
        photoDate.text = model.date
        photoCoordinate.text = model.coordinate
    }
}
