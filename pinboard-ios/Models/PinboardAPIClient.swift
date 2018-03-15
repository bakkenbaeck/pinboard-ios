import Foundation
import Teapot
import KeychainSwift

class PinboardAPIClient {
    private let baseURL = URL(string: "https://api.pinboard.in")!

    private lazy var teapot: Teapot = {
        Teapot(baseURL: self.baseURL)
    }()

    var authToken: String? {
        set {
            let keychain = KeychainSwift(keyPrefix: "pinboard::")
            if let token = newValue {
                keychain.set(token, forKey: "authToken")
            } else {
                keychain.delete("authToken")
            }
        }
        get {
            let keychain = KeychainSwift(keyPrefix: "pinboard::")
            return keychain.get("authToken")
        }
    }

    var username: String? {
        set {
            let keychain = KeychainSwift(keyPrefix: "pinboard::")
            if let token = newValue {
                keychain.set(token, forKey: "username")
            } else {
                keychain.delete("username")
            }
        }
        get {
            let keychain = KeychainSwift(keyPrefix: "pinboard::")
            return keychain.get("username")
        }
    }

    public static let shared: PinboardAPIClient = PinboardAPIClient()

    init() {
        // Uncomment to delete user
        // KeychainSwift(keyPrefix: "pinboard::").delete("authToken")
        // KeychainSwift(keyPrefix: "pinboard::").delete("username")
    }

    private func jsonPath(for path: String) -> String {
        return path.appending("?format=json")
    }

    private func authenticatedPath(for path: String) -> String {
        guard let username = self.username, let authToken = self.authToken else {
            fatalError("Could not retrieve username and/or authToken.")
        }

        return self.jsonPath(for: path).appending("&auth_token=\(username):\(authToken)")
    }

    func getAPIToken(username: String, password: String, _ completion: @escaping (_ token: String?) -> Void) {
        let path = self.jsonPath(for: "/v1/user/api_token/")
        let header = self.teapot.basicAuthenticationHeader(username: username, password: password)

        self.teapot.get(path, headerFields: header) { result in
            switch result {
            case let .success(params, response):
                let token = params?.dictionary?["result"] as? String

                self.username = username
                completion(token)
            case let .failure(params, response, error):
                completion(nil)
            }
        }
    }

    func getRecent(_ completion: @escaping (_ recent: [Post]) -> Void) {
        let path = self.authenticatedPath(for: "/v1/posts/recent")

        self.teapot.get(path) { result in
            switch result {
            case let .success(params, response):
                guard let postsArray = params?.dictionary?["posts"] as? [[String: String]] else { return }

                let posts = postsArray.flatMap { postJSON -> Post? in
                    return Post(json: postJSON, context: LocalStorage.context)
                }

                DispatchQueue.main.async {
                    try? LocalStorage.save
                }
            case let .failure(params, response, error):
                break
            }
        }
    }

    func getAll() {
        let path = self.authenticatedPath(for: "/v1/posts/all")

        self.teapot.get(path) { result in
            switch result {
            case let .success(params, response):
                guard let postsArray = params?.array as? [[String: String]] else { return }

                let posts = postsArray.flatMap { postJSON -> Post? in
                    return Post(json: postJSON, context: LocalStorage.context)
                }

                DispatchQueue.main.async {
                    try? LocalStorage.save()
                }
            case let .failure(params, response, error):
                print(error)            }
        }
    }

    func addBookmark(urlPath: String, description: String) {
        let path = self.authenticatedPath(for: "/v1/posts/add")
        let params = RequestParameter([
            "url" : urlPath,
            "description": description
            ])

        self.teapot.post(path, parameters: params) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(params, response):
                    print(params)
                    print(response)
                case let .failure(params, response, error):
                    print(params)
                    print(response)
                    print(error)
                }
            }
        }
    }
}
