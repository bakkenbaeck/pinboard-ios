import Foundation
import CoreData

class LocalStorage {
    static let shared = LocalStorage()

    static var context: NSManagedObjectContext {
        return self.shared.persistentContainer.viewContext
    }

    static var backgroundContext: NSManagedObjectContext {
        return self.shared.backgroundContext
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pinboard")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    static func saveBackgroundContext() {
        let context = self.backgroundContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

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
