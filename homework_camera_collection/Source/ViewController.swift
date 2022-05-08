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
        mapView.delegate = self
        // TODO: - удалить
        mapView.addAnnotations(annotations)
        mapView.setRegion(.centerRegion, animated: true)
        mapView.registerAnnotationView(MKMarkerAnnotationView.self)
        return mapView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TitleImageCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: Dependencies & properties
    
    private let dataManager = DataManager()
    // TODO: - очистить этот массив
    private var annotations: [TitleImageAnnotation] = [
        TitleImageAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 37.7749295, longitude: -122.4194155),
            dateTitle: "San Francisco",
            image: UIImage(systemName: "building.fill"),
            subtitle: "Big tech companies valley"
        )
    ]
    
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
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: LayoutConstants.collectionViewInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -LayoutConstants.collectionViewInset),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: LayoutConstants.collectionViewInset),
            collectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.collectionViewCellSize)
        ])
    }
    
    // MARK: Actions
    
    @objc private func didTapAddPhotoButton() {
        let alertController = UIAlertController(
            title: "Выберите источник",
            message: nil,
            preferredStyle: .actionSheet
        )
        let alertActions: [UIAlertAction] = [
            .init(title: "Галерея", style: .default) { _ in
                self.dataManager.getPhotoFromLibrary { [weak self] picker in
                    self?.present(picker, animated: true)
                }
            },
            .init(title: "Камера", style: .default) { _ in
                self.dataManager.getPhotoFromCamera { [weak self] picker in
                    self?.present(picker, animated: true)
                }
            },
            .init(title: "Отменить", style: .cancel) { _ in
                alertController.dismiss(animated: true)
            }
        ]
        alertActions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}

// MARK: - DataManagerDelegate

extension ViewController: DataManagerDelegate {
    func didChooseImage(_ image: UIImage) {
        let annotation = TitleImageAnnotation(
            coordinate: mapView.centerCoordinate,
            dateTitle: Date().formatted(),
            image: image
        )
        mapView.addAnnotation(annotation)
        annotations.append(annotation)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout & UICollectionViewDelegate

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: LayoutConstants.collectionViewCellSize,
            height: LayoutConstants.collectionViewCellSize
        )
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        annotations.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeue(TitleImageCollectionViewCell.self, for: indexPath)
        let annotation = annotations[indexPath.row]
        cell.configure(image: annotation.image, title: annotation.title, subtitle: annotation.subtitle)
        return cell
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

// MARK: - Constants

private extension MKCoordinateRegion {
    static let centerRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.786_996, longitude: -122.440_100),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    )
}

private enum LayoutConstants {
    static let collectionViewInset: CGFloat = 20
    static let collectionViewCellSize: CGFloat = 200
}
