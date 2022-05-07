//
//  DataManager.swift
//  homework_camera_collection
//
//  Created by Руслан on 07.05.2022.
//

import Foundation
import PhotosUI
import AVFoundation

final class DataManager {
    weak var delegate: (PHPickerViewControllerDelegate & UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    
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
            photoPickerViewController.delegate = self?.delegate
            completion(photoPickerViewController)
        }
    }
    
    func getPhotoFromCamera(completion: @escaping (UIImagePickerController) -> Void) {
        checkCameraUsagePermission { [weak self] isPermissionGranted in
            guard isPermissionGranted else { return }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self?.delegate
            completion(picker)
        }
    }
}
