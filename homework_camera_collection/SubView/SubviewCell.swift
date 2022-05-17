import UIKit

class SubviewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Functions
    func configure(subviewInfo: SubviewAnnotation) {
        self.imageView.image = subviewInfo.image
        self.dateLabel.text = subviewInfo.date.formatted()
        self.coordinateLabel.text = subviewInfo.coordinate.longitude.description + subviewInfo.coordinate.latitude.description
    }
}
