import UIKit
import RxSwift
import RxCocoa

/// Home tab: all cars from the API.
class CarsViewController: UIViewController {

    let tableView      = UITableView()
    let spinner        = UIActivityIndicatorView(style: .large)
    let refreshControl = UIRefreshControl()

    let viewModel: CarsViewModel
    let disposeBag = DisposeBag()

    init(viewModel: CarsViewModel) {
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
        configureSpinner()
        bindCars()
        bindLoading()
        bindErrors()
        bindSelection()

        viewModel.getCars()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.refreshControl   = refreshControl
        tableView.register(CarCell.self, forCellReuseIdentifier: CarCell.reuseID)
    }

    func configureSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /// Cars -> table rows.
    func bindCars() {
        viewModel.cars
            .bind(to: tableView.rx.items(cellIdentifier: CarCell.reuseID, cellType: CarCell.self)) { [weak self] _, car, cell in
                cell.set(car: car)
                cell.onHeartTapped = { self?.viewModel.toggleFavorite(car) }
            }
            .disposed(by: disposeBag)
    }

    /// Loading -> spinner. Pull down -> reload.
    func bindLoading() {
        viewModel.isLoading
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .filter { $0 == false }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in self?.viewModel.getCars() })
            .disposed(by: disposeBag)
    }

    /// Error -> alert.
    func bindErrors() {
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in self?.showErrorAlert(message) })
            .disposed(by: disposeBag)
    }

    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in self?.viewModel.getCars() })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    /// Tap a row -> show the car details.
    func bindSelection() {
        tableView.rx.modelSelected(Car.self)
            .subscribe(onNext: { [weak self] car in self?.showCarDetails(car) })
            .disposed(by: disposeBag)
    }
}
