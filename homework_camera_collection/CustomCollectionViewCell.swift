import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties
    
    static let customCollectionViewCellReuseId = "customCollectionViewCellReuseId"
    // MARK: - UI
    
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
        contentView.addSubview(imageView)
        contentView.addSubview(coordinateLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setUpConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(imageView).inset(10)
        }
        coordinateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(dateLabel).inset(10)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    // MARK: - Public functions
    
    public func configureCell(_ photoCard: PhotoCard) {
        self.imageView.image = photoCard.image
        self.dateLabel.text = photoCard.date
        self.coordinateLabel.text = photoCard.coordinate
    }
}
