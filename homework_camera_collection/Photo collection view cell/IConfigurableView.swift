//
//  IConfigurableView.swift
//  homework_camera_collection
//
//  Created by Tagir Kabirov on 19.05.2022.
//

import Foundation

protocol IConfigurableView {

    associatedtype ConfigurationModel

    func configure(with model: ConfigurationModel)
}
