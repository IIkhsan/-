//
//  TitleImageCalloutView.swift
//  homework_camera_collection
//
//  Created by Руслан on 09.05.2022.
//

import UIKit
import MapKit

final class TitleImageCalloutView: BaseCalloutView {
    // MARK: UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .callout)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .stackViewSpacing
        stackView.addArrangedSubviews(imageView, titleLabel, subtitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initializers
    
    override init(annotation: MKAnnotation) {
        super.init(annotation: annotation)
        
        guard let annotation = annotation as? TitleImageAnnotation else {
            assertionFailure("Annotation for `TitleImageCalloutView` must be of type `TitleImageAnnotation`")
            return
        }
        
        configure()
        updateContents(for: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .stackViewInset),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .stackViewInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.stackViewInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.stackViewInset),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: .stackViewMaxHeight),
            stackView.widthAnchor.constraint(lessThanOrEqualToConstant: .stackViewMaxWidth)
        ])
    }
    
    private func updateContents(for annotation: TitleImageAnnotation) {
        imageView.image = annotation.image
        titleLabel.text = annotation.title
        subtitleLabel.text = annotation.subtitle
    }
}

// MARK: - Constants

private extension CGFloat {
    static let stackViewMaxHeight: CGFloat = 250
    static let stackViewMaxWidth: CGFloat = 200
    static let stackViewSpacing: CGFloat = 4
    static let stackViewInset: CGFloat = 6
}
