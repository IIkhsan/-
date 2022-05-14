import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties
    
    static let customCollectionViewCellReuseId = "customCollectionViewCellReuseId"
    // MARK: - UI
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 25
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var coordinateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    // MARK: - Overrided functions
    
    // Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
    }
    // MARK: - Private functions
    
    private func setUpCollectionView() {
        contentView.addSubview(containerView)
        contentView.addSubview(imageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(coordinateLabel)
    }
    
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(16)
            make.width.equalTo(160)
        }
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(8)
            make.top.equalTo(containerView).inset(16)
            make.height.equalTo(140)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(containerView).inset(8)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        coordinateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(containerView).inset(8)
        }
    }
    // MARK: - Public functions
    
    public func configureCell(_ photoCard: PhotoCard) {
        self.imageView.image = photoCard.image
        self.dateLabel.text = photoCard.date
        self.coordinateLabel.text = photoCard.coordinate
    }
}
