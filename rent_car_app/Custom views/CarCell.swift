import UIKit

/// One row in the list: icon, name, details and a heart.
class CarCell: UITableViewCell {

    static let reuseID = "CarCell"

    let carImageView = UIImageView()
    let titleLabel   = UILabel()
    let detailLabel  = UILabel()
    let heartButton  = HeartButton()

    var onHeartTapped: (() -> Void)?   // the screen decides what a tap does

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Fill the cell with a car.
    func set(car: Car) {
        titleLabel.text  = car.title
        detailLabel.text = "\(car.year) • \(car.color) • \(car.price) • \(car.isAvailable ? "Available" : "Not available")"
        heartButton.set(isFavorite: car.isFavorite)
    }

    @objc private func heartTapped() {
        onHeartTapped?()
    }

    private func configure() {
        selectionStyle = .none

        carImageView.image       = UIImage(systemName: AppIcons.car)
        carImageView.tintColor   = .systemBlue
        carImageView.contentMode = .scaleAspectFit
        carImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        detailLabel.font          = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor     = .secondaryLabel
        detailLabel.numberOfLines = 0
        detailLabel.translatesAutoresizingMaskIntoConstraints = false

        heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)

        contentView.addSubview(carImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(heartButton)

        NSLayoutConstraint.activate([
            carImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            carImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            carImageView.widthAnchor.constraint(equalToConstant: 40),
            carImageView.heightAnchor.constraint(equalToConstant: 40),

            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            heartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heartButton.widthAnchor.constraint(equalToConstant: 44),
            heartButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -8),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
