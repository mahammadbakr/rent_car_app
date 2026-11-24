import RxSwift

/// The brain of the Favorites screen.
final class FavoritesViewModel {

    let cars: Observable<[Car]>      // only the favorite cars
    private let favorites: FavoritesStoreProtocol

    init(favorites: FavoritesStoreProtocol) {
        self.favorites = favorites
        self.cars      = favorites.favorites
    }

    func toggleFavorite(_ car: Car) {
        favorites.toggle(car)
    }
}
