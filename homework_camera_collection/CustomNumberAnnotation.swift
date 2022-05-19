//
//  CustomNumberAnnotation.swift
//  homework_camera_collection
//
//  Created by Marat Giniyatov on 19.05.2022.
//

import Foundation
import UIKit
import MapKit

class CustomNumberAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var count: Int
    
    init(coordinate: CLLocationCoordinate2D, count: Int) {
        self.coordinate = coordinate
        self.count = count
        super.init()
    }
}
