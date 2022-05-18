//
//  CustomCollectionViewLayout.swift
//  homework
//
//  Created by Evelina on 03.05.2022.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Private properties
    private var attributesCache: [UICollectionViewLayoutAttributes] = []
    private var distanceBetweenCellsX: CGFloat = 1
    private var distanceBetweenCellsY: CGFloat = 0
    private var scaledRightInset: CGFloat = 34
    private var widthForCell: CGFloat = 220
    private var heightForCell: CGFloat = 200
    private let scaleFactor: CGFloat = 0.3
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
        let insets = collectionView.contentInset
        return CGFloat(collectionView.numberOfItems(inSection: 0)) * widthForCell - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    // MARK: - Override functions
    override func prepare() {
        guard let collectionView = collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        var xOffset: CGFloat = 1
        for item in 0..<numberOfItems {
            xOffset = widthForCell * CGFloat(item)
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: xOffset,
                               y: 0,
                               width: widthForCell,
                               height: heightForCell)
            let insetFrame = frame.insetBy(dx: distanceBetweenCellsX, dy: distanceBetweenCellsY)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            attributesCache.append(attribute)
            contentHeight = frame.maxY
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in attributesCache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        for attribute in visibleLayoutAttributes {
            let centerOffset = attribute.frame.midX - collectionView.bounds.minX
            let relativeOffset: CGFloat = centerOffset / 200
            let normScale = relativeOffset.normalized
            let scale = 1 - scaleFactor * abs(normScale)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        collectionView.decelerationRate = .fast
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = layoutAttributesForElements(in: targetRect) else { return .zero }

        let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2
        
        var offset = CGFloat.greatestFiniteMagnitude
        var targetIndex = 0

        for attribute in rectAttributes {
            if (attribute.center.x - horizontalCenter).magnitude < offset.magnitude {
                offset = attribute.center.x - horizontalCenter
                targetIndex = attribute.indexPath.item
            }
        }
        
        let screenHalf  = collectionView.bounds.width / 2
        let minX = widthForCell * CGFloat(targetIndex) - scaledRightInset
        let newX = minX - screenHalf
        
        return CGPoint(x: newX, y: 0)
    }
}

extension CGFloat {
    var normalized: CGFloat {
        return CGFloat.minimum(1, CGFloat.maximum(-1, self))
    }
}
