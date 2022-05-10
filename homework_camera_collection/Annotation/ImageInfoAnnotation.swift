//
//  File.swift
//  homework_camera_collection
//
//  Created by Ильдар Арсламбеков on 10.05.2022.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class ImageInfoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let image: UIImage
    let date: Date
    
    init(image: UIImage, date: Date, coordinate: CLLocationCoordinate2D) {
        self.image = image
        self.date = date
        self.coordinate = coordinate
    }
}
