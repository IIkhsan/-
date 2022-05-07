//
//  Extensions.swift
//  homework_camera_collection
//
//  Created by Руслан on 02.05.2022.
//

import Foundation
import MapKit

extension MKMapView {
    func registerAnnotationView(_ annotationViewClass: MKAnnotationView.Type) {
        register(annotationViewClass.self,
                 forAnnotationViewWithReuseIdentifier: NSStringFromClass(annotationViewClass.self))
    }
    
    func dequeueReusableAnnotationView<T: MKAnnotationView>(
        annotationViewClass: T.Type,
        for annotation: MKAnnotation
    ) -> T {
        return dequeueReusableAnnotationView(
            withIdentifier: NSStringFromClass(annotationViewClass.self),
            for: annotation
        ) as! T
    }
}
