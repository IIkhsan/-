//
//  CollectionViewCustomLayout.swift
//  homework_camera_collection
//
//  Created by Алсу Хайруллина on 17.05.2022.
//

import Foundation
import UIKit

protocol CustomLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class CollectionViewCustomLayout: UICollectionViewFlowLayout {
    
    var delegate: CustomLayoutDelegate?
    
}
