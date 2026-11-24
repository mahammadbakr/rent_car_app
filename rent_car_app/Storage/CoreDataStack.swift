import CoreData

/// Creates the Core Data database.
enum CoreDataStack {

    /// inMemory = true means nothing is saved on disk (used by tests).
    static func makeContainer(inMemory: Bool = false) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "rent_car_app")   // name of the .xcdatamodeld file

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        return container
    }
}
