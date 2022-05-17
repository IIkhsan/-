//
//  CollectionViewCell.swift
//  homework_camera_collection
//
//  Created by NaYfront on 17.05.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: - Functions
    func setData(cell: ModelCell) {
        imageView.image = cell.image
        dateLabel.text = cell.date
        locationLabel.text = cell.location
    }
}
