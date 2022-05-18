//
//  CustomAnnotation.swift
//  homework
//
//  Created by Evelina on 30.04.2022.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var date: String?
    var location: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
