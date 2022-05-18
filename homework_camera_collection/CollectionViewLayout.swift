//
//  CollectionViewLayout.swift
//  homework_camera_collection
//
//  Created by Marat Giniyatov on 18.05.2022.
//

import Foundation
import UIKit
class CollectionViewLayout: UICollectionViewFlowLayout {
    var collectionViewAttributes: [UICollectionViewLayoutAttributes] = []
    var cellWidth = 150
    var cellHeight = 180
    var spaceBetweenCells = 5
    
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let collectionView = collectionView else { return nil }
//
//        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
//        for attribute in attributesCache {
//            if attribute.frame.intersects(rect) {
//                visibleLayoutAttributes.append(attribute)
//            }
//        }
//        for attribute in visibleLayoutAttributes {
//            let centerOffset = attribute.frame.midX - collectionView.bounds.minX
//            let relativeOffset: CGFloat = centerOffset / 200
//            let normScale = relativeOffset.normalized
//            let scale = 1 - scaleFactor * abs(normScale)
//            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
//        }
//        return visibleLayoutAttributes
//    }
    

    }

 




