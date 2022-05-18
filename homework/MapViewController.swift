//
//  ViewController.swift
//  homework
//
//  Created by Evelina on 27.04.2022.
//

import MapKit
import UIKit
import Photos
import PhotosUI

class MapViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var annotations: [PhotoAnnotation] = []
    private var numberAnnotations: [PhotoNumberAnnotation] = []
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureCollectionView()
    }
    // MARK: - Private functions
    private func configureCollectionView() {
        collectionView.dataSource = self
        //collectionView.collectionViewLayout = CustomCollectionViewLayout()
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureMapView() {
        map.delegate = self
        map.register(PhotoAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: NSStringFromClass(PhotoAnnotation.self))
        
        let kazanLatitude = CLLocationDegrees(55.780751)
        let kazanLongitude = CLLocationDegrees(49.137154)
        let initialLocationCoordinator = CLLocationCoordinate2D(latitude: kazanLatitude, longitude: kazanLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let region = MKCoordinateRegion(center: initialLocationCoordinator, span: span)
        map.setRegion(region, animated: true)
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
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        present(pickerController, animated: true, completion: nil)
    }
    
    private func addAnnotation(image: UIImage) {
        let center = self.map.centerCoordinate
        let imageAnnotation = PhotoAnnotation(coordinate: center)
        imageAnnotation.date = "date: " + Date().formatted(date: .numeric, time: .shortened)
        imageAnnotation.image = image
        imageAnnotation.location = String(format: "%.2f", center.latitude) + ", " + String(format: "%.2f", center.longitude)
        
        updateNumberAnnotations(newAnnotationCordinates: center)
        annotations.append(imageAnnotation)
            
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.map.addAnnotation(imageAnnotation)
        }
    }
    
    private func updateNumberAnnotations(newAnnotationCordinates: CLLocationCoordinate2D) {
        for annotation in numberAnnotations {
            if annotation.coordinate.latitude == newAnnotationCordinates.latitude &&
                annotation.coordinate.longitude == newAnnotationCordinates.longitude {
                annotation.number += 1
                return
            }
        }
        numberAnnotations.append(PhotoNumberAnnotation(coordinate: newAnnotationCordinates, number: 1))
    }
    
    // MARK: - IBActions
    @IBAction func buttonTap(_ sender: Any) {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.getPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.getPhotoFromCamera()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        if mapView.zoomLevel < 13 {
            map.removeAnnotations(annotations)
            map.addAnnotations(numberAnnotations)
        } else {
            map.removeAnnotations(numberAnnotations)
            map.addAnnotations(annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
                
        if let annotation = annotation as? PhotoAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(PhotoAnnotation.self), for: annotation)
            
            return annotationView
        } else if let annotation = annotation as? PhotoNumberAnnotation {
            let annotationView = MKMarkerAnnotationView()
            annotationView.glyphText = annotation.number.formatted()
            annotationView.markerTintColor = .systemBlue
            
            return annotationView
        } else {
            return nil
        }
    }
}
// MARK: - PHPickerViewControllerDelegate
extension MapViewController: PHPickerViewControllerDelegate {
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        addAnnotation(image: image)
    }
}
// MARK: - UICollectionViewDataSource
extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return annotations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCollectionViewCell
            else {return UICollectionViewCell()}
        cell.configure(image: annotations[indexPath.item].image, infoData: annotations[indexPath.item].date! +
                       "\n" + annotations[indexPath.item].location!)
        return cell
    }
}

extension MKMapView {
    var zoomLevel: Int {
        let maxZoom: Double = 20
        let zoomScale = self.visibleMapRect.size.width / Double(self.frame.size.width)
        let zoomExponent = log2(zoomScale)
        return Int(maxZoom - ceil(zoomExponent))
    }
}
