//
//  ImageInfoAnnotationView.swift
//  homework_camera_collection
//
//  Created by Ильдар Арсламбеков on 11.05.2022.
//

import UIKit
import MapKit

 class ImageInfoAnnotationView: MKAnnotationView {

     private let spacingStackView = CGFloat(10)
     private let maxWidth = CGFloat(80)
     private let contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
     private let containerInset = CGFloat(10)
     private let blurEffect = UIBlurEffect(style: .prominent)
     private var imageHeightConstraint: NSLayoutConstraint?

     
     private lazy var backgroundMaterial: UIVisualEffectView = {
         let view = UIVisualEffectView(effect: blurEffect)
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()

     private lazy var stackView: UIStackView = {
         let stackView = UIStackView(arrangedSubviews: [labelVibrancyView, imageView, locationLabel, dateLabel])
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.spacing = spacingStackView
         stackView.alignment = .top
         stackView.axis = .vertical
         return stackView
     }()

     private lazy var labelVibrancyView: UIVisualEffectView = {
         let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
         let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
         vibrancyView.translatesAutoresizingMaskIntoConstraints = false
         return vibrancyView
     }()
     
     private lazy var imageView: UIImageView = {
         let imageView = UIImageView(image: nil)
         return imageView
     }()

     private lazy var dateLabel: UILabel = {
         let label = UILabel(frame: .zero)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         return label
     }()
     
     private lazy var locationLabel: UILabel = {
         let label = UILabel(frame: .zero)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0
         return label
     }()

     override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
         super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

         backgroundColor = UIColor.clear
         addSubview(backgroundMaterial)

         backgroundMaterial.contentView.addSubview(stackView)

         backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
         backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
         backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

         stackView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: contentInset.left).isActive = true
         stackView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: contentInset.top).isActive = true

         imageView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
         labelVibrancyView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
         labelVibrancyView.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     override func prepareForReuse() {
         super.prepareForReuse()
         imageView.image = nil
         dateLabel.text = nil
         locationLabel.text = nil
     }

     override func prepareForDisplay() {
         super.prepareForDisplay()

         if let annotation = annotation as? ImageInfoAnnotation {
        dateLabel.text = annotation.date.formatted()
        locationLabel.text = annotation.coordinate.latitude.description + "\n" + annotation.coordinate.longitude.description
             imageView.image = annotation.image
                 if let heightConstraint = imageHeightConstraint {
                     imageView.removeConstraint(heightConstraint)
                 }

             let ratio = annotation.image.size.height / annotation.image.size.width
                 imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio, constant: 0)
                 imageHeightConstraint?.isActive = true
         }
         setNeedsLayout()
     }

     override func layoutSubviews() {
         super.layoutSubviews()

         invalidateIntrinsicContentSize()


         let contentSize = intrinsicContentSize
         frame.size = intrinsicContentSize

         centerOffset = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)

         let shape = CAShapeLayer()
         let path = CGMutablePath()

         let pointShape = UIBezierPath()
         pointShape.move(to: CGPoint(x: containerInset, y: 0))
         pointShape.addLine(to: CGPoint.zero)
         pointShape.addLine(to: CGPoint(x: containerInset, y: containerInset))
         path.addPath(pointShape.cgPath)

         let box = CGRect(x: containerInset, y: 0, width: self.frame.size.width - containerInset, height: self.frame.size.height)
         let roundedRect = UIBezierPath(roundedRect: box,
                                        byRoundingCorners: [.topRight, .bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: 5, height: 5))
         path.addPath(roundedRect.cgPath)
         shape.path = path
         backgroundMaterial.layer.mask = shape
     }

     override var intrinsicContentSize: CGSize {
         var size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
         size.width += contentInset.left + contentInset.right
         size.height += contentInset.top + contentInset.bottom
         return size
     }
 }
