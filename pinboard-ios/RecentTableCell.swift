import UIKit
import SweetUIKit

class RecentTableCell: UITableViewCell {
    private let titleLabel = UILabel(withAutoLayout: true)
    private let detailsLabel = UILabel(withAutoLayout: true)

    func set(title: String) {
        self.titleLabel.text = title
    }

    func set(details: String) {
        self.detailsLabel.text = details
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = .avenirHeavy(size: 20)
        self.detailsLabel.font = .avenirBook(size: 15)

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailsLabel)

        self.detailsLabel.set(height: 22)

        let margin: CGFloat = 16

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: margin),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -margin),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.detailsLabel.topAnchor, constant: -8),

            self.detailsLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: margin),
            self.detailsLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -margin),
            self.detailsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
