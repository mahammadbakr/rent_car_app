import CoreData
import RxSwift
import RxRelay

/// Anything that can remember favorite cars. (Tests plug in a fake one.)
protocol FavoritesStoreProtocol {
    var favorites: Observable<[Car]> { get }   // fires every time favorites change
    func toggle(_ car: Car)                    // add if new, remove if already saved
}

/// Saves favorite cars with Core Data.
final class FavoritesStore: FavoritesStoreProtocol {

    private let context: NSManagedObjectContext
    private let favoritesRelay = BehaviorRelay<[Car]>(value: [])

    var favorites: Observable<[Car]> { favoritesRelay.asObservable() }

    init(container: NSPersistentContainer) {
        context = container.viewContext
        loadFavorites()
    }

    func toggle(_ car: Car) {
        if let savedCar = findSavedCar(id: car.id) {
            context.delete(savedCar)   // already a favorite -> remove it
        } else {
            addSavedCar(car)           // not a favorite yet -> add it
        }
        try? context.save()
        loadFavorites()
    }
    
    /// Read everything from the database and tell the screens.
    private func loadFavorites() {
        let request = FavoriteCar.fetchRequest()
        let savedCars = (try? context.fetch(request)) ?? []

        let cars = savedCars.map { saved in
            Car(id: Int(saved.id), brand: saved.brand ?? "", model: saved.model ?? "",
                color: saved.color ?? "", year: Int(saved.year), price: saved.price ?? "",
                isAvailable: saved.isAvailable, isFavorite: true)
        }
        favoritesRelay.accept(cars.sorted { $0.id < $1.id })
    }

    private func findSavedCar(id: Int) -> FavoriteCar? {
        let request = FavoriteCar.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return try? context.fetch(request).first
    }

    private func addSavedCar(_ car: Car) {
        let saved         = FavoriteCar(context: context)
        saved.id          = Int64(car.id)
        saved.brand       = car.brand
        saved.model       = car.model
        saved.color       = car.color
        saved.year        = Int16(car.year)
        saved.price       = car.price
        saved.isAvailable = car.isAvailable
    }
}
