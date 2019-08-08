import UIKit
import SnapKit
import Kingfisher

class DeliveryCell: UITableViewCell {

    static let reuseIdentifier = "DeliveryCell"
    let margin: CGFloat = 8
    static let cornerRadius: CGFloat = 4
    static let cellHeight: CGFloat = 100

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()

    private let receiversImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = DeliveryCell.cornerRadius
        imgView.kf.indicatorType = IndicatorType.activity
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    var deliveryViewModel: DeliveryCellViewModel? {
        didSet {
            descriptionLabel.text = deliveryViewModel?.details ?? ""
            if let url = deliveryViewModel?.receiversImageUrl {
                receiversImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
            } else {
                receiversImageView.image = #imageLiteral(resourceName: "person")
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(receiversImageView)
        receiversImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(DeliveryCell.cellHeight - CGFloat(2 * margin))
            make.height.equalTo(DeliveryCell.cellHeight - CGFloat(2 * margin))
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(margin)
        }
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(margin)
            make.leading.equalTo(receiversImageView.snp.trailing).offset(margin)
            make.trailing.equalTo(contentView).offset(-margin)
            make.height.greaterThanOrEqualTo(DeliveryCell.cellHeight - 3 * margin).priority(999)
            make.bottom.equalTo(contentView).offset(-margin)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
