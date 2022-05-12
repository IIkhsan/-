//
//  Date+ToStringUsingFormatter.swift
//  homework_camera_collection
//
//  Created by Роман Сницарюк on 12.05.2022.
//

import Foundation

extension Date {
    func toString(using formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
