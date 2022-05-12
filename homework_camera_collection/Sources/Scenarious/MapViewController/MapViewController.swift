//
//  MapViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    // MARK: UI
    
    @IBOutlet private weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        title = "Фотографии"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        
        mapView.setRegion(Constants.kazanRegion, animated: true)
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
    }
}

// MARK: - Constants

private extension MapViewController {
    enum Constants {
        static let kazanRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.796391, longitude: 49.108891),
                                               span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
    }
}
