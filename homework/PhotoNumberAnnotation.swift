//
//  NumberPhotoAnnotation.swift
//  homework
//
//  Created by Evelina on 01.05.2022.
//

import Foundation
import MapKit

class PhotoNumberAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var number: Int
    
    init(coordinate: CLLocationCoordinate2D, number: Int) {
        self.coordinate = coordinate
        self.number = number
        super.init()
    }
}
