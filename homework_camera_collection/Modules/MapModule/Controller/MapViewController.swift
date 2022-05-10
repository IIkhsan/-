import UIKit
import MapKit
import Photos
import PhotosUI

class MapViewController: UIViewController {

    
    // MARK: - Private properties
    private let photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let customLayout = CustomLayout()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    private var photos = [MapImage].init()
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Public properties
    
    var itemW: CGFloat {
        return screenWidth * 0.4
    }
    
    var itemH: CGFloat {
        return screenHeight * 0.3
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureCollectionView()
    }
    
    // MARK: - Private methods
    
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
    
    private func addAnnotation(image: UIImage) {
        let center = self.mapView.centerCoordinate
        let imageAnnotation = CustomAnnotation(coordinate: center)
        imageAnnotation.title = Date().formatted()
        imageAnnotation.image = image
    
        photos.append(MapImage(image: image, date: Date().formatted(.dateTime), coords: "\(mapView.centerCoordinate.latitude), \(mapView.centerCoordinate.longitude)"))
    
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
            self.mapView.addAnnotation(imageAnnotation)
        }
    }
    
    private func configureCollectionView() {
        photosCollectionView.backgroundColor = .clear
        photosCollectionView.decelerationRate = .fast
        photosCollectionView.contentInsetAdjustmentBehavior = .never
        photosCollectionView.showsHorizontalScrollIndicator = false
        photosCollectionView.showsVerticalScrollIndicator = false
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.collectionViewLayout = customLayout
        photosCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: (itemW+customLayout.minimumLineSpacing) * 2)
        
        view.addSubview(photosCollectionView)
        
        NSLayoutConstraint.activate([
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            photosCollectionView.heightAnchor.constraint(equalToConstant: screenHeight/2)])
        
        configureCustomLayout()
    }
    
    private func configureCustomLayout() {
        customLayout.scrollDirection = .horizontal
        customLayout.minimumLineSpacing = 50.0
        customLayout.minimumInteritemSpacing = 50.0
        customLayout.itemSize.width = itemW
        
        customLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: - Actions
    
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

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        addAnnotation(image: image)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
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

extension MapViewController: PHPickerViewControllerDelegate {
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

// MARK: - UICollectionViewDelegate

extension MapViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell {
            let photoItem = photos[indexPath.item]
            cell.configure(image: photoItem.image, date: photoItem.date, coords: photoItem.coords)
            if indexPath.item == 0 {
                transformCell(cell)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: itemW, height: itemH)
    }
}

// MARK: - UIScrollViewDelegate

extension MapViewController {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            setupCell()
        }
    }
    
    private func setupCell() {
        let indexPath = IndexPath(item: customLayout.currentPage, section: 0)
        if let cell = photosCollectionView.cellForItem(at: indexPath) {
            transformCell(cell)
        }
    }
    
    private func transformCell(_ cell: UICollectionViewCell, isEffect: Bool = true) {
        if !isEffect {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        photosCollectionView.visibleCells.forEach { otherCell in
            if let indexPath = photosCollectionView.indexPath(for: otherCell) {
                if indexPath.item != customLayout.currentPage {
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                    }
                }
            }
        }
    }
}
