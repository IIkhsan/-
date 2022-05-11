//
//  CustomAnnotation .swift
//  homework_camera_collection
//
//  Created by Артем Калугин on 11.05.2022.
//

import UIKit
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    // MARK: - Life cycle
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
