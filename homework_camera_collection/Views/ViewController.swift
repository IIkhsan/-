//
//  ViewController.swift
//  homework_camera_collection
//
//  Created by ilyas.ikhsanov on 29.04.2022.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {
    // MARK: private variables
    let mapManager: MapManager = .init()
    
    // MARK: UIViews
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = mapManager
        map.setRegion(.myLocation, animated: true)
        return map
    }()
    
    lazy var collectionViewLayout: UICollectionViewCompositionalLayout = {
        // Item
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 0, leading: .itemInset, bottom: 0, trailing: .itemInset)
        // Group
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])
        // Section
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let dist = item.frame.minX - offset.x
                let containerWidth = environment.container.contentSize.width
                if dist > 0 {
                    let scale = max(1 - (dist / containerWidth / 3), 0.7)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        // Layout
        return UICollectionViewCompositionalLayout(section: section)
    }()
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .white.withAlphaComponent(0)
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbarView()
        setupViews()
    }
    
    func setupNavbarView() {
        navigationItem.title = "Images and Map"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Photo", style: .plain, target: self, action: #selector(getImage))
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(collectionView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(CGFloat.collectionViewHeight)
        }
    }
    
    @objc func getImage() {
        let bottomSheet = UIAlertController(title: "Choose an Image", message: "", preferredStyle: .actionSheet)
        let actions: [UIAlertAction] = [
            .init(title: "Choose from Gallery", style: .default) { _ in
                bottomSheet.dismiss(animated: true)
                self.showImagePicker(.photoLibrary)
            },
            .init(title: "Choose from Camera", style: .default, handler: { _ in
                bottomSheet.dismiss(animated: true)
                self.showImagePicker(.camera)
            }),
            .init(title: "Cancel", style: .cancel, handler: { _ in
                bottomSheet.dismiss(animated: true)
            })
        ]
        
        actions.forEach { bottomSheet.addAction($0) }
        present(bottomSheet, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker(_ sourceType: UIImagePickerController.SourceType?) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        guard let sourceType = sourceType else { return }
        imagePickerVC.sourceType = sourceType
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            mapManager.addAnnotation(with: image)
            collectionView.reloadData()
        }
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mapManager.annotations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let singleView = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            let item = mapManager.annotations[indexPath.row]
            singleView.configure(image: item.image,
                                 title: item.title,
                                 subtitle: item.subtitle)
            return singleView
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: private extension
private extension MKCoordinateRegion {
    static let myLocation: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: 55.792480, longitude: 49.122219), latitudinalMeters: 500, longitudinalMeters: 500)
}

private extension CGFloat {
    static let itemInset = 2.5
    static let collectionViewHeight = 150
}
