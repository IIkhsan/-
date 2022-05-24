//
//  CustomAnnotation.swift
//  homework_camera_collection
//
//  Created by Evans Owamoyo on 24.05.2022.
//

import MapKit
import Foundation

final class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let image: UIImage
    let date: Date
    var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM hh:mm"
        return "Date: \(dateFormatter.string(from: Date()))"
    }
    var subtitle: String? {
        "\(String(format: "%.2f'", coordinate.latitude)) \(String(format:"%.2f''",coordinate.longitude))"
    }
    
    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.coordinate = coordinate
        self.image = image
        self.date = Date()
    }
}
