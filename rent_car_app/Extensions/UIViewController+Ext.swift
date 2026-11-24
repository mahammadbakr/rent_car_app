import UIKit

extension UIViewController {

    /// Opens the car details as a half-screen sheet.
    func showCarDetails(_ car: Car) {
        let detailVC = CarDetailViewController(car: car)
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.sheetPresentationController?.detents = [.medium()]
        present(navigationController, animated: true)
    }
}
