import UIKit
import MapKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(annotation: CustomAnnotation) {
        imageView.image = annotation.image
        title.text = annotation.title
        subtitle.text = annotation.subtitle
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(annotation: CustomAnnotation) {
        guard let image = annotation.image,
            let title = annotation.title,
            let text = annotation.subtitle else {
            return
        }
        self.imageView.image = image
        self.title.text = title
        self.subtitle.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
