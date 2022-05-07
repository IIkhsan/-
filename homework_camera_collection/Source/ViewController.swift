//
//  ViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit
import PhotosUI

final class ViewController: UIViewController {
    // MARK: UI
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.registerAnnotationView(MKMarkerAnnotationView.self)
        // TODO: - удалить
        mapView.addAnnotation(TitleImageAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 37.7749295, longitude: -122.4194155),
            title: "San Francisco",
            image: nil,
            subtitle: "Big tech companies valley")
        )
        mapView.setRegion(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.786_996, longitude: -122.440_100),
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        ), animated: true)
        mapView.delegate = self
        return mapView
    }()
    
    // MARK: Dependencies
    
    private let dataManager = DataManager()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        configureNavigationBar()
        configureLayout()
    }
    
    // MARK: UI configuration
    
    private func configureNavigationBar() {
        title = "Фотки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Добавить",
            style: .plain,
            target: self,
            action: #selector(didTapAddPhotoButton)
        )
    }
    
    private func configureLayout() {
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
    
    @objc private func didTapAddPhotoButton() {
        let alertController = UIAlertController(title: "Выберите источик", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
            self.getPhotoFromLibrary()
        }))
        alertController.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.getPhotoFromCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true)
        }))
        present(alertController, animated: true)
    }
    
    private func getPhotoFromLibrary() {
        dataManager.getPhotoFromLibrary { [weak self] picker in
            self?.present(picker, animated: true)
        }
    }
    
    private func getPhotoFromCamera() {
        dataManager.getPhotoFromCamera { [weak self] picker in
            self?.present(picker, animated: true)
        }
    }
    
    private func addAnnotation(image: UIImage) {
        let imageAnnotation = TitleImageAnnotation(
            coordinate: mapView.centerCoordinate,
            title: Date().formatted(),
            image: image
        )
        self.mapView.addAnnotation(imageAnnotation)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self?.addAnnotation(image: image)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        DispatchQueue.main.async {
            self.addAnnotation(image: image)
        }
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self),
              let annotation = annotation as? TitleImageAnnotation else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(
            annotationViewClass: MKMarkerAnnotationView.self,
            for: annotation
        )
        
        annotationView.canShowCallout = true
        let imageView = UIImageView(image: annotation.image)
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        
        annotationView.leftCalloutAccessoryView = imageView
        return annotationView
    }
}
