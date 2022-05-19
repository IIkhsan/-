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

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables

    var photos: [Photo] = []
    var photosAnnotations: [CustomAnnotation] = []
    let layout = CollectionViewLayout()
    
    
    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ButtonName", style: .done, target: self, action: #selector(setNewPhoto(_:)))
        collectionView.dataSource = self
        mapView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .normal
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.reloadData()
        configureMapView()
    }
    
    
    
   
    private func configureMapView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        let coordinator = CLLocationCoordinate2D(latitude: 55.805569,longitude: 48.943055)
        let annotation = MKPointAnnotation()
        annotation.coordinate = (coordinator)
        mapView.addAnnotation(annotation)
        mapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        mapView.setRegion(MKCoordinateRegion(center: coordinator, span: span), animated: true)
    }
    
    private func addAnnotation(image: UIImage) {
            let center = self.mapView.centerCoordinate
            let imageAnnotation = CustomAnnotation(coordinate: center)
            imageAnnotation.title = Date().formatted()
            imageAnnotation.image = image
        
        photos.append(Photo(image: image, date: Date().formatted(.dateTime), location: "\(mapView.centerCoordinate.latitude) / \(mapView.centerCoordinate.longitude)"))
        photosAnnotations.append(CustomAnnotation(coordinate: center))
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.mapView.addAnnotation(imageAnnotation)
            }
        }
    
    
    // MARK: - Methods to get Photo from device

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
    
    
    // MARK: - @IBAction add button

    @IBAction func setNewPhoto(_ sender: UIBarButtonItem) {
        let alert = UIAlertController()
               alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
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

// MARK: - MKMapViewDelegate extension

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

// MARK: - PHPickerViewControllerDelegate

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                self?.addAnnotation(image: image)
            }
        }
    }
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate extensions

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print("dasdasdadaddsasadsdasdasdasd")
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        addAnnotation(image: image)
    }
}

// MARK: - UICollectionViewDataSource extension

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("data")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell {
            let photo = photos[indexPath.item]
            cell.configure(image: photo.image, date: photo.date, location: photo.location)
            print("config")
            return cell
        }
        return UICollectionViewCell()
    }
}
