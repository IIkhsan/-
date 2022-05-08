//
//  TitleImageAnnotation.swift
//  homework_camera_collection
//
//  Created by Руслан on 02.05.2022.
//

import MapKit

final class TitleImageAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, dateTitle: String, image: UIImage?, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = "date: " + dateTitle
        self.image = image
        
        if subtitle == nil {
            self.subtitle = [coordinate.latitude, coordinate.longitude]
                .map { String(format: "%.2f", $0) }
                .joined(separator: ", ")
        } else {
            self.subtitle = subtitle
        }
        super.init()
    }
}
