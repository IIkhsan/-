//
//  CollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Marat Giniyatov on 18.05.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!

    
    
    // MARK: - Private methods
    
    func configure(image: UIImage, date: String, location: String) {
        print("CELLLLlllLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")

        backgroundView?.layer.cornerRadius = 15
        self.photo.image = image
        self.photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
        self.date.text = "date: \(date)"
        self.location.text = location
        self.date.adjustsFontSizeToFitWidth = true
        self.location.adjustsFontSizeToFitWidth = true
        self.date.numberOfLines = 0
        self.location.numberOfLines = 0
        
    }
    

    
}
