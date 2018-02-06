import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject {
    enum Keys: String {
        case tags
        case path = "href"
        case extended
        case meta
        case description
        case hash
        case time
        case toRead = "toread"
        case shared
    }

    convenience init(json: [String: String], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Post", in: context)!
        self.init(entity: entity, insertInto: context)

        self.tags = json[Keys.tags.rawValue]
        self.path = json[Keys.path.rawValue]
        self.extended = json[Keys.extended.rawValue]
        self.meta = json[Keys.meta.rawValue]
        self.postDescription = json[Keys.description.rawValue]
        self.postHash = json[Keys.hash.rawValue]
        self.time = json[Keys.time.rawValue]
        self.toRead = json[Keys.toRead.rawValue]
        self.shared = json[Keys.shared.rawValue]
    }
}
