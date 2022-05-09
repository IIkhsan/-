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
        mapView.setRegion(.centerRegion, animated: true)
        mapView.registerAnnotationView(TitleImageAnnotationView.self)
        return mapView
    }()
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(.collectionLayoutItemFractionalWidth),
            heightDimension: .fractionalHeight(.collectionLayoutItemFractionalHeight)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(.collectionLayoutGroupFractionalWidth),
            heightDimension: .fractionalHeight(.collectionLayoutGroupFractionalHeight)
        ), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromLeft = item.frame.minX - offset.x
                if distanceFromLeft > 0 {
                    let containerWidth = environment.container.contentSize.width
                    let scale = max(1 - distanceFromLeft / containerWidth / 3, .minItemScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    item.center.y = item.bounds.height - item.frame.height / 2
                }
            }
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TitleImageCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: Dependencies & properties
    
    private let dataManager = DataManager()
    private var annotations: [TitleImageAnnotation] = []
    
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
                                                    constant: .collectionViewInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -.collectionViewInset),
            collectionView.heightAnchor.constraint(equalToConstant: .collectionViewHeight)
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
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(
            annotationViewClass: TitleImageAnnotationView.self,
            for: annotation
        )
        annotationView.annotation = annotation
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? TitleImageAnnotationView else { return }
        view.markerTintColor = view.markerTintColor?.withAlphaComponent(0)
        view.glyphTintColor = .clear
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? TitleImageAnnotationView else { return }
        view.markerTintColor = view.markerTintColor?.withAlphaComponent(1)
        view.glyphTintColor = nil
    }
}

// MARK: - Constants

private extension MKCoordinateRegion {
    static let centerRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.786_996, longitude: -122.440_100),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    )
}

private extension CGFloat {
    static let collectionViewInset: CGFloat = 20
    static let collectionViewHeight: CGFloat = 200
    
    static let collectionLayoutItemFractionalWidth: CGFloat = 0.95
    static let collectionLayoutItemFractionalHeight: CGFloat = 1
    static let collectionLayoutGroupFractionalWidth: CGFloat = 0.4
    static let collectionLayoutGroupFractionalHeight: CGFloat = 1
    
    static let minItemScale: CGFloat = 0.8
}
