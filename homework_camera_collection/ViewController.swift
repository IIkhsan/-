//
//  ViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    var photos: [Photo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        
        let coordinate = CLLocationCoordinate2D(latitude: -15.952643, longitude: -5.711970)
        mapView.delegate = self
        
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
        
    }
    
    private func getPhotoFromLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func getPhotoFromCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setPhoto(_ sender: UIBarButtonItem) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.getPhotoFromCamera()
            } else {
                alert.dismiss(animated: true)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
            self.getPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func addAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)
        imageAnnotation.image = image
        imageAnnotation.title = Date().formatted() + " " + center.latitude.description + ", " + center.longitude.description
        photos.append(.init(image: image, date: Date().formatted(), coordinates: center.latitude.description + ", " + center.longitude.description))
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.mapView.addAnnotation(imageAnnotation)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        addAnnotation(image: image)
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
        picker.dismiss(animated: true)
        
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()
        }
        cell.configure(photos[indexPath.row])
        return cell
    }
    
    
}

