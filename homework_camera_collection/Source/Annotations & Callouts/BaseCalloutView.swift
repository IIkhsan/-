//
//  BaseCalloutView.swift
//  homework_camera_collection
//
//  Created by Руслан on 09.05.2022.
//

import UIKit
import MapKit

class BaseCalloutView: UIView {
    weak var annotation: MKAnnotation?
    
    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
    
    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.blue.cgColor
        layer.lineWidth = 0.5
        return layer
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top / 2.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom - inset.right / 2.0),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left / 2.0),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right / 2.0),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: inset.left + inset.right),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: inset.top + inset.bottom)
        ])
        
        layer.insertSublayer(bubbleLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let contentViewPoint = convert(point, to: contentView)
        return contentView.hitTest(contentViewPoint, with: event)
    }
}

// MARK: - Public interface

extension BaseCalloutView {
    func add(to annotationView: MKAnnotationView) {
        annotationView.addSubview(self)
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: annotationView.topAnchor, constant: annotationView.calloutOffset.y * 2),
            centerXAnchor.constraint(equalTo: annotationView.centerXAnchor, constant: annotationView.calloutOffset.x)
        ])
    }
}

// MARK: - Private methods

private extension BaseCalloutView {
    func updatePath() {
        let path = UIBezierPath()
        var point = CGPoint(x: bounds.width - inset.right, y: bounds.height - inset.bottom)
        var controlPoint: CGPoint
        
        path.move(to: point)
        
        addRoundedCalloutPointer(to: path)
        
        // bottom left
        
        point.x = inset.left
        path.addLine(to: point)
        
        // lower left corner
        
        controlPoint = CGPoint(x: 0, y: bounds.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // left
        
        point.y = inset.top
        path.addLine(to: point)
        
        // top left corner
        
        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // top
        
        point = CGPoint(x: bounds.width - inset.left, y: 0)
        path.addLine(to: point)
        
        // top right corner
        
        controlPoint = CGPoint(x: bounds.width, y: 0)
        point = CGPoint(x: bounds.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // right
        
        point = CGPoint(x: bounds.width, y: bounds.height - inset.bottom - inset.right)
        path.addLine(to: point)
        
        // lower right corner
        
        controlPoint = CGPoint(x: bounds.width, y: bounds.height - inset.bottom)
        point = CGPoint(x: bounds.width - inset.right, y: bounds.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        path.close()
        
        bubbleLayer.path = path.cgPath
    }
    
    func addRoundedCalloutPointer(to path: UIBezierPath) {
        // lower right
        
        var point = CGPoint(x: bounds.width / 2.0 + inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)
        
        // right side of arrow
        
        var controlPoint = CGPoint(x: bounds.width / 2.0, y: bounds.height - inset.bottom)
        point = CGPoint(x: bounds.width / 2.0, y: bounds.height)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // left of pointer
        
        controlPoint = CGPoint(x: point.x, y: bounds.height - inset.bottom)
        point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }
}
