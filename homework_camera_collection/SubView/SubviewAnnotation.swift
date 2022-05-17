import UIKit
import CoreLocation
import MapKit

class SubviewAnnotation: NSObject, MKAnnotation {
    
    //MARK: - Properties
    var coordinate: CLLocationCoordinate2D
    let image: UIImage
    let date: Date
    
    //initializer
    init(image: UIImage, date: Date, coordinate: CLLocationCoordinate2D) {
        self.image = image
        self.date = date
        self.coordinate = coordinate
    }
}
