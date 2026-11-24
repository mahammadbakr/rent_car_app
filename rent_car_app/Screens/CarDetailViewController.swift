import UIKit

/// A small sheet that shows one car's details.
class CarDetailViewController: UIViewController {

    let car: Car

    let carImageView = UIImageView()
    let titleLabel   = UILabel()
    let infoLabel    = UILabel()

    init(car: Car) {
        self.car = car
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureCloseButton()
        configureViews()
        layoutViews()
    }

    func configureCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }

    @objc func closeTapped() {
        dismiss(animated: true)
    }

    func configureViews() {
        carImageView.image       = UIImage(systemName: AppIcons.car)
        carImageView.tintColor   = .systemBlue
        carImageView.contentMode = .scaleAspectFit

        titleLabel.text          = car.title
        titleLabel.font          = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textAlignment = .center

        infoLabel.text = """
        Year: \(car.year)
        Color: \(car.color)
        Price: \(car.price)
        \(car.isAvailable ? "Available" : "Not available")
        """
        infoLabel.font          = UIFont.preferredFont(forTextStyle: .body)
        infoLabel.textColor     = .secondaryLabel
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
    }

    /// Image, title and info stacked on top of each other.
    func layoutViews() {
        let stackView = UIStackView(arrangedSubviews: [carImageView, titleLabel, infoLabel])
        stackView.axis    = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            carImageView.heightAnchor.constraint(equalToConstant: 80),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
