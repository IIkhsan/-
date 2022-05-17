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
    
    private let layout = CustomLayout()
    private var modelCell: [ModelCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureCollectionView()
        configureCollectionViewFlowLayout()
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
    
    private func addAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)
        imageAnnotation.title = Date().formatted()
        imageAnnotation.image = image
        
        modelCell.append(ModelCell(image: image, date: Date().formatted(), location: "\(mapView.centerCoordinate.latitude), \(mapView.centerCoordinate.longitude)"))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.mapView.addAnnotation(imageAnnotation)
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = .normal
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureCollectionViewFlowLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 20.0
        layout.itemSize.width = 118
        layout.itemSize.height = 168
               
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
    }
    
    @IBAction func setPhotoToPlace(_ sender: Any) {
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        addAnnotation(image: image)
    }
}

// MARK: - MKMapViewDelegate

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

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell {
            cell.setData(cell: modelCell[indexPath.item])
            if indexPath.item == 0 {
                scaleCell(cell)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }

}

// MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if decelerate {
            setupCell()
        }
    }

    private func setupCell() {
        let indexPath = IndexPath(item: layout.currentPage, section: 0)

        if let cell = collectionView.cellForItem(at: indexPath) {
            scaleCell(cell)
        }
    }

    private func scaleCell(_ cell: UICollectionViewCell) {

        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }

        collectionView.visibleCells.forEach { otherCell in
            
            if let indexPath = collectionView.indexPath(for: otherCell) {
                if indexPath.item != layout.currentPage {
                    UIView.animate(withDuration: 0.1) {
                        otherCell.transform = .identity
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 138, height: 175)
    }
}
