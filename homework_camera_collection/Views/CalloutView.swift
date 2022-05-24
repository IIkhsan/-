//
//  CalloutView.swift
//  homework_camera_collection
//
//  Created by Evans Owamoyo on 24.05.2022.
//

import UIKit

class CalloutView: UIView {
  private let titleLabel = UILabel(frame: .zero)
  private let subtitleLabel = UILabel(frame: .zero)
  private let imageView = UIImageView(frame: .zero)
  private let annotation: CustomAnnotation

  init(annotation: CustomAnnotation) {
    self.annotation = annotation
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    setupTitle()
    setupSubtitle()
    setupImageView()
  }
  
  private func setupTitle() {
    titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    titleLabel.text = annotation.title
    addSubview(titleLabel)
      titleLabel.snp.makeConstraints { make in
          make.left.top.right.equalTo(self)
      }
  }
  
  private func setupSubtitle() {
    subtitleLabel.font = UIFont.systemFont(ofSize: 14)
    subtitleLabel.textColor = .gray
    subtitleLabel.text = annotation.subtitle
    addSubview(subtitleLabel)
      subtitleLabel.snp.makeConstraints { make in
          make.top.equalTo(titleLabel.snp.bottom).offset(8)
          make.left.right.equalTo(self)
      }
  }
  
  private func setupImageView() {
    imageView.image = annotation.image
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    addSubview(imageView)
      imageView.snp.makeConstraints { make in
          make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
          make.leading.trailing.bottom.equalTo(self)
          make.height.equalTo(200)
          make.width.equalTo(280)
      }
  }
}
