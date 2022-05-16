import UIKit
import MapKit
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations: [CustomAnnotation] = []
    
    var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        //        controller.sourceType = .camera
        //        ЧТОБЫ НЕ КРАШИЛОСЬ
        controller.sourceType = .photoLibrary
        controller.allowsEditing = true
        return controller
    }()
    
    var PHPickerController: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let controller = PHPickerViewController(configuration: config)
        return controller
    }()
    
    var compositionalLayout: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        ), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromLeft = item.frame.minX - offset.x
                if distanceFromLeft > 0 {
                    let containerWidth = environment.container.contentSize.width
                    let scale = max(1 - distanceFromLeft / containerWidth / 3, 0.8)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    item.center.y = item.bounds.height - item.frame.height / 2
                }
            }
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        var cell = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        PHPickerController.delegate = self
        
        configureMapView()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
    }
    
    private func configureMapView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        mapView.delegate = self
    }
    
    private func addAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)
        imageAnnotation.title = Date().formatted()
        imageAnnotation.image = image
        self.annotations.append(imageAnnotation)
        DispatchQueue.main.async {
            self.mapView.addAnnotation(imageAnnotation)
            self.collectionView.reloadData()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    
    @IBAction func didTapSetPhotoFromCam(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSetPhotoFromLib(_ sender: Any) {
        present(PHPickerController, animated: true, completion: nil)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotationView.self), for: annotation)
        return annotationView
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        addAnnotation(image: image)
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

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mapView.annotations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let annotation = annotations[indexPath.row]
        cell.backgroundColor = .systemBackground
        cell.title.text = annotation.title
        cell.imageView.image = annotation.image
        cell.subtitle.text = annotation.title
        return cell
    }
}
