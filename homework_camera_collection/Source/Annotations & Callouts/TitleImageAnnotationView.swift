//
//  TitleImageAnnotationView.swift
//  homework_camera_collection
//
//  Created by Руслан on 09.05.2022.
//

import UIKit
import MapKit

final class TitleImageAnnotationView: MKMarkerAnnotationView {
    weak var calloutView: TitleImageCalloutView?
    
    override var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
        animatesWhenAdded = true
        markerTintColor = Constants.markerTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.calloutView?.removeFromSuperview()
            guard let annotation = annotation else { return }
            let calloutView = TitleImageCalloutView(annotation: annotation)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: Constants.animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            guard let calloutView = calloutView else { return }
            
            if animated {
                UIView.animate(withDuration: Constants.animationDuration, animations: {
                    calloutView.alpha = 0
                }, completion: { _ in
                    calloutView.removeFromSuperview()
                })
            } else {
                calloutView.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        calloutView?.removeFromSuperview()
    }
}

// MARK: - Constants

private enum Constants {
    static let markerTintColor: UIColor = .blue
    static let animationDuration: TimeInterval = 0.25
}
