//
//  ImageManager.swift
//  homework_camera_collection
//
//  Created by Ильдар Арсламбеков on 10.05.2022.
//

import Foundation
import UIKit
import PhotosUI

protocol ImageManagerDelegate: AnyObject {
    func imageReceived(image: UIImage)
}

class ImageManager: NSObject {
    
    //MARK: - Properties
    weak var parentViewController: UIViewController?
    weak var delegate: ImageManagerDelegate?
    
    init(viewController: UIViewController) {
        self.parentViewController = viewController
    }
        
    func requestImageFromCamera() {
        checkCameraPermission(completion: { isAccessed in
            if isAccessed {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                    self.parentViewController?.present(picker, animated: true)
            }
        })
    }
    
    func requestImageFromGallery() {
        checkGalleryPermission(completion: { isAccessed in
            if isAccessed {
                var config = PHPickerConfiguration(photoLibrary: .shared())
                config.filter = .images
                let photoPickerViewController = PHPickerViewController(configuration: config)
                photoPickerViewController.delegate = self
                    self.parentViewController?.present(photoPickerViewController, animated: true)
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

extension ImageManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension ImageManager: PHPickerViewControllerDelegate {
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
