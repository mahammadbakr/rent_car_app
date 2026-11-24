import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // One of each, shared by both tabs.
    let carService     = CarService()
    let favoritesStore = FavoritesStore(container: CoreDataStack.makeContainer())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // No storyboard, so we create the window ourselves.
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
    }

    // Setup Tab bar
    func createCarsNC() -> UINavigationController {
        let viewModel = CarsViewModel(service: carService, favorites: favoritesStore)
        let carsVC    = CarsViewController(viewModel: viewModel)
        carsVC.title  = "Cars"
        carsVC.tabBarItem = UITabBarItem(title: "Cars", image: UIImage(systemName: AppIcons.car), tag: 0)

        let navigationController = UINavigationController(rootViewController: carsVC)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    func createFavoritesNC() -> UINavigationController {
        let viewModel     = FavoritesViewModel(favorites: favoritesStore)
        let favoritesVC   = FavoritesViewController(viewModel: viewModel)
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: AppIcons.heartFill), tag: 1)

        let navigationController = UINavigationController(rootViewController: favoritesVC)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createCarsNC(), createFavoritesNC()]
        return tabBar
    }
}
