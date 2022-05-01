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
//        addAnnotation(image: image)
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
                //                self.addAnnotation(image: image)
            }
        }
    }
}

