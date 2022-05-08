//
//  DataManager.swift
//  homework_camera_collection
//
//  Created by Руслан on 07.05.2022.
//

import Foundation
import PhotosUI
import AVFoundation

protocol DataManagerDelegate: AnyObject {
    func didChooseImage(_ image: UIImage)
}

final class DataManager: NSObject {
    weak var delegate: DataManagerDelegate?
    
    private func checkPhotoUsagePermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        default:
            completion(false)
        }
    }
    
    private func checkCameraUsagePermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { accessWasGiven in
                DispatchQueue.main.async {
                    completion(accessWasGiven)
                }
            }
        default:
            completion(false)
        }
    }
    
    func getPhotoFromLibrary(completion: @escaping (PHPickerViewController) -> Void) {
        checkPhotoUsagePermission { [weak self] isPermissionGranted in
            guard isPermissionGranted else { return }
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            let photoPickerViewController = PHPickerViewController(configuration: config)
            photoPickerViewController.delegate = self
            completion(photoPickerViewController)
        }
    }
    
    func getPhotoFromCamera(completion: @escaping (UIImagePickerController) -> Void) {
        checkCameraUsagePermission { [weak self] isPermissionGranted in
            guard isPermissionGranted else { return }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            completion(picker)
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension DataManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self?.delegate?.didChooseImage(image)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension DataManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        DispatchQueue.main.async {
            self.delegate?.didChooseImage(image)
        }
    }
}
