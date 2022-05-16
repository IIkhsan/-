import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    // MARK: - Properties
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    var image: UIImage?
    // MARK: - Initializers
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
