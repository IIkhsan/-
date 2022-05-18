//
//  CustomCollectionView.swift
//  homework_camera_collection
//
//  Created by Алсу Хайруллина on 18.05.2022.
//

import UIKit

class CustomCollectionView: UICollectionView {
    
    private let screenWidth = UIScreen.main.bounds.size.width
        
        var itemWidth: CGFloat {
            return screenWidth * 0.4
        }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        register(PinCollectionViewCell.self, forCellWithReuseIdentifier: "PinCollectionViewCell")
        self.backgroundColor = .clear
        self.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: itemWidth * 2)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 50.0
        layout.itemSize.width = itemWidth
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
