//
//  CustomFlowLayout.swift
//  homework_camera_collection
//
//  Created by Tagir Kabirov on 19.05.2022.
//

import Foundation
import UIKit

class CollectionFlowLayout: UICollectionViewFlowLayout {

    var previousOffset: CGFloat = 0.0
    var currentPage = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0.0 {
            currentPage = max(currentPage - 1, 0)
        }
        else if previousOffset < collectionView.contentOffset.x && velocity.x > 0.0 {
            currentPage = min(currentPage + 1, itemCount - 1)
        }

        let itemWidth = itemSize.width
        let spacing = minimumLineSpacing
        let offset = (itemWidth + spacing) * CGFloat(currentPage)
        
        previousOffset = offset
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
}
