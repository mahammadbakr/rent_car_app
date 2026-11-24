import Foundation
import RxSwift
import RxCocoa

/// Anything that can fetch cars. (Tests plug in a fake one.)
protocol CarServiceProtocol {
    func fetchCars() -> Single<[Car]>
}

/// Downloads the cars from the internet.
final class CarService: CarServiceProtocol {

    private let url = URL(string: "https://myfakeapi.com/api/cars/")!

    func fetchCars() -> Single<[Car]> {
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let response = try JSONDecoder().decode(CarsResponse.self, from: data)
                return response.cars
            }
            .asSingle()
    }
}
