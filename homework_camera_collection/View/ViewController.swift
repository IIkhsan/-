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
    
    //MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let identifier = "CollectionCell"
    private var cards: [SqareModel] = []
    private let layout = CustomCollectionViewFlowLayout()
    private let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        
        return formatter
    }()

    //MARK: - View life cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewFlowLayout()
        configureCollectionView()
        configureMapView()
        collectionView.register(UINib(nibName: "CustomViewCell", bundle: .main), forCellWithReuseIdentifier: identifier)
    }
    
    //MARK: - Configure UI
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
    
    private func configureMapView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        
        let coordinate = CLLocationCoordinate2D(latitude: 55.805569, longitude: 48.943055)
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
    
    private func addAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)

        let currentDate = Date()
        let annotationDate = "Date: " + dateFormatter.string(from: currentDate)
        let annotationCoordinate = String(round(1000 * center.longitude) / 1000) + " " + String(round(1000 * center.latitude) / 1000)

        imageAnnotation.title = annotationDate
        imageAnnotation.subtitle = annotationCoordinate
        imageAnnotation.image = image

        let newCard = SqareModel(image: image, date: annotationDate, coordinate: annotationCoordinate)
        cards.append(newCard)
            
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.mapView.addAnnotation(imageAnnotation)
        }
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

//MARK: - PHPickerViewControllerDelegate
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

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CustomViewCell else {
            return UICollectionViewCell()
        }
        
        let buf = cards[indexPath.item]
        cell.configure(buf)
        
        if indexPath.item == 0 {
            createLargeCell(cell: cell)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 200)
    }
}

//MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            makeCell()
        }
    }
    
    func makeCell() {
        let indexPath = IndexPath(item: layout.currentPage, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            createLargeCell(cell: cell)
        }
    }
    
    func createLargeCell(cell: UICollectionViewCell) {
        
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
