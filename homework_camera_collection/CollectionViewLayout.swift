//
//  CollectionViewLayout.swift
//  homework_camera_collection
//
//  Created by Marat Giniyatov on 18.05.2022.
//

import Foundation
import UIKit

// MARK: - CollectionViewLayout class

class CollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Variables
    
    var collectionViewAttributes: [UICollectionViewLayoutAttributes] = []
    var cellHeight: CGFloat = 200
    var cellWidth: CGFloat = 220
    var spaceBetweenCells = 5
    
    
    var collectionViewWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let inset = collectionView.contentInset
        return (CGFloat(numberOfItems) * cellWidth) - (inset.right + inset.left)
    }
    
    var collectionViewHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.height
    }
    
    var numberOfItems: Int {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.numberOfItems(inSection: 0)
    }
    
    // MARK: - Override methods

    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in collectionViewAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
            
        }
        guard let collectionView = collectionView else { return nil }
        for attributes in layoutAttributes {
            let minOffset = attributes.frame.midX - collectionView.bounds.minX
            let resizingCoefficient = minOffset / cellWidth
            let k = 0.3
            let percentage = 1 - k * abs(resizingCoefficient)
            attributes.transform = CGAffineTransform(scaleX: percentage, y: percentage)
        }
        return layoutAttributes
    }
    
    override var collectionViewContentSize : CGSize {
//        print("\(collectionViewWidth) /// \(collectionViewHeight)")
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return collectionViewAttributes[indexPath.item]
    }
    
    override func prepare() {
        var offset = 1
        guard let collectionView = collectionView else {
            return
        }
        let count = collectionView.numberOfItems(inSection: 0)
        for item in 0..<count {
            let indexPath = IndexPath(item: item, section: 0)
            offset = Int(cellWidth) * item
            let frame = CGRect(x: CGFloat(offset),
                               y: 0,
                               width: cellWidth,
                               height: cellHeight)
            
            let insets = frame.insetBy(dx: CGFloat(spaceBetweenCells), dy: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insets
            collectionViewAttributes.append(attribute)
            cellHeight = frame.maxY
        }
    }
 
}
