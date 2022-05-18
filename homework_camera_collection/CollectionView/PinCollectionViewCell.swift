//
//  DetailCollectionViewCell.swift
//  homework_camera_collection
//
//  Created by Алсу Хайруллина on 17.05.2022.
//

import UIKit

class PinCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PinCollectionViewCell"
    
    let imageView = UIImageView()
    let dateLabel = UILabel()
    let coordinatesLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.height.equalTo(100)
            make.width.equalTo(50)
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.font = .systemFont(ofSize: 10, weight: .regular)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        coordinatesLabel.font = .systemFont(ofSize: 10, weight: .regular)
        coordinatesLabel.numberOfLines = 0
        coordinatesLabel.sizeToFit()
        contentView.addSubview(coordinatesLabel)
        coordinatesLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel).inset(10)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setData(pinCell: PinCell) {
        imageView.image = pinCell.image
        dateLabel.text = pinCell.date
        coordinatesLabel.text = pinCell.coordinate
    }
}
