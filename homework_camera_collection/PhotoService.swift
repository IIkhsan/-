import UIKit
import PhotosUI

protocol PhotoServiceDelegate: AnyObject {
    func imageReceived(image: UIImage)
}

class PhotoService: NSObject {
    
    //MARK: - Properties
    weak var superViewController: UIViewController?
    weak var delegate: PhotoServiceDelegate?
    
    //initializer
    init(viewController: UIViewController) {
        self.superViewController = viewController
    }
    
    //MARK: - Functions
    func getPhotoFromGallery() {
        checkGalleryPermission(completion: { isAccessed in
            if isAccessed {
                var config = PHPickerConfiguration(photoLibrary: .shared())
                config.filter = .images
                let photoPickerViewController = PHPickerViewController(configuration: config)
                photoPickerViewController.delegate = self
                self.superViewController?.present(photoPickerViewController, animated: true)
            }
        })
    }
    
    func getPhotoFromCamera() {
        checkCameraPermission(completion: { isAccessed in
            if isAccessed {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.superViewController?.present(picker, animated: true)
            }
        })
    }
    
    private func checkGalleryPermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            DispatchQueue.main.async {
                completion(true)
            }
        default:
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                DispatchQueue.main.async {
                    completion(status == .limited || status == .authorized)
                }
            })
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                completion(true)
            }
        default:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { isAccessed in
                DispatchQueue.main.async {
                    completion(isAccessed)
                }
            })
        }
    }
}

//MARK: - Extensions
extension PhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        DispatchQueue.main.async {
            self.delegate?.imageReceived(image: image)
        }
    }
}

extension PhotoService: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                guard let image = object as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.delegate?.imageReceived(image: image)
                }
            }
        }
    }
}
