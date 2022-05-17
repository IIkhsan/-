import UIKit
import MapKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    var data: [SubviewAnnotation] = []
    private let minScale: CGFloat = 0.9
    private let itemHeight: CGFloat = 0.9
    private let itemWidth: CGFloat = 1
    private let groupHeight: CGFloat = 0.8
    private let groupWidth: CGFloat = 0.38
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemWidth),
            heightDimension: .fractionalHeight(itemHeight)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(groupWidth),
            heightDimension: .fractionalHeight(groupHeight)
        ), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distance = item.frame.minX - offset.x
                if distance > 0 {
                    let containerWidth = environment.container.contentSize.width
                    let scale = max(1 - distance / containerWidth / 3, self.minScale)
                    item.center.y = item.bounds.height - item.frame.height / 2
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.collectionViewLayout = compositionalLayout
        mapView.delegate = self
        mapView.register(SubviewImplView.self, forAnnotationViewWithReuseIdentifier: "view")
    }

    //MARK: - Functions
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let imageManager = PhotoService(viewController: self)
        imageManager.delegate = self
        
        let alertController = UIAlertController(
            title: "Get photo",
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(
            .init(title: "Gallery", style: .default, handler: { _ in
                imageManager.getPhotoFromGallery()
            }))
        alertController.addAction(
            .init(title: "Camera", style: .default, handler: { _ in
                imageManager.getPhotoFromCamera()
            })
        )
        alertController.addAction(
            .init(title: "Cancel", style: .cancel, handler: { _ in
                alertController.dismiss(animated: true)
            })
        )
        present(alertController, animated: true)
    }
}

//MARK: - ImageManagerDelegate
extension ViewController: PhotoServiceDelegate {
    
    func imageReceived(image: UIImage) {
        let imageInfo = SubviewAnnotation(
            image: image,
            date: Date(),
            coordinate: mapView.centerCoordinate
        )
        data.append(imageInfo)
        mapView.addAnnotation(imageInfo)
        collectionView.reloadData()
    }
}

//MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "view")
        annotationView?.annotation = annotation
        return annotationView
    }
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SubviewCell
        cell.configure(subviewInfo: data[indexPath.row])
        return cell
    }
}
