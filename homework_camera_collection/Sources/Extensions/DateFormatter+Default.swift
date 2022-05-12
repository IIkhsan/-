//
//  DateFormatter+Default.swift
//  homework_camera_collection
//
//  Created by Роман Сницарюк on 12.05.2022.
//

import Foundation

extension DateFormatter {
   static let commonDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.yyyy H:m"
        return formatter
    }()
}
