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

final class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    
    private let layout = CustomCollectionViewFlowLayout()
    private var cards: [Card] = []
    private let dayMonthFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        
        return formatter
    }()
    
    private let hourMinuteFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionViewFlowLayout()
        configureCollectionView()
        configureMapView()
    }
    
    // MARK: - IBActions
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
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
    
    // MARK: - Private functions
    
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
    
    private func configureView() {
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    private func configureMapView() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.805569, longitude: 48.943055)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        mapView.delegate = self
    }
        
    private func getPhotoFromLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let viewController = PHPickerViewController(configuration: config)
        viewController.delegate = self
            
        present(viewController, animated: true)
    }
        
    private func getPhotoFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
            
        present(imagePicker, animated: true)
    }
        
    private func addCustomAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)

        let dateNow = Date()
        let time = hourMinuteFormatter.string(from: dateNow)
        let annotationDate = "date: " + dayMonthFormatter.string(from: dateNow) + time
        let annotationCoordinate = String(round(1000 * center.longitude) / 1000) + " " + String(round(1000 * center.latitude) / 1000)

        imageAnnotation.title = annotationDate
        imageAnnotation.subtitle = annotationCoordinate
        imageAnnotation.image = image

        let newCard = Card(date: annotationDate, coordinate: annotationCoordinate, image: image)
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
        
        addCustomAnnotation(image: image)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
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
                
                self?.addCustomAnnotation(image: image)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        let card = cards[indexPath.item]
        cell.configure(with: card)
        
        if indexPath.item == 0 {
            makeBigCell(cell)
        }
        
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 118, height: 168)
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
            makeBigCell(cell)
        }
    }

    private func makeBigCell(_ cell: UICollectionViewCell) {

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

