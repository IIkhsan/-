//
//  CardCollectionViewCell.swift
//  homework
//
//  Created by Evelina on 03.05.2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cardContentView: UIView!
    
    func configure(image: UIImage?, infoData: String) {
        infoLabel.text = infoData
        self.image.image = image
        cardContentView.backgroundColor = .systemGray6
    }
}
