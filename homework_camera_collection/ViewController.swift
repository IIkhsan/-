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
    
    var photos: [Photo] = []
    let layout = CollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ButtonName", style: .done, target: self, action: #selector(setNewPhoto(_:)))
        collectionView.dataSource = self
        collectionView.delegate = self
        mapView.delegate = self
//        collectionView.collectionViewLayout = CollectionViewLayout()
        photos.append(Photo(image: UIImage(named: "DrogbA")!, date: "1231312", location: "sdfsfsdf"))
        photos.append(Photo(image: UIImage(named: "DrogbA")!, date: "1231312", location: "sdfsfsdf"))
        photos.append(Photo(image: UIImage(named: "DrogbA")!, date: "1231312", location: "sdfsfsdf"))
        photos.append(Photo(image: UIImage(named: "DrogbA")!, date: "1231312", location: "sdfsfsdf"))
        photos.append(Photo(image: UIImage(named: "DrogbA")!, date: "1231312", location: "sdfsfsdf"))
        collectionView.reloadData()
        
        configureMapView()
        configCollectionView()
    }
//    private func configureCollectionView() {
//        collectionView.backgroundColor = .clear
//        collectionView.decelerationRate = .fast
//        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.reloadData()
////        collectionView.collectionViewLayout = layout
////        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: itemWidth * 2)
////
////        collectionView.dataSource = self
////        collectionView.delegate = self
////
////        layout.scrollDirection = .horizontal
////        layout.minimumLineSpacing = 50.0
////        layout.minimumInteritemSpacing = 50.0
////        layout.itemSize.width = itemWidth
////        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
//
//    }
    
    private func configCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = .fast
//        collectionView.contentInsetAdjustmentBehavior = .never
    ;
        collectionView.collectionViewLayout = layout
//        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 100 * 2)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 50.0
//        layout.minimumInteritemSpacing = 50.0
//        layout.itemSize.width = 100
//        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
//
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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.mapView.addAnnotation(imageAnnotation)
            }
        print(photos.count)
        
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
    
    
    @IBAction func setNewPhoto(_ sender: UIBarButtonItem) {
        print("12313")
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
    

    @IBAction func SelectPhotoButtonAction(_ sender: Any) {
        
    }
    
//    private func transform(_ cell: UICollectionViewCell, isEffect: Bool = true) {
//        if !isEffect {
//            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            return
//        }
//
//        UIView.animate(withDuration: 0.2) {
//            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        }
//
//        collectionView.visibleCells.forEach { otherCell in
//            if let indexPath = collectionView.indexPath(for: otherCell) {
//                if indexPath.item != layout.currentPage {
//                    UIView.animate(withDuration: 0.2) {
//                        otherCell.transform = .identity
//                    }
//                }
//            }
//        }
//    }
    
    
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
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                
                self?.addAnnotation(image: image)
            }
        }
    }
//
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        results.forEach({result in
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { reading, error in
//                guard let image = reading as? UIImage, error == nil else {
//                    return
//                }
//                let center = self.mapView.centerCoordinate
//                let imageAnnotation = CustomAnnotation(coordinate: center)
//                imageAnnotation.title = Date().formatted()
//                imageAnnotation.image = image
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                    self.mapView.addAnnotation(imageAnnotation)
//
//                }
////                print(image)
//
//            })
//        })
//    }
    
    
}

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

extension ViewController: UICollectionViewDelegate {}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("configggggggggggg")

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell {
            let photo = photos[indexPath.item]
            cell.configure(image: photo.image, date: photo.date, location: photo.location)
            print("config")
            return cell
        }
        
        return UICollectionViewCell()
    }

}

