import UIKit
import MapKit
import Photos
import PhotosUI
import SnapKit

class MapViewController: UIViewController {
    // MARK: - Properties
    
    lazy var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        setUpView()
        setUpConstraints()
    }
    // MARK: - Private functions
    
    private func obtainImageFromCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func obtainImageFromLibrary() {
        var phPickerConfigiration = PHPickerConfiguration()
        phPickerConfigiration.selectionLimit = 1
        phPickerConfigiration.filter = .images
        let phPickerViewController = PHPickerViewController(configuration: phPickerConfigiration)
        phPickerViewController.delegate = self
        present(phPickerViewController, animated: true, completion: nil)
    }
    
    private func setUpView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(mapView)
        let selectImageImageBarButtonItem = UIBarButtonItem(title: "Select image", style: .plain, target: self, action: #selector(selectImageBarButtonItemDidPressed))
        selectImageImageBarButtonItem.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = selectImageImageBarButtonItem
    }
    
    private func setUpConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func addAnnotationToMapView(image: UIImage) {
        let centerCoordinate = self.mapView.centerCoordinate
        let customAnnotation = CustomAnnotation(coordinate: centerCoordinate)
        customAnnotation.title = Date().formatted() + "   "  + String(format: "%.3f", centerCoordinate.latitude) + ", " + String(format: "%.3f", centerCoordinate.longitude)
        customAnnotation.image = image
        DispatchQueue.main.async {
            self.mapView.addAnnotation(customAnnotation)
        }
    }
    
    private func setUpMapView() {
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        let currentLocationCoordinate = CLLocationCoordinate2D(latitude: 43.0069700, longitude: 40.9893000)
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = currentLocationCoordinate
        mapView.addAnnotation(pointAnnotation)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        mapView.setRegion(MKCoordinateRegion(center: currentLocationCoordinate, span: coordinateSpan), animated: true)
    }
    // MARK: - OBJC functions
    
    @objc private func selectImageBarButtonItemDidPressed() {
        let alertController = UIAlertController()
        alertController.addAction(UIAlertAction(title: "Import library", style: .default, handler: { _ in
            self.obtainImageFromLibrary()
        }))
        alertController.addAction(UIAlertAction(title: "Open camera", style: .default, handler: { _ in
            self.obtainImageFromCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        addAnnotationToMapView(image: image)
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
                self.addAnnotationToMapView(image: image)
            }
        }
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        let pointAnnotation = MKPointAnnotation()
        for mapAnnotation in mapView.annotations {
            if let annotation = mapAnnotation as? CustomAnnotation, annotation.isEqual(selectedAnnotation) {
                let currentLocationCoordinate = annotation.coordinate
                mapView.removeAnnotation(annotation)
                pointAnnotation.coordinate = currentLocationCoordinate
                mapView.addAnnotation(pointAnnotation)
            }
        }
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for mapAnnotation in mapView.annotations {
            if mapAnnotation.isEqual(selectedAnnotation) {
                mapView.removeAnnotation(mapAnnotation)
                obtainImageFromLibrary()
            }
        }
    }
}

