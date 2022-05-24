//
//  MapManager.swift
//  homework_camera_collection
//
//  Created by Evans Owamoyo on 24.05.2022.
//

import Foundation
import MapKit

class MapManager: NSObject, MKMapViewDelegate {
    var annotations: [CustomAnnotation] = []
    private weak var mapView: MKMapView!
    
    func addAnnotation(with image: UIImage) {
        if let mapView = mapView {
            let customAnnotation = CustomAnnotation(coordinate: mapView.centerCoordinate, image: image)
            annotations.append(customAnnotation)
            mapView.addAnnotation(customAnnotation)
            mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    internal func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        if let annotation = annotation as? CustomAnnotation {
          annotationView?.canShowCallout = true
          annotationView?.detailCalloutAccessoryView = CalloutView(annotation: annotation)
        }
        return annotationView
      }
}
