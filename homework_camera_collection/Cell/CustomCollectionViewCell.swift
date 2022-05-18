//
//  CustomCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Милана Махсотова on 11.05.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }

}
