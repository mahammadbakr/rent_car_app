import UIKit
import RxSwift
import RxCocoa

/// Favorites tab: only the cars you hearted.
class FavoritesViewController: UIViewController {

    let tableView = UITableView()

    let viewModel: FavoritesViewModel
    let disposeBag = DisposeBag()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureTableView()
        bindCars()
        bindEmptyState()
        bindSelection()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(CarCell.self, forCellReuseIdentifier: CarCell.reuseID)
    }

    /// Favorite cars -> table rows.
    func bindCars() {
        viewModel.cars
            .bind(to: tableView.rx.items(cellIdentifier: CarCell.reuseID, cellType: CarCell.self)) { [weak self] _, car, cell in
                cell.set(car: car)
                cell.onHeartTapped = { self?.viewModel.toggleFavorite(car) }
            }
            .disposed(by: disposeBag)
    }

    /// No favorites -> show a friendly message.
    func bindEmptyState() {
        viewModel.cars
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
                var message = UIContentUnavailableConfiguration.empty()
                message.image         = UIImage(systemName: AppIcons.heart)
                message.text          = "No favorites yet"
                message.secondaryText = "Tap the heart on a car to save it here."
                self?.contentUnavailableConfiguration = isEmpty ? message : nil
            })
            .disposed(by: disposeBag)
    }

    /// Tap a row -> show the car details.
    func bindSelection() {
        tableView.rx.modelSelected(Car.self)
            .subscribe(onNext: { [weak self] car in self?.showCarDetails(car) })
            .disposed(by: disposeBag)
    }
}
