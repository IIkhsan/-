//
//  MapViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit
import PhotosUI

final class MapViewController: UIViewController {
    // MARK: UI
    
    @IBOutlet private weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1)
        ), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach {
                let leftOffset = $0.frame.origin.x - offset.x
                if leftOffset > 0 {
                    let containerWidth = environment.container.contentSize.width
                    let scale = max(1 - leftOffset / containerWidth / 3, 0.7)
                    $0.transform = CGAffineTransform(scaleX: scale, y: scale)
                    $0.center.y = $0.bounds.height - $0.frame.height / 2
                }
            }
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    // MARK: Properties
    
    private var pins: [Pin] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        title = "Фотографии"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        
        mapView.setRegion(Constants.kazanRegion, animated: true)
        
        collectionView.register(.init(nibName: "MapCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "\(MapCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = compositionalLayout
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Библиотека", style: .default, handler: { _ in
            self.getPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.getPhotoFromCamera()
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
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
    
    private func savePin(image: UIImage) {
        let center = mapView.centerCoordinate
        pins.append(.init(image: image, date: Date(), position: "\(center.latitude) \(center.longitude)"))
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        savePin(image: image)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "\(MapCollectionViewCell.self)",
                                 for: indexPath) as? MapCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: pins[indexPath.row])
        return cell
    }
}

// MARK: - PHPickerViewControllerDelegate

extension MapViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) {
                guard let image = $0 as? UIImage, $1 == nil else {
                    return
                }
                self.savePin(image: image)
            }
        }
    }
}

// MARK: - Constants

private extension MapViewController {
    enum Constants {
        static let kazanRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.796391, longitude: 49.108891),
                                               span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
    }
}
