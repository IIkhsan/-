//
//  CustomAnnotation.swift
//  homework_camera_collection
//
//  Created by Тимур Миргалиев on 17.05.2022.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}

