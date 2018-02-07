import Foundation
import CoreData

class LocalStorage {
    static let shared = LocalStorage()

    static var context: NSManagedObjectContext {
        return self.shared.persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pinboard")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    init() {
        self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    static func save() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
