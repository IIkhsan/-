//
//  CustomCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Артем Калугин on 11.05.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }
    
    // MARK: - Private functions
    
    private func configureView() {
        containerView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        containerView.layer.cornerRadius = 24
        
    }
    
    // MARK: - Public functions 
    
    public func configure(with card: Card) {
        
        guard let image = card.image,
              let coordinate = card.coordinate,
              let date = card.date else {
                  
                  return
              }
        
        imageView.image = image
        coordinateLabel.text = coordinate
        dateLabel.text = date
    }
}
