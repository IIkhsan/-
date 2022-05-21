//
//  CustomViewCell.swift
//  homework_camera_collection
//
//  Created by Тимур Миргалиев on 17.05.2022.
//

import UIKit

class CustomViewCell: UICollectionViewCell {

    @IBOutlet weak var imageOfCell: UIImageView!
    
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(_ card: SqareModel) {
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 20
        
        imageOfCell.image = card.image
        coordinateLabel.text = card.coordinate
        dateLabel.text = card.date
    }
    
}
