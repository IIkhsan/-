//
//  ViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    // MARK: UI
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Take or choose photo"
        configureNavigationBar()
        configureViews()
    }
    
    // MARK: UI configuration
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Camera",
            style: .plain,
            target: self,
            action: #selector(didTapCameraButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Gallery",
            style: .plain,
            target: self,
            action: #selector(didTapGalleryButton)
        )
    }
    
    private func configureViews() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Actions
    
    @objc private func didTapCameraButton() {
    }
    
    @objc private func didTapGalleryButton() {
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
}
