import UIKit

/// A heart that is red & filled when favorite, gray & empty when not.
class HeartButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(isFavorite: Bool) {
        let imageName = isFavorite ? AppIcons.heartFill : AppIcons.heart
        setImage(UIImage(systemName: imageName), for: .normal)
        tintColor = isFavorite ? .systemRed : .systemGray
    }
}
