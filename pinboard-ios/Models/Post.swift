import Foundation

struct Post: Codable {
    let tags: String
    let path: String
    let extended: String
    let meta: String
    let description: String
    let hash: String
    let time: String
    let toRead: String
    let shared: String

    enum CodingKeys : String, CodingKey {
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
}
