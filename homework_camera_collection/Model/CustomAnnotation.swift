//
//  File.swift
//  homework_camera_collection
//
//  Created by Семён Соколов on 30.04.2022.
//

import Foundation

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var date: String?
    
    var coordinatesString: String?
    
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
