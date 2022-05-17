//
//  ViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit
import SnapKit
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    lazy var addButton = UIButton()
    lazy var mapView = MKMapView()
    lazy var contentView = UIView()
    lazy var collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureMapView()
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Фотопленка", style: .default, handler: { _ in
            self.getPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.getPhotoFromCamera()
        }))
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func addAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)
        imageAnnotation.title = Date().formatted()
        imageAnnotation.image = image
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(imageAnnotation)
        }
    }
    
    private func getPhotoFromCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func getPhotoFromLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func configureMapView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        let coordinate = CLLocationCoordinate2D(latitude: 55.805569, longitude: 48.943055)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.delegate = self
        
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }
    
    private func configureView() {
        
        let addButton = addButton
        addButton.setTitleColor(.blue, for: .normal)
        addButton.setTitle("Добавить пин", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().inset(20)
        }
        
        let mapView = mapView
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let contentView = contentView
        contentView.backgroundColor = .yellow
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        if let annotation = annotation as? CustomAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
            
            return annotationView
            
        } else {
            return nil
        }
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                
                self.addAnnotation(image: image)
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.addAnnotation(image: image)
    }
}
