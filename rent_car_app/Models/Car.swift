import Foundation

/// A car from https://myfakeapi.com/api/cars/
struct Car: Codable, Equatable {
    let id: Int
    let brand: String
    let model: String
    let color: String
    let year: Int
    let price: String
    let isAvailable: Bool
    var isFavorite = false   // not in the API, we set it ourselves

    // The API's names -> our names. (isFavorite is left out on purpose.)
    enum CodingKeys: String, CodingKey {
        case id
        case brand       = "car"
        case model       = "car_model"
        case color       = "car_color"
        case year        = "car_model_year"
        case price
        case isAvailable = "availability"
    }

    var title: String { "\(brand) \(model)" }
}

/// The API sends: { "cars": [ ... ] }
struct CarsResponse: Codable {
    let cars: [Car]
}
