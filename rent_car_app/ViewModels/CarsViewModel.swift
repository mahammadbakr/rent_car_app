import RxSwift
import RxRelay

/// The brain of the Cars screen. No UIKit here, so it is easy to test.
final class CarsViewModel {

    // The screen watches these:
    let cars: Observable<[Car]>                        // cars with isFavorite filled in
    let isLoading    = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()

    private let allCars = BehaviorRelay<[Car]>(value: [])   // straight from the API
    private let service: CarServiceProtocol
    private let favorites: FavoritesStoreProtocol
    private let disposeBag = DisposeBag()

    init(service: CarServiceProtocol, favorites: FavoritesStoreProtocol) {
        self.service   = service
        self.favorites = favorites

        // When the cars OR the favorites change, mark each car as favorite or not.
        cars = Observable.combineLatest(allCars, favorites.favorites) { allCars, favoriteCars in
            let favoriteIDs = favoriteCars.map { $0.id }
            return allCars.map { car in
                var car = car
                car.isFavorite = favoriteIDs.contains(car.id)
                return car
            }
        }
    }

    // The screen calls these:
    func getCars() {
        isLoading.accept(true)

        service.fetchCars()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] cars in
                self?.allCars.accept(cars)
                self?.isLoading.accept(false)
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }

    func toggleFavorite(_ car: Car) {
        favorites.toggle(car)
    }
}
